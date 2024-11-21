variable "pingone_client_region_code" {
  type = string
}
variable "pingone_client_environment_id" {
  type = string
}
variable "pingone_license_id" {
  type = string
}
variable "pingone_client_id" {
  type = string
}
variable "pingone_client_secret" {
  type = string
}
variable "pingone_environment_name" {
  description = "name that will be used when creating PingOne Environment"
  type        = string
}
variable "pingone_environment_type" {
  type = string
}
variable "pingone_force_delete_population" {
  description = "This option should not be used in environments that contain production data.  Data loss may occur."
  default     = false
  type        = bool
}

variable "app_url" {
  type        = string
  description = "Application URL"
  default     = "https://127.0.0.1:8080"
}

locals {
  # The URL of the demo app
  redirect_uris = ["${var.app_url}/dashboard.html"]
  # Worker app token variables
  raw_data     = jsondecode(data.http.get_token.response_body)
  access_token = local.raw_data.access_token
}