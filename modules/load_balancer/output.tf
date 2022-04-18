# Add output variable for LB DNS Name

output "LB_DNS_Name" {
  value= aws_lb.Group9_Project_LB.dns_name
}


# Add output variable for LB ID value
output "LB_id" {
  value=aws_lb.Group9_Project_LB.id
}