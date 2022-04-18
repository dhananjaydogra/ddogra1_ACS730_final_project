# Default tags
variable "default_tags" {
  default = {}
  type        = map(any)
  description = "Default tags to be appliad to all AWS resources"
}

# Name prefix
variable "prefix" {
  type        = string
  description = "Name prefix"
}

#  Sizes
variable "min_size" {
  type        = string
  description = "Minimum Size for the auto scaling group"
}

variable "desired_capacity" {
  type = string
  description = "Desired Capaicty for the auto scaling group"
}

variable "max_size" {
  type = string
  description = "Maximum Size for the auto scaling group"
}

# Target Group ARN for the ASG
variable "target_group_arn" {
  type        = string
  description = "Target Group ARN for the ASG"
}

# Private subnet IDs  required by the ASG
variable "private_subnet_ids" {
  default     = []
  type        = list(string)
  description = "Private Subnet IDs"
}

# LaunchConfig name for the ASG
variable "LC_namne" {
  type        = string
  description = "LaunchConfig name for the ASG"
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

variable "scale_down_threshold" {
  type        = string
  description = "scale_dwon threshold for the ASG policy"
}

variable "scale_up_threshold" {
  type        = string
  description = "scale_up threshold for the ASG policy"
}



