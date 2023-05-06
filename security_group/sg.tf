provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAQJTGRA6VEBDYYHED"
  secret_key = "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"
}
#######################################################
#Creating Security
resource "aws_security_group" "phoenix_sg" {
  name = "phoenix_sg"
  description = "Allow phoenix sg inbound traffic"
  vpc_id      = var.vpc_id
  ingress {
      from_port = 22
      to_port = 22
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
}
output "phoenix_sg_id" {
    value = aws_security_group.phoenix_sg.id
}