output "Seminar_2a_public_id" {
  value = aws_subnet.Seminar_2a_public.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "Seminar_2a_private_id" {
  value = aws_subnet.Seminar_2a_private.id
  
}

output "security_group_id" {
  value = aws_security_group.private_ec2_sg.id
}

output "Seminar_2c_private_id" {
  value = aws_subnet.Seminar_2c_private.id
  
}

output "Seminar_VPC_id" {
  value = aws_vpc.Seminar_VPC.id  
}

output "private_route_table_id" {
  value = aws_route_table.private_route_table.id
}
output "public_route_table_id" {
  value = aws_route_table.public_route_table.id
}