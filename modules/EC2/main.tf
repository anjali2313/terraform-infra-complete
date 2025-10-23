#Purpose: Provision an EC2 instance that:

#runs in your network (from the network module),

#uses the IAM role (from the iam module),

#connects to the S3 bucket (from the s3 module), and

#installs Nginx automatically on launch.


##########################
# 1️⃣ Security Group
##########################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "EC2-SG" }
}

##########################
# 2️⃣ EC2 Instance
##########################
resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = <<-EOF
              #!/bin/bash
              yum install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "Hello from $(hostname)" > /usr/share/nginx/html/index.html
              aws s3 cp /etc/hostname s3://${var.bucket_name}/ec2-hostname.txt
              EOF

  tags = {
    Name = "DemoEC2"
  }
}
