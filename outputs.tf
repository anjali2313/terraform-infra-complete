#Defines what gets displayed at the end.

# -------------------------
# Load Balancer Output
# -------------------------
output "alb_dns_name" {
  value       = module.alb.dns_name
  description = "Access your application using this ALB DNS name"
}

# -------------------------
# EC2 Instance Output
# -------------------------
output "ec2_instance_public_ip" {
  value       = module.ec2.public_ip
  description = "Public IP address of the main EC2 instance"
}

# -------------------------
# S3 Bucket Output
# -------------------------
output "s3_bucket_name" {
  value       = module.s3.bucket_name
  description = "Name of the S3 bucket used by EC2"
}

# -------------------------
# Auto Scaling Group Output
# -------------------------
output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of the Auto Scaling Group"
}

output "launch_template_id" {
  value       = module.asg.launch_template_id
  description = "ID of the Launch Template used by ASG"
}


#Purpose: To easily get URLs, IPs, and resource info after deployment.