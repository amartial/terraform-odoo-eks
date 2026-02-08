locals {
  name_prefix = "${var.cluster_name}-alb-controller"

  tags = merge(
    {
      Project   = var.cluster_name
      Terraform = "true"
      Module    = "alb-controller"
    },
    var.tags
  )
}

# ---------------------------------------------------------
# IAM Role for ALB Controller (IRSA)
# ---------------------------------------------------------
data "aws_iam_policy_document" "alb_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb_role" {
  name               = "${local.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.alb_assume_role.json

  tags = local.tags
}

# ---------------------------------------------------------
# IAM Policy for ALB Controller
# ---------------------------------------------------------
resource "aws_iam_policy" "alb_policy" {
  name        = "${local.name_prefix}-policy"
  description = "IAM policy for AWS Load Balancer Controller"

  policy = file("${path.module}/iam_policy.json")

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "alb_attach" {
  role       = aws_iam_role.alb_role.name
  policy_arn = aws_iam_policy.alb_policy.arn
}

# ---------------------------------------------------------
# OIDC Provider (imported from EKS module)
# ---------------------------------------------------------
resource "aws_iam_openid_connect_provider" "oidc" {
  url = var.oidc_issuer

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0afd10e3b"]

  tags = local.tags
}

# ---------------------------------------------------------
# Helm Chart Installation
# ---------------------------------------------------------
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.1"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "region"
    value = "eu-west-1"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  depends_on = [
    aws_iam_role_policy_attachment.alb_attach
  ]
}

# ---------------------------------------------------------
# ServiceAccount with IRSA annotation
# ---------------------------------------------------------
resource "kubernetes_service_account" "alb_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_role.arn
    }
  }
}
