#📘 Purpose: To create a shared, scalable file system mounted across multiple subnets and secured by a dedicated security group.

##########################
# 1️⃣ Security Group for EFS
##########################
resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "Allow NFS (2049) access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow NFS traffic from within VPC"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "EFS-SG" }
}

##########################
# 2️⃣ Create EFS File System
##########################
resource "aws_efs_file_system" "this" {
  encrypted = true

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name      = var.efs_name
    ManagedBy = "Terraform"
  }
}

##########################
# 3️⃣ Mount Targets (Public + Private Subnets)
##########################
resource "aws_efs_mount_target" "this" {
  for_each = toset(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = each.value
  security_groups = [aws_security_group.efs_sg.id]
}
