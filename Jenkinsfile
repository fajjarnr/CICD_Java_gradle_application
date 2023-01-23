pipeline{
    agent any
    environment{
        VERSION = "${env.BUILD_ID}"
    }
    stages{
        stage("Sonar Quality Check"){
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
                    // timeout(time: 1, unit: 'HOURS') {
                    //     def qualityGate = waitForQualityGate()
                    //     if (qualityGate.status != 'OK') {
                    //         error "Pipeline aborted due to quality gate failure: ${qualityGate.status}"
                    //     }
                    // }
                }
            }
        }
        stage("Build and Push Docker Image"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus-docker-host', variable: 'password')]) {
                        sh'''
                        docker build -t 34.27.20.45:8083/springapp:${VERSION} .
                        docker login -u admin -p $password 34.27.20.45:8083
                        docker push 34.27.20.45:8083/springapp:${VERSION}
                        docker rmi 34.27.20.45:8083/springapp:${VERSION}
                        '''
                    }
                }
            }
        }
        stage("Identifying misconfig using datree in helm charts"){
            steps{
                script{
                    withEnv(['DATREE_TOKEN=43d6bcff-a4e4-442d-9ebb-03407913038a']) {
                        dir('/kubernetes'){
                            sh 'helm datree test myapp/'
                        }
                    }
                }
            }
        }
    }
}