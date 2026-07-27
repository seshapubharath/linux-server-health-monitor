#!/bin/bash

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"

source "$BASE_DIR/scripts/logger.sh"
source "$BASE_DIR/scripts/utils.sh"

CONFIG_DIR="$BASE_DIR/config"

CONFIG_FILE="$CONFIG_DIR/config.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    log_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

source "$CONFIG_FILE"

log_success "Configuration loaded successfully."


print_title "MONITORING CONFIGURATION"

printf "%-22s %s%%\n" "CPU Threshold :" "$CPU_THRESHOLD"
printf "%-22s %s%%\n" "Memory Threshold :" "$MEMORY_THRESHOLD"
printf "%-22s %s%%\n" "Disk Threshold :" "$DISK_THRESHOLD"
printf "%-22s %s\n" "Services :" "$SERVICES"



LOGFILE="$BASE_DIR/logs/health_report.log"
ALERTFILE="$BASE_DIR/logs/alerts.log"
STATE_FILE="$BASE_DIR/logs/server_state.txt"


rotate_log "$LOGFILE"

rotate_log "$ALERTFILE"



CPU_USAGE=$(get_cpu_usage)
MEMORY_USAGE=$(get_memory_usage)
DISK_USAGE=$(get_disk_usage)
{

log_info "Starting Linux Server Health Monitor..."

print_title "LINUX SERVER HEALTH MONITOR"

printf "%-18s %s\n" "Generated At :" "$(date)"
printf "%-18s %s\n" "Hostname :" "$(get_hostname)"
printf "%-18s %s\n" "OS :" "$(get_os_name)"
printf "%-18s %s\n" "Kernel :" "$(get_kernel_version)"
printf "%-18s %s\n" "IP Address :" "$(get_ip_address)"
printf "%-18s %s\n" "Uptime :" "$(get_uptime)"
printf "%-18s %s\n" "Logged Users :" "$(who | wc -l)"
echo
echo "Active Sessions"

who

echo ""

if [ $MEMORY_USAGE -gt "$MEMORY_THRESHOLD" ]; then
      MEMORY_STATUS="WARNING"
	   log_warning "MEMORY usage exceeded threshold (${MEMORY_USAGE}% > ${MEMORY_THRESHOLD}%)"
else
      MEMORY_STATUS="HEALTHY"
fi

print_row "Memory" "${MEMORY_USAGE}%" "$(status_badge "$MEMORY_STATUS")"




echo ""

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
     CPU_STATUS="WARNING"
	  log_warning "CPU usage exceeded threshold (${CPU_USAGE}% > ${CPU_THRESHOLD}%)"
else
     CPU_STATUS="HEALTHY"
fi

print_row "CPU" "${CPU_USAGE}%" "$(status_badge "$CPU_STATUS")"



echo ""

if [ $DISK_USAGE -gt "$DISK_THRESHOLD" ]; then
     DISK_STATUS="WARNING"
	  log_warning "DISK usage exceeded threshold (${DISK_USAGE}% > ${DISK_THRESHOLD}%)"
else
     DISK_STATUS="HEALTHY"
fi

print_row "Disk" "${DISK_USAGE}%" "$(status_badge "$DISK_STATUS")"


echo ""
echo "Logged-in Users:"
who

echo ""
print_title "TOP MEMORY CONSUMING PROCESSES"
ps aux --sort=-%mem | head

echo ""
    SERVICE_STATUS="HEALTHY"
    FAILED_SERVICES=""

print_title "SERVICES"

printf "%-25s %-20s\n" "SERVICE" "STATUS"

SERVICE_STATUS="HEALTHY"
FAILED_SERVICES=""

for service in $SERVICES
do
    # Skip if service is not installed
    if ! systemctl list-unit-files --type=service | grep -q "^${service}\.service"; then

        print_row "$service" "" "$(status_badge "NOT INSTALLED")"

        log_info "Service '$service' is not installed. Skipping."

        continue
    fi

    STATUS=$(systemctl is-active "$service")

    if [ "$STATUS" = "active" ]; then

        print_row "$service" "" "$(status_badge RUNNING)"

    else

        print_row "$service" "" "$(status_badge STOPPED)"

        SERVICE_STATUS="WARNING"

        log_warning "Service '$service' is not running."

        if [ -z "$FAILED_SERVICES" ]; then
            FAILED_SERVICES="$service"
        else
            FAILED_SERVICES="$FAILED_SERVICES, $service"
        fi
    fi
done


echo ""
OVERALL_STATUS="HEALTHY"

if [ "$CPU_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi

if [ "$MEMORY_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi
 
if [ "$DISK_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi

print_title "RESOURCE SUMMARY"

printf "%-20s %-15s %-15s\n" "RESOURCE" "USAGE" "STATUS"

printf "%-15s %-10s %-10s\n" "CPU" "${CPU_USAGE}%" "$CPU_STATUS"
printf "%-15s %-10s %-10s\n" "Memory" "${MEMORY_USAGE}%" "$MEMORY_STATUS"
printf "%-15s %-10s %-10s\n" "Disk" "${DISK_USAGE}%" "$DISK_STATUS"

if [ "$SERVICE_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi


echo ""

if [ "$OVERALL_STATUS" = "ATTENTION REQUIRED" ]; then
    log_warning "Overall Status : ATTENTION REQUIRED"
else
    log_success "Overall Status : HEALTHY"
fi

touch "$STATE_FILE"


if [ ! -f "$STATE_FILE" ]; then
    echo "UNKNOWN" > "$STATE_FILE"
fi

PREVIOUS_STATUS=""

if [ -f "$STATE_FILE" ]; then
    PREVIOUS_STATUS=$(cat "$STATE_FILE")
fi

REPORT_DIR="$BASE_DIR/reports"

mkdir -p "$REPORT_DIR"

REPORT_JSON="$REPORT_DIR/server_report.json"

cat > "$REPORT_JSON" <<EOF
{
    "hostname":"$(get_hostname)",
    "os":"$(get_os_name)",
    "kernel":"$(get_kernel_version)",
    "ip":"$(get_ip_address)",
    "time":"$(date)",
    "overall_status":"$OVERALL_STATUS",
    "resources":{
        "cpu":{
            "usage":$CPU_USAGE,
            "status":"$CPU_STATUS"
        },
        "memory":{
            "usage":$MEMORY_USAGE,
            "status":"$MEMORY_STATUS"
        },
        "disk":{
            "usage":$DISK_USAGE,
            "status":"$DISK_STATUS"
        }
    },
    "services":[
EOF

FIRST=true

for service in $SERVICES
do
    if ! systemctl list-unit-files --type=service | grep -q "^${service}\.service"; then
        SERVICE_STATE="NOT INSTALLED"
    else
        STATUS=$(systemctl is-active "$service")

        if [ "$STATUS" = "active" ]; then
            SERVICE_STATE="RUNNING"
        else
            SERVICE_STATE="STOPPED"
        fi
    fi

    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        echo "," >> "$REPORT_JSON"
    fi

    cat >> "$REPORT_JSON" <<EOF
        {
            "name":"$service",
            "status":"$SERVICE_STATE"
        }
EOF
done

cat >> "$REPORT_JSON" <<EOF

    ]
}
EOF

if [ "$OVERALL_STATUS" != "$PREVIOUS_STATUS" ]; then

    echo "$OVERALL_STATUS" > "$STATE_FILE"

    python3 "$BASE_DIR/scripts/send_alert.py" "$REPORT_JSON"

    log_info "Status changed. Email notification sent."

else

    log_info "No status change. Email notification skipped."

fi

echo ""
print_line
log_success "Health report generated successfully."
log_info "Log file : $LOGFILE"
print_line
} | tee -a "$LOGFILE"
