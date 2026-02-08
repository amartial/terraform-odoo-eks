variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}

variable "environment" {
  description = "Environnement (dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID du VPC"
  type        = string
}

variable "subnet_ids" {
  description = "Liste des subnets privés pour EKS"
  type        = list(string)
}

variable "node_instance_type" {
  description = "Type d'instance EC2 pour les nodes"
  type        = string
}

variable "desired_capacity" {
  description = "Nombre de nodes désirés"
  type        = number
}

variable "min_capacity" {
  description = "Nombre minimum de nodes"
  type        = number
}

variable "max_capacity" {
  description = "Nombre maximum de nodes"
  type        = number
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}
