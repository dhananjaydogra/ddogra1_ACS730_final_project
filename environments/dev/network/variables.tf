# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.100.0.0/16"
  type        = string
  description = "VPC to host the environment"
}

# Provision public subnets in custom VPC
variable "public_subnet_cidrs" {
  default     = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24"]
  type        = list(string)
  description = "Public Subnet CIDRs"
}
# Provision Private subnets in custom VPC
variable "private_subnet_cidrs" {
  default     = ["10.100.4.0/24", "10.100.5.0/24", "10.100.6.0/24"]
  type        = list(string)
  description = "Private Subnet CIDRs"
}


# Variable to signal the current environment 
variable "env" {
  default     = "Dev"
  type        = string
  description = "Deployment Environment"
}


# Instance Profile Name for the LaunchConfig 
variable "iam_instance_profile_name" {
  default     = "EMR_EC2_DefaultRole"
  type        = string
  description = "Instance Profile Name for the LaunchConfig. It  needs to be created and updated in case this is not present"
}

# Instance type fir the LaunchConfig based on environment
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "staging" = "t3.small"
    "Dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Minimum Size for the auto scaling group based on environment
variable "min_size" {
  default = {
    "prod"    = "1"
    "staging" = "1"
    "Dev"     = "1"
  }
  description = "Minimum Size for the auto scaling group"
  type        = map(string)
}

# MMaximum Size for the auto scaling group based on environment
variable "desired_capacity" {
  default = {
    "prod"    = "3"
    "staging" = "3"
    "Dev"     = "2"
  }
  description = "Desired Capaicty for the auto scaling group"
  type        = map(string)
}

# Maximum Size for the auto scaling group based on environment
variable "max_size" {
  default = {
    "prod"    = "4"
    "staging" = "4"
    "Dev"     = "4"
  }
  description = "Maximum Size for the auto scaling group"
  type        = map(string)
}

# Maximum Size for the auto scaling group based on environment


# # Default tags
# variable "default_tags" {
#   default = {
#     "Owner" = "Dhananjay",
#     "App"   = "ACS730-Project"
#     "StduentID"="ddogra1"
#   }
#   type        = map(any)
#   description = "Default tags to be appliad to all AWS resources"
# }

# # Name prefix
# variable "prefix" {
#   type        = string
#   default     = "Group27"
#   description = "Name prefix"
# }