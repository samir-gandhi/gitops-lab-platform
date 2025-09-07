DEV_DIR:=./configuration
PINGCLI_VERSION=0.7.0
BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
PF_STACK_TPL:=$(DEV_DIR)/pf_integration.stack.tpl
PF_STACK_OUT:=$(DEV_DIR)/pf_integration.stack.tf

default: devcheck

# Generate / clean unified PingFederate stack prior to Terraform ops
.PHONY: gen-pf-stack
gen-pf-stack: validate
	@if [ -f "$(PF_STACK_TPL)" ]; then \
	  if echo "$(BRANCH)" | grep -Eq '^(int-|prod|qa)'; then \
	    cp "$(PF_STACK_TPL)" "$(PF_STACK_OUT)"; \
	    echo "[gen-pf-stack] Generated $(PF_STACK_OUT) for integrated branch $(BRANCH)"; \
	  else \
	    rm -f "$(PF_STACK_OUT)"; \
	    echo "[gen-pf-stack] Removed $(PF_STACK_OUT) (non-integrated branch $(BRANCH))"; \
	  fi; \
	fi

fmt: gen-pf-stack
	@echo "==> Formatting Terraform code with terraform fmt..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform fmt -recursive .

fmt-check: gen-pf-stack
	@echo "==> Checking Terraform code with terraform fmt..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform fmt -recursive -check .

tflint: gen-pf-stack
	@echo "==> Checking Terraform code with tflint..."
	@command -v tflint >/dev/null 2>&1 || { echo >&2 "'tflint' is required but not installed. Aborting."; exit 1; }
	@tflint --recursive

validate:
	@echo "==> Validating Terraform code with terraform validate..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform -chdir=$(DEV_DIR) validate

trivy: gen-pf-stack
	@echo "==> Checking Terraform code with trivy..."
	@command -v trivy >/dev/null 2>&1 || { echo >&2 "'trivy' is required but not installed. Aborting."; exit 1; }
	@TF_VAR_pingone_environment_name=$(BRANCH) trivy config ./

pingcli:
	@echo "==> Checking PingCLI version..."
	@command -v pingcli >/dev/null 2>&1 || { echo >&2 "'pingcli' is required but not installed. Aborting."; exit 1; }
	@pingcli --version | grep -q $(PINGCLI_VERSION) || { echo >&2 "'pingcli' version is not $(PINGCLI_VERSION). Aborting."; exit 1; }

devcheck: validate fmt fmt-check validate tflint trivy

.PHONY: devcheck fmt fmt-check validate tflint trivy pingcli
