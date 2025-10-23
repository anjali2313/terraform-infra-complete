pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('sec-key')
        AWS_SECRET_ACCESS_KEY = credentials('new-id')
        AWS_DEFAULT_REGION    = 'ap-northeast-1'
    }

    parameters {
        choice(name: 'ACTION', choices: ['plan', 'apply', 'destroy'], description: 'Select Terraform action')
        choice(name: 'ENV', choices: ['dev', 'prod'], description: 'Select environment')
    }

    stages {

        stage('Checkout Code') {
            steps {
                echo "📦 Cloning repository..."
                checkout scm
            }
        }

        stage('Init Terraform') {
            steps {
                echo "🚀 Initializing Terraform..."
                sh 'terraform init -input=false -reconfigure'
            }
        }

        stage('Validate Terraform') {
            steps {
                echo "🔍 Validating Terraform files..."
                sh 'terraform fmt -check'
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            when { expression { params.ACTION == 'plan' } }
            steps {
                echo "🧩 Running Terraform plan..."
                sh "terraform plan -var 'environment=${params.ENV}' -out=tfplan"
            }
        }

        stage('Terraform Apply') {
            when { expression { params.ACTION == 'apply' } }
            steps {
                input message: "⚠️ Approve to apply changes in ${params.ENV} environment?"
                sh "terraform apply -auto-approve tfplan"
            }
        }

        stage('Terraform Destroy') {
            when { expression { params.ACTION == 'destroy' } }
            steps {
                input message: "⚠️ Confirm destroy in ${params.ENV} environment?"
                sh "terraform destroy -auto-approve"
            }
        }
    }

    post {
        success {
            echo '✅ Terraform pipeline completed successfully!'
            cleanWs()
        }
        failure {
            echo '❌ Terraform pipeline failed. Check logs for details.'
        }
    }
}
