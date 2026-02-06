variable "project_name" { type = string }
variable "vpc_id" { type = string }
variable "subnets" { type = list(string) }
variable "alb_sg_id" { type = string }
variable "target_group_arn" { type = string }
variable "instance_type" { type = string }

variable "bastion_sg_id" {
  type = string
}

