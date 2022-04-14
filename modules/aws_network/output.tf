# Add output variables
output "public_subnet_ids" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnet[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_route_table_id" {
    value=aws_route_table.public_route_table[*].id
}

output "prod_private_route_table_id" {
    value=aws_route_table.prod_private_route_table[*].id
}