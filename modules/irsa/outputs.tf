output "role_arn" {
  description = "ARN du rôle IAM associé au ServiceAccount"
  value       = aws_iam_role.this.arn
}

output "service_account_name" {
  description = "Nom du ServiceAccount Kubernetes"
  value       = kubernetes_service_account.this.metadata[0].name
}

output "service_account_namespace" {
  description = "Namespace du ServiceAccount Kubernetes"
  value       = kubernetes_service_account.this.metadata[0].namespace
}
