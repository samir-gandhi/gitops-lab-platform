#!/bin/bash

# Script to execute commands inside the PingDirectory pod
# Usage: ./run-pd-commands.sh

# Source the lib.sh to get common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib.sh"

checkVars

# Project root directory
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Determine environment/branch name - use environment variable or default to current git branch
if [[ -z "${ENVIRONMENT_NAME}" ]]; then
  ENVIRONMENT_NAME=$(cd "${PROJECT_ROOT}" && git branch --show-current 2>/dev/null || echo "feature")
  echo "Using git branch as environment name: ${ENVIRONMENT_NAME}"
fi

# Determine the namespace based on git branch
NAMESPACE="gitops-lab-${ENVIRONMENT_NAME}"
echo "Using Kubernetes namespace: ${NAMESPACE}"

# Determine the PingDirectory pod name
PD_POD="${ENVIRONMENT_NAME}-pingdirectory-0"
echo "Target PingDirectory pod: ${PD_POD}"

# Check if pod exists
echo "Checking if pod ${PD_POD} exists in namespace ${NAMESPACE}..."
kubectl get pod ${PD_POD} -n ${NAMESPACE} &>/dev/null
if [[ $? -ne 0 ]]; then
  echo "Error: Pod ${PD_POD} not found in namespace ${NAMESPACE}"
  echo "Available pods in namespace ${NAMESPACE}:"
  kubectl get pods -n ${NAMESPACE}
  exit 1
fi

echo "Pod ${PD_POD} found. Proceeding with command execution..."

# Run the envsubst command inside the pod
echo "Step 1: Running envsubst to process LDIF template..."
kubectl exec ${PD_POD} -n ${NAMESPACE} -- sh -c "envsubst < /tmp/server-profile/server-profiles/pingdirectory/pd.profile/ldif/userRoot/30-OAuthClients.ldif > /tmp/OAuthClients.ldif"
if [[ $? -ne 0 ]]; then
  echo "Error: Failed to run envsubst command"
  exit 1
fi
echo "Successfully generated /tmp/OAuthClients.ldif"

# Run the ldapmodify command inside the pod
echo "Step 2: Importing LDIF using ldapmodify..."
kubectl exec ${PD_POD} -n ${NAMESPACE} -- sh -c "ldapmodify --defaultAdd --ldifFile /tmp/OAuthClients.ldif"
if [[ $? -ne 0 ]]; then
  echo "Warning: ldapmodify command returned non-zero exit code"
  echo "This might be expected if some entries already exist"
else
  echo "Successfully imported LDIF file"
fi

echo "Command execution completed."
