locals {
  name_prefix = "irsa-${var.name}"

  tags = merge(
    {
      Terraform = "true"
      Module    = "irsa"
      IRSA      = var.name
    },
    var.tags
  )
}

# ---------------------------------------------------------
# OIDC Provider (référence via issuer)
# ---------------------------------------------------------
data "aws_iam_openid_connect_provider" "oidc" {
  url = var.oidc_issuer
}

# ---------------------------------------------------------
# Assume Role Policy pour IRSA
# ---------------------------------------------------------
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.oidc.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "${replace(var.oidc_issuer, "https://", "")}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.serviceaccount}"]
    }
  }
}

# ---------------------------------------------------------
# IAM Role pour le ServiceAccount
# ---------------------------------------------------------
resource "aws_iam_role" "this" {
  name               = "${local.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = local.tags
}

# Attachement des policies fournies
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each = toset(var.policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

# ---------------------------------------------------------
# ServiceAccount Kubernetes annoté
# ---------------------------------------------------------
resource "kubernetes_service_account" "this" {
  metadata {
    name      = var.serviceaccount
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.this.arn
    }
  }
}
