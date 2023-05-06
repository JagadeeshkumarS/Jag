variable "vpc_cidr" {
    default = "172.16.0.0/16"
}
variable "bastion_cidr" {
    default = "172.16.0.0/24"
}
variable "app_cidr" {
    default = "172.16.1.0/24"
}
variable "web_cidr" {
    default = "172.16.2.0/24"
}
variable "db_cidr" {
    default = "172.16.3.0/24"
}