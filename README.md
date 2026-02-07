# terraform-odoo-eks
Infrastructure as Code (IaC) pour déployer Odoo 18 en haute disponibilité sur AWS EKS.  Ce projet fournit une architecture cloud complète, modulaire et reproductible basée sur Terraform, Kubernetes et GitOps.

Il déploie automatiquement :

un VPC multi‑AZ

un cluster EKS managé

une base PostgreSQL RDS Multi‑AZ

un stockage partagé EFS pour le filestore Odoo

le AWS Load Balancer Controller

ArgoCD pour le GitOps

les rôles IRSA nécessaires

les namespaces applicatifs

L’objectif est d’offrir une plateforme robuste, scalable et maintenable pour exécuter Odoo 18 en production sur AWS.
