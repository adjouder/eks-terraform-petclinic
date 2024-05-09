output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = var.cluster_name
}

data "aws_region" "current" {}

output "region" {
  description = "The AWS region in use"
  value       = data.aws_region.current.name
}

output "vet_db_endpoint_main" {
  value = module.rds.vet_db_endpoint
}

output "customer_db_endpoint_main" {
  value = module.rds.customer_db_endpoint
}

output "visit_db_endpoint_main" {
  value = module.rds.visit_db_endpoint
}

output "vet_db_password_main" {
  value = module.rds.vet_db_password
  sensitive = true
}

output "customer_db_password_main" {
  value = module.rds.customer_db_password
  sensitive = true
}

output "visit_db_password_main" {
  value = module.rds.visit_db_password
  sensitive = true
}
