provider "aws" {
  region = var.aws_region
}

provider "kubernetes" {
  host                   = var.kube_host
  cluster_ca_certificate = base64decode(var.kube_ca)
  token                  = var.kube_token
}

provider "helm" {
  kubernetes {
    host                   = var.kube_host
    cluster_ca_certificate = base64decode(var.kube_ca)
    token                  = var.kube_token
  }
}

variable "aws_region" {
  description = "Région AWS"
  type        = string
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "tags" {
  description = "Tags additionnels"
  type        = map(string)
  default     = {}
}

# Variables pour le provider Kubernetes/Helm
variable "kube_host" {
  description = "Endpoint du cluster Kubernetes"
  type        = string
  default     = ""
}

variable "kube_ca" {
  description = "Certificat CA du cluster Kubernetes"
  type        = string
  default     = ""
}

variable "kube_token" {
  description = "Token d'accès au cluster Kubernetes"
  type        = string
  default     = ""
}
