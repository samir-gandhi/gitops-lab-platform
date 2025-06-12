# TODO: update this to use a data source so it's not hardcoded to the values.yaml ingress setup. 
output "pingfederate_admin_ingress_url" {
  value = format("https://%s-pingfederate-admin.ping-devops.com", helm_release.ping_devops.name)
}

output "pingfederate_engine_ingress_url" {
  value = format("https://%s-pingfederate-engine.ping-devops.com", helm_release.ping_devops.name)
}

output "pingfederate_api_username" {
  value = var.pingfederate_api_username
}

output "pingfederate_api_password" {
  value     = var.pingfederate_api_password
  sensitive = true
}

output "pingfederate_product_version" {
  value = "12.2"
}
