// ============================================================
// Terraform CI/CD Pipeline using Jenkins
// Supports: plan, apply, destroy
// Backend: AWS S3 + DynamoDB
// Parameters: Environment & Action selection
// Tested on Jenkins 2.528+
// ============================================================

pipeline {
    agent any

    // ---------- Pipeline Options ----------
    options {
        timestamps() // adds timestamps to logs for better tracing
        // ansiColor('xterm') // optional: enable if plugin installed
    }

    // ---------- Environment Variables ----------
    environment {
        AWS_ACCESS_KEY_ID     = credentials('new-id')      // Jenkins credential ID
        AWS_SECRET_ACCESS_KEY = credentials('sec-key')     // Jenkins credential secret
        AWS_DEFAULT_REGION    = 'ap-northeast-1'           // AWS region
        BACKEND_BUCKET        = 'anjali-tfstate-backend-2025' // S3 backend bucket
        BACKEND_TABLE         = 'terraform-locks'          // DynamoDB lock table
    }

    // ---------- Build Parameters ----------
    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action')
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    }

    // ---------- Pipeline Stages ----------
    stages {

        // 1️⃣ Checkout Code
        stage('Checkout Code') {
            steps {
                echo "📦 Checking out repository..."
                cleanWs()             // clean workspace
                checkout scm          // fetch repo from GitHub
            }
        }

        // 2️⃣ Prepare Backend (S3 + DynamoDB)
        stage('Prepare Backend') {
            steps {
                echo "☁️ Checking and creating backend if missing..."
                sh '''
                set -e
                if ! aws s3api head-bucket --bucket $BACKEND_BUCKET 2>/dev/null; then
                    echo "🪣 Creating S3 bucket: $BACKEND_BUCKET"
                    aws s3api create-bucket --bucket $BACKEND_BUCKET \
                        --region $AWS_DEFAULT_REGION \
                        --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
                else
                    echo "✅ S3 bucket already exists: $BACKEND_BUCKET"
                fi

                if ! aws dynamodb describe-table --table-name $BACKEND_TABLE 2>/dev/null; then
                    echo "🧱 Creating DynamoDB table: $BACKEND_TABLE"
                    aws dynamodb create-table \
                        --table-name $BACKEND_TABLE \
                        --attribute-definitions AttributeName=LockID,AttributeType=S \
                        --key-schema AttributeName=LockID,KeyType=HASH \
                        --billing-mode PAY_PER_REQUEST
                else
                    echo "✅ DynamoDB table already exists: $BACKEND_TABLE"
                fi
                '''
            }
        }

        // 3️⃣ Initialize Terraform
        stage('Init Terraform') {
            steps {
                echo "🚀 Initializing Terraform backend and modules..."
                sh "terraform init -input=false -reconfigure"
            }
        }

        // 4️⃣ Validate Terraform
        stage('Validate Terraform') {
            steps {
                echo "🔍 Validating Terraform configuration..."
                sh "terraform fmt -check"
                sh "terraform validate"
            }
        }

        // 5️⃣ Terraform Plan
        stage('Terraform Plan') {
            when { expression { params.ACTION == 'plan' } }
            steps {
                echo "🧩 Running Terraform plan for ${params.ENV}..."
                sh "terraform plan -var 'environment=${params.ENV}' -out=tfplan"
            }
        }

        // 6️⃣ Terraform Apply
        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                input message: "⚠️ Approve APPLY for ${params.ENV} environment?"
                echo "🚀 Applying Terraform changes..."
                sh "terraform apply -auto-approve tfplan"
            }
        }

        // 7️⃣ Terraform Destroy
        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                input message: "⚠️ Confirm DESTROY for ${params.ENV} environment?"
                echo "🔥 Destroying Terraform-managed resources..."
                sh "terraform destroy -auto-approve"
            }
        }
    }

    // ---------- Post Build Actions ----------
    post {
        success {
            echo "✅ Terraform ${params.ACTION.toUpperCase()} completed successfully!"
            cleanWs() // clean up workspace
        }
        failure {
            echo "❌ Terraform ${params.ACTION.toUpperCase()} failed. Please check logs."
        }
    }
}
