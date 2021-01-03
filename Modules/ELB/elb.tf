resource "aws_elb" "Load-Balance-My-Website" {
  name                        = "My-Website"
  depends_on                  = [var.Subnet-Public_id]
  subnets                     = [var.Subnet-Public_id]
  security_groups             = [var.Security_Group_Load_Balancer_Id]
  instances                   = [var.EC2_NGINX_id]
  cross_zone_load_balancing   = false
  idle_timeout                = 60
  connection_draining         = false
  connection_draining_timeout = 300
  internal                    = false

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 80
    lb_protocol        = "http"
    ssl_certificate_id = ""
  }

  health_check {
    healthy_threshold   = 6
    unhealthy_threshold = 2
    interval            = 10
    target              = "HTTP:80/"
    timeout             = 5
  }
  tags = {
    Name = "Elastic-Load-Balancer-${var.Env}"
  }
}
