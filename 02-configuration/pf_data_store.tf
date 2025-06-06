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