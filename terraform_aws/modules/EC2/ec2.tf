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

  provisioner "local-exec" {  // 로컬에서 실행하는 것이고 bastion에서 실행되는 것이 아님. bastion에 키 전달은 수동으로 하는걸 권장, User Data로 전달은 보안상 위험
  ### terraform apply 후 해당 명령어 실행
  # scp -i seminar_key.pem seminar_key.pem ec2-user@<public_IP>:~
  ### 
    command = <<EOT
    echo "${tls_private_key.ssh_key.private_key_pem}" > seminar-key.pem
    chmod 400 seminar-key.pem
    echo "seminar-key.pem 생성 완료"
    EOT
    interpreter = [ "/bin/bash", "-c" ]
  }
  provisioner "local-exec" {
    command = <<EOT
    echo "${tls_private_key.ssh_connector_key.private_key_pem}" > connector-key.pem
    chmod 400 connector-key.pem
    echo "connector-key.pem 생성 완료"
    EOT
    interpreter = [ "/bin/bash", "-c" ]
  }
  provisioner "local-exec" {
    //when = create
    command = <<EOT
    echo "${tls_private_key.ssh_mediator_key.private_key_pem}" > mediator-key.pem
    chmod 400 mediator-key.pem
    echo "mediator-key.pem 생성 완료"
    EOT
    interpreter = [ "/bin/bash", "-c" ]
  }
}