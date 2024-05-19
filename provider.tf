terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "5.50.0"
        }
    }
}

provider "aws" {
    access_key = var.access_key
    region     = "eu-west-3"
    secret_key = var.secret_key
}
