# EC2
resource "aws_instance" "bastion_ec2" {  # AMI는 계속 바뀌므로 data resource 사용 권장 지금은 test이므로 그냥 사용
  ami                         = "ami-0c803b171269e2d72" # Amazon Linux 2 (예시)
  instance_type               = var.aws_instance_type
  subnet_id                   = aws_subnet.Seminar_2a_public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = aws_key_pair.bastion_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "BastionHost"
  }
}
