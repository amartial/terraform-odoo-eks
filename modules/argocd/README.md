# Module ArgoCD

Ce module installe ArgoCD via Helm dans un namespace dédié.

Il crée :
- Le namespace `argocd`
- Le chart Helm ArgoCD (version stable)
- Une configuration minimale compatible EKS

ArgoCD sera ensuite utilisé pour :
- Déployer Odoo 18
- Gérer les charts Helm
- Assurer le GitOps complet de la plateforme
