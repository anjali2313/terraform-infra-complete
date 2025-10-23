terraform-project/
├── main.tf
├── provider.tf
├── variables.tf
├── outputs.tf
├── backend.tf
└── modules/
    ├── ec2/
    ├── s3/
    ├── ebs/
    ├── efs/
    ├── iam/
    ├── alb/
    └── asg/



## 🧩 **1️⃣ Root Level Files (the “control tower”)**

These files tell Terraform *how to behave globally*.

### **🗂️ `backend.tf`**

Defines where your Terraform state is stored.

📘 **Purpose:**
So your state file is **centralized**, versioned, and lock-protected (no local corruption).

---

### **🌏 `provider.tf`**

Defines AWS provider and version.

📘 **Purpose:**
Keeps provider setup separate and configurable for all modules.

---

### **⚙️ `variables.tf`**

Stores shared configuration.

📘 **Purpose:**
So region or EC2 key can be changed in one place.

---

### **📜 `main.tf`**

📘 **Purpose:**
This connects all infrastructure blocks — each one reusable and clean.

---

### **📤 `outputs.tf`**

Defines what gets displayed at the end.

```hcl
output "alb_dns_name" {
  value = module.alb.dns_name
}

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "ec2_instance_public_ip" {
  value = module.ec2.public_ip
}
```

📘 **Purpose:**
To easily get URLs, IPs, and resource info after deployment.

---

## 🧱 **2️⃣ Module-Level Organization**

Now every AWS resource type gets its **own folder** with:

```
main.tf
variables.tf
outputs.tf
```

Let’s explain each logically 👇

---

### **🌐 `modules/network/`**

Handles:

* VPC
* Public & Private Subnets
* Internet Gateway
* NAT Gateway
* Route Tables

**Goal:**
Provide networking foundation for EC2, ALB, EFS.

**Outputs:**
`vpc_id`, `public_subnet_id`, `private_subnet_id`

---

### **👤 `modules/iam/`**

Handles:

* IAM Role for EC2
* IAM Policy (S3 Access)
* Instance Profile

**Goal:**
Allow EC2 to access S3 securely.

**Outputs:**
`role_name`, `instance_profile_name`

---

### **🪣 `modules/s3/`**

Handles:

* S3 bucket creation
* Versioning
* Encryption
* ACL

**Goal:**
Store static data or logs, plus Terraform backend use.

**Outputs:**
`bucket_name`

---

### **💻 `modules/ec2/`**

Handles:

* EC2 instance
* Security Group
* User Data (install Nginx + upload hostname to S3)

**Goal:**
Deploy a working web instance tied to IAM + S3.

**Outputs:**
`instance_id`, `public_ip`, `sg_id`

---

### **💾 `modules/ebs/`**

Handles:

* Create EBS volume
* Attach to EC2
* Snapshot

**Goal:**
Provide persistent block storage + backup automation.

**Outputs:**
`snapshot_id`

---

### **📁 `modules/efs/`**

Handles:

* EFS File System
* Mount Targets
* EFS Security Group

**Goal:**
Shared file system across EC2s (useful for app data or shared configs).

**Outputs:**
`efs_id`

---

### **⚖️ `modules/alb/`**

Handles:

* ALB
* Target Group
* Listener

**Goal:**
Distribute web traffic to EC2 instances.

**Outputs:**
`dns_name`

---

## 🚀 **3️⃣ Benefits of This Modular Setup**

✅ Cleaner & reusable
✅ Easier debugging (each component is isolated)
✅ Plug-and-play structure for any company
✅ Perfectly compatible with Jenkins pipeline
✅ Future ready (can add monitoring, RDS, etc.)

