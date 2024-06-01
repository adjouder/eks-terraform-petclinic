variable "database_identifier" {
  description = "Identifiants  des bases de données."
  type        = list(string)
  default     = ["vet-db", "customer-db", "visit-db"]
}

variable "region" {
  description = "The region of AWS"
  type        = string
  default = "eu-west-3"
}
variable "cluster_name" {
  default = "spring-petclinic"
}


variable "create_alarms" {
  description = "If set to false, do not create any alarms"
  type        = bool
  default     = true
}

# -- Variables for storage alerts --

variable "database_storage" {
  description = "Instance storage in GB"
  default = 1
}

variable "create_storage_80_alert" {
  description = "If set to true, create an storage alert for 80% utilization"
  type        = bool
  default     = true
}


# -- Variables for connection count alerts --

variable "max_connection_count" {
  description = "Max connection count based on db param group and DBInstanceClassMemory"
  default = 2
}

variable "create_connection_count_80_alert" {
  description = "If set to true, create an alert for 85% connection count utilization"
  type        = bool
  default     = true
}


# -- Variables for status alerts --
variable "create_rds_dd_status" {
  description = "Alert for instance status"
  type        = bool
  default     = true
}
variable "email" {
  type = string
  default = ""
}

variable "eks_logs_name" {
  type = string
  default = "eks-logs"
}

variable "sns_topic_arn" {
  type = string
  default = ""
}