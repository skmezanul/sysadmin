#!/bin/bash
#Author: Fagner Mendes
#License: GNU Public License
#Version: 1.0
#This is script rebuild DB Lvestats, take care and use with moderation. Just procedeed if certain assurance!

echo "Stoping the lvestats service"
service lvestats stop
echo "The lvestats was stoped with success"
echo "Begin the backup process of lvstats DB"
tar -zcvf /root/lveinfo_backup_$(date +%Y-%m-%d).tar.gz /var/lve/
echo "The backup process was done!"
echo "Moving the BD's old"
mv /var/lve/lvestats2.db{,.old}
echo "Db's old was moved with success!"
echo "Begin the recreation process"
lve-create-db --recreate
echo "recreate was done!"
echo "Starting the lvestat service"
service lvestats start 
echo "lvestat was started successfully!"
done
