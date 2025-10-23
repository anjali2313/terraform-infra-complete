#EBS and Snapshot

#Purpose: To provision an EBS volume that attaches to your EC2 instance and take automated snapshots 
# (for daily backup or disaster recovery).

##########################
# 1️⃣  Create EBS Volume
##########################
resource "aws_ebs_volume" "this" {
  availability_zone = var.availability_zone
  size              = var.size
  type              = var.type

  tags = {
    Name      = var.volume_name
    ManagedBy = "Terraform"
  }
}

##########################
# 2️⃣  Attach EBS to EC2
##########################
resource "aws_volume_attachment" "this" {
  device_name  = var.device_name
  volume_id    = aws_ebs_volume.this.id
  instance_id  = var.instance_id
  force_detach = true
}

##########################
# 3️⃣  Create Snapshot (Backup)
##########################
resource "aws_ebs_snapshot" "backup" {
  volume_id   = aws_ebs_volume.this.id
  description = "Automated snapshot of ${var.volume_name}"

  tags = {
    Name      = "${var.volume_name}-snapshot"
    CreatedBy = "Terraform"
  }

  depends_on = [aws_volume_attachment.this]
}
