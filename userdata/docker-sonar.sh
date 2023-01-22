#!/bin/bash
sudo sysctl -w vm.max_map_count=524288
sudo sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192

sleep 3

sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce -y
sudo systemctl enable docker

sudo chmod 666 /var/run/docker.sock

docker volume create --name sonar-data
docker volume create --name sonar-logs
docker volume create --name sonar-extensions

docker run -d -p 9000:9000 --name sonar -v sonar-data:/opt/sonarqube/data -v sonar-logs:/opt/sonarqube/logs -v sonar-extensions:/opt/sonarqube/extensions sonarqube:lts
