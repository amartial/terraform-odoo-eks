variable "environment" {
  description = "Environnement (dev, prod)"
  type        = string
}

variable "project" {
  description = "Nom du projet"
  type        = string
}

variable "db_name" {
  description = "Nom de la base PostgreSQL"
  type        = string
}

variable "db_username" {
  description = "Utilisateur PostgreSQL"
  type        = string
}

variable "db_password" {
  description = "Mot de passe PostgreSQL"
  type        = string
  sensitive   = true
}

variable "subnet_ids" {
  description = "Subnets DB"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "eks_security_group_id" {
  description = "Security Group des nodes EKS autorisés à accéder à PostgreSQL"
  type        = string
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
