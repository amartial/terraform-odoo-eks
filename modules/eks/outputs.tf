output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = data.aws_eks_cluster.cluster.endpoint
}

output "cluster_ca" {
  value = data.aws_eks_cluster.cluster.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.cluster.token
}

output "node_sg_id" {
  value = aws_security_group.node_sg.id
}

output "oidc_issuer" {
  value = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}
