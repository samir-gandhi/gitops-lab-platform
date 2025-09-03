#!/bin/bash

# Repository Separation Migration Script
# This script helps migrate files from the monorepo to separate repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
CURRENT_REPO_PATH="/Users/samirgandhi/projects/config-automation/gitops-lab/gitops-lab-platform"
INFRA_REPO_PATH="/Users/samirgandhi/projects/config-automation/gitops-lab/gitops-lab-infrastructure"

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Portable in-place sed helper (macOS/BSD sed vs GNU sed)
inplace_sed() {
    # $1: sed expression (e.g., s/foo/bar/g)
    # $2: target file
    if command -v gsed >/dev/null 2>&1; then
        gsed -i -e "$1" "$2"
    else
        sed -i '' -e "$1" "$2"
    fi
}

# Function to create infrastructure repository structure
create_infra_repo() {
    print_status "Creating infrastructure repository structure..."
    
    if [ ! -d "$INFRA_REPO_PATH" ]; then
        mkdir -p "$INFRA_REPO_PATH"
        cd "$INFRA_REPO_PATH"
        git init
        print_status "Initialized new git repository at $INFRA_REPO_PATH"
    else
        print_warning "Infrastructure repository directory already exists"
    fi
    
    # Create directory structure
    mkdir -p .github/workflows
    mkdir -p infrastructure
    mkdir -p server-profiles
    mkdir -p scripts
    mkdir -p docs
    
    print_status "Created infrastructure repository directory structure"
}

# Function to copy infrastructure files
copy_infrastructure_files() {
    print_status "Copying infrastructure files..."
    
    cd "$CURRENT_REPO_PATH"
    
    # Copy infrastructure directory
    if [ -d "01-infrastructure" ]; then
        cp -r 01-infrastructure/* "$INFRA_REPO_PATH/infrastructure/"
        print_status "Copied 01-infrastructure to infrastructure/"
    fi
    
    # Copy server profiles
    if [ -d "server-profiles" ]; then
        cp -r server-profiles/* "$INFRA_REPO_PATH/server-profiles/"
        print_status "Copied server-profiles/"
    fi
    
    # Copy infrastructure-specific scripts
    if [ -f "scripts/local_feature_deploy_infra.sh" ]; then
        cp scripts/local_feature_deploy_infra.sh "$INFRA_REPO_PATH/scripts/deploy-infrastructure.sh"
        print_status "Copied infrastructure deployment script"
    fi
    
    if [ -f "scripts/lib.sh" ]; then
        cp scripts/lib.sh "$INFRA_REPO_PATH/scripts/"
        print_status "Copied shared library script"
    fi
    
    if [ -f "scripts/kubeconfig.sh" ]; then
        cp scripts/kubeconfig.sh "$INFRA_REPO_PATH/scripts/"
        print_status "Copied kubeconfig script"
    fi
}

# Function to create infrastructure-specific workflows
create_infra_workflows() {
    print_status "Creating infrastructure-specific workflows..."
    
    # Copy and modify push_infra.yml
    if [ -f "$CURRENT_REPO_PATH/.github/workflows/push_infra.yml" ]; then
        cp "$CURRENT_REPO_PATH/.github/workflows/push_infra.yml" "$INFRA_REPO_PATH/.github/workflows/infrastructure-deploy.yml"
        print_status "Copied infrastructure deployment workflow"
    fi
    
    # Copy dependabot.yml
    if [ -f "$CURRENT_REPO_PATH/.github/dependabot.yml" ]; then
        cp "$CURRENT_REPO_PATH/.github/dependabot.yml" "$INFRA_REPO_PATH/.github/"
        print_status "Copied dependabot configuration"
    fi
    
    # Copy issue templates
    if [ -d "$CURRENT_REPO_PATH/.github/ISSUE_TEMPLATE" ]; then
        cp -r "$CURRENT_REPO_PATH/.github/ISSUE_TEMPLATE" "$INFRA_REPO_PATH/.github/"
        print_status "Copied issue templates"
    fi
}

# Function to create infrastructure-specific documentation
create_infra_docs() {
    print_status "Creating infrastructure documentation..."
    
    cat > "$INFRA_REPO_PATH/README.md" << 'EOF'
# GitOps Lab Infrastructure

This repository contains the infrastructure components for the GitOps Lab platform, including Kubernetes deployments and Helm charts for PingFederate and PingDirectory.

## Components

- **Infrastructure**: Terraform configurations for Kubernetes infrastructure
- **Server Profiles**: Configuration profiles for Ping products
- **Helm Charts**: Kubernetes deployment configurations
- **Scripts**: Deployment and management scripts

## Quick Start

1. Configure your environment variables in `localsecrets`
2. Deploy infrastructure: `./scripts/deploy-infrastructure.sh`
3. Verify deployment: `kubectl get pods -n <namespace>`

## Dependencies

This infrastructure is designed to work with the [GitOps Lab Platform](https://github.com/your-org/gitops-lab-platform) repository for application configuration.

## Documentation

- [Infrastructure Deployment Guide](docs/infrastructure-deployment.md)
- [Kubernetes Configuration](docs/kubernetes-setup.md)
- [Troubleshooting](docs/troubleshooting.md)
EOF
    
    # Create infrastructure-specific docs
    mkdir -p "$INFRA_REPO_PATH/docs"
    
    cat > "$INFRA_REPO_PATH/docs/infrastructure-deployment.md" << 'EOF'
# Infrastructure Deployment Guide

This guide covers the deployment of the GitOps Lab infrastructure components.

## Prerequisites

- Kubernetes cluster access
- Helm 3.x installed
- kubectl configured
- AWS CLI configured (for S3 state backend)

## Deployment Process

### Local Development

1. **Configure Environment**:
   ```bash
   cp secretstemplate localsecrets
   # Edit localsecrets with your values
   source localsecrets
   ```

2. **Deploy Infrastructure**:
   ```bash
   ./scripts/deploy-infrastructure.sh
   ```

### CI/CD Deployment

Infrastructure is automatically deployed via GitHub Actions when changes are pushed to:
- `infrastructure/`
- `server-profiles/`
- `.github/workflows/infrastructure-deploy.yml`

## State Management

Terraform state is stored in AWS S3. The state key structure is:
- Production: `infrastructure-state/prod/terraform.tfstate`
- QA: `infrastructure-state/qa/terraform.tfstate`
- Development: `infrastructure-state/dev/<branch-name>/terraform.tfstate`

## Outputs

The infrastructure deployment provides outputs that are consumed by the platform configuration:
- PingFederate admin and engine URLs
- API credentials
- Kubernetes namespace information
EOF
    
    print_status "Created infrastructure documentation"
}

# Function to create infrastructure-specific secrets template
create_infra_secrets() {
    print_status "Creating infrastructure secrets template..."
    
    cat > "$INFRA_REPO_PATH/secretstemplate" << 'EOF'
##########################################
# Infrastructure Deployment Configuration
##########################################

# AWS S3 Backend Configuration
export TF_VAR_tf_state_bucket=''
export TF_VAR_tf_state_region=''
export TF_VAR_tf_state_key_infrastructure="infrastructure-state"

# PingFederate Configuration
export TF_VAR_ping_identity_devops_user=''
export TF_VAR_ping_identity_devops_key=''
export TF_VAR_pingfederate_api_username=''
export TF_VAR_pingfederate_api_password=''

# Docker Registry Configuration
export TF_VAR_docker_repository=''
export TF_VAR_docker_registry_username=''
export TF_VAR_docker_registry_password=''

# Kubernetes Configuration
export TF_VAR_k8s_namespace=''
export TF_VAR_k8s_namespace_prefix="ping-devops-"

# Component Toggles
export TF_VAR_pingdirectory_enabled="true"

# Debug (uncomment to enable)
#export TF_LOG="DEBUG"
EOF
    
    print_status "Created infrastructure secrets template"
}

# Function to create infrastructure Makefile
create_infra_makefile() {
    print_status "Creating infrastructure Makefile..."
    
    cat > "$INFRA_REPO_PATH/GNUmakefile" << 'EOF'
INFRA_DIR:=./infrastructure
default: infracheck

fmt:
	@echo "==> Formatting Terraform code with terraform fmt..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform fmt -recursive .

fmt-check:
	@echo "==> Checking Terraform code with terraform fmt..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform fmt -recursive -check .

tflint:
	@echo "==> Checking Terraform code with tflint..."
	@command -v tflint >/dev/null 2>&1 || { echo >&2 "'tflint' is required but not installed. Aborting."; exit 1; }
	@tflint --recursive

validate:
	@echo "==> Validating Terraform code with terraform validate..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform -chdir=$(INFRA_DIR) validate

trivy:
	@echo "==> Checking Terraform code with trivy..."
	@command -v trivy >/dev/null 2>&1 || { echo >&2 "'trivy' is required but not installed. Aborting."; exit 1; }
	@TF_VAR_pingone_environment_name=$(shell git rev-parse --abbrev-ref HEAD) trivy config ./

infracheck: fmt-check tflint validate trivy
	@echo "==> Infrastructure validation complete"

deploy:
	@echo "==> Deploying infrastructure..."
	@./scripts/deploy-infrastructure.sh

clean:
	@echo "==> Cleaning up infrastructure..."
	@rm -rf $(INFRA_DIR)/.terraform
	@rm -f $(INFRA_DIR)/terraform.tfstate*

.PHONY: fmt fmt-check tflint validate trivy infracheck deploy clean
EOF
    
    print_status "Created infrastructure Makefile"
}

# Function to update infrastructure workflows
update_infra_workflows() {
    print_status "Updating infrastructure workflows..."
    
    # Update paths in infrastructure-deploy.yml
    if [ -f "$INFRA_REPO_PATH/.github/workflows/infrastructure-deploy.yml" ]; then
    inplace_sed 's/01-infrastructure/infrastructure/g' "$INFRA_REPO_PATH/.github/workflows/infrastructure-deploy.yml"
    inplace_sed 's/push_infra\.yml/infrastructure-deploy.yml/g' "$INFRA_REPO_PATH/.github/workflows/infrastructure-deploy.yml"
    inplace_sed 's/drift_check\.yml/drift-check.yml/g' "$INFRA_REPO_PATH/.github/workflows/infrastructure-deploy.yml"
        print_status "Updated infrastructure deployment workflow paths"
    fi
}

# Main execution
main() {
    print_status "Starting repository separation migration..."
    
    create_infra_repo
    copy_infrastructure_files
    create_infra_workflows
    update_infra_workflows
    create_infra_docs
    create_infra_secrets
    create_infra_makefile
    
    print_status "Infrastructure repository migration complete!"
    print_status "Infrastructure repository created at: $INFRA_REPO_PATH"
    print_warning "Next steps:"
    echo "1. Review and commit infrastructure repository files"
    echo "2. Push to GitHub and configure repository settings"
    echo "3. Set up GitHub secrets for infrastructure deployment"
    echo "4. Update platform repository to reference infrastructure state"
    echo "5. Test infrastructure deployment independently"
}

# Check if script is being run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
