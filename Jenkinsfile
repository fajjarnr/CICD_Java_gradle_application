pipeline{
    agent any
    stages{
        stage("sonar quality check"){
            agent {
                any {
                    image 'openjdk:11'
                }
            }
            steps{
                script{
                    withSonarQubeEnv(credentialsId: 'sonar-token') {
                        sh "chmod +x gradlew"
                        sh "./gradlew sonarqube"
                    }
                }
            }
        }
    }
}