#!/bin/bash

echo ""

echo "Statrting the process"

cd /etc/
mv hosts.allow hosts.allow-bkp2
mv hosts.deny hosts.deny-bk2
wget http://arquivos.servhost.com.br/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/hosts.deny --http-user=romero --http-passwd=servhost84@!
chown root.root hosts.*
chmod 644 hosts.*


cd /etc/csf/
mv csf.conf csf.conf-bkp
mv csf.allow csf.allow-bkp2
mv csf.deny csf.deny-bkp2
wget http://arquivos.servhost.com.br/csf.conf --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/csf.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/csf.deny --http-user=romero --http-passwd=servhost84@!
chown root.root csf.conf
chown root.root csf.allow
chowm root.root csf.deny
chmod 644 csf.conf csf.allow csf.deny

bash configserverupdate.sh

echo "Done"
