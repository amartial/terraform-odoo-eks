variable "name" {
  description = "Nom logique de l'IRSA (ex: efs-csi, external-dns)"
  type        = string
}

variable "namespace" {
  description = "Namespace Kubernetes du ServiceAccount"
  type        = string
}

variable "serviceaccount" {
  description = "Nom du ServiceAccount Kubernetes"
  type        = string
}

variable "oidc_issuer" {
  description = "OIDC issuer du cluster EKS"
  type        = string
}

variable "policy_arns" {
  description = "Liste des ARNs de policies IAM à attacher au rôle"
  type        = list(string)
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
