variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "oidc_issuer" {
  description = "OIDC issuer du cluster EKS (pour IRSA)"
  type        = string
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  type = string
}