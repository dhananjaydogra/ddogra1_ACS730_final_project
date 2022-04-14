# Instance type
variable "instance_type" {
  default = {
    "prod"    = "t3.medium"
    "test"    = "t3.micro"
    "staging" = "t3.small"
    "dev"     = "t3.micro"
    "nonprod" = "t2.micro"
  }
  description = "Type of the instance"
  type        = map(string)
}

# Variable to signal the current environment 
variable "env" {
  default     = "dev"
  type        = string
  description = "Deployment Environment"
}


variable "private_cloud9_ip" {
  default     = "172.31.3.9"
  type        = string
  description = "Private IP of Cloud9 Environment"
}

variable "public_cloud9_ip" {
  default     = "35.170.67.242"
  type        = string
  description = "Public IP of Cloud9 Environment"
}



