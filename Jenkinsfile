pipeline {
    agent any
    options {
        timestamps()
        ansiColor('xterm')
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('new-id')
        AWS_SECRET_ACCESS_KEY = credentials('sec-key')
        AWS_DEFAULT_REGION    = 'ap-northeast-1'
        BACKEND_BUCKET        = 'anjali-tfstate-backend-2025'
        BACKEND_TABLE         = 'terraform-locks'
    }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action')
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Checking out code..."
                cleanWs()
                checkout scm
            }
        }

        stage('Prepare Backend') {
            steps {
                echo "☁️ Ensuring S3 & DynamoDB backend exist..."
                sh '''
                aws s3api head-bucket --bucket $BACKEND_BUCKET 2>/dev/null || \
                aws s3api create-bucket --bucket $BACKEND_BUCKET --region $AWS_DEFAULT_REGION --create-bucket-configuration LocationConstraint=$AWS_DEFAULT_REGION

                aws dynamodb describe-table --table-name $BACKEND_TABLE 2>/dev/null || \
                aws dynamodb create-table \
                    --table-name $BACKEND_TABLE \
                    --attribute-definitions AttributeName=LockID,AttributeType=S \
                    --key-schema AttributeName=LockID,KeyType=HASH \
                    --billing-mode PAY_PER_REQUEST
                '''
            }
        }

        stage('Init Terraform') {
            steps {
                echo "🚀 Initializing Terraform..."
                sh '''
                terraform init -input=false -reconfigure
                '''
            }
        }

        stage('Validate Terraform') {
            steps {
                echo "🔍 Validating Terraform configuration..."
                sh '''
                terraform fmt -check
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            when { expression { params.ACTION == 'plan' } }
            steps {
                echo "🧩 Running Terraform plan for ${params.ENV}..."
                sh '''
                terraform plan -var "environment=${params.ENV}" -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                input message: "⚠️ Confirm APPLY for ${params.ENV} environment?"
                echo "🚀 Applying Terraform changes..."
                sh '''
                terraform apply -auto-approve tfplan
                '''
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                input message: "⚠️ Confirm DESTROY for ${params.ENV} environment?"
                echo "🔥 Destroying Terraform-managed resources..."
                sh '''
                terraform destroy -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Terraform ${params.ACTION.toUpperCase()} completed successfully!"
            cleanWs()
        }
        failure {
            echo "❌ Terraform ${params.ACTION.toUpperCase()} failed. Check logs."
        }
    }
}
