terraform {
  required_version = ">= 1.6.0"
  required_providers {
    pingone = {
      source  = "pingidentity/pingone"
      version = ">= 1.3.0, < 2.0.0"
    }
    davinci = {
      source  = "pingidentity/davinci"
      version = ">= 0.5.0, < 1.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.5"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.35.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.18.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }
  }
  backend "s3" {}
}