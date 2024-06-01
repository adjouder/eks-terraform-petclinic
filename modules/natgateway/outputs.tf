output "nat_gateway_0" {
  value = [aws_eip.natgw[0].public_ip, aws_eip.natgw[0].public_dns]
}

output "nat_gateway_1" {
  value = [aws_eip.natgw[1].public_ip, aws_eip.natgw[1].public_dns]
}