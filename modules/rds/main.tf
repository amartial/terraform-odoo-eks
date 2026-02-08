locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      Terraform   = "true"
      Module      = "rds"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# Security Group RDS
# ---------------------------------------------------------
resource "aws_security_group" "rds_sg" {
  name        = "${local.name_prefix}-rds-sg"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-rds-sg"
  })
}

# Autoriser EKS à accéder à PostgreSQL
resource "aws_security_group_rule" "eks_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.eks_security_group_id
}

# ---------------------------------------------------------
# Subnet Group
# ---------------------------------------------------------
resource "aws_db_subnet_group" "this" {
  name       = "${local.name_prefix}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-db-subnet-group"
  })
}

# ---------------------------------------------------------
# Parameter Group
# ---------------------------------------------------------
resource "aws_db_parameter_group" "this" {
  name        = "${local.name_prefix}-pg"
  family      = "postgres15"
  description = "Parameter group for PostgreSQL"

  # Paramètres optimisés pour Odoo
  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "shared_buffers"
    value = "256MB"
  }

  tags = local.tags
}

# ---------------------------------------------------------
# RDS PostgreSQL Multi-AZ
# ---------------------------------------------------------
resource "aws_db_instance" "this" {
  identifier = "${local.name_prefix}-postgres"

  engine               = "postgres"
  engine_version       = "15.5"
  instance_class       = "db.t3.medium"
  allocated_storage    = 50
  max_allocated_storage = 200

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  multi_az               = true
  storage_encrypted      = true
  skip_final_snapshot    = true
  deletion_protection    = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  parameter_group_name   = aws_db_parameter_group.this.name

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-postgres"
  })
}
