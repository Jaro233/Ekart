#!/bin/bash

# Update and Upgrade Ubuntu
sudo apt-get update -y
sudo apt-get upgrade -y

# Install Java (OpenJDK)
sudo apt-get install openjdk-11-jdk -y

# Install Maven
sudo apt-get install maven -y

# Install Docker
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update -y
sudo apt-get install docker-ce -y

# Add the current user to the Docker group to avoid using 'sudo' with Docker commands
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose (Optional, but useful if needed)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Run SonarQube on Docker
docker volume create sonarqube_data
docker volume create sonarqube_logs
docker volume create sonarqube_extensions
docker run -d --name sonarqube -p 9000:9000 -v sonarqube_data:/opt/sonarqube/data -v sonarqube_extensions:/opt/sonarqube/extensions -v sonarqube_logs:/opt/sonarqube/logs sonarqube

# Install Trivy
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

# Install dependency check
DEP_CHECK_VERSION=$(curl -s "https://api.github.com/repos/jeremylong/DependencyCheck/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
curl -L "https://github.com/jeremylong/DependencyCheck/releases/download/$DEP_CHECK_VERSION/dependency-check-$DEP_CHECK_VERSION-release.zip" -o /tmp/dependency-check.zip
sudo unzip /tmp/dependency-check.zip -d /opt/
sudo ln -s /opt/dependency-check/bin/dependency-check.sh /usr/local/bin/dependency-check

# Verify Java Installation
java -version
