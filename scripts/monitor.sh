

#!/bin/bash

LOGFILE="../logs/health_report.log"

{

TOTAL_MEM=$(free | awk '/Mem:/ {print $2}')

USED_MEM=$(free | awk '/Mem:/ {print $3}')

MEMORY_USAGE=$((USED_MEM * 100 / TOTAL_MEM))

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d "%")

CPU_IDLE=$(top -bn1 | grep "%Cpu" | awk '{print $8}' | tr -d ',')

CPU_USAGE=$(awk "BEGIN {print 100 - $CPU_IDLE}")

echo "===================================="
echo "      SERVER HEALTH REPORT"
echo "Generated: $(date)"
echo "===================================="


echo ""
echo "Hostname:"
hostname

echo ""
echo "System Uptime:"
uptime

echo ""
echo "Memory Usage: $MEMORY_USAGE%"

if [ $MEMORY_USAGE -gt 80 ]

then
      echo "Memory status: WARNING"
else
      echo "Memory status: HEALTHY"
fi

echo ""

echo "cpu usage: $CPU_USAGE%"

CPU_USAGE_INT=$(printf "%.0f" "$CPU_USAGE")

if [ $CPU_USAGE_INT -gt 80 ]
then
     echo "Cpu status: WARNING"
else
     echo "Cpu status: HEALTHY"
fi


echo ""
echo "Disk Usage: $DISK_USAGE%"

if [ $DISK_USAGE -gt 80 ]
then
     echo "Disk Status: WARNING"
else
     echo "Disk Status: HEALTHY"
fi


echo ""
echo "Logged-in Users:"
who

echo ""
echo "Top 10 Processes by Memory Usage:"
ps aux --sort=-%mem | head

echo ""
echo "===================================="
echo "      REPORT COMPLETED"
echo "===================================="
echo ""

} | tee -a "$LOGFILE"
