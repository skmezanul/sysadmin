#!/bin/bash

echo ""

cd /root
wget https://download.configserver.com/cxsinstaller.tgz
tar -xzf cxsinstaller.tgz
perl cxsinstaller.pl
rm -fv cxsinstaller.*
cxs --qcreate --quarantine /home/safe
chmod 755 /home/safe
cp /etc/cxs/cxs.ignore.example /etc/cxs/cxs.ignore

sed -i '18 s/^/#/' /etc/cxs/cxswatch.sh
echo "/usr/sbin/cxs --Wstart --mail root -Q /home/safe -I /etc/cxs/cxs.ignore --qopt mMfSGhexTv --www --all" >> /etc/cxs/cxswatch.sh

echo "Starting the service now"
systemctl start cxswatch


echo "0 5 * * * /usr/sbin/cxs --upgrade --quiet" >> /var/spool/cron/root
echo "0 3 10 * * /usr/sbin/cxs --report /root/scan.log --mail romer.ayub@gmail.com --virusscan --voptions fmMhexT --qoptions Mv --ignore /etc/cxs/cxs.ignore --options OLfmMChexdDZRP --all" >> /var/spool/cron/root
