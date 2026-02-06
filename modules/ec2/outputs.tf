output "instance_ids" {
  value = aws_instance.app[*].id
}

output "app_sg_id" {
  value = aws_security_group.app_sg.id
}
