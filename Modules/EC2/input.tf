# VARIABLES EC2#

variable "Subnet-Private_id" {
  description = "Private Subnet id"
}

variable "Subnet-Public_id" {
  description = "Public Subnet id"
}

variable "Security_Group_Private_Id" {
  description = "Private Security Group Id"
}

variable "Security_Group_Bastion_Id" {
  description = "Bastion Security Group Id"
}

variable "Aws_Instance_NGINX_private_ip" {
  description = "NGINX Private Ip"
}

variable "Aws_Instance_BASTION_private_ip" {
  description = "BASTION Private Ip"
}

variable "Aws_Instance_Type" {
  description = "Size of the Instances"
}