data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "NGINX" {
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = "us-east-2a"
  ebs_optimized               = false
  instance_type               = var.Aws_Instance_Type
  monitoring                  = false
  key_name                    = "aws-key"
  depends_on                  = [var.Subnet-Private_id]
  subnet_id                   = var.Subnet-Private_id
  vpc_security_group_ids      = [var.Security_Group_Private_Id]
  associate_public_ip_address = false
  private_ip                  = var.Aws_Instance_NGINX_private_ip
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name = "NGINX-${var.Env}"
  }
}

resource "aws_instance" "BASTION" {
  ami                         = data.aws_ami.ubuntu.id
  availability_zone           = "us-east-2a"
  ebs_optimized               = false
  instance_type               = var.Aws_Instance_Type
  monitoring                  = false
  key_name                    = "aws-key"
  depends_on                  = [var.Subnet-Public_id, aws_instance.NGINX]
  subnet_id                   = var.Subnet-Public_id
  vpc_security_group_ids      = [var.Security_Group_Bastion_Id]
  associate_public_ip_address = true
  private_ip                  = var.Aws_Instance_BASTION_private_ip
  source_dest_check           = true

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  tags = {
    Name = "BASTION-${var.Env}"
  }

  provisioner "file" {
    source      = "../Modules/EC2/index" # Copia de mi local
    destination = "/tmp/" # Copia al /tmp/ remoto */
  }

  provisioner "file" {
    source      = "../Modules/EC2/provisioner.sh" # Copia de mi local
    destination = "/tmp/provisioner.sh" # Copia al /tmp/ remoto */
  }

  provisioner "file" {
    source      = "../Modules/EC2/nginx.sh" # Copia de mi local
    destination = "/tmp/nginx.sh" # Copia al /tmp/ remoto
  }

  provisioner "file" {
    source      = "../Access/aws-key.pem" # Copia de mi local
    destination = "/tmp/aws-key.pem" # Copia al /tmp/ remoto
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/provisioner.sh",
      "sudo bash /tmp/provisioner.sh | tee ./provisioner.log ",
    ]
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/nginx.sh",
      "chmod 400 /tmp/aws-key.pem",
      "sudo bash /tmp/nginx.sh | tee ./nginx.log ",
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("../Access/aws-key.pem")
  }
}