###############################################################
# ALB module temporarily disabled due to AWS ALB restriction.
# Uncomment later once AWS enables Elastic Load Balancing.
###############################################################

# resource "aws_security_group" "alb_sg" {
#   name        = "alb-sg"
#   description = "Allow HTTP access to ALB"
#   vpc_id      = var.vpc_id
#
#   ingress {
#     description = "Allow HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#
#   tags = {
#     Name      = "ALB-SG"
#     ManagedBy = "Terraform"
#   }
# }
#
# resource "aws_lb" "app_alb" { ... }
# resource "aws_lb_target_group" "app_tg" { ... }
# resource "aws_lb_listener" "http" { ... }
#
# output "alb_dns_name" {
#   value = "ALB temporarily disabled"
# }

###############################################################
# Temporary placeholder output to keep Terraform valid
###############################################################
output "alb_dns_name" {
  description = "Placeholder while ALB disabled"
  value       = "ALB-disabled-temporarily"
}
