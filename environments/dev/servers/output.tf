
output "Dev_DNS_Name" {
  value = module.LB-Dev.LB_DNS_Name
}


output "Dev_Bastion_PublicIP" {
  value = aws_instance.bastion.public_ip
}