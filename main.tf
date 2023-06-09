provider "aws" {
  region     = "us-east-2"
  access_key = "....."
  secret_key = "....."
}
module "myvpc" {
  source = "./vpc"
  
  }
module "mysg" {
  source = "./security_group"
  vpc_id= "${module.myvpc.Phoenix_vpcid}"
}
module "myec2" {
  source = "./ec2"
  security_groups ="${module.mysg.phoenix_sg_id}"
  subnet_id = "${module.myvpc.bastion_public_subnetid}"
}
