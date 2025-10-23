output "volume_id" {
  value = aws_ebs_volume.this.id
}

output "snapshot_id" {
  value = aws_ebs_snapshot.backup.id
}




#✅ What This Module Does

#✔ Creates an EBS volume (default 10 GiB gp3)
#✔ Attaches the volume to the specified EC2 instance
#✔ Takes a snapshot after attachment for backup
#✔ Outputs volume ID and snapshot ID for monitoring or copy across regions