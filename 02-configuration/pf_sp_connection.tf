# __generated__ by Terraform from "IENFjGICXt3YsBKNxHSzkN28LWg"
resource "pingfederate_idp_sp_connection" "pingcli__docker" {
  active                                    = true
  additional_allowed_entities_configuration = null
  application_icon_url                      = null
  application_name                          = null
  attribute_query                           = null
  base_url                                  = data.terraform_remote_state.infrastructure.outputs.pingfederate_engine_ingress_url
  connection_id                             = "dockerspconnection"
  connection_target_type                    = "STANDARD"
  contact_info = {
    company    = null
    email      = null
    first_name = null
    last_name  = null
    phone      = null
  }
  credentials = {
    block_encryption_algorithm = null
    certs = [
    ]
    decryption_key_pair_ref           = null
    inbound_back_channel_auth         = null
    key_transport_algorithm           = null
    outbound_back_channel_auth        = null
    secondary_decryption_key_pair_ref = null
    signing_settings = {
      algorithm                         = "SHA256withRSA"
      alternative_signing_key_pair_refs = null
      include_cert_in_signature         = false
      include_raw_key_in_signature      = false
      signing_key_pair_ref = {
        id = pingfederate_keypairs_signing_key.devsigningcert.key_id
      }
    }
    verification_issuer_dn  = null
    verification_subject_dn = null
  }
  default_virtual_entity_id = null
  entity_id                 = "docker"
  extended_properties       = null
  license_connection_group  = null
  logging_mode              = "STANDARD"
  metadata_reload_settings  = null
  name                      = "docker"
  outbound_provision        = null
  sp_browser_sso            = null
  virtual_entity_ids        = []
  ws_trust = {
    abort_if_not_fulfilled_from_request = null
    attribute_contract = {
      core_attributes = [
        {
          name      = "TOKEN_SUBJECT"
          namespace = null
        },
      ]
      extended_attributes = [
      ]
    }
    default_token_type      = "SAML20"
    encrypt_saml2_assertion = false
    generate_key            = false
    message_customizations = [
    ]
    minutes_after            = 30
    minutes_before           = 5
    oauth_assertion_profiles = true
    partner_service_ids      = ["docker", pingfederate_server_settings.pingcli__Server-0020-Settings.federation_info.saml_1x_issuer_id]
    request_contract_ref     = null
    token_processor_mappings = [
      {
        attribute_contract_fulfillment = {
          TOKEN_SUBJECT = {
            source = {
              id   = null
              type = "TOKEN"
            }
            value = "username"
          }
        }
        attribute_sources = [
        ]
        idp_token_processor_ref = {
          id = pingfederate_idp_token_processor.pingcli__UsernameTokenProcessor.processor_id
        }
        issuance_criteria = {
          conditional_criteria = [
          ]
          expression_criteria = null
        }
        restricted_virtual_entity_ids = []
      },
    ]
  }
}

# __generated__ by Terraform from "gpFvXmhDHSRUSHWLZLZ_XBIU_YK"
resource "pingfederate_idp_sp_connection" "pingcli__Dummy-0020-SP-0020-Connection" {
  active                                    = true
  additional_allowed_entities_configuration = null
  application_icon_url                      = null
  application_name                          = null
  attribute_query                           = null
  base_url                                  = null
  connection_id                             = "dummyspconnection"
  connection_target_type                    = "STANDARD"
  contact_info = {
    company    = null
    email      = null
    first_name = null
    last_name  = null
    phone      = null
  }
  credentials = {
    block_encryption_algorithm = null
    certs = [
    ]
    decryption_key_pair_ref           = null
    inbound_back_channel_auth         = null
    key_transport_algorithm           = null
    outbound_back_channel_auth        = null
    secondary_decryption_key_pair_ref = null
    signing_settings = {
      algorithm                         = "SHA256withRSA"
      alternative_signing_key_pair_refs = null
      include_cert_in_signature         = false
      include_raw_key_in_signature      = false
      signing_key_pair_ref = {
        id = pingfederate_keypairs_signing_key.devsigningcert.key_id
      }
    }
    verification_issuer_dn  = null
    verification_subject_dn = null
  }
  default_virtual_entity_id = null
  entity_id                 = "https://httpbin.org"
  extended_properties       = null
  license_connection_group  = null
  logging_mode              = "STANDARD"
  metadata_reload_settings  = null
  name                      = "Dummy SP Connection"
  outbound_provision        = null
  sp_browser_sso = {
    adapter_mappings = [
    ]
    always_sign_artifact_response = false
    artifact                      = null
    assertion_lifetime = {
      minutes_after  = 5
      minutes_before = 5
    }
    attribute_contract = {
      core_attributes = [
        {
          name        = "SAML_SUBJECT"
          name_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified"
        },
      ]
      extended_attributes = [
      ]
    }
    authentication_policy_contract_assertion_mappings = [
      {
        abort_sso_transaction_as_fail_safe = false
        attribute_contract_fulfillment = {
          SAML_SUBJECT = {
            source = {
              id   = null
              type = "AUTHENTICATION_POLICY_CONTRACT"
            }
            value = "subject"
          }
        }
        attribute_sources = [
        ]
        authentication_policy_contract_ref = {
          id = pingfederate_authentication_policy_contract.pingcli__simplecontract.contract_id
        }
        issuance_criteria = {
          conditional_criteria = [
          ]
          expression_criteria = null
        }
        restrict_virtual_entity_ids   = false
        restricted_virtual_entity_ids = []
      },
    ]
    default_target_url = null
    enabled_profiles   = ["IDP_INITIATED_SSO"]
    encryption_policy = {
      encrypt_assertion             = false
      encrypt_slo_subject_name_id   = false
      encrypted_attributes          = []
      slo_subject_name_id_encrypted = false
    }
    incoming_bindings = null
    message_customizations = [
    ]
    protocol                      = "SAML20"
    require_signed_authn_requests = false
    sign_assertions               = false
    sign_response_as_required     = true
    slo_service_endpoints = [
    ]
    sp_saml_identity_mapping   = "STANDARD"
    sp_ws_fed_identity_mapping = null
    sso_service_endpoints = [
      {
        binding    = "POST"
        index      = 0
        is_default = true
        url        = "https://httpbin.org/anything"
      },
    ]
    url_whitelist_entries = null
    ws_fed_token_type     = null
    ws_trust_version      = null
  }
  virtual_entity_ids = []
  ws_trust           = null
}