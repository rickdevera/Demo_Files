variable "whitelist" {
  type = list(string)
}
variable "web_image_id" {
  type = string
}
variable "web_instance_type" {
  type = string
}
variable "web_desired_capacity" {
  type = number
}
variable "web_max_size" {
  type = number
}
variable "web_min_size" {
  type = number
}

provider "aws" {
  region  = "us-west-2"
  shared_credentials_files = [ "$HOME/.aws/credentials" ]
  profile = "demoprofile"
}

#  The configuration for the `remote` backend.
#  for runnining in github actions
#terraform {
#  backend "remote" {
#  # The name of your Terraform Cloud organization.
#    organization = "Tenable"

#    # The name of the Terraform Cloud workspace to store Terraform state files in.
#    workspaces {
#      name = "User-Demo-workspace"
#    }
#  }
#}

resource "aws_s3_bucket" "prod_tf_course" {
  bucket = "tf-course-mytest2020"
  acl    = "private"
  tags = {
    "Terraform" : "true"
    "DEMO" = "true"
  }

  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
    error_document = "error.html"

  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_default_vpc" "default" {
  tags = {
    "Terraform" : "True"
    "DEMO" = "true"
  }

}

resource "aws_default_subnet" "default_az1" {
  availability_zone = "us-west-2a"
  tags = {
    "Terraform" : "true"
    "DEMO" = "true"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = "us-west-2b"
  tags = {
    "Terraform" : "true"
    "DEMO" = "true"
  }
}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["172.31.0.0/28"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
//    cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["172.31.0.0/28"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" : "true"
    "DEMO" : "true"
  }
}