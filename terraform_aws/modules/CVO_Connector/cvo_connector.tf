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
  subnet_id = var.Seminar_2a_private_id
  security_group_id = var.security_group_id
  iam_instance_profile_name = var.cvo_connector_EC2_profile_name
}
resource "null_resource" "wait_for_connector" {
  depends_on = [ netapp-cloudmanager_connector_aws.CVO_connector_aws ]
  provisioner "local-exec" {
    command = "echo 'Waiting for connector'; sleep 30"
    
  }
}