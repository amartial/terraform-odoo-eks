variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "oidc_issuer" {
  description = "OIDC issuer du cluster EKS (pour IRSA)"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC dans lequel ALB Controller opérera"
  type        = string
}

### CHANGED — nouvelle variable obligatoire
variable "aws_region" {
  description = "Région AWS dans laquelle tourne le cluster"
  type        = string
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
