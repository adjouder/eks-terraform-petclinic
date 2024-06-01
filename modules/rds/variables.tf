variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

# cidr variable for the four subnets
variable "cidr_private_subnets" {
  description = "CIDR des sous-réseaux privés"
  type        = list(string)
}

variable "identifiants" {
  description = "Identifiants  des bases de données."
  type        = list(string)
  default     = ["vet-db", "customer-db", "visit-db"]
}

variable "petclinic_user" {
  description = "Mysql user"
  default     = "petclinic"
}
variable "petclinic_mysql_pwd" {
  description = "Mysql user password"
  default     = "petclinic"
}