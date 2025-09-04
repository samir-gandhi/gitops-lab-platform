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

# Import singleton PingFederate resources into module state (first deploy only)
import_pf_integration_state() {
  echo "Importing PingFederate singleton resources into module state..."
  FAIL=0
  # Address-ID pairs, derived from prior import blocks
  while read -r addr id; do
    [ -z "$addr" ] && continue
    if terraform -chdir="${TFDIR}" state show "$addr" >/dev/null 2>&1; then
      echo "Already in state: $addr"
      continue
    fi
    echo "terraform import $addr $id"
    if ! terraform -chdir="${TFDIR}" import "$addr" "$id"; then
      echo "WARN: Import failed for $addr"
      FAIL=1
      continue
    fi
  done <<'EOF_IMPORTS'
module.pf_integration[0].pingfederate_keypairs_ssl_server_settings.pingcli__Keypairs-0020-Ssl-0020-Server-0020-Settings keypairs_ssl_server_settings_singleton_id
module.pf_integration[0].pingfederate_virtual_host_names.pingcli__Virtual-0020-Host-0020-Names virtual_host_names_singleton_id
module.pf_integration[0].pingfederate_certificates_revocation_settings.pingcli__Certificates-0020-Revocation-0020-Settings certificates_revocation_settings_singleton_id
module.pf_integration[0].pingfederate_server_settings.pingcli__Server-0020-Settings server_settings_singleton_id
module.pf_integration[0].pingfederate_oauth_access_token_manager_settings.pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings oauth_access_token_manager_settings_singleton_id
module.pf_integration[0].pingfederate_authentication_policies_settings.pingcli__Authentication-0020-Policies-0020-Settings authentication_policies_settings_singleton_id
module.pf_integration[0].pingfederate_openid_connect_settings.pingcli__Openid-0020-Connect-0020-Settings openid_connect_settings_singleton_id
module.pf_integration[0].pingfederate_notification_publisher_settings.pingcli__Notification-0020-Publisher-0020-Settings notification_publisher_settings_singleton_id
module.pf_integration[0].pingfederate_service_authentication.pingcli__Service-0020-Authentication service_authentication_singleton_id
module.pf_integration[0].pingfederate_session_authentication_policies_global.pingcli__Session-0020-Authentication-0020-Policies-0020-Global session_authentication_policies_global_singleton_id
module.pf_integration[0].pingfederate_oauth_ciba_server_policy_settings.pingcli__Oauth-0020-Ciba-0020-Server-0020-Policy-0020-Settings oauth_ciba_server_policy_settings_singleton_id
module.pf_integration[0].pingfederate_session_settings.pingcli__Session-0020-Settings session_settings_singleton_id
module.pf_integration[0].pingfederate_keypairs_oauth_openid_connect.pingcli__Keypairs-0020-Oauth-0020-Openid-0020-Connect keypairs_oauth_openid_connect_singleton_id
module.pf_integration[0].pingfederate_authentication_policies.pingcli__Authentication-0020-Policies authentication_policies_singleton_id
module.pf_integration[0].pingfederate_oauth_client_settings.pingcli__Oauth-0020-Client-0020-Settings oauth_client_settings_singleton_id
module.pf_integration[0].pingfederate_server_settings_system_keys_rotate.pingcli__Server-0020-Settings-0020-System-0020-Keys-0020-Rotate server_settings_system_keys_rotate_singleton_id
module.pf_integration[0].pingfederate_cluster_settings.pingcli__Cluster-0020-Settings cluster_settings_singleton_id
module.pf_integration[0].pingfederate_extended_properties.pingcli__Extended-0020-Properties extended_properties_singleton_id
module.pf_integration[0].pingfederate_captcha_provider_settings.pingcli__Captcha-0020-Provider-0020-Settings captcha_provider_settings_singleton_id
module.pf_integration[0].pingfederate_authentication_api_settings.pingcli__Authentication-0020-Api-0020-Settings authentication_api_settings_singleton_id
module.pf_integration[0].pingfederate_incoming_proxy_settings.pingcli__Incoming-0020-Proxy-0020-Settings incoming_proxy_settings_singleton_id
module.pf_integration[0].pingfederate_configuration_encryption_keys_rotate.pingcli__Configuration-0020-Encryption-0020-Keys-0020-Rotate configuration_encryption_keys_rotate_singleton_id
module.pf_integration[0].pingfederate_sp_target_url_mappings.pingcli__Sp-0020-Target-0020-Url-0020-Mappings sp_target_url_mappings_singleton_id
module.pf_integration[0].pingfederate_oauth_server_settings.pingcli__Oauth-0020-Server-0020-Settings oauth_server_settings_singleton_id
module.pf_integration[0].pingfederate_server_settings_general.pingcli__Server-0020-Settings-0020-General server_settings_general_singleton_id
module.pf_integration[0].pingfederate_session_application_policy.pingcli__Session-0020-Application-0020-Policy session_application_policy_singleton_id
module.pf_integration[0].pingfederate_oauth_token_exchange_generator_settings.pingcli__Oauth-0020-Token-0020-Exchange-0020-Generator-0020-Settings oauth_token_exchange_generator_settings_singleton_id
module.pf_integration[0].pingfederate_server_settings_ws_trust_sts_settings.pingcli__Server-0020-Settings-0020-Ws-0020-Trust-0020-Sts-0020-Settings server_settings_ws_trust_sts_settings_singleton_id
module.pf_integration[0].pingfederate_protocol_metadata_lifetime_settings.pingcli__Protocol-0020-Metadata-0020-Lifetime-0020-Settings protocol_metadata_lifetime_settings_singleton_id
module.pf_integration[0].pingfederate_protocol_metadata_signing_settings.pingcli__Protocol-0020-Metadata-0020-Signing-0020-Settings protocol_metadata_signing_settings_singleton_id
module.pf_integration[0].pingfederate_kerberos_realm_settings.pingcli__Kerberos-0020-Realm-0020-Settings kerberos_realm_settings_singleton_id
module.pf_integration[0].pingfederate_redirect_validation.pingcli__Redirect-0020-Validation redirect_validation_singleton_id
module.pf_integration[0].pingfederate_server_settings_logging.pingcli__Server-0020-Settings-0020-Logging server_settings_logging_singleton_id
module.pf_integration[0].pingfederate_default_urls.pingcli__Default-0020-Urls default_urls_singleton_id
EOF_IMPORTS

  if [ "$FAIL" -ne 0 ]; then
    echo "ERROR: One or more imports failed. Fix the environment and re-run; imports will be retried on next run."
    exit 1
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

## terraform init
terraform -chdir="${TFDIR}" init -migrate-state \
  -backend-config="bucket=${_bucket_name}" \
  -backend-config="region=${_region}" \
  -backend-config="key=${_key}"

# Perform imports for integrated branches (idempotent)
if [ "${_integrated}" = true ]; then
  # Disable filename globbing so [0] in module address is not expanded by the shell
  set -f
  import_pf_integration_state
  set +f
fi

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
  if [ "${_restart_pod}" = true ]; then
    echo "Restarting PingFederate admin pod before configuration apply..."
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
    echo "Restarting PingFederate admin pod after successful apply..."
    restart_pf_pod "${_branch}"

    # Replicate configuration if requested
    if [ "${_replicate}" = true ]; then
      echo "Replicating PingFederation configuration..."
      replicate_pf_config "${_branch}"
    fi
  fi
fi