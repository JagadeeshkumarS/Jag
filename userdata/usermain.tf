provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQJTGRA6VEBDYYHED"
  secret_key = "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"
}
resource "aws_instance" "userdata" {
   ami = "ami-0557a15b87f6559cf"
   instance_type = "t2.micro"
   subnet_id = "subnet-04a3d0d8d59c82cfd"
   associate_public_ip_address = "true"
   vpc_security_group_ids = ["sg-098bde7cdc5eb3dc1"]
   key_name = "n.virginia"
   user_data = <<EOF
   #!/bin/bash
   sudo echo "installing nginx"
   sudo apt update && sudo apt install -y nginx
   sudo echo "starting nginx service"
   sudo systemctl start nginx
   sudo mkfs -t ext4 /dev/xvdf
   sudo mkdir /udata
   sudo mount /dev/xvdf /udata
   sudo echo /dev/xvdf /udata defaults,nofail 0 2 >> /etc/fstab
   EOF
    tags = {
      Name = "userdata"
    }  
}
output "instance_id"{
    value = aws_instance.userdata.id
}
output "Instance_PublicIP" {
    value = aws_instance.userdata.public_ip
}
resource "aws_ebs_volume" "secondary_volume" {
  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp2"
   tags = {
  Name = "secondary_volume"
 }
}
output "secondary_volume" {
  value = aws_ebs_volume.secondary_volume.id
}
resource "aws_volume_attachment" "secondary_volume-attach" {
  device_name  = "/dev/xvdf"
  instance_id  = "${aws_instance.userdata.id}"
  volume_id    = "${aws_ebs_volume.secondary_volume.id}"
  force_detach = true
}