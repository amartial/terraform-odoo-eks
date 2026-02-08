# Module ALB Controller

Ce module installe :

- Le AWS Load Balancer Controller via Helm
- Le rôle IAM IRSA associé
- La policy IAM officielle AWS
- Le ServiceAccount annoté
- L’OIDC provider (si non existant)

Ce module permet à Kubernetes de créer automatiquement :
- ALB (Application Load Balancers)
- Target Groups
- Listeners
- Security Groups

Indispensable pour exposer Odoo via Ingress.
