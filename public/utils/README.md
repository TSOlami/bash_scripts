# Utility Scripts and Common Functions

Shared utilities, helper functions, and common scripts used across deployment scripts.

## 📁 Directory Structure

```
utils/
├── common.sh           # Common functions and utilities
├── logging.sh          # Logging functions
├── validation.sh       # Input validation functions
├── security.sh         # Security hardening functions
├── monitoring.sh       # Monitoring setup functions
├── backup.sh          # Backup utilities
├── ssl.sh             # SSL/TLS certificate functions
└── cleanup.sh         # Cleanup and maintenance scripts
```

## 🛠️ Available Utilities

### Common Functions (`common.sh`)
- OS detection
- Package manager detection
- Service management
- File operations
- Network utilities

### Logging (`logging.sh`)
- Colored output functions
- Log levels (INFO, WARN, ERROR)
- Log file management
- Progress indicators

### Validation (`validation.sh`)
- Input validation
- Dependency checking
- Configuration validation
- Network connectivity tests

### Security (`security.sh`)
- Firewall configuration
- User management
- Permission setting
- Security hardening

### Monitoring (`monitoring.sh`)
- System monitoring setup
- Log monitoring
- Performance metrics
- Alert configuration

## 🚀 Usage

### Source Common Functions
```bash
#!/bin/bash
source "$(dirname "$0")/../../utils/common.sh"
source "$(dirname "$0")/../../utils/logging.sh"

# Use functions
detect_os
log_info "Starting deployment..."
```

### Standalone Utilities
```bash
# Run security hardening
./utils/security.sh

# Setup monitoring
./utils/monitoring.sh

# Create SSL certificates
./utils/ssl.sh example.com
```

## 📝 Function Reference

### Common Functions
- `detect_os()` - Detect operating system
- `check_root()` - Verify root privileges
- `install_package()` - Install packages across OS
- `start_service()` - Start system services
- `enable_service()` - Enable services at boot

### Logging Functions
- `log_info()` - Information messages
- `log_warn()` - Warning messages
- `log_error()` - Error messages
- `log_step()` - Step indicators

### Validation Functions
- `validate_email()` - Email validation
- `validate_domain()` - Domain validation
- `check_port()` - Port availability
- `check_dependencies()` - Dependency verification