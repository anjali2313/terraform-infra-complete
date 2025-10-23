variable "ami_id" {
  description = "Amazon Linux 2 AMI"
  type        = string
  default     = "ami-070e0d4707168fc07"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet where instances launch"
  type        = string
}

variable "app_sg_id" {
  description = "Security Group ID for EC2"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for EC2"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN from ALB"
  type        = string
}
