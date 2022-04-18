#Adding the VPC_ID
output "Dev_Vpc_Id" {
  value = module.vpc-Dev.vpc_id
}

output "Dev_Public_Subnet_Ids" {
  value = module.vpc-Dev.public_subnet_ids
}

output "Dev_Private_Subnet_Ids" {
  value = module.vpc-Dev.private_subnet_ids
}
