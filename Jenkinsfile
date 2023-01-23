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
                    dir('kubernetes/'){
                        withEnv(['DATREE_TOKEN=43d6bcff-a4e4-442d-9ebb-03407913038a']) {
                            echo 'test helm chart using datree'
                            // sh 'helm datree test myapp/'
                        }
                    }
                }
            }
        }
        stage("Pushing the helm charts to nexus"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'nexus-docker-host', variable: 'password')]) {
                          dir('kubernetes/') {
                             sh '''
                                 helmversion=$( helm show chart myapp | grep version | cut -d: -f 2 | tr -d ' ')
                                 tar -czvf  myapp-${helmversion}.tgz myapp/
                                 curl -u admin:$password http://34.27.20.45:8081/repository/helm-hosted/ --upload-file myapp-${helmversion}.tgz -v
                            '''
                          }
                    }
                }
            }
        }
        stage('manual approval'){
            steps{
                script{
                    timeout(10) {
                        input(id: "Deploy Gate", message: "Deploy ${params.project_name}?", ok: 'Deploy')
                    }
                }
            }
        }
        stage('Deploying application on k8s cluster') {
            steps {
            script{
                   withCredentials([kubeconfigFile(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                        dir('kubernetes/') {
                            sh 'helm upgrade --install --set image.repository="34.27.20.45:8083/springapp" --set image.tag="${VERSION}" myjavaapp myapp/ ' 
                        }
                    }
               }
            }
        }
        stage('verifying app deployment'){
            steps{
                script{
                     withCredentials([kubeconfigFile(credentialsId: 'kubernetes-config', variable: 'KUBECONFIG')]) {
                         sh 'kubectl run curl --image=curlimages/curl -i --rm --restart=Never -- curl myjavaapp-myapp:8080'
                     }
                }
            }
        }
    }
}