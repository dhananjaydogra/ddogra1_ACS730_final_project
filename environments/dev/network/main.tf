
# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}


# Defining the tags  and variables locally using the modules
locals {
  default_tags      = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix            = module.globalvars.prefix
  myip              = module.globalvars.my_ip
  name_prefix       = "${local.prefix}-${var.env}"
  keyName           = "sshkey_${var.env}"
  vpc_id            = module.vpc-dev.vpc_id
  public_subnet_ids = module.vpc-dev.public_subnet_ids
  private_cloud9_ip = module.globalvars.private_cloud9_ip
  public_cloud9_ip  = module.globalvars.public_cloud9_ip

}



# Module to deploy basic networking 
module "vpc-dev" {
  source              = "../../../modules/aws_network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_cidr_blocks  = var.public_subnet_cidrs
  private_cidr_blocks = var.private_subnet_cidrs
  prefix              = var.prefix
  default_tags        = var.default_tags
}


# Using Module to create Security Group for LoadBalancer

module "SecurityGroup-LB-dev" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "LB"
  vpc_id       = local.vpc_id
  ingress_cidr = ["${local.myip}/32"]
  egress_cidr  = [var.vpc_cidr]
  prefix       = var.prefix
  default_tags = var.default_tags
}

#### Module of  LoadBalancer
module "LB-dev" {
  source            = "../../../modules/load_balancer"
  env               = var.env
  public_subnet_ids = local.public_subnet_ids
  security_group_id = module.SecurityGroup-LB-dev.LB_SG_id
  prefix            = var.prefix
  default_tags      = var.default_tags
}




# Using Module to create Security Group for EC2 instances

module "SecurityGroup-EC2-dev" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "EC2"
  vpc_id       = local.vpc_id
  ingress_cidr = [var.vpc_cidr, "${local.myip}/32"]
  egress_cidr  = [var.vpc_cidr, "${local.myip}/32"]
  prefix       = var.prefix
  default_tags = var.default_tags
}



# Adding SSH key to Amazon EC2 and bastion
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${path.module}/../webservers/${local.keyName}.pub")
}

# Data source for AMI id to be passed into the module
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

### using  Module Launch Configuration 

module "LaunchConfig-dev" {
  source            = "../../../modules/launch_configuration"
  env               = var.env
  security_group_id = module.SecurityGroup-EC2-dev.EC2_SG_id
  key_name          = aws_key_pair.web_key.key_name
  ami_id            = data.aws_ami.latest_amazon_linux.id
  instance_type     = lookup(var.instance_type, var.env)
  prefix            = var.prefix
  default_tags      = var.default_tags
}


#####Module ASG

module "ASG-dev" {
  source               = "../../../modules/auto_scaling_group"
  env                  = var.env
  min_size             = lookup(var.min_size, var.env)
  desired_capacity     = lookup(var.desired_capacity, var.env)
  max_size             = lookup(var.max_size, var.env)
  Lb_ids               = [module.LB-dev.LB_id]
  private_subnet_ids   = module.vpc-dev.private_subnet_ids
  LC_namne             = module.LaunchConfig-dev.LC_Name
  scale_down_threshold = 5
  scale_up_threshold   = 10
  prefix               = var.prefix
  default_tags         = var.default_tags
}




# Creating a bastion host that provides access to all VMs in prod and nonprod

# Security Group for bastion
module "SecurityGroup-Bastion-dev" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "Bastion"
  vpc_id       = local.vpc_id
  ingress_cidr = [var.vpc_cidr, "${local.private_cloud9_ip}/32", "${local.public_cloud9_ip}/32"]
  egress_cidr  = [var.vpc_cidr, "${local.private_cloud9_ip}/32", "${local.public_cloud9_ip}/32"]
  prefix       = var.prefix
  default_tags = var.default_tags
}



resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = module.vpc-dev.public_subnet_ids[0]
  security_groups             = module.SecurityGroup-Bastion-dev.BS_SG_id
  associate_public_ip_address = true

  root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-Amazon-Bastion"
    }
  )
}
