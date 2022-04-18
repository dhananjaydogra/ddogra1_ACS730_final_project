
# Retrieve global variables from the Terraform module
module "globalvars" {
  source = "../../../modules/globalvars"
}


# Defining the tags  and variables locally using the modules
locals {
  default_tags = merge(module.globalvars.default_tags, { "env" = var.env })
  prefix       = module.globalvars.prefix
  name_prefix = "${local.prefix}-${var.env}"

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


