#!/bin/bash

# PostgreSQL Installation and Setup Script
# Supports Ubuntu, Debian, CentOS, RHEL, and Amazon Linux

set -euo pipefail

# Configuration
POSTGRES_VERSION="${POSTGRES_VERSION:-15}"
POSTGRES_DB="${POSTGRES_DB:-myapp}"
POSTGRES_USER="${POSTGRES_USER:-appuser}"
POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-$(openssl rand -base64 32)}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

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
    log_step "Updating system packages..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            apt update && apt upgrade -y
            apt install -y wget ca-certificates
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            if command -v dnf &> /dev/null; then
                dnf update -y
                dnf install -y wget ca-certificates
            else
                yum update -y
                yum install -y wget ca-certificates
            fi
            ;;
        *)
            log_error "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Install PostgreSQL
install_postgresql() {
    log_step "Installing PostgreSQL $POSTGRES_VERSION..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            # Add PostgreSQL official APT repository
            wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
            echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
            
            apt update
            apt install -y postgresql-$POSTGRES_VERSION postgresql-client-$POSTGRES_VERSION postgresql-contrib-$POSTGRES_VERSION
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            # Install PostgreSQL repository
            if command -v dnf &> /dev/null; then
                dnf install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm
                dnf install -y postgresql$POSTGRES_VERSION-server postgresql$POSTGRES_VERSION postgresql$POSTGRES_VERSION-contrib
            else
                yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
                yum install -y postgresql$POSTGRES_VERSION-server postgresql$POSTGRES_VERSION postgresql$POSTGRES_VERSION-contrib
            fi
            ;;
    esac
    
    log_info "PostgreSQL $POSTGRES_VERSION installed successfully"
}

# Initialize PostgreSQL
initialize_postgresql() {
    log_step "Initializing PostgreSQL..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            # PostgreSQL is automatically initialized on Debian/Ubuntu
            systemctl start postgresql
            systemctl enable postgresql
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            # Initialize database
            /usr/pgsql-$POSTGRES_VERSION/bin/postgresql-$POSTGRES_VERSION-setup initdb
            systemctl start postgresql-$POSTGRES_VERSION
            systemctl enable postgresql-$POSTGRES_VERSION
            ;;
    esac
    
    log_info "PostgreSQL initialized and started"
}

# Configure PostgreSQL
configure_postgresql() {
    log_step "Configuring PostgreSQL..."
    
    # Find PostgreSQL data directory
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            PG_DATA_DIR="/etc/postgresql/$POSTGRES_VERSION/main"
            PG_CONFIG_FILE="$PG_DATA_DIR/postgresql.conf"
            PG_HBA_FILE="$PG_DATA_DIR/pg_hba.conf"
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            PG_DATA_DIR="/var/lib/pgsql/$POSTGRES_VERSION/data"
            PG_CONFIG_FILE="$PG_DATA_DIR/postgresql.conf"
            PG_HBA_FILE="$PG_DATA_DIR/pg_hba.conf"
            ;;
    esac
    
    # Backup original configuration
    cp "$PG_CONFIG_FILE" "$PG_CONFIG_FILE.backup"
    cp "$PG_HBA_FILE" "$PG_HBA_FILE.backup"
    
    # Configure PostgreSQL settings
    cat >> "$PG_CONFIG_FILE" << EOF

# Custom configuration
listen_addresses = 'localhost'
port = $POSTGRES_PORT
max_connections = 100
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 4MB
min_wal_size = 1GB
max_wal_size = 4GB

# Logging
log_destination = 'stderr'
logging_collector = on
log_directory = 'log'
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_rotation_age = 1d
log_rotation_size = 10MB
log_min_duration_statement = 1000
log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h '
log_checkpoints = on
log_connections = on
log_disconnections = on
log_lock_waits = on
log_temp_files = 0
EOF
    
    # Configure authentication
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = 'localhost'/" "$PG_CONFIG_FILE"
    
    log_info "PostgreSQL configuration updated"
}

# Setup database and user
setup_database() {
    log_step "Setting up database and user..."
    
    # Switch to postgres user and create database and user
    sudo -u postgres psql << EOF
CREATE DATABASE $POSTGRES_DB;
CREATE USER $POSTGRES_USER WITH ENCRYPTED PASSWORD '$POSTGRES_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $POSTGRES_DB TO $POSTGRES_USER;
ALTER USER $POSTGRES_USER CREATEDB;
\q
EOF
    
    log_info "Database '$POSTGRES_DB' and user '$POSTGRES_USER' created"
}

# Setup firewall
setup_firewall() {
    log_step "Configuring firewall..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            if command -v ufw &> /dev/null; then
                ufw allow $POSTGRES_PORT/tcp
                log_info "UFW firewall rule added for port $POSTGRES_PORT"
            fi
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            if command -v firewall-cmd &> /dev/null; then
                firewall-cmd --permanent --add-port=$POSTGRES_PORT/tcp
                firewall-cmd --reload
                log_info "Firewalld rule added for port $POSTGRES_PORT"
            fi
            ;;
    esac
}

# Create backup script
create_backup_script() {
    log_step "Creating backup script..."
    
    cat > /usr/local/bin/postgres-backup.sh << 'EOF'
#!/bin/bash

# PostgreSQL Backup Script
BACKUP_DIR="/var/backups/postgresql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="$1"

if [ -z "$DB_NAME" ]; then
    echo "Usage: $0 <database_name>"
    exit 1
fi

mkdir -p "$BACKUP_DIR"

# Create backup
sudo -u postgres pg_dump "$DB_NAME" | gzip > "$BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"

# Keep only last 7 days of backups
find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -mtime +7 -delete

echo "Backup completed: $BACKUP_DIR/${DB_NAME}_${DATE}.sql.gz"
EOF
    
    chmod +x /usr/local/bin/postgres-backup.sh
    
    # Create backup directory
    mkdir -p /var/backups/postgresql
    chown postgres:postgres /var/backups/postgresql
    
    log_info "Backup script created at /usr/local/bin/postgres-backup.sh"
}

# Restart PostgreSQL
restart_postgresql() {
    log_step "Restarting PostgreSQL..."
    
    case "$OS" in
        *"Ubuntu"*|*"Debian"*)
            systemctl restart postgresql
            ;;
        *"CentOS"*|*"Red Hat"*|*"Amazon Linux"*)
            systemctl restart postgresql-$POSTGRES_VERSION
            ;;
    esac
    
    log_info "PostgreSQL restarted successfully"
}

# Display connection information
display_info() {
    log_info "PostgreSQL installation completed successfully!"
    echo
    echo "Connection Information:"
    echo "======================"
    echo "Host: localhost"
    echo "Port: $POSTGRES_PORT"
    echo "Database: $POSTGRES_DB"
    echo "Username: $POSTGRES_USER"
    echo "Password: $POSTGRES_PASSWORD"
    echo
    echo "Connection string:"
    echo "postgresql://$POSTGRES_USER:$POSTGRES_PASSWORD@localhost:$POSTGRES_PORT/$POSTGRES_DB"
    echo
    echo "To connect using psql:"
    echo "psql -h localhost -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB"
    echo
    echo "To create a backup:"
    echo "/usr/local/bin/postgres-backup.sh $POSTGRES_DB"
    echo
    echo "IMPORTANT: Please save the password securely!"
}

# Main execution
main() {
    log_info "Starting PostgreSQL installation and setup..."
    
    check_root
    detect_os
    update_system
    install_postgresql
    initialize_postgresql
    configure_postgresql
    setup_database
    setup_firewall
    create_backup_script
    restart_postgresql
    display_info
}

# Run main function
main "$@"