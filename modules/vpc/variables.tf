variable "environment" {
  description = "Environnement (dev, prod, ...)"
  type        = string
}

variable "project" {
  description = "Nom du projet"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR du VPC"
  type        = string
}

variable "azs" {
  description = "Liste des AZ utilisées"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDR des subnets publics (par AZ)"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR des subnets privés (App, par AZ)"
  type        = list(string)
}

variable "db_subnets" {
  description = "CIDR des subnets DB"
  type        = list(string)
}

variable "efs_subnets" {
  description = "CIDR des subnets EFS"
  type        = list(string)
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
