module "vpc" {
  source = "../../modules/vpc"

  project_name = "three-tier"
  vpc_cidr     = "10.0.0.0/16"

  azs = ["ap-south-1a", "ap-south-1b"]

  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnets  = ["10.0.21.0/24", "10.0.22.0/24"]
}

module "alb" {
  source = "../../modules/alb"

  project_name = "three-tier"
  vpc_id       = module.vpc.vpc_id
  subnets      = module.vpc.public_subnets
}

module "bastion" {
  source = "../../modules/bastion"

  project_name     = "three-tier"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnets[0]
  key_name         = "bastion-key"
  my_ip            = "152.58.17.120"
}

module "ec2" {
  source = "../../modules/ec2"

  project_name     = "three-tier"
  vpc_id           = module.vpc.vpc_id
  subnets          = module.vpc.private_app_subnets
  alb_sg_id        = module.alb.alb_sg_id
  target_group_arn = module.alb.target_group_arn
  instance_type    = "t3.micro"

  bastion_sg_id    = module.bastion.bastion_sg_id
}

module "rds" {
  source = "../../modules/rds"

  project_name = "three-tier"
  vpc_id       = module.vpc.vpc_id
  db_subnets   = module.vpc.private_db_subnets
  app_sg_id    = module.ec2.app_sg_id

  db_name     = "appdb"
  db_username = "admin"
  db_password = "Admin12345!"
}
