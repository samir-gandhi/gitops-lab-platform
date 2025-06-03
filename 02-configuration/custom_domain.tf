# Generate TLS resources for ACME certificates

# These resources are only created for qa and prod environments
resource "tls_private_key" "private_key" {
  count = local.create_custom_domain ? 1 : 0

  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  count = local.create_custom_domain ? 1 : 0

  account_key_pem = tls_private_key.private_key[0].private_key_pem
  email_address   = var.lets_encrypt_email_address
}

# Reference the existing hosted zone - needed by all environments for data reference
data "aws_route53_zone" "parent_zone" {
  count = local.create_custom_domain ? 1 : 0

  name         = var.parent_domain
  private_zone = false
}

resource "acme_certificate" "certificate" {
  count = local.create_custom_domain ? 1 : 0

  account_key_pem           = acme_registration.reg[0].account_key_pem
  common_name               = local.domain_name
  subject_alternative_names = [local.domain_name]

  dns_challenge {
    provider = "route53"
    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.parent_zone[0].zone_id
    }
  }
}

resource "pingone_custom_domain" "custom_domain_b" {
  count = local.create_custom_domain ? 1 : 0

  environment_id = pingone_environment.target_environment.id
  domain_name    = local.domain_name
}

resource "aws_route53_record" "pingone" {
  count = local.create_custom_domain ? 1 : 0

  zone_id = data.aws_route53_zone.parent_zone[0].zone_id
  name    = local.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [pingone_custom_domain.custom_domain_b[0].canonical_name]
}

resource "pingone_custom_domain_verify" "custom_domain" {
  count = local.create_custom_domain ? 1 : 0

  environment_id   = pingone_environment.target_environment.id
  custom_domain_id = pingone_custom_domain.custom_domain_b[0].id

  # timeouts = {
  #   create = "30m"
  # }

  depends_on = [
    aws_route53_record.pingone
  ]
}

resource "pingone_custom_domain_ssl" "custom_domain" {
  count = local.create_custom_domain ? 1 : 0

  environment_id   = pingone_environment.target_environment.id
  custom_domain_id = pingone_custom_domain.custom_domain_b[0].id

  certificate_pem_file               = acme_certificate.certificate[0].certificate_pem
  intermediate_certificates_pem_file = acme_certificate.certificate[0].issuer_pem
  private_key_pem_file               = acme_certificate.certificate[0].private_key_pem

  depends_on = [
    pingone_custom_domain_verify.custom_domain
  ]
}

# Email domain functionality is temporarily commented out for custom domain testing
# Uncomment the sections below when ready to enable email domain verification

/* Email domain resources commented out for initial custom domain testing
# These resources will also only be created for qa and prod environments when uncommented
resource "pingone_trusted_email_domain" "email_domain" {
  count = local.create_custom_domain ? 1 : 0
  
  environment_id = pingone_environment.target_environment.id
  domain_name    = var.parent_domain
}

data "pingone_trusted_email_domain_ownership" "email_domain_ownership" {
  count = local.create_custom_domain ? 1 : 0
  
  environment_id = pingone_environment.target_environment.id
  trusted_email_domain_id = pingone_trusted_email_domain.email_domain[0].id
}

data "pingone_trusted_email_domain_dkim" "email_domain_dkim" {
  count = local.create_custom_domain ? 1 : 0
  
  environment_id = pingone_environment.target_environment.id
  trusted_email_domain_id = pingone_trusted_email_domain.email_domain[0].id
}

data "pingone_trusted_email_domain_spf" "email_domain_spf" {
  count = local.create_custom_domain ? 1 : 0
  
  environment_id = pingone_environment.target_environment.id
  trusted_email_domain_id = pingone_trusted_email_domain.email_domain[0].id
}
*/

/*
# Email domain records also use the same conditional logic
resource "aws_route53_record" "email_domain_ownership" {
  count = local.create_custom_domain ? 1 : 0
  
  zone_id = data.aws_route53_zone.parent_zone[0].zone_id
  name    = data.pingone_trusted_email_domain_ownership.email_domain_ownership.host
  type    = "TXT"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_ownership.email_domain_ownership.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}

resource "aws_route53_record" "email_domain_dkim" {
  count = local.create_custom_domain ? 1 : 0
  
  zone_id = data.aws_route53_zone.parent_zone[0].zone_id
  name    = data.pingone_trusted_email_domain_dkim.email_domain_dkim.host
  type    = "CNAME"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_dkim.email_domain_dkim.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}

resource "aws_route53_record" "email_domain_spf" {
  count = local.create_custom_domain ? 1 : 0
  
  zone_id = data.aws_route53_zone.parent_zone[0].zone_id
  name    = var.parent_domain
  type    = "TXT"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_spf.email_domain_spf.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}
*/

# Output custom domain information for reference
output "custom_domain_url" {
  value = local.create_custom_domain ? "https://${local.domain_name}" : "Custom domain not enabled for this environment"
}

output "custom_domain_certificate_expiration" {
  value = local.create_custom_domain ? acme_certificate.certificate[0].certificate_not_after : "N/A - Custom domain not enabled"
}

# Additional outputs for reference
output "custom_domain_name" {
  value       = local.domain_name
  description = "The full domain name used for the PingOne environment"
}

output "custom_domain_status" {
  value       = local.create_custom_domain ? pingone_custom_domain_verify.custom_domain[0].status : "N/A - Custom domain not enabled"
  description = "The status of the custom domain verification"
}

output "parent_domain_zone_id" {
  value       = local.create_custom_domain ? data.aws_route53_zone.parent_zone[0].zone_id : "N/A - Custom domain not enabled"
  description = "The Route53 zone ID used for DNS records"
}