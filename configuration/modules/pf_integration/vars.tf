variable "user_base_dn" {
  description = "The base DN for users in PingDirectory"
  type        = string
  default     = "dc=example,dc=com"
}

variable "pingone_environment_name" {
  description = "name that will be used when creating PingOne Environment"
  type        = string
}

variable "demo_user_sample_password" {
  type    = string
  default = "2FederateM0re"
}