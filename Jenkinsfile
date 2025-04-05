pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = credentials('AZURE_CLIENT_ID')
        ARM_CLIENT_SECRET   = credentials('AZURE_CLIENT_SECRET')
        ARM_SUBSCRIPTION_ID = credentials('AZURE_SUBSCRIPTION_ID')
        ARM_TENANT_ID       = credentials('AZURE_TENANT_ID')
        resource_group_name = 'react-firebase-rg'
        web_app_name        = 'react-firebase-app-viren'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/Virendra-94/Task-Manager-Azure'
            }
        }

        stage('Terraform Init/Plan/Apply') {
            steps {
                bat 'terraform init'
                bat '''
                    echo subscription_id="%ARM_SUBSCRIPTION_ID%" > terraform.tfvars
                    echo client_id="%ARM_CLIENT_ID%" >> terraform.tfvars
                    echo client_secret="%ARM_CLIENT_SECRET%" >> terraform.tfvars
                    echo tenant_id="%ARM_TENANT_ID%" >> terraform.tfvars
                    echo resource_group_name="react-firebase-rg" >> terraform.tfvars
                    echo location="East US" >> terraform.tfvars
                    echo app_service_plan="react-plan-viren" >> terraform.tfvars
                    echo web_app_name="react-firebase-app-viren" >> terraform.tfvars
                '''
                bat 'terraform plan -var-file="terraform.tfvars"'
                bat 'terraform apply -auto-approve -var-file="terraform.tfvars"'
            }
        }

        stage('Build React App') {
            steps {
                dir('react-app') {
                    bat 'npm install'
                    bat 'npm run build'
                    // Verify build folder
                    bat 'dir build'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                // Zip the build folder (PowerShell)
                powershell '''
                    Compress-Archive -Path "react-app\\build\\*" -DestinationPath "build.zip"
                '''
                
                // Deploy using Azure CLI
                bat """
                    az login --service-principal -u %ARM_CLIENT_ID% -p %ARM_CLIENT_SECRET% --tenant %ARM_TENANT_ID%
                    az webapp deploy --resource-group %resource_group_name% --name %web_app_name% --src-path build.zip --type zip
                """
            }
        }
    }
}
