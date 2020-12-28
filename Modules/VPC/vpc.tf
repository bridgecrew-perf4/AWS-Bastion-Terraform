resource "aws_vpc" "Vpc-Bastion" {
  cidr_block           = var.Vpc-Bastion_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "Vpc-Bastion"
  }
}
