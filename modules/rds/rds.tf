resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.main.id
  vpc_security_group_ids = [var.security_group_id]

  tags = {
    Name = "SourceRDS"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = var.subnet_ids
}

