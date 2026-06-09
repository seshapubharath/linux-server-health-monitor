#!/bin/bash


LOGFILE="/home/bchand/linux-server-health-monitor/logs/health_report.log"

ALERTFILE="/home/bchand/linux-server-health-monitor/logs/alerts.log"
{

TOTAL_MEM=$(free | awk '/Mem:/ {print $2}')

USED_MEM=$(free | awk '/Mem:/ {print $3}')

MEMORY_USAGE=$((USED_MEM * 100 / TOTAL_MEM))

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d "%")

CPU_IDLE=$(vmstat 1 2 | tail -1 | awk '{print $15}')

CPU_USAGE=$((100 - CPU_IDLE))

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
      MEMORY_STATUS="WARNING"
else
      MEMORY_STATUS="HEALTHY"
fi

echo "MEMORY Status: $MEMORY_STATUS"



echo ""

echo "CPU Usage: ${CPU_USAGE}%"

if [ "$CPU_USAGE" -gt 80 ]
then
     CPU_STATUS="WARNING"
else
     CPU_STATUS="HEALTHY"
fi

echo "CPU Status: $CPU_STATUS"


echo ""

echo "Disk Usage: $DISK_USAGE%"

if [ $DISK_USAGE -gt 80 ]
then
     DISK_STATUS="WARNING"
else
     DISK_STATUS="HEALTHY"
fi

echo "DISK Status: $DISK_STATUS"


echo ""
echo "Logged-in Users:"
who

echo ""
echo "Top 10 Processes by Memory Usage:"
ps aux --sort=-%mem | head

echo ""

echo "===================================="

echo "SERVICE STATUS"

echo "===================================="
         

      SERVICE_STATUS="HEALTHY"
      FAILED_SERVICES=""

for service in sshd crond NetworkManager
do

          STATUS=$(systemctl is-active $service)

	   if [ "$STATUS" = "active" ]
	   then
	        echo "$service : RUNNING"

	   else
		echo "$service : NOT RUNNING"	
		SERVICE_STATUS="WARNING"
	        FAILED_SERVICES="$FAILED_SERVICES $service"
	  fi
done



echo ""
echo "===================================="

echo "SERVER HEALTH SUMMARY"

echo "====================================="



echo "MEMORY: $MEMORY_STATUS"

echo "DISK: $DISK_STATUS"

echo "CPU: $CPU_STATUS"

echo "Services: $SERVICE_STATUS"


OVERALL_STATUS="HEALTHY - NO ACTION REQUIRED"

if [ "$CPU_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi

if [ "$MEMORY_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi
 
if [ "$DISK_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi

if [ "$SERVICE_STATUS" = "WARNING" ]; then
    OVERALL_STATUS="ATTENTION REQUIRED"
fi


echo ""

echo "OVERALL STATUS IS: $OVERALL_STATUS"

if [ "$OVERALL_STATUS" = "ATTENTION REQUIRED" ]
then
    {


	echo "==============================="

	echo "ALERT GENERATED"

	echo "==============================="

	echo "Timestamp: $(date)"

	echo "CPU Status: $CPU_STATUS"

	echo "Memory Status: $MEMORY_STATUS"

	echo "Disk Status: $DISK_STATUS"

	echo "Service Status: $SERVICE_STATUS"

	echo "Failed Services: $FAILED_SERVICES"

	echo "OVERALL STATUS: ATTENTION REQUIRED"

	echo "================================="


} >> "$ALERTFILE"

python3 /home/bchand/linux-server-health-monitor/scripts/send_alert.py

fi

echo ""
echo "===================================="
echo "      REPORT COMPLETED"
echo "===================================="

} | tee -a "$LOGFILE"
