#!/usr/bin/env sh

### this script is used to run terraform apply for your local feature branch only. ###

test -f scripts/lib.sh || {
  echo "Please run the script from the root of the repository"
  exit 1
}
_command="apply"

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
END_USAGE
exit 99
}

exit_usage()
{
    echo "$*"
    usage
    exit 1
}

while ! test -z ${1} ; do
  case "${1}" in
    -d|--destroy)
      _command="destroy" ;;
    -g|--generate)
      _command="plan -generate-config-out=generated-infrastructure.tf" ;;
    -v|--verbose)
      set -x ;;
    -h|--help)
      exit_usage "" ;;
    *)
      exit_usage "Unrecognized Option" ;;
  esac
  shift
done

## check devops vars
if test -z "${TF_VAR_ping_identity_devops_user}" ; then
  if test -n "${PING_IDENTITY_DEVOPS_USER}" ; then
    export TF_VAR_ping_identity_devops_user="${PING_IDENTITY_DEVOPS_USER}"
  else
    echo "Set the TF_VAR_ping_identity_devops_user or PING_IDENTITY_DEVOPS_USER environment variable"
    exit 1
  fi
fi

if test -z "${TF_VAR_ping_identity_devops_key}" ; then
  if test -n "${PING_IDENTITY_DEVOPS_KEY}" ; then
    export TF_VAR_ping_identity_devops_key="${PING_IDENTITY_DEVOPS_KEY}"
  else
    echo "Set the TF_VAR_ping_identity_devops_key or PING_IDENTITY_DEVOPS_KEY environment variable"
    exit 1
  fi
fi

## check additional vars
# shellcheck source=lib.sh
. scripts/lib.sh
checkVars

## Set environment variables 
_branch=$(git rev-parse --abbrev-ref HEAD)
if test "$_branch" = "prod" || test  "$_branch" = qa ; then
  echo "You are on a non-dev branch. Please checkout to your feature branch to run this script."
  exit 1
fi
export TF_VAR_k8s_helm_deployment_name="${_branch}"
export TF_VAR_pingone_environment_name="${_branch}"
export TFDIR="01-infrastructure"

## S3 state bucket variables
## local aws default profile will be used
## Specify the bucket name and region
if [ -z "${TF_VAR_tf_state_bucket}" ] || [ -z "${TF_VAR_tf_state_region}" ]; then
  echo "TF_VAR_tf_state_bucket or TF_VAR_tf_state_region is not set. Please set the appropriate variables in your localsecrets file."
  exit 1
fi

## S3 Backend configuration
export TF_VAR_tf_state_key_prefix_infrastructure="infrastructure-state"
_bucket_name="${TF_VAR_tf_state_bucket}"
_region="${TF_VAR_tf_state_region}"
_key="${TF_VAR_tf_state_key_prefix_infrastructure}/dev/${_branch}/terraform.tfstate"

## terraform init
terraform -chdir="${TFDIR}" init -migrate-state \
  -backend-config="bucket=${_bucket_name}" \
  -backend-config="region=${_region}" \
  -backend-config="key=${_key}"

## terraform command
echo "Running terraform apply for branch: ${_branch}, You will be prompted to enter the required variables."
terraform -chdir="${TFDIR}" ${_command}

# ## Create demo user unless destroy command is passed
# if test "${_command}" != "destroy" ; then
#   sh scripts/create_demo_user.sh
# fi