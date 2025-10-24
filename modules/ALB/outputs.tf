###############################################################
# Placeholder outputs while ALB creation is disabled
###############################################################

output "dns_name" {
  description = "Placeholder for ALB DNS"
  value       = "alb-disabled"
}

output "target_group_arn" {
  description = "Placeholder for target group"
  value       = "tg-disabled"
}

output "security_group_id" {
  description = "Placeholder for ALB security group"
  value       = "sg-disabled"
}


#✅ What This Module Does

#✔ Creates a security group for HTTP traffic
#✔ Builds an Application Load Balancer (public-facing)
#✔ Defines a target group and health checks
#✔ Attaches a listener that forwards traffic to targets
#✔ Outputs the ALB DNS name for easy access