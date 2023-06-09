provider "aws" {

  region = "us-east-1"
}

variable "privid" {
  type        = string
}

variable "pubid" {
  type        = string
}

variable "MYIP" {
  default = "142.113.226.55/32"
}

variable "VPCID" {
  default = "vpc-0927e8e29721bc9eb"
}

resource "aws_key_pair" "pgadmin4" {
  key_name   = "pgadmin4"
  public_key = var.pubid
}

resource "aws_security_group" "pgadmin4_sg" {
  vpc_id      = var.VPCID
  name        = "pgadmin4-sg"
  description = "Sec Grp for pgadmin"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.MYIP]
  }
}

resource "aws_instance" "pgadmin4-instance" {
  ami                    = "ami-002070d43b0a4f171"
  instance_type          = "t2.micro"
  availability_zone      = "us-east-1d"
  key_name               = aws_key_pair.pgadmin4.key_name
  vpc_security_group_ids = [aws_security_group.pgadmin4_sg.id]
  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price = 0.004
    }
  }

  provisioner "file" {
    source      = "pgadmin4.sh"
    destination = "/tmp/pgadmin4.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/pgadmin4.sh"
      , "sudo /tmp/pgadmin4.sh"
    ]

  }

  connection {
    user        = "centos"
    private_key = var.privid
    host        = aws_instance.pgadmin4-instance
  }
}
