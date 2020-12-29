# GLOBAL CONFIG AND VARIABLES
module "Virtual_Private_Cloud" {
  source                 = "./Modules/VPC"
  Vpc-Bastion_cidr_block = "10.0.0.0/16"
}

module "Subnets" {
  source                    = "./Modules/SN"
  Vpc-Bastion_id            = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Subnet-Public_cidr_block  = "10.0.10.0/24"
  Subnet-Private_cidr_block = "10.0.20.0/24"
  Subnet_availability_zone  = "us-east-2a"
}

module "Security_Group" {
  source                          = "./Modules/SG"
  Vpc-Bastion_id                  = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Subnet-Private_Cidr_block       = module.Subnets.Subnet-Private_Cidr_block # 10.0.20.0/24
  Subnet-Public_Cidr_block        = module.Subnets.Subnet-Public_Cidr_block  # 10.0.10.0/24
  Bastion_SG_SSH_cidr_blocks      = "0.0.0.0/0"
  Bastion_SG_HTTP_DNS_cidr_blocks = "0.0.0.0/0"
  Load_Balancer_SG_cidr_blocks    = "0.0.0.0/0"
}

module "Internet_Gateway" {
  source         = "./Modules/IG"
  Vpc-Bastion_id = module.Virtual_Private_Cloud.Vpc-Bastion_id
}

module "Route_Tables" {
  source                        = "./Modules/RT"
  Vpc-Bastion_id                = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Internet-Gateway_id           = module.Internet_Gateway.Internet-Gateway_id
  Subnet-Public_id              = module.Subnets.Subnet-Public_id
  Route_Table-Public_cidr_block = "0.0.0.0/0"
}

module "Elastic_Load_Balancer" {
  source                          = "./Modules/ELB"
  Subnet-Public_id                = module.Subnets.Subnet-Public_id
  Security_Group_Load_Balancer_Id = module.Security_Group.Load-Balancer-SG-id
  EC2_NGINX_id                    = module.EC2.EC2_NGINX_id
}

module "EC2" {
  source                          = "./Modules/EC2"
  Subnet-Private_id               = module.Subnets.Subnet-Private_id
  Subnet-Public_id                = module.Subnets.Subnet-Public_id
  Security_Group_Private_Id       = module.Security_Group.Private-SG-id
  Security_Group_Bastion_Id       = module.Security_Group.Bastion-SG-id
  Aws_Instance_NGINX_private_ip   = "10.0.20.20"
  Aws_Instance_BASTION_private_ip = "10.0.10.10"
  Aws_Instance_Type               = "t2.micro"
}