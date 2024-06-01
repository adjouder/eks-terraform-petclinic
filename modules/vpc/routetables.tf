# table de routage des sous-réseaux public
resource "aws_route_table" "public_rts" {
  count  = 2
  vpc_id = aws_vpc.petclinic_vpc.id
  depends_on = [
    aws_vpc.petclinic_vpc,
    aws_subnet.public_subnets,
  ]

  tags = {
    Name = "petclinic-public_rts-${count.index}"
  }
}

# Association des tables de routage et sous-réseaux publics correspondant pour les deux AZ
resource "aws_route_table_association" "public_rt_public_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rts[count.index].id
}

# Table de routage des sous-réseaux privés
resource "aws_route_table" "private_rts" {
  count  = 2
  vpc_id = aws_vpc.petclinic_vpc.id
  depends_on = [
    aws_vpc.petclinic_vpc,
    aws_subnet.private_subnets,
  ]

  tags = {
    Name = "petclinic-private_rts-${count.index}"
  }
}

# Associatation des tables de routage et sous-réseaux privés pour les deux AZ
resource "aws_route_table_association" "private_rt_private_subnet_association" {
  count          = 2
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_rts[count.index].id
}
