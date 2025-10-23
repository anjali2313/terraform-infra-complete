output "dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  description = "Target group ARN for ASG"
  value       = aws_lb_target_group.app_tg.arn
}

output "security_group_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb_sg.id
}


#✅ What This Module Does

#✔ Creates a security group for HTTP traffic
#✔ Builds an Application Load Balancer (public-facing)
#✔ Defines a target group and health checks
#✔ Attaches a listener that forwards traffic to targets
#✔ Outputs the ALB DNS name for easy access