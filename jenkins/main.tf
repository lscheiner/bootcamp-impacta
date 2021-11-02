
variable "vpc_id"     { }
variable "subnet_cidr"     { }
variable "name_prefix"     { }
variable "app_tags"     { }
variable "jenkins-sshkey"     { }
variable "instance_type"     { }
variable "private_key_path" { }




module "jenkins-app" {
  source = "./modules/terraform-app"
  vpc_id = var.vpc_id
  subnet_cidr = var.subnet_cidr
  name_prefix = var.name_prefix
  app_tags = var.app_tags
  jenkins-sshkey = var.jenkins-sshkey
  instance_type = var.instance_type
  private_key_path = var.private_key_path
}

output "jenkins-app-name" {
  value       = module.jenkins-app.jenkins-app-name-output
  description = "Nome do APP"
}

output "jenkins-sg-app" {
  value       = module.jenkins-app.allow-jenkins-output
  description = "Nome do sg Jenkins"
}
