provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQJTGRA6VEBDYYHED"
  secret_key = "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"
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