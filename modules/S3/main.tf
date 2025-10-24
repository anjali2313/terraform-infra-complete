# 📘 Purpose: Create a secure, versioned, and encrypted S3 bucket used for:
# - Application or log storage (EC2 uploads)
# - Integration with IAM policies (for EC2 access)
# - Terraform backend / artifact storage (optional)

##########################
# 1️⃣  S3 Bucket
##########################
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name      = var.bucket_name
    ManagedBy = "Terraform"
  }
}

##########################
# 2️⃣  Ownership Controls (separate resource)
##########################
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

##########################
# 3️⃣  Versioning
##########################
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

##########################
# 4️⃣  Encryption
##########################
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##########################
# 5️⃣  Block Public Access
##########################
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls        = true
  block_public_policy      = true
  ignore_public_acls       = true
  restrict_public_buckets  = true
}
