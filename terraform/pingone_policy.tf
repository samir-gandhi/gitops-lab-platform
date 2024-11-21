##############################################
# PingOne Policies
##############################################

# PingOne Sign-On Policy
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/sign_on_policy}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_add_an_auth_policy}
resource "pingone_sign_on_policy" "default_authn_policy" {
  environment_id = pingone_environment.target_environment.id
  name           = "OIDC_SDK_Sample_Policy"
  description    = "Simple Login"
}

# PingOne sign-on Policy Action
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/sign_on_policy_action}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_add_login_auth_step}
resource "pingone_sign_on_policy_action" "default_authn_policy_firstfactor" {
  environment_id    = pingone_environment.target_environment.id
  sign_on_policy_id = pingone_sign_on_policy.default_authn_policy.id

  registration_local_population_id = pingone_population_default.sample_users.id

  priority = 1

  conditions {
    last_sign_on_older_than_seconds = 28800
  }

  login {
    recovery_enabled = true
  }
}