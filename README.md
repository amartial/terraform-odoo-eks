# Odoo 18 on AWS EKS — Infrastructure as Code (Terraform)

Ce repository contient l’infrastructure complète permettant de déployer **Odoo 18** en haute disponibilité sur **AWS EKS**, en utilisant :

- **Terraform** (IaC)
- **AWS EKS** (Kubernetes managé)
- **RDS PostgreSQL** (base de données)
- **EFS** (filestore partagé)
- **AWS Load Balancer Controller** (Ingress ALB)
- **ArgoCD** (GitOps)
- **IRSA** (IAM Roles for Service Accounts)

L’architecture est entièrement modulaire, reproductible et adaptée aux environnements **dev** et **prod** via les workspaces Terraform.

---

## 🏗️ Architecture globale

L’infrastructure déployée comprend :

### Réseau (module `vpc`)
- VPC dédié
- Subnets publics / privés / DB / EFS
- NAT Gateway
- Route tables

### Kubernetes (module `eks`)
- Cluster EKS managé
- Node Group autoscalable
- OIDC provider (IRSA)
- Security Groups

### Base de données (module `rds`)
- PostgreSQL 15 Multi‑AZ
- Parameter group optimisé pour Odoo
- Accès sécurisé depuis EKS uniquement

### Stockage (module `efs`)
- EFS chiffré
- Mount targets multi‑AZ
- Access Point pour Odoo

### Contrôleurs Kubernetes
- AWS Load Balancer Controller (Ingress ALB)
- IRSA générique pour EFS CSI, external-dns, etc.
- ArgoCD (GitOps)

### Namespaces applicatifs
- `argocd`
- `odoo-dev` / `odoo-prod`

---

## 📁 Structure du repository

├── backend/               # Backend Terraform (S3 + DynamoDB)
│   ├── backend.tf
│   ├── variables.tf
│   └── backend.tfvars
│
├── global/                # Providers, versions, locals
│   ├── providers.tf
│   ├── versions.tf
│   └── locals.tf
│
├── modules/               # Modules Terraform
│   ├── vpc/
│   ├── eks/
│   ├── rds/
│   ├── efs/
│   ├── alb_controller/
│   ├── irsa/
│   ├── argocd/
│   └── odoo_namespace/
│
└── environments/          # Environnements dev/prod
├── main.tf
├── variables.tf
├── dev.tfvars
└── prod.tfvar



---

## 🚀 Déploiement

### 1️⃣ Déployer le backend Terraform (une seule fois)

```bash
cd backend
terraform init
terraform apply -var-file=backend.tfvars -auto-approve


2 - Initialiser l'environnement

cd ../environments
terraform init
terraform workspace new dev
terraform workspace select dev


3 - Déployer l'infrastructure complete

terraform apply -var-file=dev.tfvars -auto-approve


🧩 Ce que Terraform déploie automatiquement
  - VPC complet multi‑AZ

  - Cluster EKS opérationnel

  - RDS PostgreSQL Multi‑AZ

  - EFS + Access Point

  - ALB Controller

  - IRSA pour EFS CSI

  - ArgoCD

  - Namespace Odoo

L’infrastructure est alors prête à recevoir Odoo via Helm/ArgoCD.


📦 Déploiement d’Odoo (via ArgoCD)

Une fois l’infra déployée :

  1 - Créer un repository Git contenant le chart Helm Odoo 18

  2 - Ajouter un manifest ArgoCD Application pointant vers ce repo

  3 - ArgoCD synchronise automatiquement Odoo sur EKS


🔐 Sécurité

  - IAM Roles for Service Accounts (IRSA)

  - RDS chiffré + Multi‑AZ

  - EFS chiffré

  - SG restrictifs (EKS → RDS/EFS uniquement)

  - S3 backend chiffré + versionné

  - Aucun secret en clair dans Terraform (utiliser AWS Secrets Manager si nécessaire)


🛠️ Prérequis

  - Terraform ≥ 1.5

  - AWS CLI configuré

  - kubectl

  - helm

  - Un compte AWS avec permissions administrateur


  👤 Auteur

Infrastructure conçue et maintenue par Alain Martial MBE DEFOKOU  
Cloud Architect & DevOps Engineer
