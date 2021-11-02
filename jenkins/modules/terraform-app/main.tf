data "aws_ami" "jenkins" {
  most_recent = true
  owners = ["amazon"]
  
  filter {
   name = "name"
   values = ["Amazon*"]
}
  filter {
   name = "architecture"
   values= ["x86_64"]
}

}

data "aws_subnet" "subnet_public" { 
  cidr_block = var.subnet_cidr
}

resource "aws_key_pair" "jenkins-sshkey" {
     key_name = format("%s-jenkins-app-key", var.name_prefix)
     public_key = var.jenkins-sshkey # gerando a chave publica ssh-keygen -C comentario -f slacko

}

resource "aws_instance" "jenkins" {
connection {
        user = "ec2-user"
        host = "${self.public_ip}"
        type     = "ssh"
        private_key = "${file(var.private_key_path)}"
      }
   vpc_security_group_ids = [aws_security_group.allow-jenkins.id]
   ami = data.aws_ami.jenkins.id
   instance_type = var.instance_type
   subnet_id = data.aws_subnet.subnet_public.id
   associate_public_ip_address = true

  tags = merge(var.app_tags,
            {
            "Name" = format("%s-jenkins-app", var.name_prefix)
            })
  key_name = aws_key_pair.jenkins-sshkey.id
  user_data_base64 = "IyEgL2Jpbi9iYXNoCnN1ZG8geXVtIHVwZGF0ZSAteSAKc3VkbyB3Z2V0IC1PIC9ldGMveXVtLnJlcG9zLmQvamVua2lucy5yZXBvIGh0dHBzOi8vcGtnLmplbmtpbnMuaW8vcmVkaGF0LXN0YWJsZS9qZW5raW5zLnJlcG8Kc3VkbyBycG0gLS1pbXBvcnQgaHR0cHM6Ly9wa2cuamVua2lucy5pby9yZWRoYXQtc3RhYmxlL2plbmtpbnMuaW8ua2V5CnN1ZG8gYW1hem9uLWxpbnV4LWV4dHJhcyBpbnN0YWxsIGVwZWwgLXkKc3VkbyB5dW0gdXBkYXRlIC15CnN1ZG8geXVtIGluc3RhbGwgamVua2lucyBqYXZhLTEuOC4wLW9wZW5qZGstZGV2ZWwgLXkKc3VkbyBzeXN0ZW1jdGwgZGFlbW9uLXJlbG9hZApzdWRvIHN5c3RlbWN0bCBzdGFydCBqZW5raW5z"  
  provisioner "remote-exec" {
    inline = [
      "sleep 400",
      "echo \"Chave Jenkins: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)\""
    ]
 }
}

resource "aws_security_group" "allow-jenkins" {
  name        =  format("%s-allow-ssh-8080", var.name_prefix)
  description = "Allow ssh and 8080 port"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "allow ssh"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }, 
    {
      description      = "allow http"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }

  ]

  egress = [ ## trafego de saida
    {
      description      = "saida"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self = null
    }
  ]

  tags = merge(var.app_tags,
            {
            "Name" = format("%s-allow_ssh_8080", var.name_prefix)
            })
}


