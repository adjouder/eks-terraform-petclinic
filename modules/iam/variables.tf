variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "oidc_issuer_url" {
  description = "The OIDC issuer URL for the EKS cluster"
  type        = string
}

variable "aws_account_id" {
  description = "ID du compte AWS."
  type        = string
}
