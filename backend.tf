############################################################
# 📘 Purpose: Define where Terraform stores the remote state
############################################################

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
# 🧩 Backend Resources (created manually or via init stage)
############################################################
# These are already created by your Jenkins "Prepare Backend" stage,
# so we comment them out to avoid 'already exists' errors.

# resource "aws_s3_bucket" "tf_backend" {
#   bucket        = "anjali-tfstate-backend-2025"
#   force_destroy = true
#
#   tags = {
#     Name        = "TFStateBackend"
#     Environment = "Demo"
#   }
# }
#
# resource "aws_dynamodb_table" "tf_lock" {
#   name         = "terraform-locks"
#   billing_mode = "PAY_PER_REQUEST"
#   hash_key     = "LockID"
#
#   attribute {
#     name = "LockID"
#     type = "S"
#   }
#
#   tags = {
#     Name = "TerraformStateLock"
#   }
# }

# ✅ This file now only *uses* the backend, not *creates* it.
# The bucket and table already exist, so no duplication or 409/400 errors.
