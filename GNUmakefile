DEV_DIR:=./configuration
PINGCLI_VERSION=0.7.0
BRANCH:=$(shell git rev-parse --abbrev-ref HEAD)
PF_STACK_TPL:=$(DEV_DIR)/pf_integration.stack.tpl
PF_STACK_OUT:=$(DEV_DIR)/pf_integration.stack.tf

default: devcheck

# Generate / clean unified PingFederate stack prior to Terraform ops
.PHONY: gen-pf-stack
gen-pf-stack:
	@if [ -f "$(PF_STACK_TPL)" ]; then \
	  if echo "$(BRANCH)" | grep -Eq '^(int-|prod|qa)'; then \
	    cp "$(PF_STACK_TPL)" "$(PF_STACK_OUT)"; \
	    echo "[gen-pf-stack] Generated $(PF_STACK_OUT) for integrated branch $(BRANCH)"; \
	  else \
	    rm -f "$(PF_STACK_OUT)"; \
	    echo "[gen-pf-stack] Removed $(PF_STACK_OUT) (non-integrated branch $(BRANCH))"; \
	  fi; \
	fi

.PHONY: clean-pf-stack
clean-pf-stack:
	@rm -f "$(PF_STACK_OUT)" && echo "[clean-pf-stack] Removed $(PF_STACK_OUT)"

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
	@$(MAKE) clean-pf-stack
	@echo "==> Validating Terraform code with terraform validate..."
	@command -v terraform >/dev/null 2>&1 || { echo >&2 "'terraform' is required but not installed. Aborting."; exit 1; }
	@terraform -chdir=$(DEV_DIR) validate

trivy:
	@echo "==> Checking Terraform code with trivy..."
	@command -v trivy >/dev/null 2>&1 || { echo >&2 "'trivy' is required but not installed. Aborting."; exit 1; }
	@TF_VAR_pingone_environment_name=$(BRANCH) trivy config ./

pingcli:
	@echo "==> Checking PingCLI version..."
	@command -v pingcli >/dev/null 2>&1 || { echo >&2 "'pingcli' is required but not installed. Aborting."; exit 1; }
	@installed_version="$$(pingcli --version | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')" && \
	if [ "$$installed_version" != "$(PINGCLI_VERSION)" ]; then \
	  echo >&2 "'pingcli' version is $$installed_version, but $(PINGCLI_VERSION) is required. Aborting."; \
	  exit 1; \
	fi

kubeconfig:
	@echo "==> Setting up kubeconfig..."
	@./scripts/kubeconfig.sh

devcheck:
	@$(MAKE) validate
	@$(MAKE) clean-pf-stack
	@$(MAKE) fmt
	@$(MAKE) kubeconfig

.PHONY: devcheck validate fmt fmt-check tflint trivy pingcli gen-pf-stack clean-pf-stack
	@$(MAKE) tflint
	@$(MAKE) trivy

.PHONY: devcheck validate fmt fmt-check tflint trivy pingcli
