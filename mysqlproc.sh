mysqladmin proc | grep "Waiting for table level lock" | wc -l > $mysqlproc
for loop in $mysqlproc; do
for i in cat $mysqlproc; done 2> /dev/null
done
