service lvestats stop
tar -zcvf /root/lveinfo_backup_$(date +%Y-%m-%d).tar.gz /var/lve/
mv /var/lve/lvestats2.db{,.old}
lve-create-db --recreate
service lvestats start 
