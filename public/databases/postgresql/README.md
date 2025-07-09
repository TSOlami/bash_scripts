# PostgreSQL Deployment Scripts

Scripts for deploying PostgreSQL database in various environments and configurations.

## 📁 Available Scripts

### Installation Scripts
- `setup.sh` - Basic PostgreSQL installation
- `docker-setup.sh` - Docker-based deployment
- `cluster-setup.sh` - High-availability cluster setup

### Cloud Deployments
- `aws-rds-setup.sh` - AWS RDS PostgreSQL
- `gcp-cloudsql-setup.sh` - Google Cloud SQL
- `azure-postgresql-setup.sh` - Azure Database for PostgreSQL

### Management Scripts
- `backup.sh` - Database backup script
- `restore.sh` - Database restore script
- `monitoring.sh` - Monitoring setup
- `security.sh` - Security hardening

## 🚀 Quick Start

### Local Installation
```bash
# Ubuntu/Debian
sudo ./setup.sh

# With Docker
./docker-setup.sh

# High-availability cluster
./cluster-setup.sh
```

### Cloud Deployment
```bash
# AWS RDS
./aws-rds-setup.sh

# Google Cloud SQL
./gcp-cloudsql-setup.sh
```

## 📋 Prerequisites

- Root or sudo access (for local installation)
- Docker (for containerized deployment)
- Cloud CLI tools (for cloud deployment)

## 🔧 Configuration

Set environment variables before running:

```bash
export POSTGRES_DB="myapp"
export POSTGRES_USER="appuser"
export POSTGRES_PASSWORD="securepassword"
export POSTGRES_PORT="5432"
export POSTGRES_VERSION="15"
```

## 📝 Features

- ✅ Multiple PostgreSQL versions support
- ✅ Automatic security configuration
- ✅ Performance tuning
- ✅ Backup and recovery setup
- ✅ Monitoring and alerting
- ✅ SSL/TLS encryption
- ✅ User and role management
- ✅ Extension installation