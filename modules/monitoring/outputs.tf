output "sns_topic_arn" {
  value       = aws_sns_topic.alerts.arn
  description = "SNS Topic ARN for CloudWatch alerts"
}

output "asg_cpu_alarm_name" {
  value       = aws_cloudwatch_metric_alarm.asg_cpu_alarm.alarm_name
  description = "Name of the ASG CPU utilization alarm"
}


#What This Adds

#📡 CloudWatch alarms for ASG and EC2 CPU usage
#📧 Email alerts via SNS
#🔒 Fully automated Terraform-managed monitoring stack