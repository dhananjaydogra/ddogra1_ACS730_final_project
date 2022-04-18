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
# VPC IDs  required by the SecurityGroup
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}



# which type of SecurityGroup
variable "type" {
  type        = string
  description = "type of sg"
}

# Define the Ingress cidr blocks for the Security Group 
variable "ingress_cidr" {
  default     = []
  type        = list(string)
  description = "Ingress Cidr blocks for Security Group"
}

# Define the  Egress cidr blocks for the Security Group 
variable "egress_cidr" {
  default     = []
  type        = list(string)
  description = "Ingress Cidr blocks for Security Group"
}


# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

