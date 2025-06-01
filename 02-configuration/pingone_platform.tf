resource "pingone_environment" "target_environment" {
  name        = var.pingone_environment_name
  description = "PingOne CICD demo provisioned by Terraform"
  type        = var.pingone_environment_type
  license_id  = var.pingone_license_id

  services = [
    {
      type = "SSO"
    },
    {
      type = "MFA"
    },
    {
      type = "DaVinci",
      tags = ["DAVINCI_MINIMAL"]
    },
    {
      type = "Risk"
    }
  ]
}

# PingOne Utilities Module
# {@link https://registry.terraform.io/modules/pingidentity/utils/pingone/latest}
module "pingone_utils" {
  source  = "pingidentity/utils/pingone"
  version = "0.1.0"

  environment_id = pingone_environment.target_environment.id
  region_code    = var.pingone_client_region_code
}

# PingOne Population
resource "pingone_population_default" "sample_users" {
  environment_id = pingone_environment.target_environment.id
  name           = "Sample Users"
  description    = "Sample Population"
  lifecycle {
    # change the `prevent_destroy` parameter value to `true` to prevent this data carrying resource from being destroyed
    prevent_destroy = false
  }
}

data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}

data "pingone_role" "davinci_admin" {
  name = "DaVinci Admin"
}

data "pingone_group" "org_identity_data_admin" {
  environment_id = var.pingone_client_environment_id
  name           = "org-identity-admins"
}

resource "pingone_group_role_assignment" "identity_data_admin" {
  environment_id = var.pingone_client_environment_id
  role_id        = data.pingone_role.identity_data_admin.id
  group_id       = data.pingone_group.org_identity_data_admin.id

  scope_environment_id = pingone_environment.target_environment.id
}

# PingOne Role Assignment for terraform clients to SSO to new environment
resource "pingone_group_role_assignment" "terraform_sso_davinci_admin" {
  environment_id       = var.pingone_davinci_admin_environment_id
  group_id             = var.pingone_davinci_terraform_group_id
  role_id              = data.pingone_role.davinci_admin.id
  scope_environment_id = pingone_environment.target_environment.id
}

##############################################
# PingOne Application OIDC Scopes
##############################################

resource "pingone_resource_scope_openid" "profile_scope" {
  environment_id = pingone_environment.target_environment.id
  name           = "profile"
}

resource "pingone_resource_scope_openid" "phone_scope" {
  environment_id = pingone_environment.target_environment.id
  name           = "phone"
}

resource "pingone_resource_scope_openid" "email_scope" {
  environment_id = pingone_environment.target_environment.id
  name           = "email"
}

resource "pingone_resource_scope" "revoke" {
  environment_id = pingone_environment.target_environment.id
  resource_id    = pingone_resource.oidc_sdk.id
  name           = "revoke"
}

##############################################
# PingOne Custom Resources
##############################################

resource "pingone_resource" "oidc_sdk" {
  environment_id                = pingone_environment.target_environment.id
  name                          = "OIDC SDK"
  description                   = "Custom resources for the OIDC SDK sample app"
  audience                      = "oidc-sdk"
  access_token_validity_seconds = 3000
}

##########################################################################
# outputs.tf - (optional) Contains outputs from the resources created
# @see https://developer.hashicorp.com/terraform/language/values/outputs
##########################################################################

output "pingone_environment_id" {
  value = pingone_environment.target_environment.id
}
