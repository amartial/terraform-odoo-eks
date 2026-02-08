variable "aws_region" {
  description = "Région AWS pour le backend Terraform"
  type        = string
  default     = "eu-west-1"
}

variable "backend_bucket_name" {
  description = "Nom du bucket S3 pour stocker le state Terraform"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour le verrouillage du state Terraform"
  type        = string
}

variable "environment" {
  description = "Environnement logique (dev, prod, ...)"
  type        = string
}

variable "project_name" {
  description = "Nom du projet (ex: odoo-eks)"
  type        = string
}

variable "tags" {
  description = "Tags additionnels à appliquer aux ressources backend"
  type        = map(string)
  default     = {}
}
