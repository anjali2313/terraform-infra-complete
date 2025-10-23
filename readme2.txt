🪜 Step 1 – Initialize Terraform
terraform init


✅ This downloads providers, sets up the backend (S3 + DynamoDB), and prepares the workspace.
If you changed your backend recently, add -reconfigure:

terraform init -reconfigure

🪜 Step 2 – Check syntax and formatting
terraform fmt -recursive


✅ This auto-formats all .tf files inside your root + modules.
Then validate:

terraform validate


✅ This checks for syntax errors, variable mismatches, and provider blocks.

🪜 Step 3 – Create a plan
terraform plan -out=tfplan


✅ This shows what Terraform will create.
If everything looks correct (no errors, expected resource list), you’re ready to apply.

🪜 Step 4 – Apply infrastructure
terraform apply tfplan


✅ This will actually provision your AWS resources (VPC, EC2, S3, IAM, etc.)

When finished, confirm your outputs:

terraform output


You should see:

alb_dns_name

ec2_instance_public_ip

s3_bucket