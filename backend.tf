terraform {
  backend "s3" {
    bucket = "vorx-iac-lscheiner"
    key    = "vpc-terraform.tfstate"
    region = "us-east-1"
  }
}
