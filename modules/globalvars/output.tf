# Default tags
output "default_tags" {
  value = {
    "Owner" = "Dhananjay"
    "App"   = "ACS730-Project"
    "StudentId"="ddogra1"
  }
}

# Prefix to identify resources
output "prefix" {
  value     = "Group27"
}

# Your system's IP Address
output "my_ip" {
  value     = "76.67.96.119"
}

#Cloud9 IP Address
output "private_cloud9_ip" {
  value     = "172.31.10.170"
}

output "public_cloud9_ip" {
  value     = "44.195.78.249"

