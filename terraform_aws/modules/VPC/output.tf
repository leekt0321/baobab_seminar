output "Seminar_2a_public_id" {
  value = aws_subnet.Seminar_2a_public.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}