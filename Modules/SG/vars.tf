# VARIABLES SECURITY GROUP #
variable "Vpc-Bastion_id" {}
variable "Bastion_SG_SSH_cidr_blocks" {}
variable "Load_Balancer_SG_cidr_blocks" {}
variable "Subnet-Private_Cidr_block" {}
variable "Subnet-Public_Cidr_block" {}
variable "Bastion_SG_HTTP_DNS_cidr_blocks" {}