terraform {

required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}



provider "aws" {
  region  = "eu-west-3"

}

resource "aws_instance" "instance_from_registry_sec_group" {
  ami                    = "ami-00ac45f3035ff009e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0dae6c351255f9e7e"]
  key_name               = "app-ssh-key"
  metadata_options {
	  http_tokens = "required"
    http_endpoint = "enabled"
	}	
  root_block_device {
      encrypted = true
  }
  tags = {
    Name = "java-app"
  }
    user_data = <<-EOF
              #!/bin/bash
                sudo apt-get update
                sudo apt-get install docker.io -y
                sudo systemctl start docker
                sudo systemctl enable docker
                sudo docker run -p 80:8000 -d strukovsergei/test-rep:latest
              EOF
}

