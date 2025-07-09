# Vercel Deployment Scripts

Deploy your applications to Vercel with automated scripts for different frameworks and configurations.

## 📁 Available Scripts

- `deploy.sh` - General Vercel deployment
- `nextjs-deploy.sh` - Next.js specific deployment
- `react-deploy.sh` - React application deployment
- `vue-deploy.sh` - Vue.js application deployment
- `static-deploy.sh` - Static site deployment

## 🚀 Quick Start

### Basic Deployment
```bash
./deploy.sh
```

### Framework-Specific Deployment
```bash
# Next.js
./nextjs-deploy.sh

# React
./react-deploy.sh

# Vue.js
./vue-deploy.sh
```

## 📋 Prerequisites

- Node.js installed
- Vercel account
- Project source code

## 🔧 Configuration

Set environment variables before running:

```bash
export VERCEL_TOKEN="your-vercel-token"
export PROJECT_NAME="my-app"
export DOMAIN="example.com"
```

## 📝 Features

- ✅ Automatic Vercel CLI installation
- ✅ Project initialization
- ✅ Build optimization
- ✅ Environment variable setup
- ✅ Custom domain configuration
- ✅ SSL certificate setup
- ✅ Deployment monitoring