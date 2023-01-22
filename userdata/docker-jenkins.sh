#!/bin/bash
sudo apt update
# sudo apt install openjdk-11-jdk -y
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl enable docker

sudo chmod 666 /var/run/docker.sock

docker volume create --name jenkins_home
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts-jdk11
# docker logs -f jenkins
# docker start jenkins

# docker exec -it -u 0 nexus bash
# cat /nexus-data/admin.password