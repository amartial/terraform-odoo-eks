output "backend_bucket_name" {
  description = "Nom du bucket S3 utilisé pour le state Terraform"
  value       = aws_s3_bucket.tf_state.id
}

output "backend_bucket_arn" {
  description = "ARN du bucket S3 utilisé pour le state Terraform"
  value       = aws_s3_bucket.tf_state.arn
}

output "dynamodb_table_name" {
  description = "Nom de la table DynamoDB utilisée pour le verrouillage du state"
  value       = aws_dynamodb_table.tf_lock.name
}
