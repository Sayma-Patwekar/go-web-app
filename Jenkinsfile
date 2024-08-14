Pipeline
{
    agent any

    environment {
        DOCKERHUB_CREDENTIALS = credentials('DOCKER_CREDS')
        DOCKERHUB_CREDENTIALS_USR = 'saymapatwekar'
        GITHUB_TOKEN = credentials('GITHUB_TOKEN')
        GITHUB_USR = 'Sayma-Patwekar'
        PATH_TO_GIT_REPO = 'Sayma-Patwekar/go-web-app'

    }

    stages{
        stage('checkout repository'){
            steps{
                git branch: 'main', url: 'https://github.com/Sayma-Patwekar/go-web-app'
            }   
        }

        stage('Set up go'){
            steps {
                sh 'wget https://golang.org/dl/go1.22.linux-amd64.tar.gz'
                sh 'sudo tar -C /usr/local -xzf go1.22.linux-amd64.tar.gz'
                sh 'export PATH=$PATH:/usr/local/go/bin'
            }
        }

        stage('Build'){
            steps{
                sh 'go build -o go-web-app'
            }
        }

        stage('Code Quality test'){
            steps {
                sh 'curl -sSfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s v1.56.2'
                sh './bin/golangci-lint run'
            }
        }

        stage('Docker Build and Run'){
             steps {
                script {
                    docker.withRegistry('', "${DOCKERHUB_CREDENTIALS}") {
                        def customImage = docker.build("${DOCKERHUB_CREDENTIALS_USR}/go-web-app:${env.BUILD_ID}")
                        customImage.push()
                    }
                }
            }
        }

        stage('Update Helm Chart'){
            steps {
                sh '''
                sed -i 's/tag: .*/tag: "${BUILD_ID}"/' helm/go-app-chart/values.yaml
                git config --global user.email "patwekarsayma@gmail.com"
                git config --global user.name "Sayma-Patwekar"
                git add helm/go-app-chart/values.yaml
                git commit -m "Update tag in Helm chart"
                git push https://${GITHUB_TOKEN_USR}:${GITHUB_TOKEN}@github.com/${PATH_TO_GIT_REPO}.git HEAD:main
                '''
            }
        }
    }

    post{
        always{
            cleanWs()
        }
    }
}