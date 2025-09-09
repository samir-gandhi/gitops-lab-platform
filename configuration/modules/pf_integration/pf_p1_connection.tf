# resource "pingone_gateway" "my_awesome_pingfederate_gateway" {
#   environment_id = pingone_environment.target_environment.id
#   name           = "PingFederate"
#   enabled        = true

#   type = "PING_FEDERATE"
# }

# resource "pingone_gateway_credential" "my_awesome_pingfederate_gateway" {
#   environment_id = pingone_environment.target_environment.id
#   gateway_id     = pingone_gateway.my_awesome_pingfederate_gateway.id
# }

# resource "pingfederate_pingone_connection" "example" {
#   name        = "My PingOne Environment"
#   description = "My environment"
#   credential  = pingone_gateway_credential.my_awesome_pingfederate_gateway.credential
# }