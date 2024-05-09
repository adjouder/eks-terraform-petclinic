variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "les IDs des tables de routage des sous-réseau privé."
  type        = list(any)
}