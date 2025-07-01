# output.tf
output "instance_public_ip"{
  description = "EC2 인스턴스 퍼블릭 IP 주소"
  value = aws_instance.bastion_ec2.public_ip
}
output "private_key" { // key 값 노출 방지
  value = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}
output "CVO_connector_ec2_private_ip" {
  description = "CVO connector ec2 인스턴스 프라이빗 ip 주소"
  value = data.aws_instance.connector_ec2.private_ip
}