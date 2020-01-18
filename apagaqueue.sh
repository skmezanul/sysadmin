service exim stop
find /var/spool/exim/input -type f -exec rm -f {} +
service exim start
