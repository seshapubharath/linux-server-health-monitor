
#!/bin/bash

#############################################
# logger.sh
# Logging utilities for Linux Server Health Monitor
#############################################

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# ---------- Timestamp ----------
timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

# ---------- Log Functions ----------
log_info() {
    echo -e "$(timestamp) ${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "$(timestamp) ${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "$(timestamp) ${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "$(timestamp) ${RED}[ERROR]${NC} $1"
}

# ---------- UI Helpers ----------
print_line() {
    printf '%*s\n' 70 '' | tr ' ' '='
}

print_subline() {
    printf '%*s\n' 70 '' | tr ' ' '-'
}

print_title() {
    echo
    print_line
    printf "%35s\n" "$1"
    print_line
}

status_badge() {

    case "$1" in
        HEALTHY)
            echo -e "${GREEN}HEALTHY${NC}"
            ;;
        WARNING)
            echo -e "${YELLOW}WARNING${NC}"
            ;;
        CRITICAL)
            echo -e "${RED}CRITICAL${NC}"
            ;;
        RUNNING)
            echo -e "${GREEN}RUNNING${NC}"
            ;;
        STOPPED)
            echo -e "${RED}STOPPED${NC}"
            ;;
        *)
            echo "$1"
            ;;
    esac
}

print_row() {

    printf "%-18s %-12s %-15b\n" "$1" "$2" "$3"
}

