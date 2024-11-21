# PingOne Connection (application)
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/application}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_add_app_worker}
resource "pingone_application" "client_auth_sample_app" {
  environment_id = pingone_environment.target_environment.id
  enabled        = true
  name           = "OIDC SDK Sample App"
  description    = "A custom sample OIDC application to demonstrate PingOne integration."

  oidc_options = {
    type                       = "SINGLE_PAGE_APP"
    grant_types                = ["AUTHORIZATION_CODE", "IMPLICIT", "REFRESH_TOKEN"]
    response_types             = ["CODE", "TOKEN", "ID_TOKEN"]
    pkce_enforcement           = "S256_REQUIRED"
    token_endpoint_auth_method = "NONE"
    redirect_uris              = local.redirect_uris
    post_logout_redirect_uris  = [var.app_url]
  }
}

resource "pingone_application" "worker_app" {
  environment_id = pingone_environment.target_environment.id
  name           = "DemoWorkerApp"
  enabled        = true

  oidc_options = {
    type                       = "WORKER"
    grant_types                = ["CLIENT_CREDENTIALS"]
    token_endpoint_auth_method = "CLIENT_SECRET_BASIC"
  }
}

resource "pingone_application_secret" "worker_app" {
  environment_id = pingone_environment.target_environment.id
  application_id = pingone_application.worker_app.id
}


# PingOne Role Assignment
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/application_role_assignment}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_t_configurerolesforworkerapplication}

resource "pingone_application_role_assignment" "population_identity_data_admin_to_application" {
  environment_id = pingone_environment.target_environment.id
  application_id = pingone_application.worker_app.id
  role_id        = data.pingone_role.identity_data_admin.id

  scope_population_id = pingone_population_default.sample_users.id

}

# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/application_sign_on_policy_assignment}
# {@link https://docs.pingidentity.com/r/en-us/pingone/pingonemfa_associating_sign_on_policy_with_web_app?section=rxy1666194779493}
resource "pingone_application_sign_on_policy_assignment" "default_authN_policy" {
  environment_id    = pingone_environment.target_environment.id
  application_id    = pingone_application.client_auth_sample_app.id
  sign_on_policy_id = pingone_sign_on_policy.default_authn_policy.id
  priority          = 1
}

####################################################
# PingOne Client Authn Application Resource Grants
####################################################
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/application_resource_grant}
resource "pingone_application_resource_grant" "oidc_sdk_sample_app_openid" {
  environment_id = pingone_environment.target_environment.id
  application_id = pingone_application.client_auth_sample_app.id

  resource_type = "OPENID_CONNECT"
  scopes = [
    pingone_resource_scope_openid.profile_scope.id,
    pingone_resource_scope_openid.phone_scope.id,
    pingone_resource_scope_openid.email_scope.id
  ]
}

resource "pingone_application_resource_grant" "oidc_sdk_sample_app_revoke_scope" {
  environment_id     = pingone_environment.target_environment.id
  application_id     = pingone_application.client_auth_sample_app.id
  resource_type      = "CUSTOM"
  custom_resource_id = pingone_resource.oidc_sdk.id

  scopes = [
    pingone_resource_scope.revoke.id
  ]
}