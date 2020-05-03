#!/bin/bash

echo ""

echo "Inform the cpuser"
read cpuser

/usr/sbin/cxs --mail fagner.mendes@servhost.com.br --smtp --exploitscan --virusscan --sversionscan --nobayes --nounofficial --dbreport --ignore /etc/cxs/cxs.ignore --options mMOLfuSGchexdnwZRrD --qoptions Mv --www --summary --html --ssl --nofallback --user $cpuser
echo "Done"
