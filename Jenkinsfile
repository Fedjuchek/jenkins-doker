pipeline {
    agent any

    environment {
        imagename = "fedjuchek/jenkins-doker"
        registryCredential = 'docker-hub-fedjuchek-cred'
        remoteServerCredential = "remote-server-fedjuchek-cred"
        dockerImage = ''
    }

    stages {
        stage('Git clone') {
            steps {
                checkout scm
            }
        }
        stage('Build image') {
            steps {
                script {
                    dockerImage = docker.build imagename
                }
            }
        }
        stage('Deploy Image') {
            steps {
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                    }
                }
            }
        }
        stage('Login to remote server') {
            steps {
                sshagent(credentials: ['remote-server-fedjuchek-cred']) {
                    sh '''
                        [ -d ~/.ssh ] || mkdir ~/.ssh && chmod 0700 ~/.ssh
                        ssh-keyscan -t rsa,dsa example.com >> ~/.ssh/known_hosts
                        ssh user@192.168.88.67 "java --version"
                       '''
                }
            }
        }
        stage('Cleanup') {
            steps {
                sh "docker rmi $imagename:$BUILD_NUMBER"
                sh "docker rmi $imagename:latest"
            }
        }
    }
}