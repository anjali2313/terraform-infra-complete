#Defines AWS provider and version.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.17.0"
    }
  }
}

provider "aws" {
  region = var.region
}

#zPurpose:
#Keeps provider setup separate and configurable for all modules.