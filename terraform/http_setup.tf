# # # Terraform HTTP provider
# # # {@link https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http}

# ##############################################
# # Get PingOne Worker App Token
# ##############################################

# data "http" "get_token" {
#   url    = module.pingone_utils.pingone_environment_token_endpoint
#   method = "POST"
#   depends_on = [
#     pingone_application_role_assignment.population_identity_data_admin_to_application
#   ]

#   # Optional request headers
#   request_headers = {
#     Content-Type  = "application/x-www-form-urlencoded",
#     Authorization = "Basic ${base64encode("${pingone_application.worker_app.oidc_options.client_id}:${pingone_application_secret.worker_app.secret}")}"
#   }

#   # Optional request body
#   request_body = "grant_type=client_credentials"
# }

# # Create PingOne User
# # {@link https://apidocs.pingidentity.com/pingone/platform/v1/api/#post-create-user-import}

# data "http" "create_demo_user" {
#   url    = "${module.pingone_utils.pingone_url_api_path_v1}/environments/${pingone_environment.target_environment.id}/users"
#   method = "POST"

#   # Optional request headers
#   request_headers = {
#     Accept        = "application/json",
#     Content-Type  = "application/vnd.pingidentity.user.import+json",
#     Authorization = "Bearer ${local.access_token}",
#   }

#   # Optional request body"
#   request_body = "{\"email\":\"demouser1@mailinator.com\",\"name\":{\"given\": \"Demo\",\"family\":\"User\"},\"username\":\"demouser1\",\"population\":{\"id\":\"${pingone_population_default.sample_users.id}\"},\"lifecycle\":{\"status\":\"ACCOUNT_OK\"},\"password\":{\"value\":\"2FederateM0re!\",\"forceChange\": false}}"
# }