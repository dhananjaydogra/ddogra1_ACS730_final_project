# VPC CIDR range
variable "vpc_cidr" {
  default     = "10.250.0.0/16"
  type        = string
  description = "VPC to host the environment"
}

# Variable to signal the current environment 
variable "env" {
  default     = "Prod"
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
    "Prod"    = "t3.medium"
    "Staging" = "t3.small"
    "Dev"     = "t3.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Minimum Size for the auto scaling group based on environment
variable "min_size" {
  default = {
    "Prod"    = "1"
    "Staging" = "1"
    "Dev"     = "1"
  }
  description = "Minimum Size for the auto scaling group"
  type        = map(string)
}

# MMaximum Size for the auto scaling group based on environment
variable "desired_capacity" {
  default = {
    "Prod"    = "3"
    "Staging" = "3"
    "Dev"     = "2"
  }
  description = "Desired Capaicty for the auto scaling group"
  type        = map(string)
}

# Maximum Size for the auto scaling group based on environment
variable "max_size" {
  default = {
    "Prod"    = "4"
    "Staging" = "4"
    "Dev"     = "4"
  }
  description = "Maximum Size for the auto scaling group"
  type        = map(string)
}