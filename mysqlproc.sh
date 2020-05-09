mysqladmin proc | grep "Waiting for table level lock" | wc -l >> /root/mysqlproc.txt
MYSQLPROC=$( cat /root/mysqlproc.txt )
for loop in $MYSQLPROC; do
for i in $( cat /root/mysqlproc.txt ) ; do mysqladmin proc $loop ; done
done

