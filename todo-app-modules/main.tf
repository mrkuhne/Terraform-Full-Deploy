terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.20.0"
    }
  }
}

data "aws_availability_zones" "availability_zones" {
    state = "available"
}