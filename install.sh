#!/bin/bash

###############################################################################
# Linux Server Health Monitor
# Installer Script
# Version : v10.5
# Author  : Bharath Chand
###############################################################################

set -e

##############################################
# Colors
##############################################

GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BLUE="\e[34m"
CYAN="\e[36m"
NC="\e[0m"

##############################################
# Variables
##############################################

PROJECT_NAME="Linux Server Health Monitor"

INSTALL_DIR="$(cd "$(dirname "$0")" && pwd)"

LOG_DIR="$INSTALL_DIR/logs"

REPORT_DIR="$INSTALL_DIR/reports"

SCRIPT_DIR="$INSTALL_DIR/scripts"

CONFIG_DIR="$INSTALL_DIR/config"

STATE_FILE="$LOG_DIR/server_state.txt"

CRON_JOB="*/5 * * * * bash $SCRIPT_DIR/monitor.sh >/dev/null 2>&1"

##############################################
# Helper Functions
##############################################

print_header() {

echo -e "${BLUE}"
echo "======================================================="
echo "           $PROJECT_NAME Installer"
echo "======================================================="
echo -e "${NC}"

}

success() {

echo -e "${GREEN}[✔] $1${NC}"

}

warning() {

echo -e "${YELLOW}[!] $1${NC}"

}

error_exit() {

echo -e "${RED}[✘] $1${NC}"
exit 1

}

##############################################
# Check Linux
##############################################

check_os() {

echo
echo "Checking Operating System..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    success "Linux detected."
else
    error_exit "This installer supports Linux only."
fi

}

##############################################
# Check Bash
##############################################

check_bash() {

echo
echo "Checking Bash..."

if command -v bash >/dev/null 2>&1; then

    VERSION=$(bash --version | head -n1)

    success "$VERSION"

else

    error_exit "Bash is not installed."

fi

}

##############################################
# Check Python
##############################################

check_python() {

echo
echo "Checking Python..."

if command -v python3 >/dev/null 2>&1; then

    VERSION=$(python3 --version)

    success "$VERSION"

else

    error_exit "Python3 is required."

fi

}

##############################################
# Check Cron
##############################################

check_cron() {

echo
echo "Checking Cron..."

if command -v crontab >/dev/null 2>&1; then

    success "Cron available."

else

    warning "Cron is not installed."

fi

}

##############################################
# Validate Project Files
##############################################

validate_project() {

echo
echo "Validating Project..."

FILES=(
"$SCRIPT_DIR/monitor.sh"
"$SCRIPT_DIR/logger.sh"
"$SCRIPT_DIR/utils.sh"
"$SCRIPT_DIR/send_alert.py"
"$CONFIG_DIR/config.conf"

)

for file in "${FILES[@]}"
do

    if [ ! -f "$file" ]; then

        error_exit "Missing: $file"

    fi

done

success "Project validation successful."

}

create_config_env() {

echo
echo "Checking config.env..."

CONFIG_ENV="$CONFIG_DIR/config.env"

if [ ! -f "$CONFIG_ENV" ]; then

cat > "$CONFIG_ENV" <<EOF
SENDER_EMAIL=
APP_PASSWORD=
RECEIVER_EMAIL=
EOF

warning "config.env was not found."

warning "A template has been created."

warning "Please edit config/config.env before running monitor.sh."

else

success "config.env found."

fi

}

##############################################
# Create Directories
##############################################

create_directories() {

echo
echo "Creating directories..."

mkdir -p "$LOG_DIR"
mkdir -p "$REPORT_DIR"

success "Directories ready."

}

##############################################
# Create Log Files
##############################################

create_files() {

echo
echo "Creating log files..."

touch "$LOG_DIR/health_report.log"
touch "$LOG_DIR/alerts.log"
touch "$STATE_FILE"

success "Required files created."

}

##############################################
# Set Permissions
##############################################

set_permissions() {

echo
echo "Setting permissions..."

chmod +x "$SCRIPT_DIR/"*.sh
chmod +x install.sh

success "Executable permissions applied."

}

##############################################
# Install Cron Job
##############################################

install_cron() {

    echo
    echo "Installing cron job..."

    local current_cron
    current_cron=$(crontab -l 2>/dev/null || true)

    if echo "$current_cron" | grep -Fq "$SCRIPT_DIR/monitor.sh"; then
        warning "Cron job already exists."
        return
    fi

    printf "%s\n%s\n" \
        "$current_cron" \
        "$CRON_JOB" | crontab -

    # Verify installation
    if crontab -l | grep -Fq "$SCRIPT_DIR/monitor.sh"; then
        success "Cron job installed successfully."
    else
        error_exit "Failed to install cron job."
    fi
}
##############################################
# Installation Summary
##############################################

summary() {

echo
echo -e "${CYAN}"
echo "======================================================="
echo "Installation Completed Successfully"
echo "======================================================="
echo

echo "Project Directory : $INSTALL_DIR"
echo "Logs Directory    : $LOG_DIR"
echo "Reports Directory : $REPORT_DIR"

echo

echo "Monitoring Interval : Every 5 Minutes"

echo

echo "Run manually using:"
echo
echo "bash scripts/monitor.sh"

echo
echo "Cron Status : Installed"

echo "======================================================="
echo -e "${NC}"

}

##############################################
# Main
##############################################

print_header

check_os

check_bash

check_python

check_cron

validate_project

create_config_env

create_directories

create_files

set_permissions

install_cron

summary
