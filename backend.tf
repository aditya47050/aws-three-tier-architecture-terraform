terraform {
  backend "s3" {
    bucket         = "aditya-terraform-state-3tier"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
