locals {
  name_prefix = "${var.cluster_name}-${var.environment}-argocd"

  tags = merge(
    {
      Project     = var.cluster_name
      Environment = var.environment
      Terraform   = "true"
      Module      = "argocd"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# Namespace ArgoCD
# ---------------------------------------------------------
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/name" = "argocd"
    }
  }
}

# ---------------------------------------------------------
# Helm Chart ArgoCD
# ---------------------------------------------------------
resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "6.7.2"

  # Configuration recommandée pour EKS
  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "configs.params.server.insecure"
    value = "true"
  }

  set {
    name  = "controller.enableStatefulSet"
    value = "false"
  }

  set {
    name  = "redis-ha.enabled"
    value = "false"
  }

  set {
    name  = "dex.enabled"
    value = "false"
  }

  depends_on = [
    kubernetes_namespace.argocd
  ]
}
