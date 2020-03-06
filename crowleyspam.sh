echo "----------------------------------------------"
echo ""
echo "USER ACCOUNT:"
echo ""
exigrep "\*\*" /var/log/exim_mainlog | grep '<=' | grep 'P=local' | grep -v root | grep -v mailnull | awk -F"U=" '{ print $2 }' | cut -f1 -d' ' | sort | uniq -c | sort -nk1 | tail -n10
echo ""
##Find Authenticated users with failed delivery attempts
echo "----------------------------------------------"
echo "Top Failed Deliveries | AUTHENTICATED ACCOUNTS"
echo "----------------------------------------------"
echo ""
echo "EMAIL ACCOUNT:"
echo ""
exigrep "\*\*" /var/log/exim_mainlog | grep '<=' | grep -E "A=(courier|dovecot)" | sed -r 's/.*A=(courier|dovecot)_[a-z]+:([^[:space:]]+).*/\2/' | sort -nk1 | uniq -c | sort -nk1 | tail -n10
echo ""
echo "----------------------------------------------"
echo "  SPOOFING FROM ADDR | AUTHENTICATED ACCOUNTS "
echo "----------------------------------------------"
echo ""
echo "EMAIL ACCOUNT:"
egrep ".*<= ([^[:space:]]+).*A=(courier|dovecot)_[a-z]+:([^[:space:]]+).*" /var/log/exim_mainlog | sed -r 's/.*<= ([^[:space:]]+).*A=(courier|dovecot)_[a-z]+:([^[:space:]]+).*/\1 \3/' | awk '{ if (tolower($1) != tolower($2)) print $2; }' | sort | uniq -c | sort -nk1
echo ""
##Check this IP against blacklists
#echo "----------------------------------------------"
#echo " Email Blacklists | MAIN IP"
#echo "----------------------------------------------"
#echo ""
#    python <(curl -k -s http://legal.hostdime.com/andrewd_env/checkrbl.py) "$1"
