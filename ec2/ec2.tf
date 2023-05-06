provider "aws" {
  region     = "us-east-2"
  access_key = "AKIAQJTGRA6VEBDYYHED"
  secret_key = "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"
}
resource "aws_instance" "phoenix_bastion" {
 ami = var.ami_id
 instance_type = var.instance_type
 key_name = var.key_name
 security_groups = [var.security_groups]
 subnet_id = var.subnet_id
 associate_public_ip_address = "true"
 tags = {
  Name = "phoenix_bastion"
 }
}
output "phoenix_bastion_IP" {
  value = aws_instance.phoenix_bastion.public_ip
}
output "phoenix_bastion_instance_id" {
  value = aws_instance.phoenix_bastion.id
}