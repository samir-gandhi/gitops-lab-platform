#!/usr/bin/env sh

test -f scripts/lib.sh || {
  echo "Please run the script from the root of the repository"
  exit 1
}
_command="apply"
_replicate=false
_restart_pod=false
_run_prepare_destroy=false

usage ()
{
cat <<END_USAGE
Usage: 
  This script is used to run terraform apply for your local feature branch only. 
  This script should be run from the root of the repository. 
  Terraform Secrets (\`localsecrets\` file) should be sourced and exported in the evironment

{options}
    where {options} include:
    -d, --destroy
      Run terraform destroy instead of apply
    -g, --generate
      Generate terraform resources from import blocks
    -r, --replicate
      Replicate PingFederation configuration after terraform apply
    --restart-pod
      Restart PingFederate admin pod before operations
    --prepare-destroy
      Run prepare-destroy.sh before destroying configuration
END_USAGE
exit 99
}

# Function to restart PingFederate admin pod
restart_pf_pod() {
  branch_name=$1
  echo "Restarting PingFederate admin pod for branch: ${branch_name}"
  
  # Get pod name
  namespace="${TF_VAR_k8s_namespace_prefix}${branch_name}"
  pf_pod=$(kubectl get pods -n "${namespace}" | grep pingfederate-admin | awk '{print $1}')
  
  if [ -z "${pf_pod}" ]; then
    echo "ERROR: PingFederate admin pod not found in namespace ${namespace}"
    echo "The pod should exist after infrastructure deployment."
    return 1
  fi
  
  echo "Found PingFederate admin pod: ${pf_pod}"
  kubectl delete pod "${pf_pod}" -n "${namespace}"
  
  # Wait for pod to be restarted and ready in a loop with timeout
  echo "Waiting for PingFederate admin pod to restart..."
  MAX_WAIT_SECONDS=180  # 3 minutes
  INTERVAL=10  # check every 10 seconds
  ELAPSED=0
  READY=false
  
  while [ $ELAPSED -lt $MAX_WAIT_SECONDS ]; do
    echo "Checking pod status (${ELAPSED}s elapsed)..."
    
    # Check if pod exists
    pf_pod=$(kubectl get pods -n "${namespace}" | grep pingfederate-admin | awk '{print $1}')
    if [ -z "${pf_pod}" ]; then
      echo "Pod not yet recreated. Waiting..."
      sleep $INTERVAL
      ELAPSED=$((ELAPSED + INTERVAL))
      continue
    fi
    
    # Check for crash loop
    RESTARTS=$(kubectl get pod "${pf_pod}" -n "${namespace}" -o jsonpath='{.status.containerStatuses[0].restartCount}')
    if [ $RESTARTS -gt 1 ]; then
      echo "ERROR: PingFederate admin pod is in a crash loop with ${RESTARTS} restarts."
      kubectl describe pod "${pf_pod}" -n "${namespace}"
      return 1
    fi
    
    # Check if ready
    POD_STATUS=$(kubectl get pod "${pf_pod}" -n "${namespace}" -o jsonpath='{.status.phase}')
    READY_STATUS=$(kubectl get pod "${pf_pod}" -n "${namespace}" -o jsonpath='{.status.containerStatuses[0].ready}')
    
    if [ "$POD_STATUS" = "Running" ] && [ "$READY_STATUS" = "true" ]; then
      echo "PingFederate admin pod restarted successfully and is ready"
      READY=true
      # Wait a bit longer for services to fully initialize
      sleep 20
      break
    fi
    
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
  done
  
  if [ "$READY" != "true" ]; then
    echo "ERROR: Timed out waiting for PingFederate admin pod to restart after ${MAX_WAIT_SECONDS} seconds"
    kubectl describe pod "${pf_pod}" -n "${namespace}"
    return 1
  fi
  
  return 0
}

# Function to replicate PingFederate configuration
replicate_pf_config() {
  branch_name=$1
  echo "Replicating PingFederate configuration for branch: ${branch_name}"
  
  # Check if required credentials are available
  if [ -z "${TF_VAR_pingfederate_api_username}" ] || [ -z "${TF_VAR_pingfederate_api_password}" ]; then
    echo "PingFederate API credentials are not set. Please set TF_VAR_pingfederate_api_username and TF_VAR_pingfederate_api_password in your localsecrets file."
    return 1
  fi
  
  _host="https://${branch_name}-pingfederate-admin.ping-devops.com"
  _uri="/pf-admin-api/v1/cluster/replicate"
  
  echo "Calling PingFederate replication endpoint at ${_host}${_uri}"
  curl -k -X POST "${_host}${_uri}" \
    -H "Content-Type: application/json" \
    -H "X-XSRF-Header: $(date +%s)" \
    -u "${TF_VAR_pingfederate_api_username}:${TF_VAR_pingfederate_api_password}"
    
  if [ $? -eq 0 ]; then
    echo "PingFederation configuration replicated successfully."
    return 0
  else
    echo "Failed to replicate PingFederation configuration."
    return 1
  fi
}

exit_usage()
{
    echo "$*"
    usage
    exit 1
}

while [ $# -gt 0 ]; do
  case "${1}" in
    --clean)
      _clean="true"
      ;;
    -d|--destroy)
      _command="destroy" 
      ;;
    -g|--generate)
      _command="plan -generate-config-out=generated-platform.tf" 
      ;;
    -r|--replicate)
      _replicate=true
      ;;
    --restart-pod)
      _restart_pod=true
      ;;
    --prepare-destroy)
      _run_prepare_destroy=true
      ;;
    -v|--verbose)
      set -x 
      ;;
    -h|--help)
      exit_usage "" 
      ;;
    *)
      exit_usage "Unrecognized Option: ${1}" 
      ;;
  esac
  shift
done

# shellcheck source=lib.sh
. scripts/lib.sh

checkVars

_branch=$(git rev-parse --abbrev-ref HEAD)
export TFDIR="02-configuration"

if test "$_branch" = "prod" || test  "$_branch" = qa ; then
  echo "You are on a non-dev branch. Please checkout to your feature branch to run this script."
  exit 1
fi

## S3 state bucket configuration
## local aws default profile will be used
## Specify the bucket name and region
if [ -z "${TF_VAR_tf_state_bucket}" ] || [ -z "${TF_VAR_tf_state_region}" ]; then
  echo "TF_VAR_tf_state_bucket or TF_VAR_tf_state_region is not set. Please set the appropriate variables in your localsecrets file."
  exit 1
fi
_bucket_name="${TF_VAR_tf_state_bucket}"
_region="${TF_VAR_tf_state_region}"
export TF_VAR_tf_state_key_prefix_platform="${TF_VAR_tf_state_key_prefix_platform:-platform-state}"
_key="${TF_VAR_tf_state_key_prefix_platform}/dev/${_branch}/terraform.tfstate"

if ${_clean} ; then
  echo "Cleaning up old terraform state files..."
  rm -rf "${TFDIR}/.terraform" "${TFDIR}/terraform.tfstate"
fi

## terraform init
terraform -chdir="${TFDIR}" init -migrate-state \
  -backend-config="bucket=${_bucket_name}" \
  -backend-config="region=${_region}" \
  -backend-config="key=${_key}"

## terraform apply/destroy with enhanced flow

export TF_VAR_pingone_environment_name="${_branch}"

# Enable Terraform debug logging to help catch errors
export TF_LOG=DEBUG
export TF_LOG_PATH="${TFDIR}/terraform-debug.log"

# Special handling for destroy command
if [ "${_command}" = "destroy" ]; then
  # If prepare-destroy flag is set, run the prepare script first
  if [ "${_run_prepare_destroy}" = true ]; then
    echo "Running prepare-destroy.sh before configuration destroy..."
    export ENVIRONMENT_NAME="${_branch}"
    ./scripts/prepare-destroy.sh
  fi
  
  echo "Attempting to destroy configuration for branch: ${_branch}..."
  
  # First try - run terraform normally to allow for user interaction (e.g., confirmation prompts)
  # This allows the user to confirm the destroy operation interactively
  terraform -chdir="${TFDIR}" ${_command}
  terraform_exit_code=$?
  
  # If it failed, check for specific errors in the terraform log files
  if [ ${terraform_exit_code} -ne 0 ]; then
    # Look for resource in use errors in terraform logs
    if grep -q "This resource is in use and cannot be deleted" "${TFDIR}/terraform-debug.log" 2>/dev/null || grep -q "This resource is in use and cannot be deleted" "${TFDIR}/.terraform/terraform.log" 2>/dev/null; then
      echo "Detected 'resource in use' error. Restarting PingFederate admin pod and retrying..."
      set -x
      # Restart the pod
      restart_pf_pod "${_branch}"
      set +x
      # Wait for a moment to ensure services are ready
      sleep 30
      
      # Second try after pod restart
      echo "Retrying configuration destroy..."
      terraform -chdir="${TFDIR}" ${_command}
    else
      # This was not a resource-in-use error
      echo "Terraform destroy failed with exit code ${terraform_exit_code}, but not due to 'resource in use' error."
      exit ${terraform_exit_code}
    fi
  fi
else
  # For apply command
  echo "Running terraform ${_command} for branch: ${_branch}..."
  
  # Restart pod before apply if requested
  if [ "${_restart_pod}" = true ]; then
    echo "Restarting PingFederate admin pod before configuration apply..."
    restart_pf_pod "${_branch}"
  fi
  
  # Run terraform command
  terraform -chdir="${TFDIR}" ${_command}
  
  # If terraform apply was successful and we need to replicate configuration
  if [ $? -eq 0 ] && [ "${_command}" = "apply" ]; then
    # Always restart the pod after apply to ensure config is loaded properly
    echo "Restarting PingFederate admin pod after successful apply..."
    restart_pf_pod "${_branch}"
    
    # Replicate configuration if requested
    if [ "${_replicate}" = true ]; then
      echo "Replicating PingFederation configuration..."
      replicate_pf_config "${_branch}"
    fi
  fi
fi