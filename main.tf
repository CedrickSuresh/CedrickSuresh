# Terraform Block
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27"
    }
  }
}
# Provider Block
provider "aws" {
  region = "eu-west-1"
  
}

# Data Source block

//Get aws instance details
data "aws_instance" "source_instance" {
  instance_id               = var.source_instance_id
}
# Output Block

output "source_instance" {
  value                     = "${data.aws_instance.source_instance}"
  description               = "Source Instance Details"
}

# AMI Creation Block
resource "aws_ami_from_instance" "sourceami" {
  name                      = "source-instance"
  source_instance_id        = var.source_instance_id
}

# Instance Creation Block

resource "aws_instance" "newinstance" {
    ami                     = aws_ami_from_instance.sourceami.id
    instance_type           = data.aws_instance.source_instance.instance_type
    vpc_security_group_ids  = data.aws_instance.source_instance.vpc_security_group_ids
    subnet_id               = data.aws_instance.source_instance.subnet_id
    tags                    = var.resource_tags
    key_name                = data.aws_ami_from_instance.key_name
    iam_instance_profile    = data.aws_ami_from_instance.iam_instance_profile
   # user_data               = "${file("userdata_powershell.ps1")}"  // for single user data

}   
# Template for multiple userdata scripts

    data "template_file" "user_datapowershell" {
    count        = var.user_data ? 1 : 0
    template = <<EOF
    <powershell>
     start-process powershell -verb runas -Force
     Rename-Computer -NewName ${var.hostname} -Force -Restart
     Stop-Service -Name "SonarQube" -Force
    </powershell>
   EOF
   }
   data "template_file" "user_databash"{
    count        = var.userdata ? 0 : 1
     template = <<EOF
     #!/bin/bash
     hostnamectl set-hostname ${var.hostname}
     sudo systemctl stop SonarQube

     EOF
   }

