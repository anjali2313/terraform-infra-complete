#Purpose

#Continuously watch CPU usage of your EC2 / ASG

#Trigger alerts by email when utilization crosses a threshold

#Enable simple auto-scaling or operational awareness



##########################
# 1️⃣ SNS Topic & Subscription
##########################
resource "aws_sns_topic" "alerts" {
  name = "infra-alerts-topic"
  tags = {
    Name       = "InfraAlertsTopic"
    ManagedBy  = "Terraform"
  }
}

# 🔔 Email Subscription
resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

##########################
# 2️⃣ CloudWatch Alarm – ASG CPU
##########################
resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm" {
  alarm_name          = "ASG-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Alert when average ASG CPU exceeds 70%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Name       = "ASG-CPU-Alarm"
    ManagedBy  = "Terraform"
  }
}

##########################
# 3️⃣ CloudWatch Alarm – EC2 Instance (Optional)
##########################
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  count               = var.enable_ec2_alarm ? 1 : 0
  alarm_name          = "EC2-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when individual EC2 CPU > 80%"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = var.instance_id
  }

  tags = {
    Name       = "EC2-CPU-Alarm"
    ManagedBy  = "Terraform"
  }
}






