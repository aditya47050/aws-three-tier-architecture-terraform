resource "aws_security_group" "app_sg" {
  name   = "${var.project_name}-app-sg"
  vpc_id = var.vpc_id

  # HTTP from ALB
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # SSH only from Bastion
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}

resource "aws_instance" "app" {
  count         = length(var.subnets)
  ami           = "ami-0c50b6f7dc3701ddd"
  instance_type = var.instance_type
  subnet_id     = var.subnets[count.index]

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              echo "<h1>Three Tier App - $(hostname)</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "${var.project_name}-app-${count.index + 1}"
  }
}

resource "aws_lb_target_group_attachment" "app" {
  count            = length(aws_instance.app)
  target_group_arn = var.target_group_arn
  target_id        = aws_instance.app[count.index].id
  port             = 80
}
