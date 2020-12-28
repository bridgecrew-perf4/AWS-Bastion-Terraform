resource "aws_subnet" "Subnet-Public" {
  vpc_id                  = var.Vpc-Bastion_id
  cidr_block              = var.Subnet-Public_cidr_block
  availability_zone       = var.Subnet_availability_zone
  map_public_ip_on_launch = true


  tags = {
    Name = "Subnet-Public"
  }
}

resource "aws_subnet" "Subnet-Private" {
  vpc_id                  = var.Vpc-Bastion_id
  cidr_block              = var.Subnet-Private_cidr_block
  availability_zone       = var.Subnet_availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "Subnet-Private"
  }
}