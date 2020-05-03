#!/bin/bash

echo "Prepare to intall imunify, please wait!"

echo ""

curl https://license.cc-get.com/pre.sh | bash
/usr/bin/CSPUpdate -i Imunify360
update_imunify
update_imunify --install-imunify360
echo "The process was done, configure just Malware interface, in (WHM >> Imunify360 >> Options >> Malware)"
