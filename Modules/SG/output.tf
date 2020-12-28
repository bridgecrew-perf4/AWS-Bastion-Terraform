output "Bastion-SG-id" {
  value = aws_security_group.Bastion-SG.id
}

output "Private-SG-id" {
  value = aws_security_group.Private-SG.id
}

output "Load-Balancer-SG-id" {
  value = aws_security_group.Load-Balancer-SG.id
}
