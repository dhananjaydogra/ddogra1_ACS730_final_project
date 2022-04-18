
# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}



# Defining the tags  and variables locally using the modules
locals {
  default_tags       = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix             = module.globalvars.prefix
  l_env              = lower(var.env)
  myip               = module.globalvars.my_ip
  name_prefix        = "${local.prefix}-${var.env}"
  keyName            = "sshkey_${var.env}"
  private_cloud9_ip  = module.globalvars.private_cloud9_ip
  public_cloud9_ip   = module.globalvars.public_cloud9_ip
  vpc_id             = data.terraform_remote_state.ProdNetwork.outputs.Prod_Vpc_Id
  public_subnet_ids  = data.terraform_remote_state.ProdNetwork.outputs.Prod_Public_Subnet_Ids
  private_subnet_ids = data.terraform_remote_state.ProdNetwork.outputs.Prod_Private_Subnet_Ids
}


#Getting netowrk details from the TF state  environment states 
data "terraform_remote_state" "ProdNetwork" { // This is to use Outputs from Remote State
  backend = "s3"
  config = {
    bucket = "ddogra1-acs730-project-${local.l_env}"    // Bucket from where to GET Terraform State
    key    = "${local.l_env}-network/terraform.tfstate" // Object name in the bucket to GET Terraform State
    region = "us-east-1"                                // Region where bucket created
  }
}




# Using Module to create Security Group for LoadBalancer

module "SecurityGroup-LB-Prod" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "LB"
  vpc_id       = local.vpc_id
  ingress_cidr = ["${local.myip}/32"]
  egress_cidr  = [var.vpc_cidr]
  prefix       = local.prefix
  default_tags = local.default_tags
}

# Using Module to create a TargetGroup

module "TargetGroup-Prod" {
  source       = "../../../modules/target_group"
  env          = var.env
  vpc_id       = local.vpc_id
  prefix       = local.prefix
  default_tags = local.default_tags
}



#### Module of  LoadBalancer
module "LB-Prod" {
  source            = "../../../modules/load_balancer"
  env               = var.env
  public_subnet_ids = local.public_subnet_ids
  security_group_id = module.SecurityGroup-LB-Prod.LB_SG_id
  target_Grp_Arn    = module.TargetGroup-Prod.TG_ARN
  prefix            = local.prefix
  default_tags      = local.default_tags
}




# Using Module to create Security Group for EC2 instances

module "SecurityGroup-EC2-Prod" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "EC2"
  vpc_id       = local.vpc_id
  ingress_cidr = [var.vpc_cidr, "${local.myip}/32", "0.0.0.0/0"]
  egress_cidr  = [var.vpc_cidr, "${local.myip}/32", "0.0.0.0/0"]
  prefix       = local.prefix
  default_tags = local.default_tags
}



# Adding SSH key to Amazon EC2 and bastion
resource "aws_key_pair" "web_key" {
  key_name   = local.name_prefix
  public_key = file("${path.module}/${local.keyName}.pub")
}

#Fecthing an exisitng_profile of instance porfile name from list where s3 read policy has been manually added
data "aws_iam_instance_profile" "exisitng_profile" {
  name = var.iam_instance_profile_name
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

module "LaunchConfig-Prod" {
  source            = "../../../modules/launch_configuration"
  env               = var.env
  security_group_id = module.SecurityGroup-EC2-Prod.EC2_SG_id
  key_name          = aws_key_pair.web_key.key_name
  ami_id            = data.aws_ami.latest_amazon_linux.id
  iam_ins_profile   = data.aws_iam_instance_profile.exisitng_profile.name
  instance_type     = lookup(var.instance_type, var.env)
  prefix            = local.prefix
  default_tags      = local.default_tags
}


#####Module ASG

module "ASG-Prod" {
  source               = "../../../modules/auto_scaling_group"
  env                  = var.env
  min_size             = lookup(var.min_size, var.env)
  desired_capacity     = lookup(var.desired_capacity, var.env)
  max_size             = lookup(var.max_size, var.env)
  private_subnet_ids   = local.private_subnet_ids
  LC_namne             = module.LaunchConfig-Prod.LC_Name
  target_group_arn     = module.TargetGroup-Prod.TG_ARN
  scale_down_threshold = 5
  scale_up_threshold   = 10
  prefix               = local.prefix
  default_tags         = local.default_tags
}




####Creating a bastion host that provides access to private vm of this environment

# Security Group for bastion
module "SecurityGroup-Bastion-Prod" {
  source       = "../../../modules/security_groups"
  env          = var.env
  type         = "Bastion"
  vpc_id       = local.vpc_id
  ingress_cidr = [var.vpc_cidr, "${local.private_cloud9_ip}/32", "${local.public_cloud9_ip}/32", "0.0.0.0/0"]
  egress_cidr  = [var.vpc_cidr, "${local.private_cloud9_ip}/32", "${local.public_cloud9_ip}/32"]
  prefix       = local.prefix
  default_tags = local.default_tags
}



resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.latest_amazon_linux.id
  instance_type               = lookup(var.instance_type, var.env)
  key_name                    = aws_key_pair.web_key.key_name
  subnet_id                   = local.public_subnet_ids[0]
  security_groups             = module.SecurityGroup-Bastion-Prod.BS_SG_id
  associate_public_ip_address = true
  ebs_optimized               = true
  monitoring                  = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
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

