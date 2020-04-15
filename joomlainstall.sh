user=$(pwd | cut -d/ -f3) 
installs=$(find /home/$user/public_html/ -iname en-gb.xml | grep language | head -n1)
echo -e "Joomla PATH Installation: $(find /home/$user/public_html/ -iname en-gb.xml | grep language | head -n1 | sed 's/^\(\/home\/.*\)\/language.*$/\1/g')"
cat $installs | egrep "<version>" | sed 's/<.*>\(.*\)<\/.*>/Joomla Version: \1/g;s/\t//g'
echo -e "\033[01;35mGreetz to IgorA"
