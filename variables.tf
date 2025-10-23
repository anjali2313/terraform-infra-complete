#Stores shared configuration.


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