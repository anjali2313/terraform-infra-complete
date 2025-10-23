##########################
# 1️⃣  Launch Template
##########################
resource "aws_launch_template" "this" {
  name_prefix   = "demo-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [var.app_sg_id]

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name      = "ASG-Instance"
      ManagedBy = "Terraform"
    }
  }

  tags = {
    Name      = "DemoLaunchTemplate"
    ManagedBy = "Terraform"
  }
}

##########################
# 2️⃣  Auto Scaling Group
##########################
resource "aws_autoscaling_group" "this" {
  name                      = "demo-asg"
  vpc_zone_identifier       = [var.subnet_id]
  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 3
  health_check_type         = "ELB"
  target_group_arns         = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  # ✅ Tags must be in 'tag {}' blocks for ASG (not 'tags = {}')
  tag {
    key                 = "Name"
    value               = "Demo-ASG-Instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

##########################
# 3️⃣  Scaling Policy (CPU-based)
##########################
resource "aws_autoscaling_policy" "cpu_target" {
  name                   = "cpu-target-policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50
  }

  depends_on = [aws_autoscaling_group.this]
}



#it will automatically:
#✅ Create the launch template
#✅ Spin up an Auto Scaling Group (1–3 instances)
#✅ Register with your ALB target group
#✅ Add a CPU utilization scaling policy