## Slurm

variable "db_root_password" {
  default = ""
}

variable "db_user_password" {
  default = ""
}

## Studio

variable "studio_name" {
  default = "Studio1767"
}

variable "studio_code" {
  default = "s1767"
}

variable "studio_domain" {
  default = "example.xyz"
}

variable "num_workers" {
  default = 1
}

## Network

data "external" "my_public_ip" {
  program = ["scripts/my-public-ip.sh"]
}

locals {
  management_ip  = data.external.my_public_ip.result["my_public_ip"]
  management_net = "${local.management_ip}/32"
}

variable "vpc_cidr_block" {
  type = string
  default = "10.16.0.0/16"
}

variable "subnet_cidr_blocks" {
  type = map(string)
  default = {
    public = "10.16.0.0/24"
    private = "10.16.16.0/20"
  }
}

## AWS settings

variable "aws_profile" {
  default = ""
}

variable "aws_region" {
  default = ""
}

data "aws_availability_zones" "site" {
  state = "available"
}

locals {
  num_zones = length(data.aws_availability_zones.site.names)
  aws_availability_zone = element(data.aws_availability_zones.site.names, local.num_zones - 1)
}

variable "aws_instance_type" {
  default = "t3a.micro"
}

