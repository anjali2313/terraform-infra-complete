############################################################
# Terraform CI/CD Pipeline using Jenkins
# - Supports: plan, apply, destroy
# - Backend: AWS S3 + DynamoDB
# - Parameters: Environment & Action selection
# - Tested on Jenkins 2.528+
############################################################

pipeline {
    agent any

    # Global pipeline options
    options {
        timestamps()                 // Adds timestamps to logs for better tracing
        // ansiColor('xterm')         // Optional: enable if AnsiColor plugin is installed
    }

    ############################################################
    # Environment Variables — Jenkins credentials + constants
    ############################################################
    environment {
        # AWS credentials (stored securely in Jenkins Credentials)
        AWS_ACCESS_KEY_ID     = credentials('new-id')
        AWS_SECRET_ACCESS_KEY = credentials('sec-key')

        # AWS region
        AWS_DEFAULT_REGION    = 'ap-northeast-1'

        # Backend configuration (Terraform state & lock)
        BACKEND_BUCKET        = 'anjali-tfstate-backend-2025'
        BACKEND_TABLE         = 'terraform-locks'
    }

    ############################################################
    # Parameters — dynamic user input during build
    ############################################################
    parameters {
        choice(
            name: 'ACTION',
            choices: ['plan', 'apply', 'destroy'],
            description: 'Select Terraform action to perform'
        )
        choice(
            name: 'ENV',
            choices: ['dev', 'prod'],
            description: 'Select deployment environment (dev or prod)'
        )
    }

    ############################################################
    # Pipeline Stages
    ############################################################
    stages {

        ########################################################
        # 1️⃣ Checkout Code
        ########################################################
        stage('Checkout Code') {
            steps {
                echo "📦 Checking out repository..."
                cleanWs()             // Clean previous workspace to avoid cache conflicts
                checkout scm          // Pull latest code from GitHub automatically
            }
        }

        ########################################################
        # 2️⃣ Ensure Backend Exists (S3 + DynamoDB)
        ########################################################
        stage('Prepare Backend') {
            steps {
                echo "☁️ Checking and creating backend if missing..."
                sh '''
                set -e
                # Check if S3 bucket exists; if not, create one
                if ! aws s3api head-bucket --bucket $BACKEND_BUCKET 2>/dev/null; then
                    echo "🪣 Creating S3 bucket: $BACKEND_BUCKET"
                    aws s3api create-bucket --bucket $BACKEND_BUCKET \
                        --region $AWS_DEFAULT_REGION \
                        --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION
                else
                    echo "✅ S3 bucket already exists: $BACKEND_BUCKET"
                fi

                # Check if DynamoDB table exists; if not, create it
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

        ########################################################
        # 3️⃣ Initialize Terraform
        ########################################################
        stage('Init Terraform') {
            steps {
                echo "🚀 Initializing Terraform backend and modules..."
                sh "terraform init -input=false -reconfigure"
            }
        }

        ########################################################
        # 4️⃣ Validate Terraform Code
        ########################################################
        stage('Validate Terraform') {
            steps {
                echo "🔍 Validating Terraform configuration files..."
                sh "terraform fmt -check"   // Checks formatting consistency
                sh "terraform validate"     // Validates syntax and structure
            }
        }

        ########################################################
        # 5️⃣ Terraform Plan
        ########################################################
        stage('Terraform Plan') {
            when { expression { params.ACTION == 'plan' } }
            steps {
                echo "🧩 Generating Terraform plan for environment: ${params.ENV}..."
                # Use double quotes for Groovy interpolation
                sh "terraform plan -var 'environment=${params.ENV}' -out=tfplan"
            }
        }

        ########################################################
        # 6️⃣ Terraform Apply
        ########################################################
        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                # Manual approval before applying
                input message: "⚠️ Approve to APPLY infrastructure in ${params.ENV}?"
                echo "🚀 Applying Terraform changes..."
                sh "terraform apply -auto-approve tfplan"
            }
        }

        ########################################################
        # 7️⃣ Terraform Destroy
        ########################################################
        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                # Manual approval before destroying infrastructure
                input message: "⚠️ Confirm DESTROY for ${params.ENV} environment?"
                echo "🔥 Destroying all Terraform-managed resources..."
                sh "terraform destroy -auto-approve"
            }
        }
    }

    ############################################################
    # Post Build Actions
    ############################################################
    post {
        success {
            echo "✅ Terraform ${params.ACTION.toUpperCase()} completed successfully!"
            cleanWs()     // Clean workspace after success to save disk space
        }
        failure {
            echo "❌ Terraform ${params.ACTION.toUpperCase()} failed. Please check logs."
        }
    }
}
