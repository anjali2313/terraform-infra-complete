#📘 Purpose: Create a secure, versioned, and encrypted S3 bucket used for:

#Application or log storage (EC2 uploads)

#Integration with IAM policies (for EC2 access)

#Terraform backend / artifact storage (optional)


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
# 2️⃣  Versioning
##########################
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

##########################
# 3️⃣  Encryption
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
# 4️⃣  Private Access (ACL)
##########################
resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
