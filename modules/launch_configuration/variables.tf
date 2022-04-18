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

# Instance type required by the Launch Configuration
variable "instance_type" {
  type        = string
  description = "instance_type for the webserver"
}

variable "ami_id" {
  type = string
  description = "AMI ID for the launch_configuration"
}

variable "key_name" {
  type = string
  description = "Key Name for the launch_configuration"
}

# the Security Group IDs for the LaunchConfig
variable "security_group_id" {
  default     = []
  type        = list(string)
  description = "Security Group ID"
}



# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}

