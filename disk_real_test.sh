#!/bin/bash

DISK=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')

echo "Disk usage: $DISK%"

if [ $DISK -gt 80 ]

then 
     echo "Disk status: WARNING"
else
     echo "Disk status: HEALTHY"


fi

