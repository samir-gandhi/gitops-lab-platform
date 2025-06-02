provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_client_environment_id
  region_code    = var.pingone_client_region_code

  global_options {
    population {
      // This option should not be used in environments that contain production data.  Data loss may occur.
      contains_users_force_delete = var.pingone_force_delete_population
    }
  }
}

provider "davinci" {
  username       = var.pingone_davinci_admin_username
  password       = var.pingone_davinci_admin_password
  environment_id = var.pingone_davinci_admin_environment_id
  region         = var.pingone_davinci_admin_region
}

provider "http" {
}

provider "aws" {
  region = var.aws_region

  # Credentials are typically provided via environment variables or shared credentials file
  # AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY
  # Or via a role when running in a cloud environment
}

provider "acme" {
  # IMPORTANT: Currently using Let's Encrypt staging environment which produces untrusted certificates
  # This is good for testing as it doesn't have strict rate limits
  # When ready for production, comment the staging URL and uncomment the production URL
  
  # Production URL (uncomment when ready):
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
  
  # Staging URL (for testing):
  # server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
}
# staging server should produce an error similar to:
# pingone_custom_domain_ssl.custom_domain: Creating...
# ╷
# │ Error: Error when calling `UpdateDomain`: The request could not be completed. One or more validation errors were in the request.
# │ 
# │   with pingone_custom_domain_ssl.custom_domain,
# │   on custom_domain.tf line 63, in resource "pingone_custom_domain_ssl" "custom_domain":
# │   63: resource "pingone_custom_domain_ssl" "custom_domain" {
# │ 
# │ PingOne Error Details:
# │ ID:           5971ffce-411b-4baa-9793-020346b795ba
# │ Code:         INVALID_DATA
# │ Message:      The request could not be completed. One or more validation errors were in the request.
# │ Details:
# │   - Code:     INVALID_VALUE
# │     Message:  The certificate that is attached to your distribution was not issued by a trusted Certificate Authority. For more details, see: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/CNAMEs.html#alternate-domain-names-requirements
# │ 