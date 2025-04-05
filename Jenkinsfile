pipeline {
    agent any

    environment {
        AZURE_SUBSCRIPTION_ID = '6c1e198f-37fe-4942-b348-c597e7bef44b'
        AZURE_CLIENT_ID = '0e6e41d3-5440-4176-a735-9dfdaf0f886c'
        AZURE_CLIENT_SECRET = 'LvU8Q~KHHAnB.prsihzhfKNBDsf6UwLqFBGVBcsY'
        AZURE_TENANT_ID = '341f4047-ffad-4c4a-a0e7-b86c7963832b'
        RESOURCE_GROUP = 'phonebook-app-rg'
        APP_NAME_PREFIX = 'phonebook-app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: 'main']],
                    userRemoteConfigs: [[
                        url: 'https://github.com/Yash-Khandal/phone-book-app.git',
                        credentialsId: 'github-credentials'
                    ]]
                ])
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
                script {
                    def tfInitExitCode = bat(
                        script: 'terraform init -no-color',
                        returnStatus: true
                    )
                    if (tfInitExitCode != 0) {
                        error "Terraform init failed with exit code ${tfInitExitCode}"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    def tfPlanExitCode = bat(
                        script: """
                            terraform plan ^
                            -var="subscription_id=%AZURE_SUBSCRIPTION_ID%" ^
                            -var="client_id=%AZURE_CLIENT_ID%" ^
                            -var="client_secret=%AZURE_CLIENT_SECRET%" ^
                            -var="tenant_id=%AZURE_TENANT_ID%" ^
                            -var="app_version=${env.BUILD_ID}" ^
                            -out=tfplan
                        """,
                        returnStatus: true
                    )
                    if (tfPlanExitCode != 0) {
                        error "Terraform plan failed with exit code ${tfPlanExitCode}"
                    }
                }
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
            script {
                if (currentBuild.result != null) {
                    node {
                        cleanWs()
                    }
                }
            }
            withEnv(["AZURE_CLIENT_SECRET="]) {
                // This clears the AZURE_CLIENT_SECRET variable
            }
        }
    }
}
