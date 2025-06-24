#!/bin/bash

# Script to revert SSL server certificate configuration in PingFederate
# This sets the automatically generated certificate as the active/default one

# Source the lib.sh to get common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

checkVars

# Project root directory
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Extract PingFederate host from Terraform state
echo "Getting PingFederate host from Terraform state..."

# Determine environment name - use environment variable or default to dev/feature
if [[ -z "${ENVIRONMENT_NAME}" ]]; then
  ENVIRONMENT_NAME=$(cd "${PROJECT_ROOT}" && git branch --show-current 2>/dev/null || echo "feature")
  echo "Using git branch as environment name: ${ENVIRONMENT_NAME}"
fi

# Get S3 bucket from environment variable
S3_BUCKET="${TF_VAR_tf_state_bucket}"
if [[ -z "${S3_BUCKET}" ]]; then
  echo "TF_VAR_tf_state_bucket not found in environment. Using default bucket."
  S3_BUCKET="gitlab-ping-devops-infra-tf-state"
fi

# Get Terraform state key prefix from environment variable or use default
if [[ ! -z "${TF_VAR_tf_state_key_infrastructure}" ]]; then
  TF_STATE_KEY_PREFIX="${TF_VAR_tf_state_key_infrastructure}"
  echo "Using state key prefix from environment: ${TF_STATE_KEY_PREFIX}"
else
  TF_STATE_KEY_PREFIX="infrastructure-state"
  echo "TF_VAR_tf_state_key_infrastructure not found in environment. Using default prefix: ${TF_STATE_KEY_PREFIX}"
fi

# Get Terraform state key based on environment
if [[ "${ENVIRONMENT_NAME}" == "prod" || "${ENVIRONMENT_NAME}" == "qa" ]]; then
  TF_STATE_KEY="${TF_STATE_KEY_PREFIX}/${ENVIRONMENT_NAME}/terraform.tfstate"
else
  TF_STATE_KEY="${TF_STATE_KEY_PREFIX}/dev/${ENVIRONMENT_NAME}/terraform.tfstate"
fi

echo "Using Terraform state key: ${TF_STATE_KEY}"
echo "Using S3 bucket: ${S3_BUCKET}"

# Get PingFederate admin URL from Terraform state
PF_ADMIN_HOST=$(cd "${PROJECT_ROOT}/02-configuration" && \
  AWS_PAGER="" aws s3 cp \
  "s3://${S3_BUCKET}/${TF_STATE_KEY}" - 2>/dev/null | \
  jq -r '.outputs.pingfederate_admin_ingress_url.value' 2>/dev/null)

# Check if we got a valid host
if [[ -z "${PF_ADMIN_HOST}" || "${PF_ADMIN_HOST}" == "null" ]]; then
  echo "Failed to get PingFederate admin host from Terraform state."
  
  # Use environment variable as fallback
  if [[ -z "${PF_ADMIN_HOST}" ]]; then
    echo "PF_ADMIN_HOST environment variable is not set. Using localhost:9999 as default."
    PF_ADMIN_HOST="localhost:9999"
  fi
else
  echo "Found PingFederate admin host: ${PF_ADMIN_HOST}"
fi

# Check if using HTTPS
if [[ "$PF_ADMIN_HOST" =~ ^https:// ]]; then
  pfHost="${PF_ADMIN_HOST}"
else
  pfHost="https://${PF_ADMIN_HOST}"
fi

# Check for credentials in environment variables (from secretstemplate)
echo "Checking for PingFederate credentials in environment..."

# Add basic auth using credentials from environment variables
AUTH_HEADER=""
if [[ ! -z "${TF_VAR_pingfederate_api_username}" && ! -z "${TF_VAR_pingfederate_api_password}" ]]; then
  echo "Using credentials from environment variables"
  AUTH_HEADER="-u ${TF_VAR_pingfederate_api_username}:${TF_VAR_pingfederate_api_password}"
else
  # Fallback to credentials from Terraform state if environment variables are not set
  echo "Environment variables not found. Attempting to get credentials from Terraform state..."
  PF_ADMIN_USER=$(cd "${PROJECT_ROOT}/02-configuration" && \
    AWS_PAGER="" aws s3 cp \
    "s3://gitlab-ping-devops-infra-tf-state/${TF_STATE_KEY}" - 2>/dev/null | \
    jq -r '.outputs.pingfederate_api_username.value' 2>/dev/null)

  PF_ADMIN_PASS=$(cd "${PROJECT_ROOT}/02-configuration" && \
    AWS_PAGER="" aws s3 cp \
    "s3://gitlab-ping-devops-infra-tf-state/${TF_STATE_KEY}" - 2>/dev/null | \
    jq -r '.outputs.pingfederate_api_password.value' 2>/dev/null)

  if [[ ! -z "${PF_ADMIN_USER}" && ! -z "${PF_ADMIN_PASS}" && "${PF_ADMIN_USER}" != "null" && "${PF_ADMIN_PASS}" != "null" ]]; then
    echo "Using credentials from Terraform state"
    AUTH_HEADER="-u ${PF_ADMIN_USER}:${PF_ADMIN_PASS}"
  else
    echo "No credentials found. Proceeding without authentication."
  fi
fi

# Optional: Skip SSL verification for self-signed certs in dev environments
CURL_SSL_OPTS="--insecure"

echo "Step 1: Getting list of SSL server certificates"
ssl_keys_response=$(curl ${CURL_SSL_OPTS} -s -X 'GET' \
  "${pfHost}/pf-admin-api/v1/keyPairs/sslServer" \
  -H 'accept: application/json' \
  -H 'X-XSRF-Header: PingFederate' \
  ${AUTH_HEADER})

# Check if the curl command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to retrieve SSL server certificates"
  exit 1
fi

echo "SSL keys response:"
echo "$ssl_keys_response" | jq .

# Step 2: Extract the auto-generated certificate (the one that is not "sslservercert")
auto_gen_cert=$(echo "$ssl_keys_response" | jq -r '.items[] | select(.id != "sslservercert") | .id')

if [[ -z "$auto_gen_cert" ]]; then
  echo "Error: Could not find the auto-generated certificate"
  exit 1
fi

echo "Found auto-generated certificate with ID: $auto_gen_cert"

# Step 3: Prepare the payload to set the auto-generated certificate as default
payload=$(cat <<EOF
{
  "runtimeServerCertRef": {
    "id": "${auto_gen_cert}",
    "location": "https://${PF_ADMIN_HOST}/pf-admin-api/v1/keyPairs/sslServer/${auto_gen_cert}"
  },
  "adminConsoleCertRef": {
    "id": "${auto_gen_cert}",
    "location": "https://${PF_ADMIN_HOST}/pf-admin-api/v1/keyPairs/sslServer/${auto_gen_cert}"
  },
  "activeRuntimeServerCerts": [
    {
      "id": "${auto_gen_cert}",
      "location": "https://${PF_ADMIN_HOST}/pf-admin-api/v1/keyPairs/sslServer/${auto_gen_cert}"
    }
  ],
  "activeAdminConsoleCerts": [
    {
      "id": "${auto_gen_cert}",
      "location": "https://${PF_ADMIN_HOST}/pf-admin-api/v1/keyPairs/sslServer/${auto_gen_cert}"
    }
  ]
}
EOF
)

echo "Step 3: Setting auto-generated certificate as default"
echo "Payload:"
echo "$payload" | jq .

# Store the actual hostname without protocol for location URLs
actual_hostname=$(echo "${PF_ADMIN_HOST}" | sed -e 's|^https://||' -e 's|^http://||')

# Update the payload with correct location URLs
payload=$(echo "$payload" | sed "s|https://${PF_ADMIN_HOST}|https://${actual_hostname}|g")

# PUT request to update SSL server settings
echo "Sending PUT request to ${pfHost}/pf-admin-api/v1/keyPairs/sslServer/settings"
update_response=$(curl ${CURL_SSL_OPTS} -s -X 'PUT' \
  "${pfHost}/pf-admin-api/v1/keyPairs/sslServer/settings" \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H 'X-XSRF-Header: PingFederate' \
  ${AUTH_HEADER} \
  -d "$payload")

# Check if the curl command was successful
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to update SSL server settings"
  exit 1
fi

echo "SSL settings update response:"
echo "$update_response" | jq .

echo "Successfully reverted SSL certificate configuration to use auto-generated certificate"
