// Flow Name: PingOne DaVinci API Protect Example
resource "davinci_connection" "httpconnector__867ed4363b2bc21c860085ad2baa817d" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  connector_id = "httpConnector"
  name         = "Http"
}

// Flow Name: PingOne DaVinci API Protect Example
resource "davinci_connection" "pingoneriskconnector__292873d5ceea806d81373ed0341b5c88" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  connector_id = "pingOneRiskConnector"
  name         = "PingOne Protect"

  property {
    name  = "clientId"
    type  = "string"
    value = pingone_application.worker_app.oidc_options.client_id
  }

  property {
    name  = "clientSecret"
    type  = "string"
    value = pingone_application_secret.worker_app_secret.secret
  }

  property {
    name  = "envId"
    type  = "string"
    value = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  }
  
  property {
    name  = "region"
    type  = "string"
    value = var.pingone_client_region_code
  }
}

// Flow Name: PingOne DaVinci API Protect Example
resource "davinci_connection" "pingonessoconnector__94141bf2f1b9b59a5f5365ff135e02bb" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  connector_id = "pingOneSSOConnector"
  name         = "PingOne"

  property {
    name  = "clientId"
    type  = "string"
    value = pingone_application.worker_app.oidc_options.client_id
  }

  property {
    name  = "clientSecret"
    type  = "string"
    value = pingone_application_secret.worker_app_secret.secret
  }

  property {
    name  = "envId"
    type  = "string"
    value = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  }

  property {
    name  = "region"
    type  = "string"
    value = var.pingone_client_region_code
  }
}

// Flow Name: PingOne DaVinci API Protect Example
resource "davinci_connection" "variablesconnector__06922a684039827499bdbdd97f49827b" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  connector_id = "variablesConnector"
  name         = "Variables"
}