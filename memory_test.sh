#!/bin/bash

TOTAL=$(free | awk '/Mem:/ {print $2}')
USED=$(free | awk '/Mem:/ {print $3}')

Memory_Usage=$((USED * 100 / TOTAL))

echo "memory usage: $Memory_Usage%"

if [ $Memory_Usage -gt 80 ]

then 
     echo "WARNING"
else
     echo "HEALTHY"

fi 
