# Module Namespace Odoo

Ce module crée un namespace Kubernetes dédié à Odoo, par exemple :

- `odoo-dev`
- `odoo-prod`

Il applique :
- des labels standards `app.kubernetes.io/*`
- des labels/annotations additionnels si fournis

Ce namespace est la cible naturelle :
- du chart Helm Odoo 18
- des objets Ingress/Service/ConfigMap/Secret liés à Odoo
