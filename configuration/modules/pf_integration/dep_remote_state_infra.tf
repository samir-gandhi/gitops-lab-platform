data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = var.tf_state_bucket
    region = var.tf_state_region
    key    = local.infrastructure_state_key
  }
}

# Dynamic configuration for remote state based on the environment
locals {
  # Determine the infrastructure state key based on current environment
  infrastructure_state_key = contains(["prod", "qa"], var.pingone_environment_name) ? "${var.tf_state_key_prefix_infrastructure}/${var.pingone_environment_name}/terraform.tfstate" : "${var.tf_state_key_prefix_infrastructure}/dev/${var.pingone_environment_name}/terraform.tfstate"
}

//infrastructure-state/dev/module.pf_integration[0].pingfederate_virtual_host_names.pingcli__Virtual-0020-Host-0020-Names virtual_host_names_singleton_id/terraform.tfstate

variable "tf_state_key_prefix_infrastructure" {
  type        = string
  description = "Key prefix for infrastructure state files in S3"
  default     = "infrastructure-state"
}

# S3 backend configuration variables
variable "tf_state_bucket" {
  type        = string
  description = "S3 bucket for Terraform state storage"
}

variable "tf_state_region" {
  type        = string
  description = "AWS region for S3 bucket storing Terraform state"
}