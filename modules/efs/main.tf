locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      Terraform   = "true"
      Module      = "efs"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# Security Group EFS
# ---------------------------------------------------------
resource "aws_security_group" "efs_sg" {
  name        = "${local.name_prefix}-efs-sg"
  description = "Security group for EFS"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-efs-sg"
  })
}

# Autoriser EKS à accéder à EFS (NFS 2049)
resource "aws_security_group_rule" "eks_to_efs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = var.eks_security_group_id
}

# ---------------------------------------------------------
# EFS File System
# ---------------------------------------------------------
resource "aws_efs_file_system" "this" {
  creation_token = "${local.name_prefix}-efs"

  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-efs"
  })
}

# ---------------------------------------------------------
# Mount Targets (1 par AZ)
# ---------------------------------------------------------
resource "aws_efs_mount_target" "mt" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}

# ---------------------------------------------------------
# Access Point (optionnel mais recommandé pour Odoo)
# ---------------------------------------------------------
resource "aws_efs_access_point" "odoo" {
  file_system_id = aws_efs_file_system.this.id

  posix_user {
    uid = 1000
    gid = 1000
  }

  root_directory {
    path = "/odoo"
    creation_info {
      owner_uid   = 1000
      owner_gid   = 1000
      permissions = "0755"
    }
  }

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-efs-ap-odoo"
  })
}
