

#!/bin/bash

LOGFILE="../logs/health_report.log"

{

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
echo "Memory Usage:"
free -h

echo ""
echo "Disk Usage:"
df -h

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
