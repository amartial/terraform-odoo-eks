variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "environment" {
  description = "Environnement (dev, prod)"
  type        = string
}

variable "namespace" {
  description = "Namespace ArgoCD"
  type        = string
  default     = "argocd"
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
