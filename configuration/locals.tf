# Define local variables
locals {
  # Use the branch name (environment name) as the subdomain
  subdomain = var.pingone_environment_name
  # Construct the full domain name
  domain_name = "${local.subdomain}.${var.parent_domain}"
  # Only create custom domain for qa and prod environments
  create_custom_domain = contains(["qa", "prod"], var.pingone_environment_name)
}