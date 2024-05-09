

data "aws_ami" "ubuntu" {
    most_recent = true
    owners = ["767398057060"] # Canonical
}
provider "aws" {
  region  = "eu-west-3"
  profile = "default"

}

resource "aws_instance" "instance_from_registry_sec_group" {
  ami                    = "ami-00ac45f3035ff009e"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-0dae6c351255f9e7e"]
  key_name               = "app-ssh-key"
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

