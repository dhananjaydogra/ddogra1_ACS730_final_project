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

### Module to Create a AWS Load Balancer

resource "aws_elb" "Group27_Project_LB" {
  security_groups           =  var.security_group_id
  subnets                   =  var.public_subnet_ids
  cross_zone_load_balancing = true
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTP:80/"
  }
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = "80"
    instance_protocol = "http"
  }
  
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-LoadBalancer"
    }
  )
}
