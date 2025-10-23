variable "vpc_id" {
  description = "VPC ID for the ALB"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID where the ALB will be placed"
  type        = string
}
