# Hosting Platform Deployment Scripts

Scripts for deploying applications to various hosting platforms and services.

## 📁 Directory Structure

```
hosting/
├── vercel/
├── netlify/
├── render/
├── railway/
├── heroku/
├── digitalocean-app/
├── aws-amplify/
├── google-cloud-run/
├── azure-static-web-apps/
├── cloudflare-pages/
├── surge/
└── github-pages/
```

## 🎯 Platform Categories

### Static Site Hosting
- **Vercel** - Next.js, React, Vue, static sites
- **Netlify** - Static sites, JAMstack applications
- **Cloudflare Pages** - Static sites with edge computing
- **GitHub Pages** - Static sites from GitHub repositories
- **Surge** - Simple static site deployment

### Full-Stack Hosting
- **Render** - Web services, databases, static sites
- **Railway** - Full-stack applications with databases
- **Heroku** - Container-based application deployment
- **DigitalOcean App Platform** - Managed application hosting

### Cloud Platform Hosting
- **AWS Amplify** - Full-stack serverless applications
- **Google Cloud Run** - Containerized applications
- **Azure Static Web Apps** - Static sites with serverless APIs

## 🚀 Quick Start

1. Choose your hosting platform
2. Navigate to the platform's directory
3. Read the platform-specific README
4. Run the deployment script

```bash
cd hosting/vercel
./deploy.sh
```

## 📋 Prerequisites

Each platform may require:
- Platform-specific CLI tools
- Account credentials
- Domain configuration
- Environment variables

## 🔧 Common Features

All deployment scripts include:
- ✅ Automatic CLI installation
- ✅ Authentication handling
- ✅ Build configuration
- ✅ Environment variable setup
- ✅ Domain configuration
- ✅ SSL certificate setup
- ✅ Deployment monitoring

## 📝 Configuration

Most scripts support configuration through environment variables:

```bash
export PROJECT_NAME="my-app"
export DOMAIN="example.com"
export BUILD_COMMAND="npm run build"
export OUTPUT_DIR="dist"
```