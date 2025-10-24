

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

############################################################
# Create S3 bucket + DynamoDB backend automatically
############################################################

resource "aws_s3_bucket" "tf_backend" {
  bucket        = "anjali-tfstate-backend-2025"
  force_destroy = true

  tags = {
    Name        = "TFStateBackend"
    Environment = "Demo"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformStateLock"
  }
}


#Purpose:
#So your state file is centralized, versioned, and lock-protected (no local corruption).