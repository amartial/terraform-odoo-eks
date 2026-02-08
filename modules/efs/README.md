# Module EFS

Ce module crée :

- Un File System EFS chiffré
- Un Security Group dédié
- Une règle autorisant uniquement les nodes EKS à accéder à EFS (port 2049)
- Un Mount Target dans chaque AZ
- Un Access Point optimisé pour Odoo (UID/GID 1000)
- Les outputs nécessaires pour le CSI driver et Helm chart Odoo

Ce module est conçu pour la haute disponibilité et la compatibilité EKS.
