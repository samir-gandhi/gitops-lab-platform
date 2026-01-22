variable "pingone_environment_id" {
  type        = string
  description = "The PingOne environment ID to configure DaVinci resources in"

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.pingone_environment_id))
    error_message = "The PingOne Environment ID must be a valid PingOne resource ID (UUID format)."
  }
}

# Connection Variables

variable "davinci_connection_PingOne-0020-Protect_clientId" {
  type        = string
  description = "clientId for PingOne Protect connector"
}
variable "davinci_connection_PingOne-0020-Protect_clientSecret" {
  type        = string
  description = "clientSecret for PingOne Protect connector"
  sensitive   = true
}
variable "davinci_connection_PingOne-0020-Protect_envId" {
  type        = string
  description = "envId for PingOne Protect connector"
}
variable "davinci_connection_PingOne-0020-Protect_region" {
  type        = string
  description = "region for PingOne Protect connector"
}
variable "davinci_connection_PingOne_clientId" {
  type        = string
  description = "clientId for PingOne connector"
}
variable "davinci_connection_PingOne_clientSecret" {
  type        = string
  description = "clientSecret for PingOne connector"
  sensitive   = true
}
variable "davinci_connection_PingOne_envId" {
  type        = string
  description = "envId for PingOne connector"
}
variable "davinci_connection_PingOne_region" {
  type        = string
  description = "region for PingOne connector"
}
