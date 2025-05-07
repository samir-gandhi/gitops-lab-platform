terraform {
  required_version = ">= 1.9, < 2.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.15.0, < 3.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32.0, < 3.0.0"
    }
  }
  backend "s3" {}
}

provider "helm" {
  # Configuration options
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  # Configuration options
  config_path = "~/.kube/config"
}
