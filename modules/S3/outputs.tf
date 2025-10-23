output "bucket_name" {
  value = aws_s3_bucket.this.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.this.arn
}



#✅ What This Module Does

#✔ Creates an S3 bucket
#✔ Enables versioning for rollback / file history
#✔ Enforces server-side encryption (AES-256)
#✔ Sets ACL to private (fully restricted)
#✔ Outputs both bucket name and ARN for other modules