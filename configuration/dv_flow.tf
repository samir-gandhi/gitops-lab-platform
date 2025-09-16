##########################################################################
# davinci.tf - Declarations to create DaVinci assets
# {@link https://registry.terraform.io/providers/pingidentity/davinci/latest}
##########################################################################

#########################################################################
# PingOne DaVinci - Create and deploy a flow
#########################################################################
# {@link https://registry.terraform.io/providers/pingidentity/davinci/latest/docs/resources/flow}

// Flow Name: PingOne DaVinci API Protect Example
resource "davinci_flow" "pingone_davinci_api_protect_example" {

  environment_id = pingone_group_role_assignment.terraform_sso_davinci_admin.scope_environment_id

  name        = "PingOne DaVinci API Protect Example"
  description = "This flow demonstrates how to protect an app with PingOne"

  flow_json = file("./davinci_flows/davinci-api-protect-reg-authn-flow.json")

  log_level = 2

  // Connector link: httpConnector
  connection_link {
    id                           = davinci_connection.httpconnector__867ed4363b2bc21c860085ad2baa817d.id
    name                         = davinci_connection.httpconnector__867ed4363b2bc21c860085ad2baa817d.name
    replace_import_connection_id = "867ed4363b2bc21c860085ad2baa817d"
  }

  // Connector link: pingOneRiskConnector
  connection_link {
    id                           = davinci_connection.pingoneriskconnector__292873d5ceea806d81373ed0341b5c88.id
    name                         = davinci_connection.pingoneriskconnector__292873d5ceea806d81373ed0341b5c88.name
    replace_import_connection_id = "292873d5ceea806d81373ed0341b5c88"
  }

  // Connector link: pingOneSSOConnector
  connection_link {
    id                           = davinci_connection.pingonessoconnector__94141bf2f1b9b59a5f5365ff135e02bb.id
    name                         = davinci_connection.pingonessoconnector__94141bf2f1b9b59a5f5365ff135e02bb.name
    replace_import_connection_id = "94141bf2f1b9b59a5f5365ff135e02bb"
  }

  // Connector link: variablesConnector
  connection_link {
    id                           = davinci_connection.variablesconnector__06922a684039827499bdbdd97f49827b.id
    name                         = davinci_connection.variablesconnector__06922a684039827499bdbdd97f49827b.name
    replace_import_connection_id = "06922a684039827499bdbdd97f49827b"
  }
}