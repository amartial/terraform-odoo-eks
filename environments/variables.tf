variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "odoo-eks"
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}

# -------------------------------
# VPC
# -------------------------------
variable "vpc_cidr" {
  type        = string
  description = "CIDR du VPC"
}

variable "azs" {
  type        = list(string)
  description = "Liste des AZ"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR des subnets publics"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR des subnets privés"
}

variable "db_subnets" {
  type        = list(string)
  description = "CIDR des subnets DB"
}

variable "efs_subnets" {
  type        = list(string)
  description = "CIDR des subnets EFS"
}

# -------------------------------
# EKS
# -------------------------------
variable "node_instance_type" {
  type        = string
  description = "Type d'instance des nodes EKS"
}

variable "node_desired_capacity" {
  type        = number
}

variable "node_min_capacity" {
  type        = number
}

variable "node_max_capacity" {
  type        = number
}

# -------------------------------
# RDS
# -------------------------------
variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
