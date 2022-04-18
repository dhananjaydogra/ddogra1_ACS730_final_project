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

# Create a new VPC 
resource "aws_vpc" "main" {
#resource "aws_vpc" "$${var.prefix}_$${var.env}_VPC" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-vpc"
    }
  )
}


# Add provisioning of the public subnetin the default VPC
resource "aws_subnet" "public_subnet" {
  count            =  length(var.public_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-public-subnet-${count.index}"
    }
  )
}



# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  count  = 1
  vpc_id = aws_vpc.main.id

  tags = merge(local.default_tags,
    {
      "Name" = "${local.name_prefix}-igw"
    }
  )
}

# Route table to route add default gateway pointing to Internet Gateway (IGW)
resource "aws_route_table" "public_route_table" {
  count  = 1
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[count.index].id 
  }
  tags = {
    Name = "${local.name_prefix}-public-route_table"
  }
}

# Associate subnets with the custom route table
resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public_subnet[*].id)
  route_table_id = aws_route_table.public_route_table[0].id
  subnet_id      = aws_subnet.public_subnet[count.index].id
}



# Adding private subnets 
resource "aws_subnet" "private_subnet" {
  count             = length(var.private_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index+1]
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-private-subnet-${count.index}"
    }
  )
}


#Adding EIP
resource "aws_eip" "nat_eip" {
count= 1
vpc=true
tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-nat_eip"
    }
  )
  
}


#Adding a NAT gateway to Public subnet in nonprod

resource "aws_nat_gateway" "nat_gw" {
 count=  1
  allocation_id=aws_eip.nat_eip[count.index].id
  subnet_id=aws_subnet.public_subnet[1].id
  
  tags = merge(
    local.default_tags, {
      Name = "${local.name_prefix}-NAT_gw"
    }
  )
  depends_on=[aws_internet_gateway.igw]
}


# Private Route table to route from  NAT Gateway
resource "aws_route_table" "private_route_table" {
 count= 1
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
  tags = {
    Name = "${local.name_prefix}-private-route_table"
  }
}

# Associate subnets with the private route table
resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  route_table_id = aws_route_table.private_route_table[0].id
  subnet_id      = aws_subnet.private_subnet[count.index].id
}



# # Private Route table to route from prod 
# resource "aws_route_table" "prod_private_route_table" {
# count= var.env == "prod" ? 1 : 0
#   vpc_id = aws_vpc.main.id
#   route = []
#   tags = {
#     Name = "${local.name_prefix}-private-route_table"
#   }
# }

# # Associate subnets with the private route table
# resource "aws_route_table_association" "prod_private_route_table_association" {
#   count          = var.env == "prod" ? length(aws_subnet.private_subnet[*].id) : 0
#   route_table_id = aws_route_table.prod_private_route_table[0].id
#   subnet_id      = aws_subnet.private_subnet[count.index].id
# }
