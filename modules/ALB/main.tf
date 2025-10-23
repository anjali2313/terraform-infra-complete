
#Goal: Create an ALB, Target Group, and Listener so that traffic can reach your EC2 instances securely and efficiently.

##########################
# 1️⃣  ALB Security Group
##########################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP access to ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "ALB-SG"
    ManagedBy = "Terraform"
  }
}

##########################
# 2️⃣  Application Load Balancer
##########################
resource "aws_lb" "app_alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_id]

  enable_deletion_protection = false

  tags = {
    Name      = "DemoALB"
    ManagedBy = "Terraform"
  }
}

##########################
# 3️⃣  Target Group
##########################
resource "aws_lb_target_group" "app_tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200-399"
  }

  tags = {
    Name      = "DemoTG"
    ManagedBy = "Terraform"
  }
}

##########################
# 4️⃣  Listener
##########################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
