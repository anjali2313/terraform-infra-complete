

#Defines where your Terraform state is stored.

terraform {
  backend "s3" {
    bucket         = "anjali-tfstate-backend-2025"
    key            = "infra/terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

#Purpose:
#So your state file is centralized, versioned, and lock-protected (no local corruption).