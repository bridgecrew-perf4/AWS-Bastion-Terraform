output "DNS-Load-Balancer" {
  value = module.Elastic_Load_Balancer.DNS-Load-Balancer
}

output "Bastion-Public-Ip" {
  value = module.EC2.Bastion-Public-Ip
}