
# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}


# Defining the tags  and variables locally using the modules
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  # myip              = module.globalvars.my_ip
  name_prefix = "${local.prefix}-${var.env}"
  # keyName           = "sshkey_${var.env}"
  # vpc_id            = module.vpc-Dev.vpc_id
  # public_subnet_ids = module.vpc-Dev.public_subnet_ids
  # private_cloud9_ip = module.globalvars.private_cloud9_ip
  # public_cloud9_ip  = module.globalvars.public_cloud9_ip

}



# Module to deploy basic networking 
module "vpc-Dev" {
  source              = "../../../modules/aws_network"
  env                 = var.env
  vpc_cidr            = var.vpc_cidr
  public_cidr_blocks  = var.public_subnet_cidrs
  private_cidr_blocks = var.private_subnet_cidrs
  prefix              = local.prefix
  default_tags        = local.default_tags
}


