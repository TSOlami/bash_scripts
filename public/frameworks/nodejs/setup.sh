#!/bin/bash

# Node.js Environment Setup Script
# Supports Ubuntu, Debian, CentOS, RHEL, and Amazon Linux

set -euo pipefail

# Configuration
NODE_VERSION="${NODE_VERSION:-18}"
NVM_VERSION="${NVM_VERSION:-v0.39.3}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        log_error "Please run this script as root or using sudo."
        exit 1
    fi
}

# Detect OS
detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    else
        log_error "Cannot detect operating system"
        exit 1
    fi
    
    log_info "Detected OS: $OS $VER"
}

# Update system packages
update_system() {
    log_info "Updating system packages..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            apt update && apt upgrade -y
            apt install -y curl wget git build-essential
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            if command -v dnf &> /dev/null; then
                dnf update -y
                dnf groupinstall -y "Development Tools"
                dnf install -y curl wget git
            else
                yum update -y
                yum groupinstall -y "Development Tools"
                yum install -y curl wget git
            fi
            ;;
        *)
            log_error "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Install NVM
install_nvm() {
    log_info "Installing NVM (Node Version Manager)..."
    
    # Install NVM for root
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    
    # Install for all users
    if [ -d "/etc/skel" ]; then
        cp -r "$HOME/.nvm" /etc/skel/
        echo 'export NVM_DIR="$HOME/.nvm"' >> /etc/skel/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /etc/skel/.bashrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /etc/skel/.bashrc
    fi
}

# Install Node.js
install_nodejs() {
    log_info "Installing Node.js version $NODE_VERSION..."
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install and use Node.js
    nvm install "$NODE_VERSION"
    nvm use "$NODE_VERSION"
    nvm alias default "$NODE_VERSION"
    
    # Verify installation
    node_version=$(node --version)
    npm_version=$(npm --version)
    
    log_info "Node.js installed: $node_version"
    log_info "npm installed: $npm_version"
}

# Install global packages
install_global_packages() {
    log_info "Installing global npm packages..."
    
    # Source NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    # Install commonly used global packages
    npm install -g pm2 nodemon yarn pnpm
    
    log_info "Global packages installed successfully"
}

# Setup firewall (if needed)
setup_firewall() {
    log_info "Configuring firewall..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            if command -v ufw &> /dev/null; then
                ufw --force enable
                ufw allow ssh
                ufw allow 80
                ufw allow 443
                ufw allow 3000
                log_info "UFW firewall configured"
            fi
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            if command -v firewall-cmd &> /dev/null; then
                systemctl enable firewalld
                systemctl start firewalld
                firewall-cmd --permanent --add-service=ssh
                firewall-cmd --permanent --add-service=http
                firewall-cmd --permanent --add-service=https
                firewall-cmd --permanent --add-port=3000/tcp
                firewall-cmd --reload
                log_info "Firewalld configured"
            fi
            ;;
    esac
}

# Create deployment user
create_deploy_user() {
    log_info "Creating deployment user..."
    
    if ! id "deploy" &>/dev/null; then
        useradd -m -s /bin/bash deploy
        usermod -aG sudo deploy
        
        # Copy NVM to deploy user
        cp -r "$HOME/.nvm" /home/deploy/
        chown -R deploy:deploy /home/deploy/.nvm
        
        # Add NVM to deploy user's bashrc
        echo 'export NVM_DIR="$HOME/.nvm"' >> /home/deploy/.bashrc
        echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /home/deploy/.bashrc
        echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /home/deploy/.bashrc
        
        log_info "Deploy user created successfully"
    else
        log_warn "Deploy user already exists"
    fi
}

# Main execution
main() {
    log_info "Starting Node.js environment setup..."
    
    check_root
    detect_os
    update_system
    install_nvm
    install_nodejs
    install_global_packages
    setup_firewall
    create_deploy_user
    
    log_info "Node.js environment setup completed successfully!"
    log_info "You can now deploy Node.js applications to this server."
    log_info "Switch to deploy user: su - deploy"
}

# Run main function
main "$@"