resource "aws_security_group" "bastion_sg" {
  name   = "${var.project_name}-bastion-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0c50b6f7dc3701ddd"
  instance_type               = "t3.micro"
  subnet_id                   = var.public_subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]

  tags = {
    Name = "${var.project_name}-bastion"
  }
}
