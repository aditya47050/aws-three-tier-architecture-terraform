# DB Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnets

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# Security Group for RDS (ONLY EC2 allowed)
resource "aws_security_group" "db_sg" {
  name   = "${var.project_name}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project_name}-db-sg" }
}

# RDS Instance (MySQL)
resource "aws_db_instance" "this" {
  identifier              = "${var.project_name}-db"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20

  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password

  vpc_security_group_ids  = [aws_security_group.db_sg.id]
  db_subnet_group_name    = aws_db_subnet_group.this.name

  publicly_accessible     = false
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "${var.project_name}-rds"
  }
}
