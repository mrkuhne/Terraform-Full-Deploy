variable "environment" {
  description     = "The environment specifically used for an instance"
  type            = string
  default         = "dev"
}

variable "ami" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "vpc_id" {}
