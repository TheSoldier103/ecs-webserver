# Define variables with default values and descriptions

variable "aws_account" {
  description = "The AWS account ID"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
}

variable "private_subnet_1" {
  description = "The CIDR block for the first private subnet"
}

variable "availability_zone_1" {
  description = "The availability zone for the first private subnet"
}

variable "private_subnet_2" {
  description = "The CIDR block for the second private subnet"
}

variable "availability_zone_2" {
  description = "The availability zone for the second private subnet"
}

variable "public_subnet_1" {
  description = "The CIDR block for the first public subnet"
}

variable "public_subnet_2" {
  description = "The CIDR block for the second public subnet"
}

variable "container_port" {
  description = "The port number on which the container listens"
}

variable "domain" {
  description = "The domain of your public URL"
}

variable "sub-domain" {
  description = "The sub-domain for your public URL"
}