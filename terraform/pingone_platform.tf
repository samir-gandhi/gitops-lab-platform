resource "pingone_environment" "target_environment" {
  name        = var.pingone_environment_name
  description = "PingOne CICD demo provisioned by Terraform"
  type        = var.pingone_environment_type
  license_id  = var.pingone_license_id

  services = [
    {
      type = "MFA"
    },
    {
      type = "DaVinci"
      tags = ["DAVINCI_MINIMAL"]
    }
  ]

}

data "pingone_role" "davinci_admin" {
  name = "DaVinci Admin"
}

# PingOne Role Assignment for DaVinci Flow Designers to SSO to new environment
# resource "pingone_group_role_assignment" "admin_sso_davinci_admin" {
#   environment_id       = var.pingone_environment_id
#   group_id             = var.pingone_davinci_user_group_id
#   role_id              = data.pingone_role.davinci_admin.id
#   scope_environment_id = pingone_environment.target_environment.id
# }

# PingOne Role Assignment for terraform clients to SSO to new environment
resource "pingone_group_role_assignment" "terraform_sso_davinci_admin" {
  environment_id       = var.pingone_davinci_admin_environment_id
  group_id             = var.pingone_davinci_terraform_group_id
  role_id              = data.pingone_role.davinci_admin.id
  scope_environment_id = pingone_environment.target_environment.id
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

resource "pingone_application" "davinci_connection_worker" {
  environment_id = pingone_environment.target_environment.id
  name           = "DaVinci Connection Worker"
  enabled        = true

  oidc_options = {
    type                       = "WORKER"
    grant_types                = ["CLIENT_CREDENTIALS"]
    token_endpoint_auth_method = "CLIENT_SECRET_BASIC"
  }
}

resource "pingone_application_secret" "davinci_connection_worker" {
  environment_id = pingone_environment.target_environment.id
  application_id = pingone_application.davinci_connection_worker.id
}

data "pingone_role" "identity_data_admin" {
  name = "Identity Data Admin"
}

resource "pingone_application_role_assignment" "single_environment_admin_to_application" {
  environment_id       = pingone_environment.target_environment.id
  application_id       = pingone_application.davinci_connection_worker.id
  role_id              = data.pingone_role.identity_data_admin.id
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


##############################################
# PingOne Agreements
##############################################

# PingOne Agreement
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/agreement}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_c_agreements}
data "pingone_language" "en" {
  environment_id = pingone_environment.target_environment.id

  locale = "en"
}

resource "pingone_agreement" "agreement" {
  environment_id = pingone_environment.target_environment.id

  name        = "Terms of Service"
  description = "Terms of Service Agreement"
}

resource "pingone_agreement_localization" "agreement_en" {
  environment_id = pingone_environment.target_environment.id
  agreement_id   = pingone_agreement.agreement.id
  language_id    = data.pingone_language.en.id

  display_name = "Terms and Conditions"
}

resource "pingone_agreement_localization_revision" "agreement_en_now" {
  environment_id            = pingone_environment.target_environment.id
  agreement_id              = pingone_agreement.agreement.id
  agreement_localization_id = pingone_agreement_localization.agreement_en.id

  content_type      = "text/html"
  require_reconsent = true
  text              = <<EOT
<p>Terms of Service Agreement</p>
EOT
}

resource "pingone_agreement_localization_enable" "agreement_en_enable" {
  environment_id            = pingone_environment.target_environment.id
  agreement_id              = pingone_agreement.agreement.id
  agreement_localization_id = pingone_agreement_localization.agreement_en.id

  enabled = true

  depends_on = [
    pingone_agreement_localization_revision.agreement_en_now
  ]
}

resource "pingone_agreement_enable" "agreement_enable" {
  environment_id = pingone_environment.target_environment.id
  agreement_id   = pingone_agreement.agreement.id

  enabled = true

  depends_on = [
    pingone_agreement_localization_enable.agreement_en_enable
  ]
}

##############################################
# PingOne Notifications
##############################################

# PingOne Notifications
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/notification_template_content}
# {@link https://docs.pingidentity.com/r/en-us/pingone/pingonemfa_customizing_notifications}

resource "pingone_notification_template_content" "email" {
  environment_id = pingone_environment.target_environment.id
  template_name  = "general"
  locale         = "en"

  email = {
    body    = <<EOT
<div style="display: block; text-align: center; font-family: sans-serif; border: 1px solid #c5c5c5; width: 400px; padding: 50px 30px;">
<img class="align-self-center mb-5" src="$${logoUrl}" alt="$${companyName}" style="$${logoStyle}"/>
     <h1>Success</h1>
     <div style="margin-top: 20px; margin-bottom:25px">
     <p> Please click the link below to confirm your email for Authentication. </p>
     <a href="$${magicLink}" style="font-size: 14pt">Confirmation Link</a>
     </div>
</div>
EOT
    subject = "Magic Link Authentication"

    from = {
      name    = "PingOne"
      address = "noreply@pingidentity.com"
    }
  }
}

##########################################################################
# outputs.tf - (optional) Contains outputs from the resources created
# @see https://developer.hashicorp.com/terraform/language/values/outputs
##########################################################################

output "pingone_environment_id" {
  value = pingone_environment.target_environment.id
}
