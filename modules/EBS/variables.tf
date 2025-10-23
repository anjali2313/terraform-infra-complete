variable "availability_zone" {
  description = "Availability zone for EBS volume"
  type        = string
}

variable "size" {
  description = "Volume size in GiB"
  type        = number
  default     = 10
}

variable "type" {
  description = "Volume type (gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "device_name" {
  description = "Device name to attach (e.g. /dev/sdf)"
  type        = string
  default     = "/dev/sdf"
}

variable "instance_id" {
  description = "EC2 instance ID to attach the volume to"
  type        = string
}

variable "volume_name" {
  description = "Name tag for the EBS volume"
  type        = string
  default     = "DemoEBSVolume"
}
