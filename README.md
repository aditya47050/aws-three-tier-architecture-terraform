# AWS Three Tier Architecture using Terraform

This project demonstrates a production-ready **Three Tier Architecture on AWS** using **Terraform (Infrastructure as Code)**.

## Architecture Overview
![Architecture Diagram](diagrams/architecture.png)

## Components
- VPC with public and private subnets across multiple AZs
- Internet Gateway & NAT Gateway
- Application Load Balancer (ALB)
- Bastion Host for secure SSH access
- EC2 instances (Nginx) in private subnets
- RDS MySQL in private database subnets
- Security Groups with least-privilege access

## Traffic Flow
- User → ALB (HTTP 80)
- ALB → EC2 (Nginx)
- EC2 → RDS MySQL (3306)
- SSH → Bastion → Private EC2

## Tools & Services
- AWS (EC2, VPC, ALB, RDS, NAT Gateway)
- Terraform
- Amazon Linux
- Nginx

## How to Deploy
```bash
cd env/dev
terraform init
terraform plan
terraform apply
# aws-three-tier-architecture-terraform
