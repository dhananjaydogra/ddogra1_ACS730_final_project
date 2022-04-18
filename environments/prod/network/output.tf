#Adding the VPC_ID
output "Prod_Vpc_Id" {
  value = module.vpc-Prod.vpc_id
}

output "Prod_Public_Subnet_Ids" {
  value = module.vpc-Prod.public_subnet_ids
}

output "Prod_Private_Subnet_Ids" {
  value = module.vpc-Prod.private_subnet_ids
}
