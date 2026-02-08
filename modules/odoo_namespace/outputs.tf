output "namespace_name" {
  description = "Nom du namespace Odoo"
  value       = kubernetes_namespace.odoo.metadata[0].name
}
