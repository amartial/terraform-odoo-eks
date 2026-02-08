variable "environment" {
  description = "Environnement (dev, prod)"
  type        = string
}

variable "project" {
  description = "Nom du projet"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets EFS (1 par AZ)"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "eks_security_group_id" {
  description = "Security Group des nodes EKS autorisés à accéder à EFS"
  type        = string
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
