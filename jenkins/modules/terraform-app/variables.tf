variable "vpc_id" {  type = string  }
variable "subnet_cidr" { type = string}
variable "app_tags" {  type = map }
variable "jenkins-sshkey" { type = string }
variable "name_prefix" {  type = string }
variable "instance_type" {  type = string }

variable "private_key_path" {  type = string }
