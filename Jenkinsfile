pipeline {
    agent any

    environment {
        ARM_CLIENT_ID       = '0e6e41d3-5440-4176-a735-9dfdaf0f886c'
        ARM_CLIENT_SECRET   = 'LvU8Q~KHHAnB.prsihzhfKNBDsf6UwLqFBGVBcsY'
        ARM_SUBSCRIPTION_ID = '6c1e198f-37fe-4942-b348-c597e7bef44b'
        ARM_TENANT_ID       = '341f4047-ffad-4c4a-a0e7-b86c7963832b'
        resource_group_name = 'phonebook-app-rg'
        web_app_name        = 'phonebook-app'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                bat '''
                    del terraform.tfvars 2> nul || exit 0
                    del build.zip 2> nul || exit 0
                    rmdir /s /q .terraform 2> nul || exit 0
                    del terraform.tfstate* 2> nul || exit 0
                '''
            }
        }

        stage('Checkout Code') {
            steps {
                git branch: 'main', 
                url: 'https://github.com/Yash-Khandal/phone-book-app.git'
            }
        }

        stage('Terraform Init') {
            steps {
                bat 'terraform init -reconfigure'
                bat 'terraform init -upgrade'
            }
        }

        stage('Terraform Plan/Apply') {
            steps {
                bat '''
                    echo subscription_id="%ARM_SUBSCRIPTION_ID%" > terraform.tfvars
                    echo client_id="%ARM_CLIENT_ID%" >> terraform.tfvars
                    echo client_secret="%ARM_CLIENT_SECRET%" >> terraform.tfvars
                    echo tenant_id="%ARM_TENANT_ID%" >> terraform.tfvars
                    echo resource_group_name="%resource_group_name%" >> terraform.tfvars
                    echo location="East US" >> terraform.tfvars
                    echo app_service_plan="phonebook-app-plan" >> terraform.tfvars
                    echo web_app_name="%web_app_name%" >> terraform.tfvars
                '''
                
                // Import existing resource group
                bat 'terraform import azurerm_resource_group.rg /subscriptions/%ARM_SUBSCRIPTION_ID%/resourceGroups/%resource_group_name% || echo "Import may have failed - continuing"'
                
                bat 'terraform plan -var-file="terraform.tfvars"'
                bat 'terraform apply -auto-approve -var-file="terraform.tfvars"'
            }
        }

        stage('Build React App') {
            steps {
                dir('react-app') {
                    bat 'npm install'
                    bat 'npm run build'
                }
            }
        }

        stage('Deploy to Azure') {
            steps {
                powershell 'Compress-Archive -Path "react-app\\build\\*" -DestinationPath "build.zip" -Force'
                bat '''
                    az login --service-principal -u %ARM_CLIENT_ID% -p %ARM_CLIENT_SECRET% --tenant %ARM_TENANT_ID%
                    az webapp deploy --resource-group %resource_group_name% --name %web_app_name% --src-path build.zip --type zip
                '''
            }
        }
    }

    post {
        always {
            bat '''
                del terraform.tfvars 2> nul || exit 0
                del build.zip 2> nul || exit 0
            '''
        }
        success {
            script {
                def WEBAPP_URL = sh(
                    script: 'terraform output -raw webapp_url', 
                    returnStdout: true
                ).trim()
                echo "✅ Deployment Successful!"
                echo "🌐 Web App URL: ${WEBAPP_URL}"
            }
        }
        failure {
            echo "❌ Pipeline Failed"
            archiveArtifacts artifacts: '**/*.log', allowEmptyArchive: true
        }
    }
}
