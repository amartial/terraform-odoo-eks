# Module VPC

Ce module crée :

- 1 VPC
- 1 Internet Gateway
- 1 NAT Gateway (dans le premier subnet public)
- Subnets :
  - Publics (1 par AZ)
  - Privés App/EKS (1 par AZ)
  - DB (1 par AZ)
  - EFS (1 par AZ)
- Route tables et associations

Les IDs de subnets sont exposés pour être consommés par :
- EKS (subnets privés)
- RDS (subnets DB)
- EFS (subnets EFS)
- ALB (subnets publics)
