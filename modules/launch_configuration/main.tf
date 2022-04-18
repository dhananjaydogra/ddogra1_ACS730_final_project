### Module to Create a AWS Launch Configuration

# Step 1 - Define the provider
provider "aws" {
  region = "us-east-1"
}

# Data source for availability zones in us-east-1
data "aws_availability_zones" "available" {
  state = "available"
}

# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}



resource "aws_launch_configuration" "Group27_Project_webserver" {
  security_groups             =  var.security_group_id
  key_name                    =  var.key_name
  image_id                    =  var.ami_id
  instance_type               =  var.instance_type
  associate_public_ip_address = false
  user_data = templatefile("${path.module}/install_httpd.sh.tpl",
    {
      env    = upper(var.env),
      prefix = upper(local.name_prefix)
    }
  )
   root_block_device {
    encrypted = true
  }

  lifecycle {
    create_before_destroy = true
  }
  
  name_prefix = "${local.name_prefix}-Amazon-VM-"
}