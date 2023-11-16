terraform {
    backend "s3" {
    bucket         = "committed-todo-app-prometheus-tf-state"
    key            = "03-basics/web-app/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }

    required_providers {
    aws = {
        source      = "hashicorp/aws"
        version     = "~> 5.20.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
  access_key = "AKIARHTOOXUH7BG6ZXQL"
  secret_key = "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"
}

locals {
  environment_name = terraform.workspace
}

module "todo_app" {
  source = "../todo-app-modules"
  environment     = local.environment_name
  instance_type   = "t2.micro"
  ami             = "ami-04e601abe3e1a910f"
  instance_count  = 1
  database_name   = "todo_db_${local.environment_name}"
  database_port   = "3306"
  database_user   = "root"
  database_pass   = "password"
  db_exists       = false # should only be false at FIRST run!yes
  bucket_name     = "committed-todo-app-${local.environment_name}-bucket"
}

module "prometheus" {
  source            = "../prometheus-modules"
  vpc_id            = module.todo_app.vpc_id
  environment       = local.environment_name
  instance_type     = "t2.micro"
  ami               = "ami-04e601abe3e1a910f"
  depends_on        = [module.todo_app]
}
