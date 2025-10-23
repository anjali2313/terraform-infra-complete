variable "asg_name" {
  description = "Name of the Auto Scaling Group to monitor"
  type        = string
}

variable "instance_id" {
  description = "EC2 instance ID (optional for individual alarm)"
  type        = string
  default     = ""
}

variable "alert_email" {
  description = "Email address to receive alert notifications"
  type        = string
}

variable "enable_ec2_alarm" {
  description = "Set true to enable EC2 CPU alarm"
  type        = bool
  default     = false
}
