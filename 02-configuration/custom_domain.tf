# Generate TLS resources for ACME certificates

# Define local variables
locals {
  # Use the branch name (environment name) as the subdomain
  subdomain    = var.pingone_environment_name
  # Construct the full domain name
  domain_name  = "${local.subdomain}.${var.parent_domain}"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = var.email_address
}

# Reference the existing hosted zone
data "aws_route53_zone" "parent_zone" {
  name         = var.parent_domain
  private_zone = false
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = local.domain_name
  subject_alternative_names = [local.domain_name]

  dns_challenge {
    provider = "route53"
    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.parent_zone.zone_id
    }
  }
}

resource "aws_route53_record" "pingone" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = local.domain_name
  type    = "CNAME"
  ttl     = 300
  records = [pingone_custom_domain.custom_domain_b.canonical_name]
}

resource "pingone_custom_domain" "custom_domain_b" {
  environment_id = pingone_environment.target_environment.id

  domain_name = local.domain_name
}

resource "pingone_custom_domain_verify" "custom_domain" {
  environment_id = pingone_environment.target_environment.id

  custom_domain_id = pingone_custom_domain.custom_domain_b.id

  # timeouts = {
  #   create = "30m"
  # }

  depends_on = [
    aws_route53_record.pingone
  ]
}

resource "pingone_custom_domain_ssl" "custom_domain" {
  environment_id = pingone_environment.target_environment.id

  custom_domain_id = pingone_custom_domain.custom_domain_b.id

  certificate_pem_file               = acme_certificate.certificate.certificate_pem
  intermediate_certificates_pem_file = acme_certificate.certificate.issuer_pem
  private_key_pem_file               = acme_certificate.certificate.private_key_pem

  depends_on = [
    pingone_custom_domain_verify.custom_domain
  ]
}

# Email domain functionality is temporarily commented out for custom domain testing
# Uncomment the sections below when ready to enable email domain verification

/* Email domain resources commented out for initial custom domain testing
resource "pingone_trusted_email_domain" "email_domain" {
  environment_id = pingone_environment.target_environment.id

  domain_name = var.parent_domain
}

data "pingone_trusted_email_domain_ownership" "email_domain_ownership" {
  environment_id = pingone_environment.target_environment.id

  trusted_email_domain_id = pingone_trusted_email_domain.email_domain.id
}

data "pingone_trusted_email_domain_dkim" "email_domain_dkim" {
  environment_id = pingone_environment.target_environment.id

  trusted_email_domain_id = pingone_trusted_email_domain.email_domain.id
}

data "pingone_trusted_email_domain_spf" "email_domain_spf" {
  environment_id = pingone_environment.target_environment.id

  trusted_email_domain_id = pingone_trusted_email_domain.email_domain.id
}
*/

/*
resource "aws_route53_record" "email_domain_ownership" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = data.pingone_trusted_email_domain_ownership.email_domain_ownership.host
  type    = "TXT"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_ownership.email_domain_ownership.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}

resource "aws_route53_record" "email_domain_dkim" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = data.pingone_trusted_email_domain_dkim.email_domain_dkim.host
  type    = "CNAME"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_dkim.email_domain_dkim.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}

resource "aws_route53_record" "email_domain_spf" {
  zone_id = data.aws_route53_zone.parent_zone.zone_id
  name    = var.parent_domain
  type    = "TXT"
  ttl     = 300
  records = [data.pingone_trusted_email_domain_spf.email_domain_spf.value]
  depends_on = [pingone_trusted_email_domain.email_domain]
}
*/

# Output custom domain information for reference
output "custom_domain_url" {
  value = "https://${local.domain_name}"
}

output "custom_domain_certificate_expiration" {
  value = acme_certificate.certificate.certificate_not_after
}

# Additional outputs for reference
output "custom_domain_name" {
  value = local.domain_name
  description = "The full domain name used for the PingOne environment"
}

output "custom_domain_status" {
  value = pingone_custom_domain_verify.custom_domain.status
  description = "The status of the custom domain verification"
}

output "parent_domain_zone_id" {
  value = data.aws_route53_zone.parent_zone.zone_id
  description = "The Route53 zone ID used for DNS records"
}