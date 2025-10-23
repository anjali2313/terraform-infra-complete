output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}


#✅ What This Module Does

#Creates an isolated VPC
#Adds both public and private subnets
#Connects the public subnet to the Internet Gateway
#Allows private subnet to reach Internet via NAT
#Outputs VPC and Subnet IDs for other modules (EC2, EFS, etc.)
