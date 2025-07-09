#!/bin/bash

# Vercel Deployment Script
# Supports Next.js, React, Vue, and static sites

set -euo pipefail

# Configuration
PROJECT_NAME="${PROJECT_NAME:-$(basename $(pwd))}"
VERCEL_TOKEN="${VERCEL_TOKEN:-}"
DOMAIN="${DOMAIN:-}"
BUILD_COMMAND="${BUILD_COMMAND:-npm run build}"
OUTPUT_DIR="${OUTPUT_DIR:-dist}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

log_step() {
    echo -e "${BLUE}[STEP]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
    # Check if Node.js is installed
    if ! command -v node &> /dev/null; then
        log_error "Node.js is not installed. Please install Node.js first."
        exit 1
    fi
    
    # Check if npm is installed
    if ! command -v npm &> /dev/null; then
        log_error "npm is not installed. Please install npm first."
        exit 1
    fi
    
    # Check if package.json exists
    if [ ! -f "package.json" ]; then
        log_error "package.json not found. Please run this script from your project root."
        exit 1
    fi
    
    log_info "Prerequisites check passed"
}

# Install Vercel CLI
install_vercel_cli() {
    log_step "Installing Vercel CLI..."
    
    if ! command -v vercel &> /dev/null; then
        npm install -g vercel
        log_info "Vercel CLI installed successfully"
    else
        log_info "Vercel CLI already installed"
    fi
}

# Authenticate with Vercel
authenticate_vercel() {
    log_step "Authenticating with Vercel..."
    
    if [ -n "$VERCEL_TOKEN" ]; then
        echo "$VERCEL_TOKEN" | vercel login --stdin
        log_info "Authenticated using token"
    else
        log_info "Please authenticate with Vercel:"
        vercel login
    fi
}

# Detect project type
detect_project_type() {
    log_step "Detecting project type..."
    
    if [ -f "next.config.js" ] || [ -f "next.config.mjs" ] || grep -q "next" package.json; then
        PROJECT_TYPE="nextjs"
        log_info "Detected Next.js project"
    elif grep -q "react" package.json && grep -q "vite" package.json; then
        PROJECT_TYPE="react-vite"
        log_info "Detected React + Vite project"
    elif grep -q "react" package.json; then
        PROJECT_TYPE="react"
        log_info "Detected React project"
    elif grep -q "vue" package.json; then
        PROJECT_TYPE="vue"
        log_info "Detected Vue.js project"
    elif grep -q "angular" package.json; then
        PROJECT_TYPE="angular"
        log_info "Detected Angular project"
    else
        PROJECT_TYPE="static"
        log_info "Detected static project"
    fi
}

# Create vercel.json configuration
create_vercel_config() {
    log_step "Creating Vercel configuration..."
    
    case "$PROJECT_TYPE" in
        "nextjs")
            cat > vercel.json << EOF
{
  "framework": "nextjs",
  "buildCommand": "npm run build",
  "outputDirectory": ".next"
}
EOF
            ;;
        "react"|"react-vite")
            cat > vercel.json << EOF
{
  "buildCommand": "$BUILD_COMMAND",
  "outputDirectory": "$OUTPUT_DIR",
  "framework": "vite"
}
EOF
            ;;
        "vue")
            cat > vercel.json << EOF
{
  "buildCommand": "$BUILD_COMMAND",
  "outputDirectory": "$OUTPUT_DIR",
  "framework": "vue"
}
EOF
            ;;
        "angular")
            cat > vercel.json << EOF
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "angular"
}
EOF
            ;;
        "static")
            cat > vercel.json << EOF
{
  "buildCommand": "$BUILD_COMMAND",
  "outputDirectory": "$OUTPUT_DIR"
}
EOF
            ;;
    esac
    
    log_info "Vercel configuration created"
}

# Install dependencies
install_dependencies() {
    log_step "Installing dependencies..."
    
    if [ -f "package-lock.json" ]; then
        npm ci
    elif [ -f "yarn.lock" ]; then
        yarn install --frozen-lockfile
    elif [ -f "pnpm-lock.yaml" ]; then
        pnpm install --frozen-lockfile
    else
        npm install
    fi
    
    log_info "Dependencies installed successfully"
}

# Build project
build_project() {
    log_step "Building project..."
    
    case "$PROJECT_TYPE" in
        "nextjs")
            npm run build
            ;;
        *)
            if npm run build; then
                log_info "Build completed successfully"
            else
                log_warn "Build command failed or not found, proceeding with deployment"
            fi
            ;;
    esac
}

# Deploy to Vercel
deploy_to_vercel() {
    log_step "Deploying to Vercel..."
    
    # Deploy with production flag
    if vercel --prod --yes; then
        log_info "Deployment successful!"
        
        # Get deployment URL
        DEPLOYMENT_URL=$(vercel ls | grep "$PROJECT_NAME" | head -1 | awk '{print $2}')
        if [ -n "$DEPLOYMENT_URL" ]; then
            log_info "Deployment URL: https://$DEPLOYMENT_URL"
        fi
    else
        log_error "Deployment failed"
        exit 1
    fi
}

# Configure custom domain
configure_domain() {
    if [ -n "$DOMAIN" ]; then
        log_step "Configuring custom domain..."
        
        if vercel domains add "$DOMAIN"; then
            log_info "Domain $DOMAIN added successfully"
            
            # Link domain to project
            vercel alias set "$DEPLOYMENT_URL" "$DOMAIN"
            log_info "Domain linked to deployment"
        else
            log_warn "Failed to add domain $DOMAIN"
        fi
    fi
}

# Setup environment variables
setup_environment() {
    log_step "Setting up environment variables..."
    
    if [ -f ".env.example" ]; then
        log_info "Found .env.example file. Please set up your environment variables:"
        cat .env.example
        
        read -p "Do you want to add environment variables now? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            while IFS= read -r line; do
                if [[ $line == *"="* ]] && [[ $line != "#"* ]]; then
                    var_name=$(echo "$line" | cut -d'=' -f1)
                    read -p "Enter value for $var_name: " var_value
                    vercel env add "$var_name" production <<< "$var_value"
                fi
            done < .env.example
        fi
    fi
}

# Main execution
main() {
    log_info "Starting Vercel deployment for $PROJECT_NAME..."
    
    check_prerequisites
    install_vercel_cli
    authenticate_vercel
    detect_project_type
    create_vercel_config
    install_dependencies
    build_project
    setup_environment
    deploy_to_vercel
    configure_domain
    
    log_info "Vercel deployment completed successfully!"
    log_info "Your application is now live on Vercel."
}

# Run main function
main "$@"