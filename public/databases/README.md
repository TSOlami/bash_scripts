# Database Deployment Scripts

Scripts for setting up and deploying various database systems across different platforms.

## 📁 Directory Structure

```
databases/
├── postgresql/
├── mysql/
├── mongodb/
├── redis/
├── elasticsearch/
├── influxdb/
├── cassandra/
├── neo4j/
├── sqlite/
└── mariadb/
```

## 🗄️ Supported Databases

### Relational Databases
- **PostgreSQL** - Advanced open-source relational database
- **MySQL** - Popular open-source relational database
- **MariaDB** - MySQL-compatible database server
- **SQLite** - Lightweight embedded database

### NoSQL Databases
- **MongoDB** - Document-oriented database
- **Cassandra** - Wide-column store database
- **Neo4j** - Graph database

### In-Memory Databases
- **Redis** - In-memory data structure store
- **Memcached** - Distributed memory caching system

### Search & Analytics
- **Elasticsearch** - Search and analytics engine
- **InfluxDB** - Time series database

## 🚀 Quick Start

1. Choose your database system
2. Navigate to the database directory
3. Read the database-specific README
4. Run the setup script

```bash
cd databases/postgresql
sudo ./setup.sh
```

## 📋 Deployment Options

Each database supports multiple deployment methods:
- **Local Installation** - Direct server installation
- **Docker Deployment** - Containerized deployment
- **Cloud Deployment** - Managed cloud services
- **Cluster Setup** - High-availability clusters

## 🔧 Common Features

All database scripts include:
- ✅ Automated installation
- ✅ Security configuration
- ✅ Performance optimization
- ✅ Backup setup
- ✅ Monitoring configuration
- ✅ User management
- ✅ SSL/TLS setup
- ✅ Firewall configuration

## 📝 Configuration

Most scripts support environment variables:

```bash
export DB_NAME="myapp"
export DB_USER="appuser"
export DB_PASSWORD="securepassword"
export DB_HOST="localhost"
export DB_PORT="5432"
```