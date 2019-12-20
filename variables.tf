# AWS specific variables
variable "region" {
  default = "us-east-1"
}

# Project specific variables
variable "namespace" {
  default = "demo"
}

variable "datacenter" {
  default = "dc1"
}

variable "key_name" {
  default = ""
}

variable "instance_type" {
  default = "c5.large"
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_security_group_ids" {
  default = ""
}

# Consul variables
variable "consul_version" {
  default = "1.1.0"
}

variable "consul_server_count" {
  default = "3"
}

variable "retry_join_tag" {
  default = "consul"
}

variable "username" {
  default = "ubuntu"
}

