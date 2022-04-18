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

resource "aws_lb" "Group27_Project_LB" {
  name                      = "${local.name_prefix}-LoadBalancer"
  security_groups           =  var.security_group_id
  subnets                   =  var.public_subnet_ids
  load_balancer_type        = "application"
  internal                  = false
  drop_invalid_header_fields = true
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-LoadBalancer"
    }
  )
}

# Adding the LB Listenr 
resource "aws_lb_listener" "Group27_Project_LB_Listener" {
  load_balancer_arn = aws_lb.Group27_Project_LB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
 type = "forward"

 target_group_arn = var.target_Grp_Arn

}
 tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-LoadBalancer"
    }
  )
}
