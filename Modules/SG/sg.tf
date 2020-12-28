resource "aws_security_group" "Bastion-SG" {
  name        = "Bastion-Security-Group"
  description = "Only ingress port 80 and 22 are allowed also  Internet access"
  vpc_id      = var.Vpc-Bastion_id

  ingress {
    description = "Tiny Proxy"
    from_port   = 8888
    protocol    = "tcp"
    to_port     = 8888
    cidr_blocks = [var.Subnet-Private_Cidr_block] # 10.0.20.0/24
  }

  ingress {
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.Bastion_SG_SSH_cidr_blocks] # 0.0.0.0/0
  }

  egress {
    description     = "Rule needed for apt update / upgrade"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    cidr_blocks     = [var.Bastion_SG_HTTP_DNS_cidr_blocks] # 0.0.0.0/0
  }

  egress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = [var.Subnet-Private_Cidr_block] # 10.0.20.0/24
  }

  egress {
    description     = "Rule needed for apt update / upgrade"
    from_port       = 53
    to_port         = 53
    protocol        = "udp"
    cidr_blocks     = [var.Bastion_SG_HTTP_DNS_cidr_blocks] # 0.0.0.0/0
  }

}

resource "aws_security_group" "Private-SG" {
  name        = "Private-sg"
  description = "Private-sg only port 80 and 22"
  vpc_id      = var.Vpc-Bastion_id

  ingress {
    description = "HTTP"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = [var.Subnet-Public_Cidr_block] # 10.0.10.0/24
  }

  ingress {
    description = "SSH"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = [var.Subnet-Public_Cidr_block] # 10.0.10.0/24
  }

  egress {
    from_port   = 8888
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [var.Subnet-Public_Cidr_block] # 10.0.10.0/24
  }
}

resource "aws_security_group" "Load-Balancer-SG" {
  name        = "Load-Balancer"
  description = "This Load Balancer belongs to My-Website"
  vpc_id      = var.Vpc-Bastion_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.Load_Balancer_SG_cidr_blocks] # 0.0.0.0/0
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.Subnet-Private_Cidr_block] # 10.0.20.0/24
  }

}