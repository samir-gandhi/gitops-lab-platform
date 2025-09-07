# Unified PingFederate stack template. Generated copy: pf_integration.stack.tf (ignored in VCS).
# Only materialize this file for integrated branches.

terraform {
  required_version = ">= 1.5.0"
}

# Remote infrastructure state (assumes integrated branch prepared infra state)
data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket = var.tf_state_bucket
    key    = "infrastructure-state/dev/${var.pingone_environment_name}/terraform.tfstate"
    region = var.tf_state_region
  }
}

locals { pf_outputs = data.terraform_remote_state.infrastructure.outputs }

provider "pingfederate" {
  username        = local.pf_outputs.pingfederate_api_username
  password        = local.pf_outputs.pingfederate_api_password
  https_host      = local.pf_outputs.pingfederate_admin_ingress_url
  product_version = local.pf_outputs.pingfederate_product_version
}

module "pf_integration" {
  source                             = "./modules/pf_integration"
  pingone_environment_name           = var.pingone_environment_name
  tf_state_key_prefix_infrastructure = "infrastructure-state"
  tf_state_bucket                    = var.tf_state_bucket
  tf_state_region                    = var.tf_state_region
}

# Import blocks (singletons) — executed only first time; idempotent afterward.
import {
  to = module.pf_integration.pingfederate_keypairs_ssl_server_settings.pingcli__Keypairs-0020-Ssl-0020-Server-0020-Settings
  id = "keypairs_ssl_server_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_virtual_host_names.pingcli__Virtual-0020-Host-0020-Names
  id = "virtual_host_names_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_certificates_revocation_settings.pingcli__Certificates-0020-Revocation-0020-Settings
  id = "certificates_revocation_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_server_settings.pingcli__Server-0020-Settings
  id = "server_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_oauth_access_token_manager_settings.pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings
  id = "oauth_access_token_manager_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_authentication_policies_settings.pingcli__Authentication-0020-Policies-0020-Settings
  id = "authentication_policies_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_openid_connect_settings.pingcli__Openid-0020-Connect-0020-Settings
  id = "openid_connect_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_notification_publisher_settings.pingcli__Notification-0020-Publisher-0020-Settings
  id = "notification_publisher_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_service_authentication.pingcli__Service-0020-Authentication
  id = "service_authentication_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_session_authentication_policies_global.pingcli__Session-0020-Authentication-0020-Policies-0020-Global
  id = "session_authentication_policies_global_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_oauth_ciba_server_policy_settings.pingcli__Oauth-0020-Ciba-0020-Server-0020-Policy-0020-Settings
  id = "oauth_ciba_server_policy_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_session_settings.pingcli__Session-0020-Settings
  id = "session_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_keypairs_oauth_openid_connect.pingcli__Keypairs-0020-Oauth-0020-Openid-0020-Connect
  id = "keypairs_oauth_openid_connect_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_authentication_policies.pingcli__Authentication-0020-Policies
  id = "authentication_policies_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_oauth_client_settings.pingcli__Oauth-0020-Client-0020-Settings
  id = "oauth_client_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_server_settings_system_keys_rotate.pingcli__Server-0020-Settings-0020-System-0020-Keys-0020-Rotate
  id = "server_settings_system_keys_rotate_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_cluster_settings.pingcli__Cluster-0020-Settings
  id = "cluster_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_extended_properties.pingcli__Extended-0020-Properties
  id = "extended_properties_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_captcha_provider_settings.pingcli__Captcha-0020-Provider-0020-Settings
  id = "captcha_provider_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_authentication_api_settings.pingcli__Authentication-0020-Api-0020-Settings
  id = "authentication_api_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_incoming_proxy_settings.pingcli__Incoming-0020-Proxy-0020-Settings
  id = "incoming_proxy_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_configuration_encryption_keys_rotate.pingcli__Configuration-0020-Encryption-0020-Keys-0020-Rotate
  id = "configuration_encryption_keys_rotate_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_sp_target_url_mappings.pingcli__Sp-0020-Target-0020-Url-0020-Mappings
  id = "sp_target_url_mappings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_oauth_server_settings.pingcli__Oauth-0020-Server-0020-Settings
  id = "oauth_server_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_server_settings_general.pingcli__Server-0020-Settings-0020-General
  id = "server_settings_general_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_session_application_policy.pingcli__Session-0020-Application-0020-Policy
  id = "session_application_policy_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_oauth_token_exchange_generator_settings.pingcli__Oauth-0020-Token-0020-Exchange-0020-Generator-0020-Settings
  id = "oauth_token_exchange_generator_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_server_settings_ws_trust_sts_settings.pingcli__Server-0020-Settings-0020-Ws-0020-Trust-0020-Sts-0020-Settings
  id = "server_settings_ws_trust_sts_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_protocol_metadata_lifetime_settings.pingcli__Protocol-0020-Metadata-0020-Lifetime-0020-Settings
  id = "protocol_metadata_lifetime_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_protocol_metadata_signing_settings.pingcli__Protocol-0020-Metadata-0020-Signing-0020-Settings
  id = "protocol_metadata_signing_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_kerberos_realm_settings.pingcli__Kerberos-0020-Realm-0020-Settings
  id = "kerberos_realm_settings_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_redirect_validation.pingcli__Redirect-0020-Validation
  id = "redirect_validation_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_server_settings_logging.pingcli__Server-0020-Settings-0020-Logging
  id = "server_settings_logging_singleton_id"
}
import {
  to = module.pf_integration.pingfederate_default_urls.pingcli__Default-0020-Urls
  id = "default_urls_singleton_id"
}

# S3 backend configuration variables
variable "tf_state_bucket" { type = string }
variable "tf_state_region" { type = string }
variable "enable_infrastructure_integration" { type = bool default = false }
