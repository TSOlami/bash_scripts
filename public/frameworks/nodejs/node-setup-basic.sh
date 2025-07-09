#!/bin/bash

# Basic Node.js Setup Script (Legacy)
# This is a basic version - use setup.sh for the enhanced version

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

# Install the latest LTS version of Node.js
nvm install --lts

# Log Node.js version
node -e "console.log('Running Node.js ' + process.version)"

# Install pm2
npm install pm2@latest -g
