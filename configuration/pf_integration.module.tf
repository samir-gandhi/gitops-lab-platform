module "pf_integration" {
  count  = var.enable_infrastructure_integration ? 1 : 0
  source = "./modules/pf_integration"
  # Pass-through variables can be added here as needed
  pingone_environment_name           = var.pingone_environment_name
  tf_state_key_prefix_infrastructure = "infrastructure-state"
  tf_state_bucket                    = var.tf_state_bucket
  tf_state_region                    = var.tf_state_region
}