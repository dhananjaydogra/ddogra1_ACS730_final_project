
output "Prod_DNS_Name" {
  value = module.LB-Prod.LB_DNS_Name
}

output "Prod_Bastion_PublicIP" {
  value = aws_instance.bastion.public_ip
}