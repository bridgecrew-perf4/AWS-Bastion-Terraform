resource "aws_internet_gateway" "Internet-Gateway" {
  vpc_id = var.Vpc-Bastion_id

  tags = {
    Name = "Internet Gateway"
  }
}