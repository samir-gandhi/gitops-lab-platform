
resource "pingone_davinci_application" "pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Application" {
  environment_id = var.pingone_environment_id

  name           = "DaVinci API Protect Sample Application"

  api_key = {
    enabled = true
  }

  oauth = {
    grant_types                   = ["authorizationCode"]
    redirect_uris                 = ["https://auth.pingone.com/9804c259-1f4f-4fda-b0a8-3f3b7339d5ce/rp/callback/openid_connect"]
    scopes                        = ["openid", "profile"]
  }
}