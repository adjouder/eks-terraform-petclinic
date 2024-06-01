#Security group pour mysql
resource "aws_security_group" "petclinic_sg_bd" {
  name   = "petclinic_sg_bd"
  vpc_id = var.vpc_id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.cidr_private_subnets[0], var.cidr_private_subnets[1]]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "petclinic_sg_bd"
  }
}