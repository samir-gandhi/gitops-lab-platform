# Configuration Management Guide

This document outlines the processes, scripts, and workflows used to manage infrastructure and configuration in this GitOps-based platform.

## Overview

Our infrastructure and configuration deployment follows a two-phase approach:

1. **Infrastructure Deployment**: Deploys Kubernetes containers and services using Terraform.
2. **Configuration Deployment**: Configures the deployed PingFederate service and SaaS PingOne service once infrastructure is healthy.

## Deployment Process

### Local Development

For local feature branch development:

1. **Deploy Infrastructure**:

   ```bash
   ./scripts/local_feature_deploy_infra.sh [-c]
   ```

   The `-c` option automatically runs configuration deployment after infrastructure is ready.

2. **Deploy Configuration**:

   ```bash
   ./scripts/local_feature_deploy.sh [-r] [--restart-pod]
   ```

   Options:
   - `-r, --replicate`: Replicates PingFederate configuration after deployment
   - `--restart-pod`: Restarts the PingFederate admin pod before configuration

### CI/CD Deployment (GitHub Workflows)

Our GitHub workflow automation follows this sequence:

1. **Infrastructure Deployment** (push_infra.yml):
   - Validates Terraform configuration
   - Deploys infrastructure resources
   - Marks infrastructure status in S3
   - Restarts PingFederate admin pod to ensure clean state

2. **Configuration Deployment** (push_config.yml):
   - Waits for infrastructure to be ready (checks S3 status)
   - Restarts PingFederate admin pod
   - Applies configuration
   - Replicates PingFederate configuration

## Destruction Process

### Local Destruction

1. **Prepare for Destroy**:

   ```bash
   ./scripts/local_feature_deploy.sh --prepare-destroy -d
   ```

   This prepares the environment for destruction by:
   - Running prepare-destroy.sh which reverts SSL server certificate configuration in PingFederate
   - Attempts to destroy configuration
   - If resource-in-use errors occur, restarts the PingFederate admin pod and retries

2. **Destroy Infrastructure**:

   ```bash
   ./scripts/local_feature_deploy_infra.sh -d
   ```

### CI/CD Destruction (GitHub Workflows)

When a branch is deleted, the prune.yml workflow:

1. Runs prepare-destroy.sh to clean up PingFederate configuration
2. Attempts to destroy configuration resources
3. If resource-in-use errors occur, restarts PingFederate admin pod and retries
4. Destroys infrastructure resources
5. Cleans up S3 status files

## Key Components Explained

### 1. PingFederate Pod Management

The PingFederate admin pod needs to be restarted at specific points:

- Before configuration deployment to ensure it can accept changes
- After a resource-in-use error when trying to destroy configuration

### 2. Configuration Replication

After applying configuration changes, we need to replicate the configuration to ensure all PingFederate nodes are in sync:

```bash
curl -k -X POST "https://${branch}-pingfederate-admin.ping-devops.com/pf-admin-api/v1/cluster/replicate" \
  -H "Content-Type: application/json" \
  -H "X-XSRF-Header: $(date +%s)" \
  -u "${username}:${password}"
```

### 3. Status Tracking

We use S3 to track the status of infrastructure deployment:

- `in-progress`: Infrastructure deployment has started
- `ready`: Infrastructure is ready for configuration
- `failed`: Infrastructure deployment has failed

### 4. Resource Dependencies

The configuration depends on the infrastructure being healthy. The workflow enforces this by:

- Tracking state in S3
- Waiting for infrastructure to be ready before deploying configuration
- Handling specific error cases like resource-in-use errors

## Common Issues and Troubleshooting

### Resource-in-Use Errors

When destroying configuration, you may encounter:
```
Error: PingFederate API error
Error summary: An error occurred while deleting a data store
Message: This resource is in use and cannot be deleted.
HTTP status: 422 Unprocessable Entity
Result ID: resource_in_use
```

This is addressed by:
1. Running prepare-destroy.sh to clean up configurations
2. Restarting the PingFederate admin pod
3. Retrying the configuration destroy operation

### Infrastructure Not Ready

If configuration deployment fails because infrastructure isn't ready:
1. Check if the infrastructure deployment completed successfully
2. Verify the S3 status file shows "ready" state
3. Check PingFederate admin pod status (`kubectl get pods -n ping-devops-<branch>`)

## Maintaining This System

When making changes to the deployment process:

1. Always handle the PingFederate admin pod restart during critical operations
2. Ensure proper sequencing of operations (infrastructure → pod restart → configuration → replication)
3. Update status tracking in S3 to maintain workflow coordination
4. Consider the dependencies between components when making changes
