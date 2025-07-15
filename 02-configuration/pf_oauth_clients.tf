resource "pingfederate_oauth_client" "mySampleApp" {
  client_id                     = "mySampleApp"
  name                          = "mySampleApp"
  client_auth = {
    secret = "myS@mpl3s3cr3t"
    type   = "SECRET"
  }
  client_secret_retention_period_type = "SERVER_DEFAULT"
  device_flow_setting_type            = "SERVER_DEFAULT"
  enabled                             = true
  exclusive_scopes                    = []
  grant_types                         = ["ACCESS_TOKEN_VALIDATION"]
  oidc_policy = {
    grant_access_session_revocation_api         = false
    grant_access_session_session_management_api = false
    logout_mode                                 = "NONE"
    pairwise_identifier_user_type               = false
    ping_access_logout_capable                  = false
  }
  persistent_grant_expiration_type                = "SERVER_DEFAULT"
  persistent_grant_idle_timeout                   = 0
  persistent_grant_idle_timeout_time_unit         = "DAYS"
  persistent_grant_idle_timeout_type              = "SERVER_DEFAULT"
  persistent_grant_reuse_grant_types              = []
  persistent_grant_reuse_type                     = "SERVER_DEFAULT"
  redirect_uris                                   = []
  refresh_rolling                                 = "SERVER_DEFAULT"
  refresh_token_rolling_grace_period_type         = "SERVER_DEFAULT"
  refresh_token_rolling_interval_type             = "SERVER_DEFAULT"
  restricted_response_types                       = []
  restricted_scopes                               = []
  validate_using_all_eligible_atms                = true
}