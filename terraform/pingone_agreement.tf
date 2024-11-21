##############################################
# PingOne Agreements
##############################################

# PingOne Agreement
# {@link https://registry.terraform.io/providers/pingidentity/pingone/latest/docs/resources/agreement}
# {@link https://docs.pingidentity.com/r/en-us/pingone/p1_c_agreements}
data "pingone_language" "en" {
  environment_id = pingone_environment.target_environment.id

  locale = "en"
}

resource "pingone_agreement" "agreement" {
  environment_id = pingone_environment.target_environment.id

  name        = "Terms of Service"
  description = "Terms of Service Agreement"
}

resource "pingone_agreement_localization" "agreement_en" {
  environment_id = pingone_environment.target_environment.id
  agreement_id   = pingone_agreement.agreement.id
  language_id    = data.pingone_language.en.id

  display_name = "Terms and Conditions"
}

resource "pingone_agreement_localization_revision" "agreement_en_now" {
  environment_id            = pingone_environment.target_environment.id
  agreement_id              = pingone_agreement.agreement.id
  agreement_localization_id = pingone_agreement_localization.agreement_en.id

  content_type      = "text/html"
  require_reconsent = true
  text              = <<EOT
<p>Terms of Service Agreement</p>
EOT
}

resource "pingone_agreement_localization_enable" "agreement_en_enable" {
  environment_id            = pingone_environment.target_environment.id
  agreement_id              = pingone_agreement.agreement.id
  agreement_localization_id = pingone_agreement_localization.agreement_en.id

  enabled = true

  depends_on = [
    pingone_agreement_localization_revision.agreement_en_now
  ]
}

resource "pingone_agreement_enable" "agreement_enable" {
  environment_id = pingone_environment.target_environment.id
  agreement_id   = pingone_agreement.agreement.id

  enabled = true

  depends_on = [
    pingone_agreement_localization_enable.agreement_en_enable
  ]
}