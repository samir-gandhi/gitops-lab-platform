# resource "pingone_schema_attribute" "sample_attribute" {
#   environment_id = pingone_environment.target_environment.id

#   name         = "sample-attribute"
#   display_name = "My Sample Attribute"
#   description  = "My new awesome attribute"

#   type        = "STRING"
#   unique      = false
#   multivalued = false

#   lifecycle {
#     # change the `prevent_destroy` parameter value to `true` to prevent this data carrying resource from being destroyed
#     prevent_destroy = false
#   }
# }

# resource "pingfederate_data_store" "pingOneDataStore" {
#   custom_data_store = {
#     name = format("PingOne Data Store (%s)", pingone_environment.target_environment.name)
#     plugin_descriptor_ref = {
#       id = "com.pingidentity.plugins.datastore.p14c.PingOneForCustomersDataStore"
#     }
#     configuration = {
#       tables = [
#         {
#           name = "Custom Attributes Details",
#           rows = [
#             for schema_attribute in [pingone_schema_attribute.sample_attribute] : {
#               fields = [
#                 {
#                   name  = "Local Attribute",
#                   value = schema_attribute.name
#                 },
#                 {
#                   name  = "PingOne for Customers Attribute",
#                   value = format("/%s", schema_attribute.name)
#                 }
#               ],
#               defaultRow = false
#             }
#           ]
#         }
#       ],
#       fields = [
#         {
#           name  = "PingOne Environment",
#           value = format("%s|%s", pingfederate_pingone_connection.example.id, pingone_environment.target_environment.id)
#         },
#         {
#           name  = "Connection Timeout",
#           value = "10000"
#         },
#         {
#           name  = "Retry Request",
#           value = "true"
#         },
#         {
#           name  = "Maximum Retries Limit",
#           value = "5"
#         },
#         {
#           name  = "Retry Error Codes",
#           value = "429"
#         },
#         {
#           name  = "Proxy Settings",
#           value = "System Defaults"
#         },
#         {
#           name  = "Custom Proxy Host",
#           value = ""
#         },
#         {
#           name  = "Custom Proxy Port",
#           value = ""
#         }
#       ]
#     }
#     mask_attribute_values = false
#   }
# }

# # __generated__ by Terraform from "LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3"
# resource "pingfederate_data_store" "pingcli__LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3_LDAP" {
#   data_store_id     = "LDAP-D803C87FAB2ADFB4B0A947B64BA6F0C6093A5CA3"
#   ldap_data_store = {
#     bind_anonymously           = false
#     connection_timeout         = 3000
#     create_if_necessary        = true
#     dns_ttl                    = 60000
#     # TODO: convert this to a regular password
#     # encrypted_password         = "eyJhbGciOiJkaXIiLCJlbmMiOiJBMTI4Q0JDLUhTMjU2Iiwia2lkIjoiRW1JY1UxOVdueSIsInZlcnNpb24iOiIxMi4yLjIuMCJ9..tqwu5cDSgLvJ1S775baMLQ.kHMAz46_lCYMpWeqV-_n9w.yiRzDgTv7BgCTnDr4loB3g"
#     password = data.terraform_remote_state.infrastructure.outputs.pingfederate_api_password
#     follow_ldap_referrals      = false
#     hostnames                  = ["${var.pingone_environment_name}-pingdirectory:389"]
#     hostnames_tags = [
#       {
#         default_source = true
#         hostnames      = ["${var.pingone_environment_name}-pingdirectory:389"]
#         tags           = null
#       },
#     ]
#     ldap_dns_srv_prefix     = "_ldap._tcp"
#     ldap_type               = "PING_DIRECTORY"
#     ldaps_dns_srv_prefix    = "_ldaps._tcp"
#     max_connections         = 100
#     max_wait                = -1
#     min_connections         = 10
#     name                    = "pingdirectory"
#     read_timeout            = 3000
#     retry_failed_operations = false
#     test_on_borrow          = false
#     test_on_return          = false
#     time_between_evictions  = 60000
#     use_dns_srv_records     = false
#     use_ssl                 = false
#     use_start_tls           = false
#     user_dn                 = "cn=pingfederate"
#     verify_host             = true
#   }
#   mask_attribute_values            = false
#   ping_one_ldap_gateway_data_store = null
# }