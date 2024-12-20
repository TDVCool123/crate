
provider "aws" {
    region = "us-east-1"
}

resource "aws_key_pair" "docker-server-ssh" {
   key_name   = "docker-server-ssh-ec2tf"
   public_key = file("docker-server.key.pub")
}


resource "aws_security_group" "docker-server-sg" {
 name        = "docker-server-sg-ec2tf"
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
             sudo amazon-linux-extras install docker -y
             sudo service docker start
             sudo usermod -aG docker ec2-user
             sudo mkdir actions-runner && cd actions-runner
             sudo curl -o actions-runner-linux-x64-2.321.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.321.0/actions-runner-linux-x64-2.321.0.tar.gz
             sudo tar xzf ./actions-runner-linux-x64-2.321.0.tar.gz
             sudo ./config.sh --url https://github.com/TDVCool123/crate --token AQ634URKWUTOWH4DIU4KI53HMUUOC
             sudo ./run.sh 
             EOF
 user_data_replace_on_change = true
 key_name = aws_key_pair.docker-server-ssh.key_name
 vpc_security_group_ids = [ aws_security_group.docker-server-sg.id ]

}

output "ec2_public_ip" {
  value = aws_instance.docker-server.public_ip
}


