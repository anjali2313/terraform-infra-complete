#This is your orchestrator — it calls all submodules.

module "network" {
  source = "./modules/network"
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = "anjali-project-demo-bucket-2025"
}

module "iam" {
  source    = "./modules/iam"
  s3_bucket = module.s3.bucket_name
}

module "ec2" {
  source               = "./modules/ec2"
  key_name             = var.key_name
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.public_subnet_id
  iam_instance_profile = module.iam.instance_profile_name
  bucket_name          = module.s3.bucket_name
}

module "alb" {
  source           = "./modules/alb"
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_id
}

# ✅ Add this right after ALB
module "asg" {
  source               = "./modules/asg"
  ami_id               = "ami-070e0d4707168fc07"
  instance_type        = "t3.micro"
  key_name             = var.key_name
  subnet_id            = module.network.public_subnet_id
  app_sg_id            = module.ec2.sg_id
  iam_instance_profile = module.iam.instance_profile_name
  target_group_arn     = module.alb.target_group_arn
}

module "monitoring" {
  source           = "./modules/monitoring"
  asg_name         = module.asg.asg_name
  instance_id      = module.ec2.instance_id
  alert_email      = "brittobaby2313@gmail.com"
  enable_ec2_alarm = true
}

#Purpose: This connects all infrastructure blocks — each one reusable and clean.