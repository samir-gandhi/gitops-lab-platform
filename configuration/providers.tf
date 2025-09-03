provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_client_environment_id
  region_code    = var.pingone_client_region_code

  global_options {
    population {
      // This option should not be used in environments that contain production data.  Data loss may occur.
      contains_users_force_delete = var.pingone_force_delete_population
    }
  }
}

provider "davinci" {
  username       = var.pingone_davinci_admin_username
  password       = var.pingone_davinci_admin_password
  environment_id = var.pingone_davinci_admin_environment_id
  region         = var.pingone_davinci_admin_region
}

# Only resolve infrastructure remote state when integration is enabled
data "terraform_remote_state" "infrastructure" {
  count   = var.enable_infrastructure_integration ? 1 : 0
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    region = var.tf_state_region
    key    = local.infrastructure_state_key
  }
}

locals {
  # Determine the infrastructure state key based on current environment
  infrastructure_state_key = contains(["prod", "qa"], var.pingone_environment_name) ? "${var.tf_state_key_prefix_infrastructure}/${var.pingone_environment_name}/terraform.tfstate" : "${var.tf_state_key_prefix_infrastructure}/dev/${var.pingone_environment_name}/terraform.tfstate"

  # Safe access to infra outputs when enabled
  infra_outputs = var.enable_infrastructure_integration ? data.terraform_remote_state.infrastructure[0].outputs : {}
}

## Temporary output for tflint, this variable will be used by P1 to PingFederate Configuration later. 
output "name" {
  value = local.infra_outputs
}

variable "tf_state_key_prefix_infrastructure" {
  type        = string
  description = "Key prefix for infrastructure state files in S3"
  default     = "infrastructure-state"
}

# Removed root-level pingfederate provider; configured in pf_integration module

provider "http" {
}

provider "aws" {
  region = var.aws_region

  # Credentials are typically provided via environment variables or shared credentials file
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  # Or via a role when running in a cloud environment
}

provider "acme" {
  # IMPORTANT: Currently using Let's Encrypt staging environment which produces untrusted certificates
  # This is good for testing as it doesn't have strict rate limits
  # When ready for production, comment the staging URL and uncomment the production URL

  # Production URL (uncomment when ready):
  server_url = "https://acme-v02.api.letsencrypt.org/directory"

  # Staging URL (for testing):
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
# staging server should produce an error similar to:
# pingone_custom_domain_ssl.custom_domain: Creating...
# ╷
# │ Error: Error when calling `UpdateDomain`: The request could not be completed. One or more validation errors were in the request.
# │ 
# │   with pingone_custom_domain_ssl.custom_domain,
# │   on custom_domain.tf line 63, in resource "pingone_custom_domain_ssl" "custom_domain":
# │   63: resource "pingone_custom_domain_ssl" "custom_domain" {
# │ 
# │ PingOne Error Details:
# │ ID:           5971ffce-411b-4baa-9793-020346b795ba
# │ Code:         INVALID_DATA
# │ Message:      The request could not be completed. One or more validation errors were in the request.
# │ Details:
# │   - Code:     INVALID_VALUE
# │     Message:  The certificate that is attached to your distribution was not issued by a trusted Certificate Authority. For more details, see: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/CNAMEs.html#alternate-domain-names-requirements
# │