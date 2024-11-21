###############################################################
# Output PingOne Environment variables to local global.js file
###############################################################

resource "local_file" "env_config" {
  content  = "window._env_ = { pingOneDomain: \"${module.pingone_utils.pingone_domain_suffix}\", pingOneEnvId: \"${pingone_environment.target_environment.id}\", clientId: \"${pingone_application.client_auth_sample_app.id}\"}"
  filename = "../sample-app/global.js"
}