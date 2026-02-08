locals {
  name_prefix = "${var.cluster_name}-${var.environment}"

  tags = merge(
    {
      Project     = var.cluster_name
      Environment = var.environment
      Terraform   = "true"
      Module      = "eks"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# IAM ROLE for EKS Cluster
# ---------------------------------------------------------
resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.name_prefix}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

# ---------------------------------------------------------
# EKS Cluster
# ---------------------------------------------------------
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = local.tags

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_cluster_AmazonEKSServicePolicy
  ]
}

# ---------------------------------------------------------
# IAM ROLE for Node Group
# ---------------------------------------------------------
resource "aws_iam_role" "node_role" {
  name = "${local.name_prefix}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# ---------------------------------------------------------
# Security Group for Nodes
# ---------------------------------------------------------
resource "aws_security_group" "node_sg" {
  name        = "${local.name_prefix}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  tags = merge(local.tags, {
    Name = "${local.name_prefix}-node-sg"
  })
}

# Allow nodes to communicate with each other
resource "aws_security_group_rule" "node_ingress_self" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.node_sg.id
  source_security_group_id = aws_security_group.node_sg.id
}

# Allow nodes to access the cluster API
resource "aws_security_group_rule" "node_to_cluster" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.node_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------------------
# Node Group
# ---------------------------------------------------------
resource "aws_eks_node_group" "this" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.name_prefix}-ng"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    min_size     = var.min_capacity
    max_size     = var.max_capacity
  }

  instance_types = [var.node_instance_type]

  tags = local.tags

  depends_on = [
    aws_eks_cluster.this
  ]
}

# ---------------------------------------------------------
# OIDC Provider (IRSA)
# ---------------------------------------------------------
data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.this.name
}

resource "aws_iam_openid_connect_provider" "oidc" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10e3b"]

  tags = local.tags
}
