provider "aws" {

  region = "ap-northeast-1"
}

variable "privid" {
  type        = string
}
variable "pubid" {
  type        = string
}

resource "aws_lightsail_instance" "outline-instance" {
  name              = "outline-instance"
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "ubuntu_24_04"
  bundle_id         = "nano_2_0"
  key_pair_name     = aws_lightsail_key_pair.outline-key.name
  provisioner "file" {
    source      = "DeployOutlineVPN.sh"
    destination = "/tmp/DeployOutlineVPN.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod u+x /tmp/DeployOutlineVPN.sh"
      , "sudo /tmp/DeployOutlineVPN.sh"
    ]

  }
  connection {
    user        = "ubuntu"
    private_key = var.privid
    host        = aws_lightsail_instance.outline-instance.public_ip_address
  }
}
resource "aws_lightsail_key_pair" "outline-key" {
  name       = "outline-key"
  public_key = var.pubid
}

resource "aws_lightsail_instance_public_ports" "outline" {
  instance_name = aws_lightsail_instance.outline-instance.name

  port_info {
    protocol  = "tcp"
    from_port = 0
    to_port   = 65535
  }
  port_info {
    protocol  = "udp"
    from_port = 0
    to_port   = 65535
  }
  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["142.113.226.55/32"]
  }
}
