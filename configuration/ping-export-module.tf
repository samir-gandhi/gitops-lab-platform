module "ping-export" {
  source = "./ping-export-module"

  pingone_environment_id = var.pingone_environment_id

  # Connection Variables
  davinci_connection_PingOne-0020-Protect_clientId     = var.davinci_connection_PingOne-0020-Protect_clientId
  davinci_connection_PingOne-0020-Protect_clientSecret = var.davinci_connection_PingOne-0020-Protect_clientSecret
  davinci_connection_PingOne-0020-Protect_envId        = var.davinci_connection_PingOne-0020-Protect_envId
  davinci_connection_PingOne-0020-Protect_region       = var.davinci_connection_PingOne-0020-Protect_region
  davinci_connection_PingOne_clientId                  = var.davinci_connection_PingOne_clientId
  davinci_connection_PingOne_clientSecret              = var.davinci_connection_PingOne_clientSecret
  davinci_connection_PingOne_envId                     = var.davinci_connection_PingOne_envId
  davinci_connection_PingOne_region                    = var.davinci_connection_PingOne_region

}
