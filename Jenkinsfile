pipeline{
    agent any
    tools{
        go 'go-1.23.0'
    }
    environment{
        IMAGE = 'saymapatwekar/python-web-app'
    }
    stages{
        stage('Checkout'){
            steps{
                git branch: 'main', url: 'https://github.com/Sayma-Patwekar/go-web-app.git'
            }
        }
        stage('go build'){
            steps{
                sh 'go version'
                sh 'go build -o go-web-app'
            }
        }
        stage('build image'){
            steps{
                sh 'docker build -t ${IMAGE}:${BUILD_NUMBER} .'
            }
        }
        stage('Login and push to dockerhub'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDS', passwordVariable: 'password', usernameVariable: 'username')]) {
                    sh 'docker login -u ${username} -p ${password}'
                    sh 'docker push ${IMAGE}:${BUILD_NUMBER}'
                }
            }
        }
        stage('Checkout K8S manifest SCM'){
            steps {
                git credentialsId: 'GITHUB_CREDS', 
                url: 'https://github.com/Sayma-Patwekar/go-web-app.git',
                branch: 'main'
            }
        }
        stage('update tag in helm'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'GITHUB_CREDS', passwordVariable: 'gitpassword', usernameVariable: 'gitusername')]) {
                    sh '''
                        git config --global user.email "patwekarsayma@gmail.com"
                        git config --global user.name "${gitusername}"
                        cat helm/go-app-chart/values.yaml
                        BUILD_NUMBER=${BUILD_NUMBER}
                        sed -i "s/tag: .*/tag: ${BUILD_NUMBER}/" helm/go-app-chart/values.yaml
                        cat helm/go-app-chart/values.yaml
                        git add helm/go-app-chart/values.yaml
                        git commit -m 'Updated the deploy yaml | Jenkins Pipeline'
                        git push https://${gitpassword}@github.com/${gitusername}/go-web-app HEAD:main
                    ''' 
                }
                
            }
        }
    }
    post{
        always{
            cleanWs()
        }
    }
}