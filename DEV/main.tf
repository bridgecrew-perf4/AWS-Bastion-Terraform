# GLOBAL CONFIG AND VARIABLES FOR DEV ONLY

module "Access" {
  source = "../Access"
}
provider "aws" {
  region = module.Access.region
  access_key = module.Access.access_key
  secret_key = module.Access.secret_key
}

module "Virtual_Private_Cloud" {
  Env                    = "DEV"
  source                 = "../Modules/VPC"
  Vpc-Bastion_cidr_block = "10.0.0.0/16"

}

module "Subnets" {
  Env                       = "DEV"
  source                    = "../Modules/SN"
  Vpc-Bastion_id            = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Subnet-Public_cidr_block  = "10.0.10.0/24"
  Subnet-Private_cidr_block = "10.0.20.0/24"
  Subnet_availability_zone  = "us-east-2a"
}

module "Security_Group" {
  Env                             = "DEV"
  source                          = "../Modules/SG"
  Vpc-Bastion_id                  = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Subnet-Private_Cidr_block       = module.Subnets.Subnet-Private_Cidr_block # 10.0.20.0/24
  Subnet-Public_Cidr_block        = module.Subnets.Subnet-Public_Cidr_block  # 10.0.10.0/24
  Bastion_SG_SSH_cidr_blocks      = "0.0.0.0/0"
  Bastion_SG_HTTP_DNS_cidr_blocks = "0.0.0.0/0"
  Load_Balancer_SG_cidr_blocks    = "0.0.0.0/0"
}

module "Internet_Gateway" {
  Env                             = "DEV"
  source         = "../Modules/IG"
  Vpc-Bastion_id = module.Virtual_Private_Cloud.Vpc-Bastion_id
}

module "Route_Tables" {
  Env                           = "DEV"
  source                        = "../Modules/RT"
  Vpc-Bastion_id                = module.Virtual_Private_Cloud.Vpc-Bastion_id
  Internet-Gateway_id           = module.Internet_Gateway.Internet-Gateway_id
  Subnet-Public_id              = module.Subnets.Subnet-Public_id
  Route_Table-Public_cidr_block = "0.0.0.0/0"
}

module "Elastic_Load_Balancer" {
  Env                             = "DEV"
  source                          = "../Modules/ELB"
  Subnet-Public_id                = module.Subnets.Subnet-Public_id
  Security_Group_Load_Balancer_Id = module.Security_Group.Load-Balancer-SG-id
  EC2_NGINX_id                    = module.EC2.EC2_NGINX_id
}

module "EC2" {
  Env                             = "DEV"
  Count_NGINX                     = 3
  source                          = "../Modules/EC2"
  Subnet-Private_id               = module.Subnets.Subnet-Private_id
  Subnet-Public_id                = module.Subnets.Subnet-Public_id
  Security_Group_Private_Id       = module.Security_Group.Private-SG-id
  Security_Group_Bastion_Id       = module.Security_Group.Bastion-SG-id
  Aws_Instance_NGINX_private_ip   = ["10.0.20.20","10.0.20.21","10.0.20.22"]
  Aws_Instance_BASTION_private_ip = "10.0.10.10"
  Aws_Instance_Type               = "t2.micro"
}