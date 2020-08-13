resource "aws_db_instance" "default" {
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.name
  username               = var.username
  password               = var.password
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  tags = {
    Name = "wahaj-db-${terraform.workspace}"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description     = "incoming for ec2-instance"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg-${terraform.workspace}"
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "main-${terraform.workspace}"
  subnet_ids = [var.public_subnet[0], var.public_subnet[1]]

  tags = {
    Name = "subnetgroup-${terraform.workspace}"
  }
}
