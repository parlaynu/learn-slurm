terraform {  
  required_version = ">= 1.4.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.66"
    }
  }
}

provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
}
