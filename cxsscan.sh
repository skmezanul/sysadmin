#!/bin/bash

echo ""

echo "Inform an email account to send log"
read mail
echo "Inform the cpuser"
read cpuser

/usr/sbin/cxs --mail $mail --smtp --exploitscan --virusscan --sversionscan --nobayes --nounofficial --dbreport --ignore /etc/cxs/cxs.ignore --options mMOLfuSGchexdnwZRrD --qoptions Mv --www --summary --html --ssl --nofallback --user $cpuser
echo "Done"
