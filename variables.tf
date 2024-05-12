variable "aws_account_id" {
  description = "ID du compte AWS, utilisé pour créer le role IAM de l'AWS Load Balancer Controller dans le cluster Kubernetes."
  type        = string
}

# VPC

variable "cidr_vpc" {
  description = "VPC CIDR"
  type        = string
}

variable "availability_zones" {
  description = "Liste des zones de disponibilités sur lesquelles s'étend le VPC."
  type        = list(string)
}

variable "cidr_public_subnets" {
  description = "CIDR des sous-réseaux publics"
  type        = list(string)
}

variable "cidr_private_subnets" {
  description = "CIDR des sous-réseaux publics"
  type        = list(string)
}

# DB

variable "petclinic_user" {
  description = "Mysql user"
  type        = string
}

variable "petclinic_mysql_pwd" {
  description = "Mysql user password"
  type        = string
}

# EKS

variable "cluster_name" {
  description = "Nom du cluster EKS"
  type        = string
}
variable "access_key" {
  description = "the aws access key"
  type        = string
}
variable "secret_key" {
  description = "the aws secret key"
  type        = string
}

variable "sns_topic_arn" {
  default = ""
}