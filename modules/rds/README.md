# Module RDS PostgreSQL

Ce module crée :

- Un Security Group RDS
- Une règle autorisant uniquement les nodes EKS à accéder à PostgreSQL
- Un Subnet Group (DB subnets)
- Un Parameter Group optimisé pour Odoo
- Une instance RDS PostgreSQL Multi-AZ
- Les outputs nécessaires pour Odoo et Helm

Ce module est conçu pour la haute disponibilité et la sécurité.
