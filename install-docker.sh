#!/bin/bash

# Update the apt package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
echo \
 "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 \"$(. /etc/os-release && echo \"$VERSION_CODENAME\")\" stable" | \
 sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the apt package index again
sudo apt-get update

# Install Docker Engine, containerd, and Docker Compose
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify the installation
sudo docker run hello-world

echo "Docker Engine has been successfully installed!"

# Check if jq and curl are installed, list the missing packages
missing_packages=""
if ! command -v jq &> /dev/null; then
    missing_packages+="jq "
fi

if ! command -v curl &> /dev/null; then
    missing_packages+="curl "
fi

# If any packages are missing, update the package list and install missing packages
if [ ! -z "$missing_packages" ]; then
    echo "Installing missing packages: $missing_packages"
    apt update && apt install -y $missing_packages
fi

# Fetch latest release from GitHub API
LATEST_RELEASE=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | jq -r .tag_name)
echo "Latest release: $LATEST_RELEASE"

# Download the Docker Compose binary using your specific OS and architecture
curl -L "https://github.com/docker/compose/releases/download/${LATEST_RELEASE}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Check if the binary was downloaded successfully
if [ $? -ne 0 ]; then
    echo "Failed to download Docker Compose binary"
    exit 1
fi

# Make the Docker Compose binary executable
chmod +x /usr/local/bin/docker-compose

# Print the Docker Compose version to verify the installation
docker-compose --version
