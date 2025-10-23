variable "vpc_id" {
  description = "VPC ID where EFS will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC for access control"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "efs_name" {
  description = "Name for the EFS file system"
  type        = string
  default     = "SharedEFS"
}
