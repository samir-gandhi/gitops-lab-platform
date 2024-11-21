terraform {
  required_version = ">= 1.6.0"
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = "~> 1.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
  }
  backend "s3" {}
}