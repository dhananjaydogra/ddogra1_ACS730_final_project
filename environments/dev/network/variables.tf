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

