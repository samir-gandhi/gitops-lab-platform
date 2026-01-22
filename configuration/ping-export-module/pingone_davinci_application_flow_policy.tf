# Flow Policies (1 total)

resource "pingone_davinci_application_flow_policy" "pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Policy" {
  environment_id         = var.pingone_environment_id
  davinci_application_id = pingone_davinci_application.pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Application.id
  name                   = "DaVinci API Protect Sample Policy"
  status                 = "enabled"

  flow_distributions = [
    {
      id      = pingone_davinci_flow.pingcli__PingOne-0020-DaVinci-0020-API-0020-Protect-0020-Example.id
      version = -1
      weight  = 100
    },
  ]
}