output "Subnet-Private_id" {
  value = aws_subnet.Subnet-Private.id
}

output "Subnet-Public_id" {
  value = aws_subnet.Subnet-Public.id
}

output "Subnet-Private_Cidr_block" {
  value = aws_subnet.Subnet-Private.cidr_block
}

output "Subnet-Public_Cidr_block" {
  value = aws_subnet.Subnet-Public.cidr_block
}
