output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "DNS name of the Application Load Balancer"
}

output "alb_sg_id" {
  value       = aws_security_group.alb_sg.id
  description = "Security Group ID of the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.this.arn
  description = "Target Group ARN for EC2 instances"
}
output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}


#✅ What This Module Does

#✔ Creates a security group for HTTP traffic
#✔ Builds an Application Load Balancer (public-facing)
#✔ Defines a target group and health checks
#✔ Attaches a listener that forwards traffic to targets
#✔ Outputs the ALB DNS name for easy access