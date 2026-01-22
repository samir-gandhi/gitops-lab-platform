###############################################################
# Output PingOne Environment variables to local global.js file
###############################################################

resource "local_file" "env_config_simple_p1_reg_app" {
  content  = "window._env_ = { pingOneDomain: \"${module.pingone_utils.pingone_domain_suffix}\", pingOneEnvId: \"${pingone_environment.target_environment.id}\", clientId: \"${pingone_application.client_auth_sample_app.id}\"}"
  filename = "../simple-p1-reg-app/global.js"
}

resource "local_file" "env_config_dv_p1_protect_reg_app" {
  content  = "window._env_ = {\n  pingOneDomain: \"${module.pingone_utils.pingone_domain_suffix}\",\n  pingOneEnvId: \"${pingone_environment.target_environment.id}\",\n  clientId: \"${pingone_application.client_auth_sample_app.id}\", \n companyId: \"${module.ping-export.dv_app_environment_id}\", \n apiKey: \"${module.ping-export.dv_app_api_key}\",\n  policyId: \"${module.ping-export.dv_policy_id}\"\n};"
  filename = "../dv-p1-protect-reg-app/global.js"
}

# resource "local_file" "env_config" {
#   content  = "window._env_ = {\n  pingOneDomain: \"${module.pingone_utils.pingone_domain_suffix}\",\n  pingOneEnvId: \"${pingone_environment.my_environment.id}\",\n  clientId: \"${pingone_application.oidc_sdk_sample_app.id}\", \n  companyId: \"${davinci_application.registration_flow_app.environment_id}\",\n  apiKey: \"${davinci_application.registration_flow_app.api_keys.prod}\",\n  policyId: \"${davinci_application_flow_policy.registration_flow_app_policy.id}\"\n};"
#   filename = "../sample-app/global.js"
# }