output "pingone_environment_information" {
  value = {
    environment_name = pingone_environment.target_environment.name
    environment_id   = pingone_environment.target_environment.id
  }
}

# output "sample_user_response" {
#   value = data.http.create_demo_user.response_body
# }