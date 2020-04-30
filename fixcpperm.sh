#!/bin/bash

echo ""

echo "Inform the cpuser to changes folders permissions"
read cpuser
find /home/$cpuser/public_html -type d -exec chmod 755 {} \;
echo "Done"

echo ""

echo "Inform the cpuser to changes files permissions"
read cpuser
find /home/$cpuser/public_html -type f -exec chmod 644 {} \; 
echo "Done"



