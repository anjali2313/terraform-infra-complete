output "role_name" {
  value = aws_iam_role.ec2_role.name
}

output "policy_arn" {
  value = aws_iam_policy.ec2_policy.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}



#✅ What This Module Does

#Creates a secure IAM role for EC2.
#Defines a policy that allows access to a specific S3 bucket (read/write/list).
#Creates an instance profile, which EC2 uses to assume this role.
#Outputs the role name and profile name for use in the EC2 module
