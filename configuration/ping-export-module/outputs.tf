output "dv_app_environment_id" {
  description = "Environment ID for the DaVinci sample application"
  value       = pingone_davinci_application.pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Application.environment_id
}

output "dv_app_api_key" {
  description = "API key value for the DaVinci sample application"
  value       = pingone_davinci_application.pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Application.api_key.value
  sensitive   = true
}

output "dv_policy_id" {
  description = "Flow policy ID for the DaVinci sample application"
  value       = pingone_davinci_application_flow_policy.pingcli__DaVinci-0020-API-0020-Protect-0020-Sample-0020-Policy.id
}
