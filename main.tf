
provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "docker-server-ssh" {
   key_name   = "docker-server-ssh-ec2tfd"
   public_key = file("docker-server.key.pub")
}


resource "aws_security_group" "docker-server-sg" {
 name        = "docker-server-sg-ec2tfd"
 description = "Security group allowing SSH and HTTP access"


 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }

}


resource "aws_instance" "docker-server" {
 ami = "ami-0453ec754f44f9a4a"  # agrega el ami Amazon Linux de acuerdo a tu region
 instance_type = "t2.micro"



 tags = {
   Name        = "Upb-docker"
   Environment = "test"
   Owner       = "luisandypp@gmail.com" # Puedes agregar tu mail para el tag
   Team        = "DevOps"
   Project     = "crates"
 }


 user_data = <<-EOF
             #!/bin/bash
             sudo yum update -y
             sudo sudo yum install -y docker
             sudo service docker start
             sudo usermod -aG docker ec2-user 
             sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
             sudo chmod +x /usr/local/bin/docker-compose
             EOF
 user_data_replace_on_change = true
 key_name = aws_key_pair.docker-server-ssh.key_name
 vpc_security_group_ids = [ aws_security_group.docker-server-sg.id ]

}

output "ec2_public_ip" {
  value = aws_instance.docker-server.public_ip
}


