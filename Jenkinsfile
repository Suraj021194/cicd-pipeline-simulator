pipeline {
    agent any
    stages {
        stage('Build'){
            steps {
                sh 'whoami && uname -a'
                sh './pipeline.sh --stage build'
            }
        }
        stage('Test'){
            steps{
                sh 'whoami && uname -a'
                sh './pipeline.sh --stage test'
            }
        }
        stage('Deploy'){
            steps{
                sh 'whoami && uname -a'
                sh './pipeline.sh --stage deploy'
            }
        }
    }
}