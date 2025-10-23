#Stores shared configuration.

############################################################
# Environment Variable (Required by Jenkins pipeline)
############################################################
variable "environment" {
  description = "Environment name like dev, stage, or prod"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-northeast-1"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = "MyKeyPair"
}


#Purpose: So region or EC2 key can be changed in one place.