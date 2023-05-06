#Declaring AWS Provider and credentials
provider "aws" {
  region     = "us-east-2"
  access_key = "....."
  secret_key = "....."
}
#######################################################
#Creating Production VPC with CIDR: 10.0.0.0/16
resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr 
    tags = {
        Name = "Phoenix"
    }
}
output "Phoenix_vpcid" {
  value = aws_vpc.vpc.id
}
#######################################################
#Creating Public Subnet with CIDR: 10.0.0.0/24
resource "aws_subnet" "bastion_public_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.bastion_cidr
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    Name        = "bastion_public"
  }
}
output "bastion_public_subnetid" {
  value = aws_subnet.bastion_public_subnet.id
}
#######################################################

#######################################################
#Creating IGW and attaching for Production VPC 
resource "aws_internet_gateway" "phoenix_igw" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
        Name = "phoenix-igw"
    }
}
output "internet_gateway_id" {
  value = aws_internet_gateway.phoenix_igw.id
}
#######################################################
#Adding Route table and IGW
resource "aws_route_table" "phoenix_public_rt" {
    vpc_id = "${aws_vpc.vpc.id}"  
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0"         //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.phoenix_igw.id}" 
    }
    tags = {
        Name = "phoenix-public-rt"
    }
}
output "Phoenix_Public_RT_id" {
  value = aws_route_table.phoenix_public_rt.id
}
#######################################################
#Adding public subnet to public route table
resource "aws_route_table_association" "phoenix-public-routetable"{
    subnet_id = "${aws_subnet.bastion_public_subnet.id}"
    route_table_id = "${aws_route_table.phoenix_public_rt.id}"
}

#Creating Private Subnet with CIDR: 10.0.1.0/24
resource "aws_subnet" "app_private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.app_cidr
  availability_zone       = "us-east-2a"
  tags = {
    Name        = "app"
  }
}
output "app_private_subnetid" {
  value = aws_subnet.app_private_subnet.id
}
resource "aws_subnet" "web_private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.web_cidr
  availability_zone       = "us-east-2a"
  tags = {
    Name        = "web"
  }
}
output "web_private_subnetid" {
  value = aws_subnet.web_private_subnet.id
}

resource "aws_subnet" "db_private_subnet" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = var.db_cidr
  availability_zone       = "us-east-2a"
  tags = {
    Name        = "db"
  }
}
output "db_private_subnetid" {
  value = aws_subnet.db_private_subnet.id
}
resource "aws_route_table" "phoenix_private_rt" {
    vpc_id = "${aws_vpc.vpc.id}"  
    tags = {
        Name = "phoenix-private-rt"
    }
}
output "Phoenix_private_RT_id" {
  value = aws_route_table.phoenix_private_rt.id
}

resource "aws_route_table_association" "app-private-routetable"{
    subnet_id = "${aws_subnet.app_private_subnet.id}"
    route_table_id = "${aws_route_table.phoenix_private_rt.id}"
}
resource "aws_route_table_association" "web-private-routetable"{
    subnet_id = "${aws_subnet.web_private_subnet.id}"
    route_table_id = "${aws_route_table.phoenix_private_rt.id}"
}
resource "aws_route_table_association" "db-private-routetable"{
    subnet_id = "${aws_subnet.db_private_subnet.id}"
    route_table_id = "${aws_route_table.phoenix_private_rt.id}"
}
