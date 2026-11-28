terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "pathnex_ec2" {
  ami           = "ami-1234567890abcdef0"
  instance_type = "t2.micro"

  tags = {
    Owner = "PathnexStudent"
    Name  = "Pathnex-EC2"
  }
}
