locals {
  base_labels = merge(
    {
      "app.kubernetes.io/name"      = "odoo"
      "app.kubernetes.io/instance"  = var.namespace
      "app.kubernetes.io/part-of"   = "odoo-platform"
    },
    var.labels
  )

  base_annotations = var.annotations
}

resource "kubernetes_namespace" "odoo" {
  metadata {
    name = var.namespace

    labels      = local.base_labels
    annotations = local.base_annotations
  }
}
