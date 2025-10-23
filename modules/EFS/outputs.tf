output "efs_id" {
  value = aws_efs_file_system.this.id
}

output "efs_sg_id" {
  value = aws_security_group.efs_sg.id
}


#✅ What This Module Does

#✔ Creates an encrypted, versioned EFS filesystem
#✔ Builds NFS-2049-only security group (within VPC)
#✔ Mounts EFS to multiple subnets (both public & private)
#✔ Outputs file system ID and security group ID