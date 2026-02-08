output "alb_role_arn" {
  description = "ARN du rôle IAM utilisé par le ALB Controller"
  value       = aws_iam_role.alb_role.arn
}

output "alb_policy_arn" {
  description = "ARN de la policy IAM du ALB Controller"
  value       = aws_iam_policy.alb_policy.arn
}
