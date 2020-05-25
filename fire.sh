#!/bin/bash

echo ""

echo "Statrting the process"

cd /etc/csf/
mv csf.conf csf.conf-bkp
wget http://arquivos.servhost.com.br/csf.conf --http-user=romero --http-passwd=servhost84@!
chown root.root csf.conf
chmod 644 csf.conf
bash configserverupdate.sh

echo "Done"
