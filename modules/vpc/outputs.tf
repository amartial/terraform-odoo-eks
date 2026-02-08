output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs des subnets publics"
  value       = [for s in aws_subnet.public : s.id]
}

output "private_subnet_ids" {
  description = "IDs des subnets privés (App/EKS)"
  value       = [for s in aws_subnet.private : s.id]
}

output "db_subnet_ids" {
  description = "IDs des subnets DB"
  value       = [for s in aws_subnet.db : s.id]
}

output "efs_subnet_ids" {
  description = "IDs des subnets EFS"
  value       = [for s in aws_subnet.efs : s.id]
}
