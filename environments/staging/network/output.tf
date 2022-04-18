#Adding the VPC_ID
output "Staging_Vpc_Id" {
  value = module.vpc-Staging.vpc_id
}

output "Staging_Public_Subnet_Ids" {
  value = module.vpc-Staging.public_subnet_ids
}

output "Staging_Private_Subnet_Ids" {
  value = module.vpc-Staging.private_subnet_ids
}
