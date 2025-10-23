#Goal: Create:

#IAM Role for EC2

#IAM Policy to allow EC2 → S3 access

#Attach policy to role

#Create Instance Profile (so EC2 can assume the role)


##########################
# 1️⃣  IAM Role for EC2
##########################
resource "aws_iam_role" "ec2_role" {
  name = "EC2AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name      = "EC2AccessRole"
    ManagedBy = "Terraform"
  }
}

##########################
# 2️⃣  IAM Policy – S3 + EFS + CloudWatch
##########################
resource "aws_iam_policy" "ec2_policy" {
  name        = "EC2BaseAccessPolicy"
  description = "Allow EC2 to use S3, EFS and CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket", "s3:GetObject", "s3:PutObject"],
        Resource = ["arn:aws:s3:::${var.s3_bucket}", "arn:aws:s3:::${var.s3_bucket}/*"]
      },
      {
        Effect   = "Allow"
        Action   = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite"],
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Resource = "*"
      }
    ]
  })
}

##########################
# 3️⃣  Attach Policy → Role
##########################
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

##########################
# 4️⃣  Instance Profile
##########################
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}
