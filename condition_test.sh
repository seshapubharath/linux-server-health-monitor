#!/bin/bash

DISK=85

if [ $DISK -gt 80 ]

then
	echo "WARNING"
else
	echo "HEALTHY"
fi

