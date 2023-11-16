variable "aws_region" {
  default = "eu-west-3"
}

variable "vpc_cidr_block" {
  description     = "CIDR block for VPC"
  type            = string
  default         = "10.0.0.0/16"
}

variable "subnet_count" {
  description     = "Number of subnets per type created"
  type            = map(number)
  default         = {
    "public"      = 2,
    "private"     = 2
  }
}

variable "instance_count" {
  description = "Number of ec2 instances created"
  type        = number
  default     = 1
}

variable "public_subnet_cidr_blocks" {
    description   = "Available CIDR blocks for public subnets"
    type          =  list(string)
    default       = [ 
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24",
        "10.0.4.0/24"
        ]
}

variable "private_subnet_cidr_blocks" {
    description   = "Available CIDR blocks for private subnets"
    type          =  list(string)
    default       = [ 
        "10.0.101.0/24",
        "10.0.102.0/24",
        "10.0.103.0/24",
        "10.0.104.0/24"
        ]
}

variable "ami" {
    description   = "Amazon machine image to use for the es2 instance" 
    type          = string
    default       = "ami-05b5a865c3579bbc4"
}

variable "instance_type" {
    description   = "The ec2 instance type"
    type          = string
    default       = "t2.micro"
}

variable "environment" {
  description     = "The environment specifically used for an instance"
  type            = string
  default         = "dev"
}

variable "database_name" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_pass" {
  type = string
}

variable "database_port" {
  type = string
}

variable "db_exists" {
  description = "If true uses the available database, if false creates one"
  type        = bool
  default     = true
}

variable "bucket_name" {
  type        = string
}
