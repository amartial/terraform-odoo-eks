output "efs_id" {
  description = "ID du File System EFS"
  value       = aws_efs_file_system.this.id
}

output "efs_dns_name" {
  description = "DNS EFS"
  value       = aws_efs_file_system.this.dns_name
}

output "efs_access_point" {
  description = "Access Point EFS pour Odoo"
  value       = aws_efs_access_point.odoo.id
}

output "efs_sg_id" {
  description = "Security Group EFS"
  value       = aws_security_group.efs_sg.id
}
