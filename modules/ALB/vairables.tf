############################################################
# Environment Variable
############################################################
variable "environment" {
  description = "Deployment environment name (e.g. dev, stage, prod)"
  type        = string
  default     = "dev"
}


variable "vpc_id" {
  description = "VPC ID where the ALB is deployed"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for the ALB"
  type        = string
}


