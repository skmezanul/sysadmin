mysqladmin proc | grep "Waiting for table level lock" | wc -l >> /root/mysqlproc.txt
for proc in $( cat /root/mysqlproc.txt ) ; do mysqladmin proc
done

