output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "sg_id" {
  value = aws_security_group.ec2_sg.id
}


#✅ What This Module Does

#✔ Creates a security group (HTTP + SSH)
#✔ Deploys an EC2 instance using your VPC and IAM profile
#✔ Installs Nginx and uploads the hostname to S3
#✔ Outputs the instance ID + public IP + SG ID