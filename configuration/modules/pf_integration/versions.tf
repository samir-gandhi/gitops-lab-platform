terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    pingfederate = {
      source  = "pingidentity/pingfederate"
      version = ">= 1.4.0, < 2.0.0"
    }
  }
}