#!/usr/bin/env sh

## this holds the common functions used by other scripts ####

# Set default namespace prefix if not already set
if [ -z "${TF_VAR_k8s_namespace_prefix}" ]; then
  export TF_VAR_k8s_namespace_prefix="ping-devops-"
fi

checkVars() {
  for var in \
  "${TF_VAR_pingone_client_id}" \
  "${TF_VAR_pingone_client_secret}" \
  "${TF_VAR_pingone_client_region_code}" \
  "${TF_VAR_pingone_client_environment_id}" \
  "${TF_VAR_pingone_license_id}" \
  "${TF_VAR_pingone_davinci_admin_username}" \
  "${TF_VAR_pingone_davinci_admin_password}" \
  "${TF_VAR_pingone_davinci_admin_environment_id}" \
  "${TF_VAR_pingone_davinci_admin_region}" \
  "${TF_VAR_pingone_davinci_terraform_group_id}" \
  "${TF_VAR_pingone_environment_type}" \
  "${AWS_ACCESS_KEY_ID}" \
  "${AWS_SECRET_ACCESS_KEY}" \
  "${TF_VAR_tf_state_bucket}" \
  "${TF_VAR_tf_state_region}" \
  "${TF_VAR_ping_identity_devops_user}" \
  "${TF_VAR_ping_identity_devops_key}" \
  "${DEMO_USER_EMAIL_PREFIX}" \
  "${DEMO_USER_EMAIL_DOMAIN}" \
  "${DEMO_USER_PASSWORD}" ; do
    if [ -z "${var}" ]; then
      echo "Please set the required environment variables: 
      TF_VAR_pingone_client_id
      TF_VAR_pingone_client_secret
      TF_VAR_pingone_client_region_code
      TF_VAR_pingone_client_environment_id
      TF_VAR_pingone_license_id
      TF_VAR_pingone_davinci_admin_username
      TF_VAR_pingone_davinci_admin_password
      TF_VAR_pingone_davinci_admin_environment_id
      TF_VAR_pingone_davinci_admin_region
      TF_VAR_pingone_davinci_terraform_group_id
      TF_VAR_pingone_environment_type
      AWS_ACCESS_KEY_ID
      AWS_SECRET_ACCESS_KEY
      TF_VAR_tf_state_bucket
      TF_VAR_tf_state_region
      TF_VAR_ping_identity_devops_user
      TF_VAR_ping_identity_devops_key
      DEMO_USER_EMAIL_PREFIX
      DEMO_USER_EMAIL_DOMAIN
      DEMO_USER_PASSWORD"
      exit 1
    fi
  done
}
