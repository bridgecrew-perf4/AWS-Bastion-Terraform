# LOAD BALANCER OUTPUT

output "DNS-Load-Balancer" {
  value = aws_elb.Load-Balance-My-Website.dns_name
}