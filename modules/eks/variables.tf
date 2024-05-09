variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "workernodes_iam_role_arn" {
  description = "Nom de la ressource correspondant aux rôles IAM pour les noeuds workers."
  type        = string
}

variable "amazon_eks_worker_node_role_policy_attachment" {
  description = ""
  type        = any
}

variable "amazon_eks_cni_role_policy_attachment" {
  description = ""
  type        = any
}

variable "amazon_ec2_container_registry_read_only_role_policy_attachment" {
  description = ""
  type        = any
}

variable "aws_certificate_manager_read_only_eks_role_policy_attachment" {
  description = ""
  type        = any
}