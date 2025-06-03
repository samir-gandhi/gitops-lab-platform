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

variable "pingone_davinci_admin_environment_id" {
  type        = string
  description = "PingOne ENVIRONMENT ID for the DaVinci Admin Group"
}

variable "pingone_davinci_admin_username" {
  type        = string
  description = "PingOne USERNAME for the DaVinci Admin Group"
}

variable "pingone_davinci_admin_password" {
  type        = string
  description = "PingOne PASSWORD for the DaVinci Admin Group"
}

variable "pingone_davinci_admin_region" {
  type        = string
  description = "PingOne REGION for the DaVinci Admin Group"
}

variable "pingone_davinci_terraform_group_id" {
  type        = string
  description = "PingOne GROUP ID for the DaVinci Terraform Admin Group"
}

variable "app_url" {
  type        = string
  description = "Application URL"
  default     = "https://127.0.0.1:8080"
}

# AWS Region for Route53 and other resources
variable "aws_region" {
  type        = string
  description = "AWS region for Route53 and other resources"
  default     = "us-east-1"
}

# Domain configuration
variable "parent_domain" {
  type        = string
  description = "The parent domain name that's already registered in AWS (e.g., pingfwd.com)"
  default     = "pingfwd.com"
}

# Email for Let's Encrypt registration
variable "email_address" {
  type        = string
  description = "Email address used for Let's Encrypt registration and certificate expiry notifications"
  # Replace with a real email address before deployment
  default = "admin@example.com"
}

locals {
  # The URL of the demo app
  redirect_uris = ["${var.app_url}/dashboard.html"]
  # Worker app token variables
  # raw_data     = jsondecode(data.http.get_token.response_body)
  # access_token = local.raw_data.access_token
}