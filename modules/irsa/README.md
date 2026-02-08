# Module IRSA générique

Ce module crée :

- Un rôle IAM assumable via OIDC (IRSA)
- Les attachements de policies IAM fournies
- Un ServiceAccount Kubernetes annoté avec le rôle IAM

Entrées principales :

- `name` : nom logique (ex: `efs-csi`, `external-dns`)
- `namespace` : namespace Kubernetes
- `serviceaccount` : nom du ServiceAccount
- `oidc_issuer` : issuer OIDC du cluster EKS
- `policy_arns` : liste des ARNs de policies IAM

Exemples d’usage :

- EFS CSI driver
- external-dns
- AWS Load Balancer Controller (si on veut le basculer sur ce module)
