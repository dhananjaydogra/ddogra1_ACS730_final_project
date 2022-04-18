
# Add output variable for SecurityGroup ID value
output "LB_SG_id" {
  value=aws_security_group.Group27_Project_LB_SG[*].id
}
output "EC2_SG_id" {
  value=aws_security_group.Group27_Project_EC2_SG[*].id
}

output "BS_SG_id" {
  value=aws_security_group.Group27_Project_Bastion_SG[*].id
}  