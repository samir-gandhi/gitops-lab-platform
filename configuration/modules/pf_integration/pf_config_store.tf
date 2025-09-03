# Configuration Store Resources
# These resources are converted from the configStore entries in data.json.subst

# CORS Configuration
resource "pingfederate_config_store" "cors_configuration_allowedHeaders" {
  bundle       = "cors-configuration"
  setting_id   = "allowedHeaders"
  string_value = "X-Requested-With,Content-Type,Accept,Origin,Authorization"
}

resource "pingfederate_config_store" "cors_configuration_allowedMethods" {
  bundle       = "cors-configuration"
  setting_id   = "allowedMethods"
  string_value = "GET,POST,HEAD"
}

# OAuth Client Manager LDAP Implementation
resource "pingfederate_config_store" "client_ldap_impl_ping_federate_ds_jndi_name" {
  bundle       = "org.sourceid.oauth20.domain.ClientManagerLdapImpl"
  setting_id   = "PingFederateDSJNDIName"
  string_value = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory
  ]
}

resource "pingfederate_config_store" "client_ldap_impl_search_base" {
  bundle       = "org.sourceid.oauth20.domain.ClientManagerLdapImpl"
  setting_id   = "SearchBase"
  string_value = "ou=oauthClients,${var.user_base_dn}"
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory
  ]
}

# Client Manager XML File Implementation
resource "pingfederate_config_store" "client_xml_impl_migration_complete" {
  bundle       = "org.sourceid.oauth20.domain.ClientManagerXmlFileImpl"
  setting_id   = "MigrationComplete8.4"
  string_value = "true"
}

# Security Token Creator
resource "pingfederate_config_store" "security_token_creator_base64_required_plugins" {
  bundle     = "org.sourceid.oauth20.handlers.process.exchange.execution.SecurityTokenCreator"
  setting_id = "base64-required-plugins"
  list_value = [
    "org.sourceid.wstrust.processor.oauth.BearerAccessTokenTokenProcessor",
    "org.sourceid.wstrust.processor.jwt.JWTTokenProcessor"
  ]
}

# Access Grant Manager LDAP PingDirectory Implementation
resource "pingfederate_config_store" "access_grant_manager_ldap_ds_jndi_name" {
  bundle       = "org.sourceid.oauth20.token.AccessGrantManagerLDAPPingDirectoryImpl"
  setting_id   = "PingFederateDSJNDIName"
  string_value = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory,
    pingfederate_authentication_policy_contract.pingcli__simplecontract
  ]
}

resource "pingfederate_config_store" "access_grant_manager_ldap_search_base" {
  bundle       = "org.sourceid.oauth20.token.AccessGrantManagerLDAPPingDirectoryImpl"
  setting_id   = "SearchBase"
  string_value = "ou=grants,${var.user_base_dn}"
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_authentication_policy_contract.pingcli__simplecontract
  ]
}

# Admin User Manager
resource "pingfederate_config_store" "admin_user_manager_ea_role_updated" {
  bundle       = "org.sourceid.saml20.domain.mgmt.AdminUserManager"
  setting_id   = "isEaRoleUpdated"
  string_value = "true"
}

# Partner Cert Migrator
resource "pingfederate_config_store" "partner_cert_migrator_complete" {
  bundle       = "org.sourceid.saml20.domain.mgmt.impl.PartnerCertMigrator"
  setting_id   = "partner.cert.migration.complete"
  string_value = "true"
}

# Tracked HTTP Param Manager
resource "pingfederate_config_store" "tracked_http_param_allowed_params" {
  bundle     = "org.sourceid.saml20.domain.mgmt.impl.TrackedHttpParamManagerImpl"
  setting_id = "AllowedTrackedParams"
  list_value = []
}

# Metadata Directory Hybrid Database Implementation
resource "pingfederate_config_store" "metadata_directory_hybrid_db_migration_complete" {
  bundle       = "org.sourceid.saml20.metadata.partner.impl.MetadataDirectoryHybridDbImpl"
  setting_id   = "MigrationComplete8.4"
  string_value = "true"
}

# Account Linking Service LDAP Implementation
resource "pingfederate_config_store" "account_linking_service_ldap_data_attribute" {
  bundle       = "org.sourceid.saml20.service.impl.AccountLinkingServiceLDAPImpl"
  setting_id   = "AccountLinkDataAttribute"
  string_value = "description"
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory,
    pingfederate_local_identity_profile.pingcli__pingdirectory
  ]
}

resource "pingfederate_config_store" "account_linking_service_ldap_ping_federate_ds_jndi_name" {
  bundle       = "org.sourceid.saml20.service.impl.AccountLinkingServiceLDAPImpl"
  setting_id   = "PingFederateDSJNDIName"
  string_value = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
  depends_on   = [pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP]
}

resource "pingfederate_config_store" "account_linking_service_ldap_user_search_base" {
  bundle       = "org.sourceid.saml20.service.impl.AccountLinkingServiceLDAPImpl"
  setting_id   = "UserSearchBase"
  string_value = "ou=identities,${var.user_base_dn}"
  depends_on   = [pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP]
}

resource "pingfederate_config_store" "account_linking_service_ldap_username_attribute" {
  bundle       = "org.sourceid.saml20.service.impl.AccountLinkingServiceLDAPImpl"
  setting_id   = "UsernameAttribute"
  string_value = "mail"
  depends_on   = [pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP]
}

# Pseudonym Service SHA1 Implementation
resource "pingfederate_config_store" "pseudonym_service_sha1_entropy" {
  bundle       = "org.sourceid.saml20.service.impl.PseudonymServiceSha1Impl"
  setting_id   = "entropy"
  string_value = "77+977+9bu+/vQ=="
}

# Session Storage Manager LDAP Implementation
resource "pingfederate_config_store" "session_storage_manager_ldap_ds_jndi_name" {
  bundle       = "org.sourceid.saml20.service.session.data.impl.SessionStorageManagerLdapImpl"
  setting_id   = "PingFederateDSJNDIName"
  string_value = pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP.data_store_id
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory
  ]
}

resource "pingfederate_config_store" "session_storage_manager_ldap_search_base" {
  bundle       = "org.sourceid.saml20.service.session.data.impl.SessionStorageManagerLdapImpl"
  setting_id   = "SearchBase"
  string_value = "ou=sessions,${var.user_base_dn}"
  depends_on = [
    pingfederate_data_store.pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP,
    pingfederate_password_credential_validator.pingcli__pingdirectory
  ]
}

# License Data
resource "pingfederate_config_store" "license_data" {
  bundle       = "org.sourceid.util.license.Data"
  setting_id   = "4961444dd0f96066cc3c2dd1c0ce24962e5e415ccea2e06a2cde455fa8633d7b"
  string_value = "1549584000000"
}

# Response Header Admin Config
resource "pingfederate_config_store" "response_header_admin_config_x_frame_options" {
  bundle     = "response-header-admin-config"
  setting_id = "X-Frame-Options"
  map_value = {
    include-patterns = "*"
    value            = "DENY"
  }
}
