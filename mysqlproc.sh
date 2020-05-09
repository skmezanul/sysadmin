mysqladmin proc > /root/mysqlproc.txt
MYSQLPROC=$( cat /root/mysqlproc.txt )
for loop in $MYSQLPROC; do
for i in $( cat /root/mysqlproc.txt ) ; do mysqladmin proc stat $loop ; done
done

