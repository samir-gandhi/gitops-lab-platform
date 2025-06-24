# import {
#   to = helm_release.ping_devops
#   id = format("%s/%s", local.k8s_deployment_namespace, var.k8s_helm_deployment_name)
# }

resource "helm_release" "ping_devops" {
  name      = var.k8s_helm_deployment_name
  namespace = kubernetes_namespace_v1.gitops-lab.metadata[0].name
  # cleanup_on_fail = var.k8s_helm_deployment_name == "prod" || var.k8s_helm_deployment_name == "qa" ? false : true
  timeout = 360

  repository = "https://helm.pingidentity.com"
  chart      = "ping-devops"
  version    = var.ping_devops_chart_version

  ## TODO: add values.dev.yaml, or put dev settings via set
  values = [
    file("values.yaml")
  ]

  set {
    name  = "pingfederate-admin.workload.annotations.server-profile-sha-1"
    value = sha1(join("", [for f in fileset(path.module, "../server-profiles/pingfederate/**") : f != "server-profiles/pingfederate/README.md" ? filesha1(f) : ""]))
  }

  set {
    name  = "pingfederate-engine.workload.annotations.server-profile-sha-1"
    value = sha1(join("", [for f in fileset(path.module, "../server-profiles/pingfederate/**") : f != "server-profiles/pingfederate/README.md" ? filesha1(f) : ""]))
  }

  set {
    name  = "pingdirectory.workload.annotations.server-profile-sha-1"
    value = sha1(join("", [for f in fileset(path.module, "../server-profiles/pingdirectory/**") : f != "server-profiles/pingdirectory/README.md" ? filesha1(f) : ""]))
  }

  set {
    name  = "pingfederate-admin.envs.SERVER_PROFILE_BRANCH"
    value = var.k8s_helm_deployment_name
  }

  set {
    name  = "pingfederate-admin.envs.PING_IDENTITY_PASSWORD"
    value = var.pingfederate_api_password
  }

  set {
    name  = "pingfederate-engine.envs.SERVER_PROFILE_BRANCH"
    value = var.k8s_helm_deployment_name
  }

  set {
    name  = "pingdirectory.envs.PING_IDENTITY_PASSWORD"
    value = var.pingfederate_api_password
  }

  set {
    name  = "pingdirectory.envs.SERVER_PROFILE_BRANCH"
    value = var.k8s_helm_deployment_name
  }
  
  set {
    name  = "pingdataconsole.envs.SERVER_PROFILE_BRANCH"
    value = var.k8s_helm_deployment_name
  }

  set {
    name  = "pingfederate-admin.envs.CREATE_INITIAL_ADMIN_USER"
    value = "true"
    type  = "string"
  }

  set {
    name  = "pingfederate-admin.envs.PING_IDENTITY_PASSWORD"
    value = var.pingfederate_api_password
  }

  set {
    name  = "pingdirectory.enabled"
    value = var.pingdirectory_enabled
  }

  set {
    name  = "pingdataconsole.enabled"
    value = var.pingdirectory_enabled
  }
  depends_on = [kubernetes_secret_v1.ping_devops]
}