variable "k8s_helm_deployment_name" {
  description = "The name of the helm deployment"
  type        = string
}

variable "ping_devops_chart_version" {
  type    = string
  default = "0.11.7"
}

variable "pingdirectory_enabled" {
  type    = bool
  default = true
}

variable "ping_identity_devops_key" {
  type        = string
  description = "Ping Identity DevOps Key"
}
variable "ping_identity_devops_user" {
  type        = string
  description = "Ping Identity DevOps User"
}

locals {
  k8s_deployment_namespace = "gitops-lab-${var.k8s_helm_deployment_name}"
}

variable "pingfederate_api_username" {
  default = "administrator"
}

variable "pingfederate_api_password" {
  default     = "2FederateM0re"
  sensitive = true
}