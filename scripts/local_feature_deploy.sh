#!/usr/bin/env sh

test -f scripts/lib.sh || {
  echo "Please run the script from the root of the repository"
  exit 1
}
_command="apply"
_replicate=false

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
END_USAGE
exit 99
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

## terraform apply

echo "Running terraform ${_command} for branch: ${_branch}, You will be prompted to enter the required variables."

export TF_VAR_pingone_environment_name="${_branch}"

terraform -chdir="${TFDIR}" ${_command}

## Replicate PingFederation Configuration if requested
if [ "${_replicate}" = true ] && [ "${_command}" != "destroy" ]; then
  echo "Replicating PingFederation configuration..."
  
  # Check if required credentials are available
  if [ -z "${TF_VAR_pingfederate_api_username}" ] || [ -z "${TF_VAR_pingfederate_api_password}" ]; then
    echo "PingFederate API credentials are not set. Please set TF_VAR_pingfederate_api_username and TF_VAR_pingfederate_api_password in your localsecrets file."
    exit 1
  fi
  
  _host="https://${_branch}-pingfederate-admin.ping-devops.com"
  _uri="/pf-admin-api/v1/cluster/replicate"
  
  echo "Calling PingFederate replication endpoint at ${_host}${_uri}"
  curl -k -X POST "${_host}${_uri}" \
    -H "Content-Type: application/json" \
    -H "X-XSRF-Header: $(date +%s)" \
    -u "${TF_VAR_pingfederate_api_username}:${TF_VAR_pingfederate_api_password}"
    
  if [ $? -eq 0 ]; then
    echo "PingFederation configuration replicated successfully."
  else
    echo "Failed to replicate PingFederation configuration."
    exit 1
  fi
fi