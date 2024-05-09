output "public_subnet_ids" {
  value = [aws_subnet.public_subnets[0].id, aws_subnet.public_subnets[1].id]
}

output "private_subnet_ids" {
  value = [aws_subnet.private_subnets[0].id, aws_subnet.private_subnets[1].id]
}

output "private_route_table_ids" {
  value = [aws_route_table.private_rts[0].id, aws_route_table.private_rts[1].id]
}

output "vpc_id" {
  value = aws_vpc.petclinic_vpc.id
}
