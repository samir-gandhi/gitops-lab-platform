// PingFederate
output "pingfederate_admin_ingress_url" {
  value = format("https://pingfederate-admin-%s.ping-devops.com", helm_release.ping_devops.name)
}

output "pingfederate_engine_ingress_url" {
  value = format("https://pingfederate-engine-%s.ping-devops.com", helm_release.ping_devops.name)
}

output "pingfederate_api_username" {
  value = "Administrator"
}

output "pingfederate_api_password" {
  value     = "2FederateM0re"
  sensitive = true
}

output "pingfederate_product_version" {
  value = "12.2"
}
