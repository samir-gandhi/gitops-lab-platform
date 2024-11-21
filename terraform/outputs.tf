output "pingone_environment_information" {
  value = {
    environment_name = pingone_environment.target_environment.name
    environment_id   = pingone_environment.target_environment.id
  }
}

output "mfa_device_policies" {
  value = data.pingone_mfa_device_policies.mfa_device_policies
}