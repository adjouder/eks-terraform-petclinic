terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = ">= 2.7.0, < 4.3.0"
        }
    }
}

provider "aws" {
    access_key = var.access_key
    region     = "eu-west-3"
    secret_key = var.secret_key
}
