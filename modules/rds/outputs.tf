
output "vet_db_password" {
  description = "Mot de pass pour instance vet-db"
  value       = aws_db_instance.db[0].password
}

output "customer_db_password" {
  description = "Mot de pass pour instance customer-db"
  value       = aws_db_instance.db[1].password
}

output "visit_db_password" {
  description = "Mot de pass pour instance visit-db"
  value       = aws_db_instance.db[2].password
}


output "vet_db_endpoint" {
  description = "Point de terminaison  pour vet-db instance"
  value       = aws_db_instance.db[0].endpoint
}

output "visit_db_endpoint" {
  description = "Point de terminaison  pour visit-db instance"
  value       = aws_db_instance.db[2].endpoint
}


output "customer_db_endpoint" {
  description = "Point de terminaison  pour customer-db instance"
  value       = aws_db_instance.db[1].endpoint
}


