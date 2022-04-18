
# Local variables
locals {
  default_tags = merge(
    var.default_tags,
    { "Env" = var.env }
  )
  name_prefix = "${var.prefix}-${var.env}"
}

### Module to Create a Security Group for LoadBalancer

resource "aws_security_group" "Group27_Project_LB_SG" {
  count= var.type== "LB" ? 1 : 0
  vpc_id      = var.vpc_id
  # Inbound Rules
  # HTTP access from specific cidrs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  
  # Outbound Rules
  # Internet access to specific cidrs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr
   }
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-LB-SecurityGroup"
    }
  )
}



### Module to Create a Security Group for Ec2 

resource "aws_security_group" "Group27_Project_EC2_SG" {
  count= var.type== "EC2" ? 1 : 0
  vpc_id      = var.vpc_id
  # Inbound Rules
  # HTTP access from specific cidrs
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  # SSH access from specific cidrs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  # Outbound Rules
  # Internet access to specific cidrs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr
   }
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-EC2-SecurityGroup"
    }
  )
}



### Module to Create a Security Group for Bastion

resource "aws_security_group" "Group27_Project_Bastion_SG" {
  count= var.type== "Bastion" ? 1 : 0
  vpc_id      = var.vpc_id
  # Inbound Rules
  # SSH access from specific cidrs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr
  }
  
  # Outbound Rules
  # Internet access to specific cidrs
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidr
   }
   tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-Bastion-SecurityGroup"
    }
  )
}
