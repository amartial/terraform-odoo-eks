terraform {
  backend "s3" {
    bucket         = "odoo-eks-terraform-backend"
    key            = "terraform-odoo-eks/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "odoo-eks-terraform-lock"
    encrypt        = true
  }
}

locals {
  env = terraform.workspace
}

# ---------------------------------------------------------
# Providers AWS / Kubernetes / Helm
# ---------------------------------------------------------

provider "aws" {
  region = var.aws_region
}

# Providers Kubernetes & Helm alimentés par le module EKS
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = module.eks.cluster_token
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
    token                  = module.eks.cluster_token
  }
}

# ---------------------------------------------------------
# Tags globaux
# ---------------------------------------------------------

locals {
  tags = merge(
    {
      Project     = var.project_name
      Environment = local.env
      Terraform   = "true"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# MODULE : VPC
# ---------------------------------------------------------

module "vpc" {
  source = "../modules/vpc"

  environment = local.env
  project     = var.project_name

  vpc_cidr = var.vpc_cidr
  azs      = var.azs

  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  db_subnets      = var.db_subnets
  efs_subnets     = var.efs_subnets

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : EKS
# ---------------------------------------------------------

module "eks" {
  source = "../modules/eks"

  cluster_name = "${var.project_name}-${local.env}"
  environment  = local.env

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  node_instance_type = var.node_instance_type
  desired_capacity   = var.node_desired_capacity
  min_capacity       = var.node_min_capacity
  max_capacity       = var.node_max_capacity

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : RDS PostgreSQL
# ---------------------------------------------------------

module "rds" {
  source = "../modules/rds"

  environment = local.env
  project     = var.project_name

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  subnet_ids = module.vpc.db_subnet_ids
  vpc_id     = module.vpc.vpc_id

  eks_security_group_id = module.eks.node_sg_id

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : EFS
# ---------------------------------------------------------

module "efs" {
  source = "../modules/efs"

  environment = local.env
  project     = var.project_name

  subnet_ids = module.vpc.efs_subnet_ids
  vpc_id     = module.vpc.vpc_id

  eks_security_group_id = module.eks.node_sg_id

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : ALB Controller (corrigé)
# ---------------------------------------------------------

module "alb_controller" {
  source = "../modules/alb_controller"

  cluster_name = module.eks.cluster_name
  oidc_issuer  = module.eks.oidc_issuer
  vpc_id       = module.vpc.vpc_id

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : IRSA (EFS CSI)
# ---------------------------------------------------------

module "irsa_efs" {
  source = "../modules/irsa"

  name           = "efs-csi"
  namespace      = "kube-system"
  serviceaccount = "efs-csi-controller-sa"

  oidc_issuer = module.eks.oidc_issuer

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  ]

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : ArgoCD
# ---------------------------------------------------------

module "argocd" {
  source = "../modules/argocd"

  cluster_name = module.eks.cluster_name
  environment  = local.env

  tags = local.tags
}

# ---------------------------------------------------------
# MODULE : Namespace Odoo
# ---------------------------------------------------------

module "odoo_namespace" {
  source = "../modules/odoo_namespace"

  namespace = "odoo-${local.env}"

  tags = local.tags
}
