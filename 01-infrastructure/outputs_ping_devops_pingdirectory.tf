output "pingdirectory_pf_bind_dn" {
  value = "cn=administrator"
}

output "pingdirectory_pf_bind_password" {
  value     = "2FederateM0re"
  sensitive = true
}

output "pingdirectory_pingone_gw_bind_dn" {
  value = "cn=administrator"
}

output "pingdirectory_pingone_gw_bind_password" {
  value     = "2FederateM0re"
  sensitive = true
}

output "pingdirectory_enabled" {
  value = var.pingdirectory_enabled
}

output "pingdirectory_ldaps_service_host" {
  value = format("%s-pingdirectory.%s", helm_release.ping_devops.name, local.k8s_deployment_namespace)
}

output "pingdirectory_ldaps_service_port" {
  value = 636
}
output "pingdirectory_ldap_service_port" {
  value = 389
}

output "pingdirectory_admin_ingress_url" {
  value = format("https://pingdataconsole-%s.ping-devops.com", helm_release.ping_devops.name)
}
