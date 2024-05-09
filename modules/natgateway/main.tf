# IPs élastiques pour les  NAT Gateway
resource "aws_eip" "natgw" {
  count  = 2
  domain = "vpc"
  tags = {
    Name = "petclinic-natgw_eips-${count.index}"
  }
}

# Passerelles NAT
resource "aws_nat_gateway" "natgw" {
  count         = 2
  allocation_id = aws_eip.natgw[count.index].id
  subnet_id     = var.public_subnet_ids[count.index]
  tags = {
    Name = "petclinic-natgws-${count.index}"
  }
}

# Pour chaque sous-réseau privé, crée la route associant la NAT Gateway et l'extérieur du VPC
resource "aws_route" "route_natgw" {
  count                  = 2
  route_table_id         = var.private_route_table_ids[count.index]
  nat_gateway_id         = aws_nat_gateway.natgw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}