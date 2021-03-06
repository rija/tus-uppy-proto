provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "ap-southeast-1"
}

resource "aws_security_group" "docker_host_sg" {
  name        = "docker_host_sg"
  description = "Allow connection to docker host"
  vpc_id      = "${var.aws_vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2376
    to_port     = 2376
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 30000
    to_port     = 30009
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9021
    to_port     = 9021
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


resource "aws_instance" "prototype_dockerhost" {
  ami = "ami-8e0205f2"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.docker_host_sg.id}"]
  key_name = "aws-centos7-keys"

  tags = {
    Name = "ec2-as1-file-upload-wizard"
  }

  root_block_device = {
    delete_on_termination = "true"
    volume_size = "25"
  }
}

data "aws_eip" "prototype_eip" {
  filter {
    name   = "tag:Name"
    values = ["eip-prototype-file-upload-wizard"]
  }
}

resource "aws_eip_association" "prototype_eip_association" {
  instance_id   = "${aws_instance.prototype_dockerhost.id}"
  allocation_id = "${data.aws_eip.prototype_eip.id}"
}
