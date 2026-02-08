locals {
  project_name = var.project_name
  environment  = terraform.workspace

  common_tags = merge(
    {
      Project     = local.project_name
      Environment = local.environment
      Terraform   = "true"
    },
    var.tags
  )
}
