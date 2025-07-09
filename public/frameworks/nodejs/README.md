# Node.js Deployment Scripts

Scripts for deploying Node.js applications to various platforms and environments.

## 📁 Available Scripts

### Basic Setup
- `setup.sh` - Basic Node.js environment setup
- `pm2-setup.sh` - PM2 process manager setup

### Platform Deployments
- `vercel-deploy.sh` - Deploy to Vercel
- `render-deploy.sh` - Deploy to Render
- `railway-deploy.sh` - Deploy to Railway
- `heroku-deploy.sh` - Deploy to Heroku

### VPS Deployments
- `ubuntu-vps.sh` - Deploy to Ubuntu VPS
- `centos-vps.sh` - Deploy to CentOS VPS
- `debian-vps.sh` - Deploy to Debian VPS

### Cloud Deployments
- `aws-ec2.sh` - Deploy to AWS EC2
- `gcp-compute.sh` - Deploy to Google Cloud Compute
- `azure-vm.sh` - Deploy to Azure Virtual Machine

## 🚀 Quick Start

### Basic VPS Setup
```bash
# For Ubuntu/Debian
sudo ./ubuntu-vps.sh

# For CentOS/RHEL
sudo ./centos-vps.sh
```

### Platform Deployment
```bash
# Deploy to Vercel
./vercel-deploy.sh

# Deploy to Render
./render-deploy.sh
```

## 📋 Prerequisites

- Root or sudo access (for VPS deployments)
- Git installed
- Internet connection
- Platform-specific CLI tools (for platform deployments)

## 🔧 Configuration

Most scripts support environment variables for configuration:

```bash
export NODE_VERSION="18"
export APP_NAME="my-app"
export DOMAIN="example.com"
```

## 📝 Script Features

All scripts include:
- ✅ Error handling and validation
- ✅ Automatic dependency installation
- ✅ Security configurations
- ✅ Process management setup
- ✅ SSL certificate setup (where applicable)
- ✅ Firewall configuration
- ✅ Logging setup