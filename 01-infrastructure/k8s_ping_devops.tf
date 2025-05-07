resource "kubernetes_namespace_v1" "gitops-lab" {
  metadata {
    name = local.k8s_deployment_namespace
  }
}

resource "kubernetes_secret_v1" "ping_devops" {
  metadata {
    name = "devops-secret"
    namespace = kubernetes_namespace_v1.gitops-lab.metadata[0].name
  }

  data = {
    PING_IDENTITY_DEVOPS_KEY = var.ping_identity_devops_key
    PING_IDENTITY_DEVOPS_USER = var.ping_identity_devops_user
  }

  type = "Opaque"
}