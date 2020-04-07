#!/bin/bash

echo "Preparing to delete the queue"
echo ""
service exim stop
find /var/spool/exim/input -type f -exec rm -f {} +
service exim start
echo ""
clear

