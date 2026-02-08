# Module EKS

Ce module crée :

- Un cluster EKS managé
- Un Node Group managé
- Les IAM Roles nécessaires (cluster + nodes)
- Le Security Group des nodes
- Le provider OIDC pour IRSA
- Les outputs nécessaires pour :
  - ALB Controller
  - EFS CSI
  - ArgoCD
  - Providers Kubernetes & Helm

Ce module suit les bonnes pratiques AWS.
