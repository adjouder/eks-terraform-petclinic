resource "aws_db_subnet_group" "petclinic_db_subnet" {
  name       = "petclinic_db_subnet"
  subnet_ids = var.private_subnet_ids
}

resource "aws_db_instance" "db" {
  count                   = 3
  username                = var.petclinic_user
  password                = var.petclinic_mysql_pwd
  db_name                 = "service_instance_db"
  allocated_storage       = 10
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t3.micro"
  identifier              = var.identifiants[count.index]
  parameter_group_name    = "default.mysql5.7"
  db_subnet_group_name    = aws_db_subnet_group.petclinic_db_subnet.name
  vpc_security_group_ids  = [aws_security_group.petclinic_sg_bd.id]
  multi_az                = true
  skip_final_snapshot     = true
  backup_retention_period = 1
  tags = {
    Name = "petclinic-db-${var.identifiants[count.index]}"
  }
}