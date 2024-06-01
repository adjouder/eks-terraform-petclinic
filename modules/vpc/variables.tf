# varible for the vpc IP range
variable "cidr_vpc" {
  description = "VPC CIDR"
}

variable "availability_zones" {
  description = "Liste les dénomminations des zones de disponibilités sur lesquelles s'étend le VPC."
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

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}
