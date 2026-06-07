

#!/bin/bash


echo "===================================="
echo "      SERVER HEALTH REPORT"
echo "===================================="

echo ""
echo "Date & Time:"
date

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
