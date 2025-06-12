
import {
  to = pingfederate_server_settings.pingcli__Server-0020-Settings
  id = "server_settings_singleton_id"
}

resource "pingfederate_server_settings" "pingcli__Server-0020-Settings" {
  contact_info = {
    company    = null
    email      = null
    first_name = null
    last_name  = null
    phone      = null
  }
  federation_info = {
    base_url          = data.terraform_remote_state.infrastructure.outputs.pingfederate_engine_ingress_url
    saml_1x_issuer_id = null
    saml_1x_source_id = null
    saml_2_entity_id  = "https://${var.pingone_environment_name}-pingfederate-engine:9031"
    wsfed_realm       = null
  }
  notifications = {
    account_changes_notification_publisher_ref               = null
    bulkhead_alert_notification_settings                     = null
    certificate_expirations                                  = null
    expired_certificate_administrative_console_warning_days  = 14
    expiring_certificate_administrative_console_warning_days = 14
    license_events                                           = null
    metadata_notification_settings                           = null
    notify_admin_user_password_changes                       = false
    thread_pool_exhaustion_notification_settings = {
      email_address              = ""
      notification_mode          = "LOGGING_ONLY"
      notification_publisher_ref = null
      thread_dump_enabled        = true
    }
  }
}

# Resource Type: pingfederate_notification_publisher_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_notification_publisher_settings.pingcli__Notification-0020-Publisher-0020-Settings
  id = "notification_publisher_settings_singleton_id"
}

# __generated__ by Terraform from "notification_publisher_settings_singleton_id"
resource "pingfederate_notification_publisher_settings" "pingcli__Notification-0020-Publisher-0020-Settings" {
  default_notification_publisher_ref = null
}

# Resource Type: pingfederate_service_authentication
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_service_authentication.pingcli__Service-0020-Authentication
  id = "service_authentication_singleton_id"
}

# __generated__ by Terraform from "service_authentication_singleton_id"
resource "pingfederate_service_authentication" "pingcli__Service-0020-Authentication" {
  attribute_query = null
  jmx             = null
}

# Resource Type: pingfederate_session_authentication_policies_global
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_session_authentication_policies_global.pingcli__Session-0020-Authentication-0020-Policies-0020-Global
  id = "session_authentication_policies_global_singleton_id"
}

# __generated__ by Terraform from "session_authentication_policies_global_singleton_id"
resource "pingfederate_session_authentication_policies_global" "pingcli__Session-0020-Authentication-0020-Policies-0020-Global" {
  enable_sessions                = false
  hash_unique_user_key_attribute = false
  idle_timeout_display_unit      = "MINUTES"
  idle_timeout_mins              = 60
  max_timeout_display_unit       = "MINUTES"
  max_timeout_mins               = 480
  persistent_sessions            = false
}

##TODO: remove this
# Data Store Type: JDBC
# Resource Type: pingfederate_data_store
import {
  to = pingfederate_data_store.pingcli__ProvisionerDS_JDBC
  id = "ProvisionerDS"
}

# __generated__ by Terraform from "ProvisionerDS"
resource "pingfederate_data_store" "pingcli__ProvisionerDS_JDBC" {
  custom_data_store = null
  data_store_id     = "ProvisionerDS"
  jdbc_data_store = {
    allow_multi_value_attributes = false
    blocking_timeout             = 5000
    connection_url               = "jdbc:hsqldb:$${pf.server.data.dir}$${/}hypersonic$${/}ProvisionerDefaultDB;hsqldb.lock_file=false"
    connection_url_tags = [
      {
        connection_url = "jdbc:hsqldb:$${pf.server.data.dir}$${/}hypersonic$${/}ProvisionerDefaultDB;hsqldb.lock_file=false"
        default_source = true
        tags           = null
      },
    ]
    driver_class = "org.hsqldb.jdbcDriver"
    # encrypted_password      = "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoiTkd3bk5NbkRyYyIsInZlcnNpb24iOiIxMi4yLjIuMCJ9..QeBqnwTDsC6GpF2VGP7H4w.u2RSnEkZYpMNOmcHaQDPNg.u4j97uP1KOXyPjtbdBMhvA"
    idle_timeout            = 5
    max_pool_size           = 100
    min_pool_size           = 10
    name                    = "ProvisionerDS (sa)"
    password                = var.provisioner_ds_password
    user_name               = "sa"
    validate_connection_sql = null
  }
  ldap_data_store                  = null
  mask_attribute_values            = false
  ping_one_ldap_gateway_data_store = null
}

# Resource Type: pingfederate_oauth_ciba_server_policy_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_oauth_ciba_server_policy_settings.pingcli__Oauth-0020-Ciba-0020-Server-0020-Policy-0020-Settings
  id = "oauth_ciba_server_policy_settings_singleton_id"
}

# __generated__ by Terraform from "oauth_ciba_server_policy_settings_singleton_id"
resource "pingfederate_oauth_ciba_server_policy_settings" "pingcli__Oauth-0020-Ciba-0020-Server-0020-Policy-0020-Settings" {
  default_request_policy_ref = null
}

# Resource Type: pingfederate_session_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_session_settings.pingcli__Session-0020-Settings
  id = "session_settings_singleton_id"
}

# __generated__ by Terraform from "session_settings_singleton_id"
resource "pingfederate_session_settings" "pingcli__Session-0020-Settings" {
  revoke_user_session_on_logout     = true
  session_revocation_lifetime       = 1450
  track_adapter_sessions_for_logout = false
}

# Resource Type: pingfederate_keypairs_oauth_openid_connect
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_keypairs_oauth_openid_connect.pingcli__Keypairs-0020-Oauth-0020-Openid-0020-Connect
  id = "keypairs_oauth_openid_connect_singleton_id"
}

# __generated__ by Terraform from "keypairs_oauth_openid_connect_singleton_id"
resource "pingfederate_keypairs_oauth_openid_connect" "pingcli__Keypairs-0020-Oauth-0020-Openid-0020-Connect" {
  p256_active_cert_ref                  = null
  p256_active_key_id                    = null
  p256_decryption_active_cert_ref       = null
  p256_decryption_active_key_id         = null
  p256_decryption_previous_cert_ref     = null
  p256_decryption_previous_key_id       = null
  p256_decryption_publish_x5c_parameter = null
  p256_previous_cert_ref                = null
  p256_previous_key_id                  = null
  p256_publish_x5c_parameter            = null
  p384_active_cert_ref                  = null
  p384_active_key_id                    = null
  p384_decryption_active_cert_ref       = null
  p384_decryption_active_key_id         = null
  p384_decryption_previous_cert_ref     = null
  p384_decryption_previous_key_id       = null
  p384_decryption_publish_x5c_parameter = null
  p384_previous_cert_ref                = null
  p384_previous_key_id                  = null
  p384_publish_x5c_parameter            = null
  p521_active_cert_ref                  = null
  p521_active_key_id                    = null
  p521_decryption_active_cert_ref       = null
  p521_decryption_active_key_id         = null
  p521_decryption_previous_cert_ref     = null
  p521_decryption_previous_key_id       = null
  p521_decryption_publish_x5c_parameter = null
  p521_previous_cert_ref                = null
  p521_previous_key_id                  = null
  p521_publish_x5c_parameter            = null
  rsa_active_cert_ref                   = null
  rsa_active_key_id                     = null
  rsa_algorithm_active_key_ids = [
  ]
  rsa_algorithm_previous_key_ids = [
  ]
  rsa_decryption_active_cert_ref       = null
  rsa_decryption_active_key_id         = null
  rsa_decryption_previous_cert_ref     = null
  rsa_decryption_previous_key_id       = null
  rsa_decryption_publish_x5c_parameter = null
  rsa_previous_cert_ref                = null
  rsa_previous_key_id                  = null
  rsa_publish_x5c_parameter            = null
  static_jwks_enabled                  = false
}

#######################################################################################################################
# Resource Type: pingfederate_authentication_policies
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_authentication_policies.pingcli__Authentication-0020-Policies
  id = "authentication_policies_singleton_id"
}
# __generated__ by Terraform from "authentication_policies_singleton_id"
resource "pingfederate_authentication_policies" "pingcli__Authentication-0020-Policies" {
  authn_selection_trees = [
  ]
  default_authentication_sources = [
  ]
  fail_if_no_selection    = false
  tracked_http_parameters = []
}


## TODO: upgrade to baseline version, but has dependencies. 
# # __generated__ by Terraform from "authentication_policies_singleton_id"
# resource "pingfederate_authentication_policies" "pingcli__Authentication-0020-Policies" {
#   authn_selection_trees = [
#     {
#       authentication_api_application_ref = null
#       description                        = null
#       enabled                            = true
#       handle_failures_locally            = false
#       id                                 = "PuCSAIbrWMwFX23rbcGvYTv4J"
#       name                               = "Default AuthN Policy"
#       root_node = {
#         action = {
#           apc_mapping_policy_action    = null
#           authn_selector_policy_action = null
#           authn_source_policy_action = {
#             attribute_rules = null
#             authentication_source = {
#               source_ref = {
#                 id = "HTMLFormPD"
#               }
#               type = "IDP_ADAPTER"
#             }
#             context               = null
#             input_user_id_mapping = null
#             user_id_authenticated = null
#           }
#           continue_policy_action               = null
#           done_policy_action                   = null
#           fragment_policy_action               = null
#           local_identity_mapping_policy_action = null
#           restart_policy_action                = null
#         }
#         children = [
#           {
#             action = {
#               apc_mapping_policy_action    = null
#               authn_selector_policy_action = null
#               authn_source_policy_action   = null
#               continue_policy_action       = null
#               done_policy_action = {
#                 context = "Fail"
#               }
#               fragment_policy_action               = null
#               local_identity_mapping_policy_action = null
#               restart_policy_action                = null
#             }
#             children = [
#             ]
#           },
#           {
#             action = {
#               apc_mapping_policy_action    = null
#               authn_selector_policy_action = null
#               authn_source_policy_action   = null
#               continue_policy_action       = null
#               done_policy_action           = null
#               fragment_policy_action       = null
#               local_identity_mapping_policy_action = {
#                 context = "Success"
#                 inbound_mapping = {
#                   attribute_contract_fulfillment = {
#                     "pf.local.identity.unique.id" = {
#                       source = {
#                         id   = "HTMLFormPD"
#                         type = "ADAPTER"
#                       }
#                       value = "username"
#                     }
#                   }
#                   attribute_sources = [
#                   ]
#                   issuance_criteria = {
#                     conditional_criteria = [
#                     ]
#                     expression_criteria = null
#                   }
#                 }
#                 local_identity_ref = {
#                   id = "RBSQIwi5KWYN9ZGK"
#                 }
#                 outbound_attribute_mapping = {
#                   attribute_contract_fulfillment = {
#                     mail = {
#                       source = {
#                         id   = "RBSQIwi5KWYN9ZGK"
#                         type = "LOCAL_IDENTITY_PROFILE"
#                       }
#                       value = "mail"
#                     }
#                     subject = {
#                       source = {
#                         id   = "RBSQIwi5KWYN9ZGK"
#                         type = "LOCAL_IDENTITY_PROFILE"
#                       }
#                       value = "entryUUID"
#                     }
#                   }
#                   attribute_sources = [
#                   ]
#                   issuance_criteria = {
#                     conditional_criteria = [
#                     ]
#                     expression_criteria = null
#                   }
#                 }
#               }
#               restart_policy_action = null
#             }
#             children = [
#             ]
#           },
#         ]
#       }
#     },
#   ]
#   default_authentication_sources = [
#   ]
#   fail_if_no_selection    = false
#   tracked_http_parameters = []
# }


# Resource Type: pingfederate_oauth_client_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_oauth_client_settings.pingcli__Oauth-0020-Client-0020-Settings
  id = "oauth_client_settings_singleton_id"
}
# __generated__ by Terraform from "oauth_client_settings_singleton_id"
resource "pingfederate_oauth_client_settings" "pingcli__Oauth-0020-Client-0020-Settings" {
  dynamic_client_registration = null
}

import {
  to = pingfederate_oauth_access_token_manager_settings.pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings
  id = "oauth_access_token_manager_settings_singleton_id"
}

# __generated__ by Terraform from "oauth_access_token_manager_settings_singleton_id"
resource "pingfederate_oauth_access_token_manager_settings" "pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings" {
  default_access_token_manager_ref = null
}

# Resource Type: pingfederate_server_settings_system_keys_rotate
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_server_settings_system_keys_rotate.pingcli__Server-0020-Settings-0020-System-0020-Keys-0020-Rotate
  id = "server_settings_system_keys_rotate_singleton_id"
}
# __generated__ by Terraform from "server_settings_system_keys_rotate_singleton_id"
resource "pingfederate_server_settings_system_keys_rotate" "pingcli__Server-0020-Settings-0020-System-0020-Keys-0020-Rotate" {
  rotation_trigger_values = null
}

# Resource Type: pingfederate_cluster_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_cluster_settings.pingcli__Cluster-0020-Settings
  id = "cluster_settings_singleton_id"
}

# __generated__ by Terraform from "cluster_settings_singleton_id"
resource "pingfederate_cluster_settings" "pingcli__Cluster-0020-Settings" {
  replicate_clients_on_save     = true
  replicate_connections_on_save = true
}

# Resource Type: pingfederate_extended_properties
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_extended_properties.pingcli__Extended-0020-Properties
  id = "extended_properties_singleton_id"
}

# __generated__ by Terraform from "extended_properties_singleton_id"
resource "pingfederate_extended_properties" "pingcli__Extended-0020-Properties" {
  items = [
  ]
}

# Resource Type: pingfederate_certificates_revocation_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_certificates_revocation_settings.pingcli__Certificates-0020-Revocation-0020-Settings
  id = "certificates_revocation_settings_singleton_id"
}

# __generated__ by Terraform from "certificates_revocation_settings_singleton_id"
resource "pingfederate_certificates_revocation_settings" "pingcli__Certificates-0020-Revocation-0020-Settings" {
  crl_settings = null
  ocsp_settings = {
    action_on_responder_unavailable = "CONTINUE"
    action_on_status_unknown        = "FAIL"
    action_on_unsuccessful_response = "FAIL"
    current_update_grace_period     = 5
    next_update_grace_period        = 5
    requester_add_nonce             = false
    responder_cert_reference        = null
    responder_timeout               = 5
    responder_url                   = null
    response_cache_period           = 48
  }
  proxy_settings = null
}

# Resource Type: pingfederate_captcha_provider_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_captcha_provider_settings.pingcli__Captcha-0020-Provider-0020-Settings
  id = "captcha_provider_settings_singleton_id"
}

# __generated__ by Terraform from "captcha_provider_settings_singleton_id"
resource "pingfederate_captcha_provider_settings" "pingcli__Captcha-0020-Provider-0020-Settings" {
  default_captcha_provider_ref = null
}

# Resource Type: pingfederate_authentication_api_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_authentication_api_settings.pingcli__Authentication-0020-Api-0020-Settings
  id = "authentication_api_settings_singleton_id"
}

# __generated__ by Terraform from "authentication_api_settings_singleton_id"
resource "pingfederate_authentication_api_settings" "pingcli__Authentication-0020-Api-0020-Settings" {
  api_enabled                          = false
  default_application_ref              = null
  enable_api_descriptions              = true
  include_request_context              = false
  restrict_access_to_redirectless_mode = true
}

# Resource Type: pingfederate_incoming_proxy_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_incoming_proxy_settings.pingcli__Incoming-0020-Proxy-0020-Settings
  id = "incoming_proxy_settings_singleton_id"
}

# __generated__ by Terraform from "incoming_proxy_settings_singleton_id"
resource "pingfederate_incoming_proxy_settings" "pingcli__Incoming-0020-Proxy-0020-Settings" {
  client_cert_chain_ssl_header_name  = null
  client_cert_header_encoding_format = "APACHE_MOD_SSL"
  client_cert_ssl_header_name        = null
  enable_client_cert_header_auth     = false
  forwarded_host_header_index        = null
  forwarded_host_header_name         = null
  forwarded_ip_address_header_index  = null
  forwarded_ip_address_header_name   = null
  proxy_terminates_https_conns       = false
}

# Resource Type: pingfederate_virtual_host_names
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_virtual_host_names.pingcli__Virtual-0020-Host-0020-Names
  id = "virtual_host_names_singleton_id"
}

# __generated__ by Terraform from "virtual_host_names_singleton_id"
resource "pingfederate_virtual_host_names" "pingcli__Virtual-0020-Host-0020-Names" {
  virtual_host_names = []
}

# Resource Type: pingfederate_configuration_encryption_keys_rotate
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_configuration_encryption_keys_rotate.pingcli__Configuration-0020-Encryption-0020-Keys-0020-Rotate
  id = "configuration_encryption_keys_rotate_singleton_id"
}

# __generated__ by Terraform from "configuration_encryption_keys_rotate_singleton_id"
resource "pingfederate_configuration_encryption_keys_rotate" "pingcli__Configuration-0020-Encryption-0020-Keys-0020-Rotate" {
  rotation_trigger_values = null
}

# Resource Type: pingfederate_sp_target_url_mappings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_sp_target_url_mappings.pingcli__Sp-0020-Target-0020-Url-0020-Mappings
  id = "sp_target_url_mappings_singleton_id"
}

# __generated__ by Terraform from "sp_target_url_mappings_singleton_id"
resource "pingfederate_sp_target_url_mappings" "pingcli__Sp-0020-Target-0020-Url-0020-Mappings" {
  items = [
  ]
}

# Resource Type: pingfederate_oauth_server_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_oauth_server_settings.pingcli__Oauth-0020-Server-0020-Settings
  id = "oauth_server_settings_singleton_id"
}

# __generated__ by Terraform from "oauth_server_settings_singleton_id"
resource "pingfederate_oauth_server_settings" "pingcli__Oauth-0020-Server-0020-Settings" {
  activation_code_check_mode                              = "AFTER_AUTHENTICATION"
  admin_web_service_pcv_ref                               = null
  allow_unidentified_client_extension_grants              = false
  allow_unidentified_client_ro_creds                      = false
  allowed_origins                                         = []
  approved_authorization_detail_attribute                 = null
  approved_scopes_attribute                               = null
  atm_id_for_oauth_grant_management                       = ""
  authorization_code_entropy                              = 30
  authorization_code_timeout                              = 60
  bypass_activation_code_confirmation                     = false
  bypass_authorization_for_approved_consents              = false
  bypass_authorization_for_approved_grants                = false
  client_secret_retention_period                          = 0
  consent_lifetime_days                                   = -1
  default_scope_description                               = null
  device_polling_interval                                 = 5
  disallow_plain_pkce                                     = false
  dpop_proof_enforce_replay_prevention                    = false
  dpop_proof_lifetime_seconds                             = 120
  dpop_proof_require_nonce                                = false
  enable_cookieless_user_authorization_authentication_api = false
  exclusive_scope_groups = [
  ]
  exclusive_scopes = [
  ]
  include_issuer_in_authorization_response         = false
  jwt_secured_authorization_response_mode_lifetime = 600
  offline_access_require_consent_prompt            = false
  par_reference_length                             = 24
  par_reference_timeout                            = 60
  par_status                                       = "ENABLED"
  pending_authorization_timeout                    = 600
  persistent_grant_contract = {
    extended_attributes = [
    ]
  }
  persistent_grant_idle_timeout                        = 30
  persistent_grant_idle_timeout_time_unit              = "DAYS"
  persistent_grant_lifetime                            = -1
  persistent_grant_lifetime_unit                       = "DAYS"
  persistent_grant_reuse_grant_types                   = ["IMPLICIT"]
  refresh_rolling_interval                             = 0
  refresh_rolling_interval_time_unit                   = "HOURS"
  refresh_token_length                                 = 42
  refresh_token_rolling_grace_period                   = 60
  registered_authorization_path                        = null
  require_offline_access_scope_to_issue_refresh_tokens = false
  return_id_token_on_open_id_with_device_authz_grant   = true
  roll_refresh_token_values                            = false
  scope_for_oauth_grant_management                     = ""
  scope_groups = [
  ]
  scopes = [
  ]
  token_endpoint_base_url                 = ""
  track_user_sessions_for_logout          = false
  user_authorization_consent_adapter      = null
  user_authorization_consent_page_setting = "INTERNAL"
  user_authorization_url                  = null
}

# Resource Type: pingfederate_server_settings_general
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_server_settings_general.pingcli__Server-0020-Settings-0020-General
  id = "server_settings_general_singleton_id"
}

# __generated__ by Terraform from "server_settings_general_singleton_id"
resource "pingfederate_server_settings_general" "pingcli__Server-0020-Settings-0020-General" {
  datastore_validation_interval_secs          = 300
  disable_automatic_connection_validation     = false
  idp_connection_transaction_logging_override = "DONT_OVERRIDE"
  request_header_for_correlation_id           = null
  sp_connection_transaction_logging_override  = "DONT_OVERRIDE"
}

# Resource Type: pingfederate_session_application_policy
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_session_application_policy.pingcli__Session-0020-Application-0020-Policy
  id = "session_application_policy_singleton_id"
}

# __generated__ by Terraform from "session_application_policy_singleton_id"
resource "pingfederate_session_application_policy" "pingcli__Session-0020-Application-0020-Policy" {
  idle_timeout_mins = 60
  max_timeout_mins  = 480
}

# Resource Type: pingfederate_keypairs_ssl_server_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_keypairs_ssl_server_settings.pingcli__Keypairs-0020-Ssl-0020-Server-0020-Settings
  id = "keypairs_ssl_server_settings_singleton_id"
}

# __generated__ by Terraform from "keypairs_ssl_server_settings_singleton_id"
resource "pingfederate_keypairs_ssl_server_settings" "pingcli__Keypairs-0020-Ssl-0020-Server-0020-Settings" {
  active_admin_console_certs = [
    {
      id = "4lbj1pas49dbbaohbih3hy1eq"
    },
  ]
  active_runtime_server_certs = [
    {
      id = "4lbj1pas49dbbaohbih3hy1eq"
    },
  ]
  admin_console_cert_ref = {
    id = "4lbj1pas49dbbaohbih3hy1eq"
  }
  runtime_server_cert_ref = {
    id = "4lbj1pas49dbbaohbih3hy1eq"
  }
}

# Resource Type: pingfederate_oauth_token_exchange_generator_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_oauth_token_exchange_generator_settings.pingcli__Oauth-0020-Token-0020-Exchange-0020-Generator-0020-Settings
  id = "oauth_token_exchange_generator_settings_singleton_id"
}
# __generated__ by Terraform from "oauth_token_exchange_generator_settings_singleton_id"
resource "pingfederate_oauth_token_exchange_generator_settings" "pingcli__Oauth-0020-Token-0020-Exchange-0020-Generator-0020-Settings" {
  default_generator_group_ref = null
}

# Resource Type: pingfederate_openid_connect_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_openid_connect_settings.pingcli__Openid-0020-Connect-0020-Settings
  id = "openid_connect_settings_singleton_id"
}

# __generated__ by Terraform from "openid_connect_settings_singleton_id"
resource "pingfederate_openid_connect_settings" "pingcli__Openid-0020-Connect-0020-Settings" {
  default_policy_ref = null
}

# Resource Type: pingfederate_server_settings_ws_trust_sts_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_server_settings_ws_trust_sts_settings.pingcli__Server-0020-Settings-0020-Ws-0020-Trust-0020-Sts-0020-Settings
  id = "server_settings_ws_trust_sts_settings_singleton_id"
}

# __generated__ by Terraform from "server_settings_ws_trust_sts_settings_singleton_id"
resource "pingfederate_server_settings_ws_trust_sts_settings" "pingcli__Server-0020-Settings-0020-Ws-0020-Trust-0020-Sts-0020-Settings" {
  basic_authn_enabled       = false
  client_cert_authn_enabled = false
  issuer_certs = [
  ]
  restrict_by_issuer_cert = false
  restrict_by_subject_dn  = false
  subject_dns             = []
  users = [
  ]
}

# Resource Type: pingfederate_protocol_metadata_lifetime_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_protocol_metadata_lifetime_settings.pingcli__Protocol-0020-Metadata-0020-Lifetime-0020-Settings
  id = "protocol_metadata_lifetime_settings_singleton_id"
}

# __generated__ by Terraform from "protocol_metadata_lifetime_settings_singleton_id"
resource "pingfederate_protocol_metadata_lifetime_settings" "pingcli__Protocol-0020-Metadata-0020-Lifetime-0020-Settings" {
  cache_duration = 1440
  reload_delay   = 1440
}

# Resource Type: pingfederate_protocol_metadata_signing_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_protocol_metadata_signing_settings.pingcli__Protocol-0020-Metadata-0020-Signing-0020-Settings
  id = "protocol_metadata_signing_settings_singleton_id"
}

# __generated__ by Terraform from "protocol_metadata_signing_settings_singleton_id"
resource "pingfederate_protocol_metadata_signing_settings" "pingcli__Protocol-0020-Metadata-0020-Signing-0020-Settings" {
  signature_algorithm = null
  signing_key_ref     = null
}

# Resource Type: pingfederate_kerberos_realm_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_kerberos_realm_settings.pingcli__Kerberos-0020-Realm-0020-Settings
  id = "kerberos_realm_settings_singleton_id"
}

# __generated__ by Terraform from "kerberos_realm_settings_singleton_id"
resource "pingfederate_kerberos_realm_settings" "pingcli__Kerberos-0020-Realm-0020-Settings" {
  debug_log_output              = false
  force_tcp                     = false
  kdc_retries                   = 0
  kdc_timeout                   = 0
  key_set_retention_period_mins = 610
}

# Resource Type: pingfederate_redirect_validation
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_redirect_validation.pingcli__Redirect-0020-Validation
  id = "redirect_validation_singleton_id"
}

# __generated__ by Terraform from "redirect_validation_singleton_id"
resource "pingfederate_redirect_validation" "pingcli__Redirect-0020-Validation" {
  redirect_validation_local_settings = {
    enable_in_error_resource_validation                 = true
    enable_target_resource_validation_for_idp_discovery = true
    enable_target_resource_validation_for_slo           = true
    enable_target_resource_validation_for_sso           = true
    uri_allow_list = [
    ]
    white_list = [
    ]
  }
  redirect_validation_partner_settings = {
    enable_wreply_validation_slo = true
  }
}

# Resource Type: pingfederate_authentication_policies_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_authentication_policies_settings.pingcli__Authentication-0020-Policies-0020-Settings
  id = "authentication_policies_settings_singleton_id"
}

# __generated__ by Terraform from "authentication_policies_settings_singleton_id"
resource "pingfederate_authentication_policies_settings" "pingcli__Authentication-0020-Policies-0020-Settings" {
  enable_idp_authn_selection = false
  enable_sp_authn_selection  = false
}

# Resource Type: pingfederate_server_settings_logging
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_server_settings_logging.pingcli__Server-0020-Settings-0020-Logging
  id = "server_settings_logging_singleton_id"
}

# __generated__ by Terraform from "server_settings_logging_singleton_id"
resource "pingfederate_server_settings_logging" "pingcli__Server-0020-Settings-0020-Logging" {
  log_categories = [
    {
      enabled = false
      id      = "xmlsig"
    },
    {
      enabled = false
      id      = "core"
    },
    {
      enabled = false
      id      = "requestparams"
    },
    {
      enabled = false
      id      = "requestheaders"
    },
    {
      enabled = false
      id      = "trustedcas"
    },
    {
      enabled = false
      id      = "restdatastore"
    },
    {
      enabled = false
      id      = "protocolrequestresponse"
    },
    {
      enabled = false
      id      = "dsresponsetime"
    },
    {
      enabled = false
      id      = "policytree"
    },
  ]
}

# Resource Type: pingfederate_default_urls
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_default_urls.pingcli__Default-0020-Urls
  id = "default_urls_singleton_id"
}

# __generated__ by Terraform from "default_urls_singleton_id"
resource "pingfederate_default_urls" "pingcli__Default-0020-Urls" {
  confirm_idp_slo     = false
  confirm_sp_slo      = false
  idp_error_msg       = "errorDetail.idpSsoFailure"
  idp_slo_success_url = null
  sp_slo_success_url  = null
  sp_sso_success_url  = null
}