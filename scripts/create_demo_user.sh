#!/usr/bin/env sh

### this script is used to create a demo user in the PingOne environment. ###
# shellcheck source=lib.sh
. scripts/lib.sh
checkVars

_demousername="demouser1"
if test -n "${1}" ; then
  _demousername="${1}"
fi

## Temp file to store terraform state
_tfState=$(mktemp)
terraform -chdir=./terraform show -json > "${_tfState}"
echo "Terraform state saved to: ${_tfState}"
cat "${_tfState}"

_sampleUserPopulationId=$(jq -r '.values.root_module.resources[] | select(.name == "sample_users") | .values.id' < ${_tfState})
export PINGONE_POPULATION_SAMPLE_USERS_ID="${_sampleUserPopulationId}"
_pingoneTargetEnvironmentId=$(jq -r '.values.root_module.resources[] | select(.name == "target_environment") | .values.id' < ${_tfState})

echo "Checking for demo user: ${_demousername}"
## Does user exist? If not, create user
_demoUserId=$(pingcli request --http-method GET --service pingone "environments/${_pingoneTargetEnvironmentId}/users" --output-format JSON | jq -r --arg _demousername "${_demousername}" '.response._embedded.users[] | select(.username == $_demousername) | .id')
if test -z "${_demoUserId}" ; then
  echo "Creating demo user: ${_demousername}"
  _demoUserJson=$(envsubst < pingcli-request-data/create-demo-user.json)
  _createUserResponse=$(pingcli request --http-method POST --service pingone "environments/${_pingoneTargetEnvironmentId}/users" --data "${_demoUserJson}" --output-format JSON)
  _demoUserId=$(echo "${_createUserResponse}" | jq -r '.response.id')
  echo "Demo user created with name: ${_demousername}, id: ${_demoUserId}"
else
  echo "Demo user: ${_demousername} already exists."
fi

## Does user have MFA Device? If not, create MFA Device
_demoUserMfaDeviceId=$(pingcli request --http-method GET --service pingone "environments/${_pingoneTargetEnvironmentId}/users/${_demoUserId}/devices" --output-format JSON | jq -r '.response._embedded.devices[] | select(.type == "EMAIL") | .id')
_demoUserMfaDeviceEmail=$(pingcli request --http-method GET --service pingone "environments/${_pingoneTargetEnvironmentId}/users/${_demoUserId}/devices" --output-format JSON | jq -r '.response._embedded.devices[] | select(.type == "EMAIL") | .email')
if test -z "${_demoUserMfaDeviceId}" ; then
  PINGONE_MFA_POLICY_ID=$(jq -r '.values.root_module.resources[] | select(.name == "mfa_device_policies") | .values.ids[0]' < ${_tfState})
  if test -z "${PINGONE_MFA_POLICY_ID}" ; then
    echo "MFA Policy not found in terraform state."
    exit 1
  fi
  export PINGONE_MFA_POLICY_ID
  echo "Creating MFA Device for demo user: ${_demousername}, with MFA Policy: ${PINGONE_MFA_POLICY_ID}"
  _mfaDeviceJson=$(envsubst < pingcli-request-data/add-device.json)
  _createMfaDeviceResponse=$(pingcli request --http-method POST --service pingone "environments/${_pingoneTargetEnvironmentId}/users/${_demoUserId}/devices" --data "${_mfaDeviceJson}" --output-format JSON)
  _demoUserMfaDeviceId=$(echo "${_createMfaDeviceResponse}" | jq -r '.response.id')
  _demoUserMfaDeviceEmail=$(echo "${_createMfaDeviceResponse}" | jq -r '.response.email')
  echo "MFA Device created with email: ${_demoUserMfaDeviceEmail}, id: ${_demoUserMfaDeviceId}"
else
  echo "MFA Device EMAIL already exists for demo user: ${_demoUserMfaDeviceEmail}"
fi
