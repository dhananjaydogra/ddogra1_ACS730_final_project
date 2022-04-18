# Default tags
variable "default_tags" {
  default = {
    "Owner" = "Dhananjay",
    "App"   = "ACS730-Project"
  }
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  default     = "Group27"
  description = "Name prefix"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  type        = list(string)
  description = "Non Prod Public Subnet CIDRs"
}


# Provision Private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
  type        = list(string)
  description = "Non Prod Private Subnet CIDRs"
}

# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC to host Non Prod environment"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

# Instance type fir the LaunchConfig based on environment
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}



# Minimum Size for the auto scaling group based on environment
variable "min_size" {
  default = {
    "prod"    = "1"
    "staging" = "1"
    "dev"     = "1"
  }
  description = "Minimum Size for the auto scaling group"
  type        = map(string)
}

# MMaximum Size for the auto scaling group based on environment
variable "desired_capacity" {
  default = {
    "prod"    = "3"
    "staging" = "3"
    "dev"     = "2"
  }
  description = "Desired Capaicty for the auto scaling group"
  type        = map(string)
}

# Maximum Size for the auto scaling group based on environment
variable "max_size" {
  default = {
    "prod"    = "4"
    "staging" = "4"
    "dev"     = "4"
  }
  description = "Maximum Size for the auto scaling group"
  type        = map(string)
}