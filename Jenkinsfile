pipeline {
    agent any
    
    environment {
        AZURE_SUBSCRIPTION_ID = '6c1e198f-37fe-4942-b348-c597e7bef44b'
        AZURE_CLIENT_ID = '0e6e41d3-5440-4176-a735-9dfdaf0f886c'
        AZURE_CLIENT_SECRET = 'LvU8Q~KHHAnB.prsihzhfKNBDsf6UwLqFBGVBcsY'
        AZURE_TENANT_ID = '341f4047-ffad-4c4a-a0e7-b86c7963832b'
        RESOURCE_GROUP = 'phonebook-app-rg
        APP_NAME_PREFIX = 'phonebook-app'
    }
    
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Yash-Khandal/phone-book-app.git'
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh 'npm install'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Terraform Init') {
            steps {
                dir('infra') {
                    sh 'terraform init'
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                dir('infra') {
                    sh """
                    terraform plan \
                    -var="subscription_id=${AZURE_SUBSCRIPTION_ID}" \
                    -var="client_id=${AZURE_CLIENT_ID}" \
                    -var="client_secret=${AZURE_CLIENT_SECRET}" \
                    -var="tenant_id=${AZURE_TENANT_ID}" \
                    -var="app_version=${env.BUILD_ID}" \
                    -out=tfplan
                    """
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('infra') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }
        
        stage('Get App URL') {
            steps {
                script {
                    dir('infra') {
                        env.APP_URL = sh(
                            script: 'terraform output -raw app_url',
                            returnStdout: true
                        ).trim()
                    }
                    echo "Application deployed at: ${env.APP_URL}"
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            slackSend(color: "good", message: "Phonebook App Deployment Successful: ${env.APP_URL}")
        }
        failure {
            slackSend(color: "danger", message: "Phonebook App Deployment Failed: ${env.BUILD_URL}")
        }
    }
}
