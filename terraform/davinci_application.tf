resource "davinci_application" "registration_flow_app" {
  name           = "DaVinci API Protect Sample Application"
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  
  oauth {
    enabled = true
    values {
      allowed_grants                = ["authorizationCode"]
      allowed_scopes                = ["openid", "profile"]
      enabled                       = true
      enforce_signed_request_openid = false
      redirect_uris                 = ["${module.pingone_utils.pingone_url_auth_path_full}/rp/callback/openid_connect"]
    }
  }
}

resource "davinci_application_flow_policy" "registration_flow_app_policy" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  application_id = davinci_application.registration_flow_app.id
  name           = "DaVinci API Protect Sample Policy"
  status         = "enabled"
  policy_flow {
    flow_id    = davinci_flow.pingone_davinci_api_protect_example.id
    version_id = -1
    weight     = 100
  }
}