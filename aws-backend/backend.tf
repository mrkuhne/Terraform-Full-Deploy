terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.20.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "terraform-state" {
    bucket        = "committed-todo-app-prometheus-tf-state"
    force_destroy = true
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
    bucket      = aws_s3_bucket.terraform-state.id
    versioning_configuration {
      status    = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto_conf" {
  bucket            = aws_s3_bucket.terraform-state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket" "environment_variables" {
    bucket        = "committed-todo-app-environment-variables"
    force_destroy = true
}


resource "aws_s3_bucket_versioning" "environment_variables_versioning" {
    bucket      = aws_s3_bucket.environment_variables.bucket
    versioning_configuration {
      status    = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "environment_variables_crypto_conf" {
  bucket = aws_s3_bucket.environment_variables.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
