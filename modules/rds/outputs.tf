output "rds_endpoint" {
  description = "Endpoint PostgreSQL"
  value       = aws_db_instance.this.address
}

output "rds_port" {
  description = "Port PostgreSQL"
  value       = aws_db_instance.this.port
}

output "rds_sg_id" {
  description = "Security Group RDS"
  value       = aws_security_group.rds_sg.id
}
