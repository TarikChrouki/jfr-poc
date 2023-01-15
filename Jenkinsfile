@Library('first-lib@master')_

pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'git --version'
                sh 'which git'
                script {
                  welcomeJob 'Hello'
                }
            }
        }
    }
}
