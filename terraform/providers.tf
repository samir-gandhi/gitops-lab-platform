provider "pingone" {
  client_id      = var.pingone_client_id
  client_secret  = var.pingone_client_secret
  environment_id = var.pingone_client_environment_id
  region_code    = var.pingone_client_region_code

  global_options {
    population {
      // This option should not be used in environments that contain production data.  Data loss may occur.
      contains_users_force_delete = var.pingone_force_delete_population
    }
  }
}

provider "http" {
}