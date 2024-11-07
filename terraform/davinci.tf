resource "davinci_connection" "sso" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  connector_id = "pingOneSSOConnector"
  name         = "PingOne"

  property {
    name  = "clientId"
    type  = "string"
    value = pingone_application.davinci_connection_worker.oidc_options.client_id
  }

  property {
    name  = "clientSecret"
    type  = "string"
    value = pingone_application_secret.davinci_connection_worker.secret
  }

  property {
    name  = "envId"
    type  = "string"
    value = pingone_application.davinci_connection_worker.environment_id
  }

  property {
    name  = "region"
    type  = "string"
    value = "NA"
  }
}

resource "davinci_connection" "http" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  name           = "Http"
  connector_id   = "httpConnector"
}

resource "davinci_connection" "annotation" {
  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id
  connector_id   = "annotationConnector"
  name           = "Annotation"
}