# VARIABLES ROUTE TABLES RT #
variable "Vpc-Bastion_id" {
  description = "VPC Bastion ID"
}

variable "Internet-Gateway_id" {
  description = "Internet Gateway ID"
}

variable "Subnet-Public_id" {
  description = "Subnet Public ID"
}

variable "Route_Table-Public_cidr_block" {
  description = "Route Table Cidr_block"
}
