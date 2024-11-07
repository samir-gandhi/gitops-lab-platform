DEV_DIR:=./terraform
default: devcheck

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
	@terraform -chdir=$(DEV_DIR) validate

trivy:
	@echo "==> Checking Terraform code with trivy..."
	@command -v trivy >/dev/null 2>&1 || { echo >&2 "'trivy' is required but not installed. Aborting."; exit 1; }
        @TF_VAR_pingone_environment_name=$(git rev-parse --abbrev-ref HEAD) trivy config ./

devcheck: fmt fmt-check validate tflint trivy

.PHONY: devcheck fmt fmt-check validate tflint trivy
