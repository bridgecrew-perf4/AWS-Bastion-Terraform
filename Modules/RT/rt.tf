resource "aws_route_table" "Route-Table-Public" {
  vpc_id = var.Vpc-Bastion_id

  route {

    cidr_block = var.Route_Table-Public_cidr_block
    gateway_id = var.Internet-Gateway_id
  }

  tags = {
    Name = "Route-Table-Public-${var.Env}"
  }
}

resource "aws_route_table_association" "Route-Table-Public-association" {
  subnet_id      = var.Subnet-Public_id
  route_table_id = aws_route_table.Route-Table-Public.id
}

resource "aws_route_table" "Route-Table-Private" {
  vpc_id = var.Vpc-Bastion_id

  tags = {
    Name = "Route-Table-Private-${var.Env}"
  }
}
