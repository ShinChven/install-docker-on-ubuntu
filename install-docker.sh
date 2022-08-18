#!/usr/bin/env bash

## Update the apt package index
apt-get update
apt-get upgrade -y

## Install prerequisites
apt-get install -y jq curl ca-certificates curl gnupg lsb-release

## Add the Docker repository key to your system
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

## Add the Docker repository to your system
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Update the apt package index
apt-get update
## Install the latest version of Docker CE
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

## Get the latest version of Docker Compose
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | jq -r .name)
## Install Docker Compose
curl -L https://github.com/docker/compose/releases/download/"${DOCKER_COMPOSE_VERSION}"/docker-compose-"$(uname -s)"-"$(uname -m)" > /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

## Test Docker and Docker Compose
docker version
docker-compose version
