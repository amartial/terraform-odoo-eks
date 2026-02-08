variable "namespace" {
  description = "Nom du namespace Odoo (ex: odoo-dev, odoo-prod)"
  type        = string
}

variable "labels" {
  description = "Labels additionnels pour le namespace"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations additionnelles pour le namespace"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags logiques (pour cohérence avec le reste du projet)"
  type        = map(string)
  default     = {}
}
