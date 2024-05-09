# create a virtual private cloud
resource "aws_vpc" "petclinic_vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "petclinic-vpc"
  }
}

# private subnets
resource "aws_subnet" "private_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.petclinic_vpc.id
  map_public_ip_on_launch = "false"
  cidr_block              = var.cidr_private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  depends_on = [
    aws_vpc.petclinic_vpc,
  ]

  tags = {
    Name                                        = "petclinic-private_subnets-${count.index}"
    "kubernetes.io/role/internal-elb"           = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

# public subnets
resource "aws_subnet" "public_subnets" {
  count                   = 2
  vpc_id                  = aws_vpc.petclinic_vpc.id
  map_public_ip_on_launch = "true"
  cidr_block              = var.cidr_public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  depends_on = [
    aws_vpc.petclinic_vpc,
  ]
  tags = {
    Name                                        = "petclinic-public_subnets-${count.index}"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

