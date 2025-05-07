output "deployment_name" {
  value = helm_release.ping_devops.name
}

output "k8s_namespace" {
  value = helm_release.ping_devops.namespace
}

