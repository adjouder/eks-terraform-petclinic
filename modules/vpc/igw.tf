# internet gateway du vpc
resource "aws_internet_gateway" "petclinic_igw" {
  vpc_id = aws_vpc.petclinic_vpc.id
  depends_on = [
    aws_vpc.petclinic_vpc,
  ]

  tags = {
    Name = "petclinic-igw"
  }
}

# route to the igw
resource "aws_route" "route_igw" {
  count                  = 2
  route_table_id         = aws_route_table.public_rts[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.petclinic_igw.id
}