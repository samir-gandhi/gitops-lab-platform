# Dynamic configuration for remote state based on the environment
locals {
  # Determine the infrastructure state key based on current environment
  infrastructure_state_key = contains(["prod", "qa"], var.pingone_environment_name) ? "${var.tf_state_key_prefix_infrastructure}/${var.pingone_environment_name}/terraform.tfstate" : "${var.tf_state_key_prefix_infrastructure}/dev/${var.pingone_environment_name}/terraform.tfstate"
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    bucket = var.tf_state_bucket
    region = var.tf_state_region
    key    = local.infrastructure_state_key
  }
}