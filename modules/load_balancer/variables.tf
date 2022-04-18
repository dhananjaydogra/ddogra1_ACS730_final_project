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

# Public subnet IDs  required by the Load Balancer
variable "public_subnet_ids" {
  default     = []
  type        = list(string)
  description = "Public Subnet IDs"
}

# Define the Security Group for the Load Balancer
variable "security_group_id" {
  default     = []
  type        = list(string)
  description = "Security Group ID"
}

# Get the Target Group ARN for the Load Balancer
variable "target_Grp_Arn" {
  type        = string
  description = "Target Group ARN for the Load Balancer"
}




# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

