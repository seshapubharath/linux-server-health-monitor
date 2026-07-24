#!/bin/bash

CONFIG_FILE="/home/bchand/linux-server-health-monitor/config.conf"

if [ -f "$CONFIG_FILE" ]; then
     source "$CONFIG_FILE"
else
     echo "Configuration file is not found"
     exit 1 
fi


echo ""
echo "Monitoring Configuration"
echo "_________________________"
echo "CPU Threshold : ${CPU_THRESHOLD}%"
echo "Memory Threshold : ${MEMORY_THRESHOLD}%"
echo "Disk Threshold : ${DISK_THRESHOLD}%"
echo "Services        :$SERVICES"


LOGFILE="/home/bchand/linux-server-health-monitor/logs/health_report.log"

ALERTFILE="/home/bchand/linux-server-health-monitor/logs/alerts.log"

rotate_log() {
    local logfile=$1
    local max_size=1048576

    if [ -f "$logfile" ]; then
        size=$(stat -c%s "$logfile")

        if [ "$size" -ge "$max_size" ]; then

            [ -f "${logfile}.2" ] && rm -f "${logfile}.2"
            [ -f "${logfile}.1" ] && mv "${logfile}.1" "${logfile}.2"

            mv "$logfile" "${logfile}.1"

            touch "$logfile"

            echo "$(date) - Log rotated: $logfile -> ${logfile}.1"
        fi
    fi
}

rotate_log "$LOGFILE"

rotate_log "$ALERTFILE"

TOTAL_MEM=$(free | awk '/Mem:/ {print $2}')

USED_MEM=$(free | awk '/Mem:/ {print $3}')

MEMORY_USAGE=$((USED_MEM * 100 / TOTAL_MEM))

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d "%")

CPU_IDLE=$(vmstat 1 2 | tail -1 | awk '{print $15}')

CPU_USAGE=$((100 - CPU_IDLE))
{

echo "===================================="
echo "      SERVER HEALTH REPORT"
echo "Generated: $(date)"
echo "====================================="


echo ""
echo "Hostname:"
hostname

echo ""
echo "System Uptime:"
uptime


echo ""

echo "Memory Usage: $MEMORY_USAGE%"

if [ $MEMORY_USAGE -gt "$MEMORY_THRESHOLD" ]

then
      MEMORY_STATUS="WARNING"
else
      MEMORY_STATUS="HEALTHY"
fi

echo "MEMORY Status: $MEMORY_STATUS"



echo ""

echo "CPU Usage: ${CPU_USAGE}%"

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]
then
     CPU_STATUS="WARNING"
else
     CPU_STATUS="HEALTHY"
fi

echo "CPU Status: $CPU_STATUS"


echo ""

echo "Disk Usage: $DISK_USAGE%"

if [ $DISK_USAGE -gt "$DISK_THRESHOLD" ]
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

for service in $SERVICES
do

          STATUS=$(systemctl is-active "$service")

	   if [ "$STATUS" = "active" ]; then
	   
	        echo "$service : RUNNING"

	   else
		echo "$service : NOT RUNNING"

	
		SERVICE_STATUS="WARNING"


                if [ -z "$FAILED_SERVICES" ]; then
		    FAILED_SERVICES="$service"
		else
		    FAILED_SERVICES="$FAILED_SERVICES, $service"
		fi
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

	EMAIL_REPORT="/tmp/email_report.txt"
    {


	echo "========================================================"

	echo "LINUX SERVER HEALTH MONITOR ALERT"

	echo "========================================================="

	echo ""


	echo "Alert Time              : $(date)"

	echo "Hostname                : $(hostname)"

	echo ""


	echo "=============== SERVER STATUS ================="
	

	echo "CPU_Status: $CPU_STATUS"

	echo "Memory Status: $MEMORY_STATUS"

	echo "Disk Status: $DISK_STATUS"

	echo "Service Status: $SERVICE_STATUS"

	echo ""
  

	echo "================ RESOURCE USAGE ================"

	echo "CPU Usage              : ${CPU_USAGE}%"
	
	echo "Memory Usage           : ${MEMORY_USAGE}%"

	echo "Disk Usage             : ${DISK_USAGE}%"

	echo ""
 

	echo "=================FAILED SERVICES================="


	if [ -z "$FAILED_SERVICES" ]; then
	    echo "None"
	else
	    echo "$FAILED_SERVICES"
	fi

	echo ""


	echo "================= OVERALL STATUS ================="

	echo "Overall Status  :  $OVERALL_STATUS"

	echo ""	


	echo "================= RECOMMENDED ACTION ================"

	if [ "$OVERALL_STATUS" = "ATTENTION REQUIRED" ]; then

	    echo "- Review system health report."

	    echo "- Restart failed services if required"

	    echo "- Investigate high resource utilization."

	    echo "- Verify application availabilit."

	    echo "- check logs for root cause analysis."
	
	else
	    echo "No action required."

	fi


	echo ""

	echo "======================================================"

	echo "Generated by Linux Server Health Monitor"

	echo "======================================================"

		

        } > "$EMAIL_REPORT"


python3 /home/bchand/linux-server-health-monitor/scripts/send_alert.py "$EMAIL_REPORT"

fi

echo ""
echo "===================================="
echo "REPORT COMPLETED"
echo "===================================="

} | tee -a "$LOGFILE"
