#!/bin/bash

DISK=$(df -h)

echo "Disk Usage: $DISK%"

if [ $DISK -gt 80 ]

then
     echo "status: WARNING"
else
     echo "status: HEALTHY"

fi
