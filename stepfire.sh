#!/bin/bash


cd ~
wget https://download.configserver.com/csf.tgz 
tar -xzf csf.tgz 
cd csf/ 
sh install.sh


echo "Adding the user csf..."
useradd csf -s /bin/false
cd /etc/csf/messenger
echo "Rename the index files"
mv index.html index.html-bkp
mv index.text index.text-bkp
echo "Done..."
clear

sleep 5


echo "Downlowing the new files, please wait..."
sleep 5
wget http://arquivos.servhost.com.br/index.html --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/index.text --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Prepare to rename the files CSF"
cd /etc/csf
mv csf.allow csf.allow-bkp
mv csf.deny csf.deny-bkp
echo "Done..."
clear

sleep 5

echo "Downlowing the new files, please wait..."
wget http://arquivos.servhost.com.br/csf.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/csf.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Setting permissions for csf files configuration"
chmod 600 /etc/csf/csf.allow
chmod 600 /etc/csf/csf.deny
echo "Done..."
clear

sleep 5

echo "Prepare to rename the files permission - TCP Wrapper"
cd /etc
mv hosts.allow hosts.allow-bkp 
mv hosts.deny hosts.deny-bkp
echo "Done..."
clear

sleep 5

echo "Downlowding the new files, please wait..."
wget http://arquivos.servhost.com.br/hosts.allow --http-user=romero --http-passwd=servhost84@!
wget http://arquivos.servhost.com.br/hosts.deny --http-user=romero --http-passwd=servhost84@!
echo "Done..."
clear

sleep 5

echo "Setting new permissions"
chmod 644 /etc/hosts.allow
chmod 644 /etc/hosts.deny
echo "Done..."
clear

sleep 5

echo "user:mailman" >> /etc/csf/csf.pignore
echo "user:dovecot" >> /etc/csf/csf.pignore
echo "user:cpanelroundcube" >> /etc/csf/csf.pignore
echo "user:dovenull" >> /etc/csf/csf.pignore
echo "user:mysql" >> /etc/csf/csf.pignore
echo "user:mailnull" >> /etc/csf/csf.pignore
echo "user:rpm" >> /etc/csf/csf.pignore
clear

sleep 5

echo "Prepare to rename csf.conf"
mv /etc/csf/csf.conf /etc/csf/csf.conf-BKP
cd /etc/csf/
wget http://arquivos.servhost.com.br/csf.conf --http-user=romero --http-passwd=servhost84@!
chmod 600 csf.conf
csf -r


