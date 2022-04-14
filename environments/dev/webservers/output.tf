# Step 10 - Add output variables
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}


output "bastion_sg" {
  value = aws_security_group.bastion_sg.id
}

output "nonprod_VM_ips" {
  value = aws_instance.nonprod_VM[*].private_ip
}