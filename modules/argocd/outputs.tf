output "argocd_namespace" {
  description = "Namespace ArgoCD"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_release_name" {
  description = "Nom du release Helm ArgoCD"
  value       = helm_release.argocd.name
}
