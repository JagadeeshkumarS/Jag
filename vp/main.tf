provider "aws" {
  region     = "us-east-1"
  access_key = "....."
  secret_key = "....."
}
resource "aws_vpc" "vpc"{
    cidr_block = var.cidr_block
    tags = {
        Name = "JJJ"
    }
}
output "vpc"{
    value = aws_vpc.vpc.id
}
