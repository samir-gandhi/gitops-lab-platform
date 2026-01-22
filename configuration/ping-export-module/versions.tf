terraform {
  required_version = ">= 1.3"

  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = ">= 1.0.0"
    }
  }
}
