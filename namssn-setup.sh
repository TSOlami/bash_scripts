#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script as root or using sudo."
    exit 1
fi

# Update and upgrade packages
yum update -y
yum upgrade -y

# Install git
yum install git -y

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# Activate nvm
. ~/.nvm/nvm.sh

# Install Node.js version 16
nvm install 16

# Clone the github repository
git clone https://github.com/TSOlami/namssn-website.git

# Change directory to the cloned repository
cd namssn-website

# Install the project dependencies
npm install

# install pm2
npm install pm2@latest -g

# Start the application
pm2 start backend/server.js