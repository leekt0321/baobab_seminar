# CVO Connector
terraform {
  required_providers {
    netapp-cloudmanager = {
      source = "netApp/netapp-cloudmanager"
      version = "~> 25.3.0"
    }
  }
}

resource "netapp-cloudmanager_connector_aws" "CVO_connector_aws" {
  provider = netapp-cloudmanager
  name = "Terraform-ConnectorAWS"
  region = var.aws_region
  key_name = var.aws_connector_key
  company = "baobab"
  instance_type = "t3.xlarge"
  aws_tag {
              tag_key = "bluexp"
              tag_value = "CVO_connector"
            }
  subnet_id = aws_subnet.Seminar_2a_private.id
  security_group_id = aws_security_group.private_ec2_sg.id
  iam_instance_profile_name = aws_iam_instance_profile.cvo_connector_EC2_profile.name
  depends_on = [aws_internet_gateway.Seminar_IGW, aws_key_pair.connector_key]
}
resource "null_resource" "wait_for_connector" {
  depends_on = [ netapp-cloudmanager_connector_aws.CVO_connector_aws ]
  provisioner "local-exec" {
    command = "echo 'Waiting for connector'; sleep 30"
    
  }
}