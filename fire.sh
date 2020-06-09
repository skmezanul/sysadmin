#!/bin/bash

echo ""

echo "Starting the process"

cd /etc/
mv hosts.allow hosts.allow-bkp2
mv hosts.deny hosts.deny-bk2
wget http://arquivos.servhost.com.br/vps/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/vps/hosts.deny --http-user=romero --http-passwd=servhost84@!
chown root.root hosts.*
chmod 644 hosts.*


cd /etc/csf/
mv csf.conf csf.conf-bkp
mv csf.allow csf.allow-bkp2
mv csf.deny csf.deny-bkp2
wget http://arquivos.servhost.com.br/vps/csf.conf --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/vps/csf.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/vps/csf.deny --http-user=romero --http-passwd=servhost84@!
chown root.root csf.conf
chown root.root csf.allow
chown root.root csf.deny
chmod 644 csf.conf csf.allow csf.deny

bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/updatecs.sh)

echo "Done"

cd /etc/cron.hourly
wget http://arquivos.servhost.com.br/vps/flushdeny.sh --http-user=romero --http-passwd=servhost84@!
chmod +x flushdeny.sh

echo "done"

