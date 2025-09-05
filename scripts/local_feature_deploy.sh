#!/usr/bin/env sh

test -f scripts/lib.sh || {
  echo "Please run the script from the root of the repository"
  exit 1
}
_command="apply"
_replicate=false
_restart_pod=false
_run_prepare_destroy=false
_first_deploy=false
_integrated=false
_fail_fast_pf_500=false
_auto_approve=false

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
    --fail-fast-pf-500
      Do not retry apply on PingFederate API 500 errors; fail immediately (default is to retry once)
    --auto-approve
      Run terraform with -auto-approve and redirect output to logs (apply: terraform-apply.out, destroy: terraform-destroy.out)
END_USAGE
exit 99
}

# Detect PingFederate 500 server error in the last apply output
_detect_pf_500_error() {
  _log_file="${TFDIR}/terraform-apply.out"
  test -f "${_log_file}" || return 1
  if grep -qi "PingFederate API error" "${_log_file}" && \
     (grep -q "Error summary: An error occurred while creating the OAuth Client" "${_log_file}" || grep -qi "Result ID: server_error" "${_log_file}"); then
    return 0
  fi
  return 1
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
    --fail-fast-pf-500)
      _fail_fast_pf_500=true
      ;;
    --auto-approve)
      _auto_approve=true
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
# Use new directory name by default; allow override via env
export TFDIR="${TFDIR:-configuration}"

# Ensure variables used by remote state are set before init/import
export TF_VAR_pingone_environment_name="${_branch}"
export TF_VAR_tf_state_key_prefix_infrastructure="${TF_VAR_tf_state_key_prefix_infrastructure:-infrastructure-state}"

# Force default workspace to avoid accidental workspace-derived S3 paths
export TF_WORKSPACE=default

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

# First-deploy detection (no remote state object for this branch)
if ! aws s3api head-object --bucket "${_bucket_name}" --key "${_key}" >/dev/null 2>&1; then
  _first_deploy=true
  echo "First deploy detected for branch: ${_branch} (no remote platform state)"
fi

# Integration detection via branch prefix "int-"
case "${_branch}" in
  int-*) _integrated=true ;;
  *) _integrated=false ;;
 esac

# If integrated, pull infra outputs from corresponding infra state and expose to Terraform
if [ "${_integrated}" = true ]; then
  # jq required to parse terraform state
  if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq is required for integrated deployments. Install jq and retry."
    exit 1
  fi

  infra_prefix="${TF_VAR_tf_state_key_prefix_infrastructure:-infrastructure-state}"
  infra_key="${infra_prefix}/dev/${_branch}/terraform.tfstate"
  echo "Using infra remote state key: s3://${_bucket_name}/${infra_key}"

  if ! aws s3api head-object --bucket "${_bucket_name}" --key "${infra_key}" >/dev/null 2>&1; then
    echo "ERROR: Infrastructure state not found at s3://${_bucket_name}/${infra_key}. Ensure infra is applied for branch ${_branch}."
    exit 1
  fi

  echo "Integration mode enabled for branch: ${_branch}. Reading infra outputs..."
  export TF_VAR_enable_infrastructure_integration=true
  export TF_VAR_state_bucket="${_bucket_name}"
  export TF_VAR_state_region="${_region}"
fi

if ${_clean} ; then
  echo "Cleaning up old terraform state files..."
  rm -rf "${TFDIR}/.terraform" "${TFDIR}/terraform.tfstate"
fi

# Unified PingFederate stack generation (integrated only)
_stack_tpl="${TFDIR}/pf_integration.stack.tpl"
_stack_gen="${TFDIR}/pf_integration.stack.tf"
if [ "${_integrated}" = true ]; then
  if [ -f "${_stack_tpl}" ]; then
    cp "${_stack_tpl}" "${_stack_gen}"
  fi
else
  rm -f "${_stack_gen}" 2>/dev/null || true
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

# Emit detection summary
echo "Deploy context: branch=${_branch} first_deploy=${_first_deploy} integrated=${_integrated}"

# Special handling for destroy command
if [ "${_command}" = "destroy" ]; then
  # If prepare-destroy flag is set, run the prepare script first
  if [ "${_run_prepare_destroy}" = true ]; then
    echo "Running prepare-destroy.sh before configuration destroy..."
    export ENVIRONMENT_NAME="${_branch}"
    ./scripts/prepare-destroy.sh
  fi
  
  echo "Attempting to destroy configuration for branch: ${_branch}..."
  
  if [ "${_auto_approve}" = true ]; then
    terraform -chdir="${TFDIR}" destroy -auto-approve >"${TFDIR}/terraform-destroy.out" 2>&1
    terraform_exit_code=$?
  else
    terraform -chdir="${TFDIR}" destroy
    terraform_exit_code=$?
  fi
  
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
      if [ "${_auto_approve}" = true ]; then
        terraform -chdir="${TFDIR}" destroy -auto-approve >"${TFDIR}/terraform-destroy.out" 2>&1
      else
        terraform -chdir="${TFDIR}" destroy
      fi
    else
      echo "Terraform destroy failed with exit code ${terraform_exit_code}, but not due to 'resource in use' error."
      exit ${terraform_exit_code}
    fi
  fi
else
  # For apply command
  echo "Running terraform ${_command} for branch: ${_branch}..."
  # Restart pod before apply if requested
  if [ "${_integrated}" = true ] && [ "${_restart_pod}" = true ]; then
    echo "Restarting PingFederate admin pod before configuration apply (integrated branch)..."
    restart_pf_pod "${_branch}"
  fi

  if [ "${_auto_approve}" = true ]; then
    # Non-interactive apply, redirect output to file
    terraform -chdir="${TFDIR}" apply -auto-approve >"${TFDIR}/terraform-apply.out" 2>&1
    terraform_exit_code=$?
  else
    # Interactive apply, print to screen and log to file via tee while preserving exit code
    _status_file=$(mktemp)
    { terraform -chdir="${TFDIR}" apply 2>&1; echo "$?" >"${_status_file}"; } | tee "${TFDIR}/terraform-apply.out"
    terraform_exit_code=$(cat "${_status_file}")
    rm -f "${_status_file}"
  fi

  # Retry once on PingFederate 500 error by default (unless fail-fast is set)
  if [ ${terraform_exit_code} -ne 0 ] && _detect_pf_500_error && [ "${_fail_fast_pf_500}" != true ]; then
    echo "Detected PingFederate 500 during apply. Restarting PF admin pod and re-applying (fail-fast disabled)..."
    restart_pf_pod "${_branch}" || true
    sleep 20
    if [ "${_auto_approve}" = true ]; then
      terraform -chdir="${TFDIR}" apply -auto-approve >"${TFDIR}/terraform-apply.out" 2>&1
      terraform_exit_code=$?
    else
      _status_file=$(mktemp)
      { terraform -chdir="${TFDIR}" apply 2>&1; echo "$?" >"${_status_file}"; } | tee "${TFDIR}/terraform-apply.out"
      terraform_exit_code=$(cat "${_status_file}")
      rm -f "${_status_file}"
    fi
  fi

  if [ ${terraform_exit_code} -ne 0 ]; then
    echo "Terraform ${_command} failed. See ${TFDIR}/terraform-apply.out for details."
    exit ${terraform_exit_code}
  fi

  # If terraform apply was successful and we are on an integrated branch we need to replicate configuration
  if [ "${_command}" = "apply" ] && [ ${_integrated} = "true" ]; then
    # Always restart the pod after apply to ensure config is loaded properly
    if [ "${_restart_pod}" != true ]; then
      echo "Restarting PingFederate admin pod after configuration apply..."
      restart_pf_pod "${_branch}"
    fi

    # Replicate configuration if requested
    if [ "${_replicate}" = true ]; then
      echo "Replicating PingFederation configuration..."
      replicate_pf_config "${_branch}"
    fi
  fi
fi