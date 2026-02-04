module "ping-export" {
  source = "./ping-export-module"

  pingone_environment_id = pingone_environment.target_environment.id

  # Connection Variables
  davinci_connection_PingOne-0020-Protect_clientId     = pingone_application.worker_app.oidc_options.client_id
  davinci_connection_PingOne-0020-Protect_clientSecret = pingone_application_secret.worker_app_secret.secret
  davinci_connection_PingOne-0020-Protect_envId        = pingone_application.worker_app.environment_id
  davinci_connection_PingOne-0020-Protect_region       = var.pingone_client_region_code
  davinci_connection_PingOne_clientId                  = pingone_application.worker_app.oidc_options.client_id
  davinci_connection_PingOne_clientSecret              = pingone_application_secret.worker_app_secret.secret
  davinci_connection_PingOne_envId                     = pingone_application.worker_app.environment_id
  davinci_connection_PingOne_region                    = var.pingone_client_region_code

}
