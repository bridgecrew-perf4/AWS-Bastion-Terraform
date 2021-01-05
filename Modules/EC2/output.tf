output "EC2_NGINX_id" {
  value = aws_instance.NGINX[*].id
}
output "Bastion-Public-Ip" {
  value = aws_instance.BASTION.public_ip
}