#!/bin/bash

###############################################################################
# Copyright 2020							                                                
# Author: Fagner Mendes							                                          
# License: GNU Public License						                                      
# Version: 1.2								                                                  
# Email: fagner.mendes22@gmail.com					                                  
###############################################################################

<< 'CHANGELOG'

1.1 - 01/04/2020 [Author: Fagner Mendes]
#Changes
- Change the functions (Disable functions, change permissions, )

1.2 - 03/04/2020 [Author: Fagner Mendes]
#Chaneges
- Changend the function to update cPanel
- Added the function to stalling the utilites
- Changed functios to change Selinux
- Added function to check roundcube DB
- Added function to check the hostname
- Changed the function to change the Apache port
- Added the function to install custom EA
- Added the step to download php.ini files

CHANGELOG


echo ""


echo "Starting the update server"
yum update -y
echo "Done..."
clear

sleep 5

echo "Updating the cPanel, please wait..."
/scripts/upcp --force > /root/upcp.log
echo "Done"
clear

sleep 5

echo "Prepare to change the interface - inform the actual IP address"
sed -i 's/IPADDR=216.120.234.31/IPADDR=216.120.234.31/g' /etc/sysconfig/network-scripts/ifcfg-ens3
echo "Done
clear

sleep 5

echo "Prepare to disable functions in the server"
for SERVICE in autofs cups nfslock rpcidmapd rpcidmapd bluetooth anacron hidd pcscd avahi-daemon
do
        service "$SERVICE" stop > /dev/null 2>&1
        chkconfig "$SERVICE" off > /dev/null 2>&1
done
echo "Done..."
clear

sleep 5

echo "Prepare to changes the permission files"
for FILES1 in /usr/bin/rcp /usr/bin/rcp /usr/bin/lynx /usr/bin/links /usr/bin/scp /usr/bin/gcc
do

chmod 750 "$FILES1" > /dev/null 2>&1
done

for FILES2 in /etc/httpd/proxy/ /var/spool/samba/ /var/mail/vbox/
do

chmod 000 "$FILES2" > /dev/null 2>&1
done

echo "Done"

clear

echo "Install DNS Check"

cd ~
wget http://download.ndchost.com/accountdnscheck/latest-accountdnscheck
sh latest-accountdnscheck
echo "Done..."
clear

sleep 5

echo "Adding script remove"
echo "30 23 * * * sh /root/remover.sh" >> /var/spool/cron/root
chmod 755 /root/remover.sh
echo "Done..."
clear

sleep 5

echo "Running the fix quotas"
/scripts/fixquotas
echo "Done..."
clear

sleep 5

echo "Apache monitor, please wait while set the permission"
sleep 5
chmod 755 /root/cron/http.sh
echo "00 * * * * sh /root/cron/http.sh" >> /var/spool/cron/root
echo "Done..."
clear

sleep 5

echo "Change the Apache port"
sed -i 's/apache_port=0.0.0.0:82/apache_port=0.0.0.0:80/g' /var/cpanel/cpanel.config
sed -i 's/apache_ssl_port=0.0.0.0:445/apache_ssl_port=0.0.0.0:443/g' /var/cpanel/cpanel.config
echo "Done..."
clear

sleep 5

echo "Stalling the utilities"
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/installtools.sh)
echo "Done..."
cd /root/
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/.mytop
echo "Mytop is configured"
clear

sleep 5

echo "Disabling Selinux"
sed -i 's/permissive\|enforcing/disabled/g' /etc/selinux/config
echo "Done..."
clear

sleep 5

echo "Add script for update configserver"
cd /root/
https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/updatecs.sh
chmod +x updatecs.sh
echo "00 22 * * 1,6 bash /root/configserverupdate.sh" >> /var/spool/cron/root
echo "Done"
clear

sleep 5

echo "Prepare to check Roundcube DB"
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/roudcubebase.sh)
echo "Is all right? Press <ENTER> to continue"
read #pause until ENTER is pressed
echo "Done..."
clear


echo "Prepare to create hook SPF - custom template dns zones"
bash <( curl -s https://raw.githubusercontent.com/fagner-fmlo/sysadmin/master/createhooksspf.sh)
echo "Done"
clear

sleep 5


echo "Check the hostname"
HOSTNAME=`echo $HOSTNAME`
echo "'$HOSTNAME'Is correct?, otherwise Press Press <ENTER> and enter the new hostname"
read #pause until ENTER is pressed
clear
echo "Inform the new hostname"
read new_hostname
echo $new_hostname > /etc/hostname
clear
echo "The new hostname is: '$new_hostname' "

sleep 5


echo "Prepare to install EA customization, since 5.4 to 7.3 and any extensions"
mkdir /etc/cpanel/ea4/profiles/custom
cd /etc/cpanel/ea4/profiles/custom
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea-custom.json
echo "Install now, please wait...!"
sleep 5
/usr/local/bin/ea_install_profile --install /etc/cpanel/ea4/profiles/custom/ea-custom.json > /root/easyapacheinstall.log
echo "Done..."
clear

sleep 5

echo "Downloading the php.ini files for all php versions"
cd /opt/cpanel/ea-php54/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.4-php.ini
mv ea.5.4-php.ini php.ini
echo "done"
clear

cd /opt/cpanel/ea-php55/root/etc/
mv php.ini php.ini-bkp
https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.5-php.ini
mv ea.5.5-php.ini php.ini
echo "done"
clear

cd /opt/cpanel/ea-php56/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.5.6-php.ini
mv ea.5.6-php.ini php.ini
echo "done"
clear

cd /opt/cpanel/ea-php70/root/etc/
mv php.ini php.ini-bkp
https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.0-php.ini
mv ea.7.0-php.ini php.ini
echo "done"
clear

cd /opt/cpanel/ea-php71/root/etc/
mv php.ini php.ini-bkp
wget https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.1-php.ini
mv ea.7.1-php.ini php.ini
echo "done"
clear

cd /opt/cpanel/ea-php72/root/etc/
mv php.ini php.ini-bkp
https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.2-php.ini
mv ea.7.2-php.ini php.ini
echo "done"
clear

cd cd /opt/cpanel/ea-php72/root/etc/
mv php.ini php.ini-bkp
https://raw.githubusercontent.com/fagner-fmlo/arquivos/master/ea.7.3-php.ini
mv ea.7.3-php.ini php.ini
echo "done"
clear


