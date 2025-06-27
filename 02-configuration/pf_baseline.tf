resource "pingfederate_keypairs_signing_key" "devsigningcert" {
  file_data = "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%"
  password  = data.terraform_remote_state.infrastructure.outputs.pingfederate_api_password
  format    = "PKCS12"
  key_id    = "devsigningcert"
}

resource "pingfederate_keypairs_ssl_server_key" "sslServerKey" {
  key_id    = "sslservercert"
  file_data = "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%"
  password  = data.terraform_remote_state.infrastructure.outputs.pingfederate_api_password
  format    = "PKCS12"
}

# __generated__ by Terraform from "50z1hm968rdu2irr31i5ridbh"
resource "pingfederate_certificate_ca" "pingcli__CN-003D-dev-002C--0020-OU-003D-docker-002C--0020-O-003D-pingidentity-002C--0020-L-003D-denver-002C--0020-ST-003D-co-002C--0020-C-003D-us_1971379859" {
  ca_id           = "50z1hm968rdu2irr31i5ridbh"
  crypto_provider = null
  file_data       = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUY4akNDQTlxZ0F3SUJBZ0lFZFlEZWt6QU5CZ2txaGtpRzl3MEJBUXNGQURCaE1Rc3dDUVlEVlFRR0V3SjFjekVMTUFrR0ExVUUKQ0JNQ1kyOHhEekFOQmdOVkJBY1RCbVJsYm5abGNqRVZNQk1HQTFVRUNoTU1jR2x1WjJsa1pXNTBhWFI1TVE4d0RRWURWUVFMRXdaawpiMk5yWlhJeEREQUtCZ05WQkFNVEEyUmxkakFlRncweE9UQTFNREV5TURRNE1ERmFGdzB5T1RBME1qZ3lNRFE0TURGYU1HRXhDekFKCkJnTlZCQVlUQW5Wek1Rc3dDUVlEVlFRSUV3SmpiekVQTUEwR0ExVUVCeE1HWkdWdWRtVnlNUlV3RXdZRFZRUUtFd3h3YVc1bmFXUmwKYm5ScGRIa3hEekFOQmdOVkJBc1RCbVJ2WTJ0bGNqRU1NQW9HQTFVRUF4TURaR1YyTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQwpBZzhBTUlJQ0NnS0NBZ0VBak9uZCtqdUd6T3pTL0N0OHFtZmg2SFJ4WmY4NTZ5UjM5Q3ZxOHFZMlhhOUsxU3FuTFBoS0kyeUJocVNpCkFoQ01laHAvRHRQdEFJaXgvNUVVZmwvUWxuOU1Ka3dGTkt5QTVUQ090SHVBWE5maGhSY0p2VCs4TDZaM0VsOGduQWE1S1A5b1BtVzkKcngvWHhUcU11RGVOQWhuSGZIaVlsdEdXc3F1TGY2WnVaMVhWcHp3NmZWRzZWcVdwNmdTSU0wRXQrS2ZFMVczeUNyekIzajdCQ0hMRQp0V0ZGdEdWVjB6cS8zZE5wUFlCbG5XOEtreC9Cd3hhNkE4ZldDeEVzVjk0NUQzUDRWR2V5VmlMUklWS1hQNjVTOTZ3eGRPYk1xYjJOCis4K0VKdERxNmlZYUplWDMrYStiOG9yOFJ0MHZIRm83YXkrV3NLSVljZWlDUW5wTEcwQkRJb1pYQnhNVnc5OVpjN0x2dGRmaGpBRlcKaEI1T2dJQ3duck51YkR0djArN3d0Y0lROVV5akpYZWw4bTI2QjlsNFRXWjYyNXozR2EzbkZSK2c2TmdUb2JyWkRYbzBwV2dxU0R3eQpTem9QQ3FWT3N6VFduVzBscFNRM3diZnNkQ0w1YXVzeFE0STR5bnY3anJQS3V5WFRxdGRSK0lCajEyeFBrcy94ckM3eW9aV2RjcGN1CmRrYkR4U3REK1VCeUM4QlYvOFpzZm9LSU8rSFhKM2drc0dOYUhGQ2YyZVIyZXVVT3cycWJDRGYxYnJYOEk3RU1KdFNJajd4YnpqajQKbGFiT0NIWnF5a2FBajNveWlaTVN4ZjFnUUdRMmNKMHNYdFRERG5BNWRocjhtNUZPcUFuc0VTN2tsNEMvVzFuMCtZd3FzZisvNERyVQpoc3VKNjhQMHhIV0gwNk1DQXdFQUFhT0JzVENCcmpDQmpBWURWUjBSQklHRU1JR0JnZ3B3YVc1bllXTmpaWE56Z2c5d2FXNW5aR0YwCllXTnZibk52YkdXQ0VuQnBibWRrWVhSaFoyOTJaWEp1WVc1alpZSU1jR2x1WjJSaGRHRnplVzVqZ2cxd2FXNW5aR2x5WldOMGIzSjUKZ2d4d2FXNW5abVZrWlhKaGRHV0NFbkJwYm1kbVpXUmxjbUYwWlMxaFpHMXBib0lKYkc5allXeG9iM04waHdSL0FBQUJNQjBHQTFVZApEZ1FXQkJRSnpnbGdaeTdOczlpR3J2V0U3TjlWWXBnV0FqQU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FnRUFaRXpqblhZUGpSSUYwdlQ1CnZYaGRQUlN5L3pMamZVQWVZSkZTWENuUUh1ODVkS0N0SExtekdXMjQ5aGd4c2VjQW03MS9UMHFoKzMvWlA0UTNwL2doU3dWOHlsK0wKM2kxak9mUWF1dlRXQnNmQzBla29MNHZReEpJSXkxMmRJYzJpd3pCUklOSUpUaGlJVmdaVTJiTjVqdGRzRER4Y09CU2UzMVN5RWFPSwpOVWUvRUV6WnBIRXpHUDFETjVqMzRZYXBkQjNtNXVrUWZnN1laT0dNb0k2QjFmejlNcFZOMklORmcyenF0TmRKVkhVZlI0M0NxbDk2CnpDangvQVZFejJPMUFMeVd3KzNMZXFGeWo1Q1pVL1pWaXpwWFRFM0d3VmRRVlFnVkZPcndIS29HODcvRDhaSUpvQmI5MW4zNlZ4RXEKcVZFUjNJeC9WL3R5bWNCLzFTMnhKL0Zza1NBR1lQeFNkVlBlRlNRNTN3NkJkaHFvT0krdk5hSXR4aW5yV3V3Y1dBWHVMLzJabGd5TQppNGpZeXQ0UDI0anE0dTBMRytkSE1meW15VTV6MHhWaUMxSjdsZDdJMytUM2lCLzgyTTBjeVFrSDJGNmNKbVNyZ1o3cEtZQ3BaV2J2CjZ3R3ZGdzFnaUtHa1VERFhKT0E5NTBmSzY2cUZFSmdXb3RoV3J6SFRuZ1RMSHZZakpZOUZiMElocjRWb3VLOG1WdTBLYmxUY2x3eVoKNjNKcXhBZEl0alNvbzZVVUcyZnFoOHpSdTRTWjNLaXVZVGF1Q3dUZFpmbmE5ejNlZk83RHg5Y3dPWWwxQy9Ea01BOVBHdExTOW0vagpEOElOQnFFdmxIMFgyTVBNWS9mWGdEUFhlbFU5TEs4aStaZ2FvbDhnVkd3dlNUL0dWdGtuaGVSWVVoMD0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo="
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
      id = pingfederate_keypairs_ssl_server_key.sslServerKey.key_id
    },
  ]
  active_runtime_server_certs = [
    {
      id = pingfederate_keypairs_ssl_server_key.sslServerKey.key_id
    },
  ]
  admin_console_cert_ref = {
    id = pingfederate_keypairs_ssl_server_key.sslServerKey.key_id
  }
  runtime_server_cert_ref = {
    id = pingfederate_keypairs_ssl_server_key.sslServerKey.key_id
  }
}

# Resource Type: pingfederate_virtual_host_names
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_virtual_host_names.pingcli__Virtual-0020-Host-0020-Names
  id = "virtual_host_names_singleton_id"
}

# __generated__ by Terraform from "virtual_host_names_singleton_id"
resource "pingfederate_virtual_host_names" "pingcli__Virtual-0020-Host-0020-Names" {
  virtual_host_names = ["pingfederate"]
}

# Resource Type: pingfederate_certificates_revocation_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_certificates_revocation_settings.pingcli__Certificates-0020-Revocation-0020-Settings
  id = "certificates_revocation_settings_singleton_id"
}

# __generated__ by Terraform from "certificates_revocation_settings_singleton_id"
resource "pingfederate_certificates_revocation_settings" "pingcli__Certificates-0020-Revocation-0020-Settings" {
  crl_settings = {
    next_retry_mins_when_next_update_in_past = 60
    next_retry_mins_when_resolve_failed      = 1440
    treat_non_retrievable_crl_as_revoked     = false
    verify_crl_signature                     = true
  }
  ocsp_settings  = null
  proxy_settings = null
}

import {
  to = pingfederate_server_settings.pingcli__Server-0020-Settings
  id = "server_settings_singleton_id"
}

# __generated__ by Terraform from "server_settings_singleton_id"
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
    saml_1x_issuer_id = "localhost:default:entityId"
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

import {
  to = pingfederate_oauth_access_token_manager_settings.pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings
  id = "oauth_access_token_manager_settings_singleton_id"
}

# __generated__ by Terraform from "oauth_access_token_manager_settings_singleton_id"
resource "pingfederate_oauth_access_token_manager_settings" "pingcli__Oauth-0020-Access-0020-Token-0020-Manager-0020-Settings" {
  default_access_token_manager_ref = {
    id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
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
  enable_idp_authn_selection = true
  enable_sp_authn_selection  = false
}

# __generated__ by Terraform from "jwt"
resource "pingfederate_oauth_access_token_manager" "pingcli__JSON-0020-Web-0020-Tokens" {
  access_control_settings = {
    allowed_clients = [
    ]
    restrict_clients = false
  }
  attribute_contract = {
    default_subject_attribute = null
    extended_attributes = [
      {
        multi_valued = false
        name         = "OrgName"
      },
      {
        multi_valued = false
        name         = "Username"
      },
    ]
  }
  configuration = {
    fields = [
      {
        name  = "Access Grant GUID Claim Name"
        value = "agid"
      },
      {
        name  = "Active Signing Certificate Key ID"
        value = "k1"
      },
      {
        name  = "Active Symmetric Encryption Key ID"
        value = ""
      },
      {
        name  = "Active Symmetric Key ID"
        value = ""
      },
      {
        name  = "Asymmetric Encryption JWKS URL"
        value = ""
      },
      {
        name  = "Asymmetric Encryption Key"
        value = ""
      },
      {
        name  = "Audience Claim Value"
        value = ""
      },
      {
        name  = "Authorization Details Claim Name"
        value = "authorization_details"
      },
      {
        name  = "Client ID Claim Name"
        value = "client_id_name"
      },
      {
        name  = "Default JWKS URL Cache Duration"
        value = "720"
      },
      {
        name  = "Enable Token Revocation"
        value = "false"
      },
      {
        name  = "Expand Scope Groups"
        value = "false"
      },
      {
        name  = "Include Issued At Claim"
        value = "false"
      },
      {
        name  = "Include JWE Key ID Header Parameter"
        value = "true"
      },
      {
        name  = "Include JWE X.509 Thumbprint Header Parameter"
        value = "false"
      },
      {
        name  = "Include Key ID Header Parameter"
        value = "true"
      },
      {
        name  = "Include X.509 Thumbprint Header Parameter"
        value = "false"
      },
      {
        name  = "Issuer Claim Value"
        value = ""
      },
      {
        name  = "JWE Algorithm"
        value = ""
      },
      {
        name  = "JWE Content Encryption Algorithm"
        value = ""
      },
      {
        name  = "JWKS Endpoint Cache Duration"
        value = "720"
      },
      {
        name  = "JWKS Endpoint Path"
        value = ""
      },
      {
        name  = "JWS Algorithm"
        value = "RS256"
      },
      {
        name  = "JWT ID Claim Length"
        value = "0"
      },
      {
        name  = "Not Before Claim Offset"
        value = ""
      },
      {
        name  = "Publish Key ID X.509 URL"
        value = "false"
      },
      {
        name  = "Publish Keys to the PingFederate JWKS Endpoint"
        value = "false"
      },
      {
        name  = "Publish Thumbprint X.509 URL"
        value = "false"
      },
      {
        name  = "Scope Claim Name"
        value = "scope"
      },
      {
        name  = "Space Delimit Scope Values"
        value = "false"
      },
      {
        name  = "Token Lifetime"
        value = "120"
      },
      {
        name  = "Type Header Value"
        value = ""
      },
      {
        name  = "Use Centralized Signing Key"
        value = "false"
      },
    ]
    sensitive_fields = [
    ]
    tables = [
      {
        name = "Symmetric Keys"
        rows = null
      },
      {
        name = "Certificates"
        rows = [
          {
            default_row = false
            fields = [
              {
                name  = "Certificate"
                value = pingfederate_keypairs_signing_key.devsigningcert.key_id
              },
              {
                name  = "Key ID"
                value = "k1"
              },
            ]
            sensitive_fields = [
            ]
          },
        ]
      },
    ]
  }
  manager_id = "jwt"
  name       = "JSON Web Tokens"
  parent_ref = null
  plugin_descriptor_ref = {
    id = "com.pingidentity.pf.access.token.management.plugins.JwtBearerAccessTokenManagementPlugin"
  }
  selection_settings = {
    resource_uris = []
  }
  session_validation_settings = {
    check_session_revocation_status = false
    check_valid_authn_session       = false
    include_session_id              = false
    update_authn_session_activity   = false
  }
  token_endpoint_attribute_contract = {
    attributes = [
    ]
  }
}

# __generated__ by Terraform from "pingdirectory"
resource "pingfederate_password_credential_validator" "pingcli__pingdirectory" {
  attribute_contract = {
    extended_attributes = [
      {
        name = "entryUUID"
      },
    ]
  }
  configuration = {
    fields = [
      {
        name  = "Account Disabled Attribute"
        value = ""
      },
      {
        name  = "Case-Sensitive Matching"
        value = "false"
      },
      {
        name  = "Display Name Attribute"
        value = "displayName"
      },
      {
        name  = "Enable PingDirectory Detailed Password Policy Requirement Messaging"
        value = "false"
      },
      {
        name  = "Expect Password Expired Control"
        value = "false"
      },
      {
        name  = "LDAP Datastore"
        value = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
      },
      {
        name  = "Mail Attribute"
        value = "mail"
      },
      {
        name  = "Mail Search Filter"
        value = ""
      },
      {
        name  = "Mail Verified Attribute"
        value = ""
      },
      {
        name  = "PingID Username Attribute"
        value = ""
      },
      {
        name  = "SMS Attribute"
        value = ""
      },
      {
        name  = "Scope of Search"
        value = "Subtree"
      },
      {
        name  = "Search Base"
        value = "dc=example,dc=com"
      },
      {
        name  = "Search Filter"
        value = "(&(objectClass=person)(|(mail=$${username})(cn=$${username})(uid=$${username})))"
      },
      {
        name  = "Trim Username Spaces For Search"
        value = "false"
      },
      {
        name  = "Username Attribute"
        value = ""
      },
    ]
    sensitive_fields = [
    ]
    tables = [
      {
        name = "Authentication Error Overrides"
        rows = null
      },
    ]
  }
  name       = "pingdirectory"
  parent_ref = null
  plugin_descriptor_ref = {
    id = "org.sourceid.saml20.domain.LDAPUsernamePasswordCredentialValidator"
  }
  validator_id = "pingdirectory"
}

# __generated__ by Terraform from "simple"
resource "pingfederate_password_credential_validator" "pingcli__simple" {
  attribute_contract = {
    extended_attributes = [
    ]
  }
  configuration = {
    fields = [
    ]
    sensitive_fields = [
    ]
    tables = [
      {
        name = "Users"
        rows = [
          {
            default_row = false
            fields = [
              {
                name  = "Relax Password Requirements"
                value = "true"
              },
              {
                name  = "Username"
                value = "joe"
              },
            ]
            sensitive_fields = [
              {
                # encrypted_value = "OBF:JWE:eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoiRW1JY1UxOVdueSIsInZlcnNpb24iOiIxMi4yLjIuMCJ9..ZPgy2Mba08tUwDHa2y7EoA.WpDBPTLjoiCDWf78RKMmZCbOYQo7biAA6eO2dSy3HqQpmDoi3AHrJLI4w3Yh-dH4ILWNB-7ViHQ4ubEtl5dFuw._4dFeZYpxwhrg-NAATBt1Q"
                name  = "Confirm Password"
                value = var.demo_user_sample_password
              },
              {
                # encrypted_value = "OBF:JWE:eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoiRW1JY1UxOVdueSIsInZlcnNpb24iOiIxMi4yLjIuMCJ9..eH7GyZZ7qgCIqh1wsv2t_Q.eDEeBZE1l_51aed1EU_2aZFohAYtDWCDpMqIgJc3lFhV2Yahj9KMTV2CjzsRtP1Df8MKxqxZ-AhZnTN-5OdPkA.N5AKCnuDQ_vgwqiAJWbcLg"
                name  = "Password"
                value = var.demo_user_sample_password
              },
            ]
          },
        ]
      },
    ]
  }
  name       = "simple"
  parent_ref = null
  plugin_descriptor_ref = {
    id = "org.sourceid.saml20.domain.SimpleUsernamePasswordCredentialValidator"
  }
  validator_id = "simple"
}

# __generated__ by Terraform from "UsernameTokenProcessor"
resource "pingfederate_idp_token_processor" "pingcli__UsernameTokenProcessor" {
  attribute_contract = {
    core_attributes = [
      {
        masked = false
        name   = "username"
      },
    ]
    extended_attributes = [
    ]
    mask_ognl_values = false
  }
  configuration = {
    fields = [
      {
        name  = "Authentication Attempts"
        value = "3"
      },
    ]
    sensitive_fields = [
    ]
    tables = [
      {
        name = "Credential Validators"
        rows = [
          {
            default_row = false
            fields = [
              {
                name  = "Password Credential Validator Instance"
                value = pingfederate_password_credential_validator.pingcli__pingdirectory.validator_id
              },
            ]
            sensitive_fields = [
            ]
          },
          {
            default_row = false
            fields = [
              {
                name  = "Password Credential Validator Instance"
                value = pingfederate_password_credential_validator.pingcli__simple.validator_id
              },
            ]
            sensitive_fields = [
            ]
          },
        ]
      },
    ]
  }
  name       = "UsernameTokenProcessor"
  parent_ref = null
  plugin_descriptor_ref = {
    id = "com.pingidentity.pf.tokenprocessors.username.UsernameTokenProcessor"
  }
  processor_id = "UsernameTokenProcessor"
}

# __generated__ by Terraform from "Zxp6N6W5PH9onACT"
resource "pingfederate_authentication_policy_contract" "pingcli__simplecontract" {
  contract_id = "simplecontract"
  extended_attributes = [
    {
      name = "mail"
    },
  ]
  name = "simplecontract"
}

resource "pingfederate_oauth_authentication_policy_contract_mapping" "simplecontract_mapping" {
  attribute_contract_fulfillment = {
    "USER_NAME" = {
      source = {
        type = "AUTHENTICATION_POLICY_CONTRACT"
      }
      value = "subject"
    }
    "USER_KEY" = {
      source = {
        type = "AUTHENTICATION_POLICY_CONTRACT"
      }
      value = "subject"
    }
  }
  authentication_policy_contract_ref = {
    id = pingfederate_authentication_policy_contract.pingcli__simplecontract.contract_id
  }
}

# __generated__ by Terraform from "authz_req|apc.Zxp6N6W5PH9onACT|jwt"
resource "pingfederate_oauth_access_token_mapping" "pingcli__authz_req-007C-apc-002E-Zxp6N6W5PH9onACT-007C-jwt_AUTHENTICATION_POLICY_CONTRACT" {
  access_token_manager_ref = {
    id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
  }
  attribute_contract_fulfillment = {
    OrgName = {
      source = {
        id   = null
        type = "TEXT"
      }
      value = "PingIdentity"
    }
    Username = {
      source = {
        id   = null
        type = "AUTHENTICATION_POLICY_CONTRACT"
      }
      value = "subject"
    }
  }
  attribute_sources = [
  ]
  context = {
    context_ref = {
      id = pingfederate_authentication_policy_contract.pingcli__simplecontract.contract_id
    }
    type = "AUTHENTICATION_POLICY_CONTRACT"
  }
  issuance_criteria = {
    conditional_criteria = [
    ]
    expression_criteria = null
  }
}

# TODO: fix, broken doesn't create
# __generated__ by Terraform from "password|pingdirectory|jwt"
# resource "pingfederate_oauth_access_token_mapping" "pingcli__password-007C-pingdirectory-007C-jwt_PCV" {
#   access_token_manager_ref = {
#     id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
#   }
#   attribute_contract_fulfillment = {
#     OrgName = {
#       source = {
#         id   = null
#         type = "TEXT"
#       }
#       value = "PingIdentity"
#     }
#     Username = {
#       source = {
#         id   = null
#         type = "PASSWORD_CREDENTIAL_VALIDATOR"
#       }
#       value = "mail"
#     }
#   }
#   attribute_sources = [
#   ]
#   context = {
#     context_ref = {
#       id = pingfederate_password_credential_validator.pingcli__pingdirectory.validator_id
#     }
#     type = "PCV"
#   }
#   issuance_criteria = {
#     conditional_criteria = [
#     ]
#     expression_criteria = null
#   }
# }

# Resource Type: pingfederate_openid_connect_settings
# Singleton ID: This resource is a singleton, so the value of 'ID' in the import block does not matter - it is just a placeholder and required by terraform.
import {
  to = pingfederate_openid_connect_settings.pingcli__Openid-0020-Connect-0020-Settings
  id = "openid_connect_settings_singleton_id"
}
# # __generated__ by Terraform from "openid_connect_settings_singleton_id"
resource "pingfederate_openid_connect_settings" "pingcli__Openid-0020-Connect-0020-Settings" {
  default_policy_ref = {
    id = pingfederate_openid_connect_policy.pingcli__OAuthPlayground.policy_id
  }
}

# __generated__ by Terraform from "OAuthPlayground"
resource "pingfederate_openid_connect_policy" "pingcli__OAuthPlayground" {
  access_token_manager_ref = {
    id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
  }
  attribute_contract = {
    extended_attributes = [
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.country"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.formatted"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.locality"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.postal_code"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.region"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "address.street_address"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "birthdate"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "email"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "email_verified"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "family_name"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "gender"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "given_name"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "locale"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "middle_name"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "name"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "nickname"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "phone_number"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "phone_number_verified"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "picture"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "preferred_username"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "profile"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "updated_at"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "website"
      },
      {
        include_in_id_token  = null
        include_in_user_info = null
        multi_valued         = false
        name                 = "zoneinfo"
      },
    ]
  }
  attribute_mapping = {
    attribute_contract_fulfillment = {
      "address.country" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "USA"
      }
      "address.formatted" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "123 Main Street, Smallville, ME USA 11223"
      }
      "address.locality" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Smallville"
      }
      "address.postal_code" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "11223"
      }
      "address.region" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "ME"
      }
      "address.street_address" = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "123 Main Street"
      }
      birthdate = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "1977-12-31"
      }
      email = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "auser@example.com"
      }
      email_verified = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "true"
      }
      family_name = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Sample"
      }
      gender = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "female"
      }
      given_name = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Mary"
      }
      locale = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "en_US"
      }
      middle_name = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Good"
      }
      name = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Mary Good Sample"
      }
      nickname = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "Name"
      }
      phone_number = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "(555) 555-5555"
      }
      phone_number_verified = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "true"
      }
      picture = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "https://www.pingidentity.com/images/ping-logo.png"
      }
      preferred_username = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "mgsample"
      }
      profile = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "https://www.pingidentity.com/products/pingfederate/"
      }
      sub = {
        source = {
          id   = null
          type = "TOKEN"
        }
        value = "Username"
      }
      updated_at = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "2011-01-03T23:58:42+0000"
      }
      website = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "https://www.pingidentity.com/"
      }
      zoneinfo = {
        source = {
          id   = null
          type = "TEXT"
        }
        value = "America/New_York"
      }
    }
    attribute_sources = [
    ]
    issuance_criteria = {
      conditional_criteria = [
      ]
      expression_criteria = null
    }
  }
  id_token_lifetime                       = 5
  id_token_typ_header_value               = null
  include_s_hash_in_id_token              = false
  include_sri_in_id_token                 = false
  include_user_info_in_id_token           = false
  include_x5t_in_id_token                 = false
  name                                    = "OAuthPlayground"
  policy_id                               = "OAuthPlayground"
  reissue_id_token_in_hybrid_flow         = false
  return_id_token_on_refresh_grant        = false
  return_id_token_on_token_exchange_grant = false
  scope_attribute_mappings = {
  }
}

# __generated__ by Terraform from "pingdelegator"
resource "pingfederate_openid_connect_policy" "pingcli__pingdelegator" {
  access_token_manager_ref = {
    id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
  }
  attribute_contract = {
    extended_attributes = [
    ]
  }
  attribute_mapping = {
    attribute_contract_fulfillment = {
      sub = {
        source = {
          id   = null
          type = "TOKEN"
        }
        value = "Username"
      }
    }
    attribute_sources = [
    ]
    issuance_criteria = {
      conditional_criteria = [
      ]
      expression_criteria = null
    }
  }
  id_token_lifetime                       = 5
  id_token_typ_header_value               = null
  include_s_hash_in_id_token              = false
  include_sri_in_id_token                 = false
  include_user_info_in_id_token           = false
  include_x5t_in_id_token                 = false
  name                                    = "pingdelegator"
  policy_id                               = "pingdelegator"
  reissue_id_token_in_hybrid_flow         = false
  return_id_token_on_refresh_grant        = false
  return_id_token_on_token_exchange_grant = false
  scope_attribute_mappings = {
  }
}

# __generated__ by Terraform from "pingaccess"
resource "pingfederate_openid_connect_policy" "pingcli__pingaccess" {
  access_token_manager_ref = {
    id = pingfederate_oauth_access_token_manager.pingcli__JSON-0020-Web-0020-Tokens.manager_id
  }
  attribute_contract = {
    extended_attributes = [
    ]
  }
  attribute_mapping = {
    attribute_contract_fulfillment = {
      sub = {
        source = {
          id   = null
          type = "TOKEN"
        }
        value = "Username"
      }
    }
    attribute_sources = [
    ]
    issuance_criteria = {
      conditional_criteria = [
      ]
      expression_criteria = null
    }
  }
  id_token_lifetime                       = 5
  id_token_typ_header_value               = null
  include_s_hash_in_id_token              = false
  include_sri_in_id_token                 = true
  include_user_info_in_id_token           = true
  include_x5t_in_id_token                 = false
  name                                    = "pingaccess"
  policy_id                               = "pingaccess"
  reissue_id_token_in_hybrid_flow         = false
  return_id_token_on_refresh_grant        = false
  return_id_token_on_token_exchange_grant = false
  scope_attribute_mappings = {
  }
}

# __generated__ by Terraform from "LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3"
resource "pingfederate_data_store" "pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP" {
  data_store_id = "LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3"
  lifecycle {
    create_before_destroy = true
  }
  ldap_data_store = {
    bind_anonymously      = false
    connection_timeout    = 3000
    create_if_necessary   = true
    dns_ttl               = 60000
    password              = data.terraform_remote_state.infrastructure.outputs.pingfederate_api_password
    follow_ldap_referrals = false
    hostnames             = ["${var.pingone_environment_name}-pingdirectory:389"]
    hostnames_tags = [
      {
        default_source = true
        hostnames      = ["${var.pingone_environment_name}-pingdirectory:389"]
        tags           = null
      },
    ]
    ldap_dns_srv_prefix     = "_ldap._tcp"
    ldap_type               = "PING_DIRECTORY"
    ldaps_dns_srv_prefix    = "_ldaps._tcp"
    max_connections         = 100
    max_wait                = -1
    min_connections         = 10
    name                    = "pingdirectory"
    read_timeout            = 3000
    retry_failed_operations = false
    test_on_borrow          = false
    test_on_return          = false
    time_between_evictions  = 60000
    use_dns_srv_records     = false
    use_ssl                 = false
    use_start_tls           = false
    user_dn                 = "cn=pingfederate"
    verify_host             = true
  }
  mask_attribute_values            = false
  ping_one_ldap_gateway_data_store = null
}

# __generated__ by Terraform from "RBSQIwi5KWYN9ZGK"
resource "pingfederate_local_identity_profile" "pingcli__pingdirectory" {
  apc_id = {
    id = pingfederate_authentication_policy_contract.pingcli__simplecontract.contract_id
  }
  auth_source_update_policy = {
    retain_attributes = false
    store_attributes  = false
    update_attributes = false
    update_interval   = 0
  }
  auth_sources = [
  ]
  data_store_config = {
    auxiliary_object_classes = null
    base_dn                  = "ou=people,dc=example,dc=com"
    create_pattern           = "uid=$${mail}"
    data_store_mapping = {
      cn = {
        metadata = {}
        name     = "cn"
        type     = "LDAP"
      }
      entryUUID = {
        metadata = {}
        name     = "entryUUID"
        type     = "LDAP"
      }
      mail = {
        metadata = {}
        name     = "mail"
        type     = "LDAP"
      }
      sn = {
        metadata = {}
        name     = "sn"
        type     = "LDAP"
      }
      uid = {
        metadata = {}
        name     = "uid"
        type     = "LDAP"
      }
    }
    data_store_ref = {
      id = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
    }
    object_class = "inetOrgPerson"
    type         = "LDAP"
  }
  email_verification_config = {
    allowed_otp_character_set                = null
    email_verification_enabled               = false
    email_verification_error_template_name   = null
    email_verification_otp_template_name     = null
    email_verification_sent_template_name    = null
    email_verification_success_template_name = null
    email_verification_type                  = null
    field_for_email_to_verify                = null
    field_storing_verification_status        = null
    notification_publisher_ref               = null
    otl_time_to_live                         = null
    otp_length                               = null
    otp_retry_attempts                       = null
    otp_time_to_live                         = null
    require_verified_email                   = null
    require_verified_email_template_name     = null
    verify_email_template_name               = null
  }
  field_config = {
    fields = [
      {
        attributes = {
          "Mask Log Values" = false
          Read-Only         = false
          Required          = true
          "Unique ID Field" = false
        }
        default_value           = null
        id                      = "cn"
        label                   = "First Name"
        options                 = null
        profile_page_field      = true
        registration_page_field = true
        type                    = "TEXT"
      },
      {
        attributes = {
          "Mask Log Values" = false
          Read-Only         = false
          Required          = true
          "Unique ID Field" = false
        }
        default_value           = null
        id                      = "sn"
        label                   = "Last Name"
        options                 = null
        profile_page_field      = true
        registration_page_field = true
        type                    = "TEXT"
      },
      {
        attributes = {
          "Mask Log Values" = false
          Read-Only         = false
          Required          = true
          "Unique ID Field" = true
        }
        default_value           = null
        id                      = "mail"
        label                   = "Email address"
        options                 = null
        profile_page_field      = true
        registration_page_field = true
        type                    = "EMAIL"
      },
      {
        attributes = {
          "Mask Log Values" = false
          "Unique ID Field" = false
        }
        default_value           = null
        id                      = "entryUUID"
        label                   = "entryUUID"
        options                 = null
        profile_page_field      = false
        registration_page_field = false
        type                    = "HIDDEN"
      },
      {
        attributes = {
          "Mask Log Values" = false
          "Unique ID Field" = false
        }
        default_value           = null
        id                      = "uid"
        label                   = "uid"
        options                 = null
        profile_page_field      = false
        registration_page_field = true
        type                    = "HIDDEN"
      },
    ]
    strip_space_from_unique_field = false
  }
  name = "pingdirectory"
  profile_config = {
    delete_identity_enabled = true
    template_name           = "local.identity.profile.html"
  }
  profile_enabled = true
  profile_id      = "RBSQIwi5KWYN9ZGK"
  registration_config = {
    captcha_enabled                         = false
    captcha_provider_ref                    = null
    create_authn_session_after_registration = true
    execute_workflow                        = null
    registration_workflow                   = null
    template_name                           = "local.identity.registration.html"
    this_is_my_device_enabled               = false
    username_field                          = null
  }
  registration_enabled = true
}