pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = '6c1e198f-37fe-4942-b348-c597e7bef44b'
        AZURE_CLIENT_ID = '0e6e41d3-5440-4176-a735-9dfdaf0f886c'
        AZURE_CLIENT_SECRET = 'LvU8Q~KHHAnB.prsihzhfKNBDsf6UwLqFBGVBcsY'
        AZURE_TENANT_ID = '	341f4047-ffad-4c4a-a0e7-b86c7963832b'
        RESOURCE_GROUP = 'phonebook-app-rg'
        APP_NAME_PREFIX = 'phonebook-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Install Dependencies') {
            steps {
                bat 'npm install'  
            }
        }
        
        stage('Build') {
            steps {
                bat 'npm run build'
            }
        }
        
        stage('Terraform Init') {
            steps {
                bat 'terraform init'
            }
        }
        
        stage('Terraform Plan') {
            steps {
                bat """
                terraform plan ^
                -var="subscription_id=%AZURE_SUBSCRIPTION_ID%" ^
                -var="client_id=%AZURE_CLIENT_ID%" ^
                -var="client_secret=%AZURE_CLIENT_SECRET%" ^
                -var="tenant_id=%AZURE_TENANT_ID%" ^
                -out=tfplan
                """
            }
        }
        
        stage('Terraform Apply') {
            steps {
                bat 'terraform apply -auto-approve tfplan'
            }
        }
        
        stage('Get App URL') {
            steps {
                script {
                    env.APP_URL = bat(
                        script: 'terraform output -raw app_url',
                        returnStdout: true
                    ).trim()
                    echo "Application deployed at: ${env.APP_URL}"
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
            bat 'set AZURE_CLIENT_SECRET='  
        }
    }
}
