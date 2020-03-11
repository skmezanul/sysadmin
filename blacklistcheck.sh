#!/bin/sh

#Editado por hellnux (Danillo Costa)

# Fonte: http://daemonforums.org/showthread.php?t=302

#version="15.0508"



# Checa um determinado IP se passado como parametro, caso contrario é

# analisado um faixa de IPs pre determinados.



#####################################################################################

#                               Functions

#####################################################################################



function dateNow () {

        date +%d/%m/%Y" "%k:%M:%S

}



function getIps() {

  # Cria lista de ips

        ips=""

        notes_mail="Faixa de IPs analisadas:\n"

        prefix="138.128.188"

        notes_mail="$notes_mail de 138.128.188.82 até 138.128.188.85 \n"

        for i in `seq 82 85`; do

                ips="$ips $prefix.$i"

        done




      
}



function printResultBase () {

        printf "%-22s %-18s %-30s %-24s %s \n" "$date_now" "$ip" "$reverse_dns" "${BL}" "$result"

}



function printResultSenderbase() {

        date_now=`dateNow`

        BL="talosintelligence.com"

        # Evita consulta desnecessaria quando o SenderBase tiver bloqueado IP da maquina que executa este script

        if [ "$block_printResultSenderbase" == "1" ]; then

                result="Fail"

                printResultBase

        else

                # Passa pelos Termos de Servicos do SenderBase, method post e pega a saida do lynx

                out=$(echo "tos_accepted=Yes, I Agree" | lynx -dump -post_data "$link_sederbase$ip" | nl -ba)

                if [ $? -eq 0 ]; then

                        if [ "`echo "$out" | grep -F "You don't have permission to access"`" != "" ]; then

                                block_printResultSenderbase="1"

                                result="Fail"

                                printResultBase

                        else

                                # O status do email_reputation costuma está uma linha antes de "Web Reputation Help" na saida do lynx

                                n_web_reputation=$(echo "$out" | grep -F "Web Reputation Help" | awk '{print $1}')

                                n_email_reputation=$(( $n_web_reputation - 1 ))

                                email_reputation=$(echo "$out" | sed -n "$n_email_reputation"p | awk '{print $2}')

                                if [ "$email_reputation" == "Poor" ]; then

                                        result="<a href=$link_sederbase$ip>Listed</a>"

                                        printResultBase | tee -a "$log_file"

                                else

                                        result="---"

                                        printResultBase

                                fi

                        fi

                else # Metodo antigo. Não é muito preciso, pois informa apenas o score. Raramente entre neste trecho

                        BL=""

                        result=$(dig +short txt ${reverse[$i]}.${BL}.)

                        date_now=`dateNow`

                        if [ "`echo "$result" | grep -F "-"`" != "" ]; then

                                score=$(echo "$result" | tr -d '"') 

                                result="<a href=$link_sederbase$ip>NeedCheck</a>:$score" 

                                printResultBase | tee -a "$log_file"

                        else

                                result="---"

                                printResultBase

                        fi

                fi

        fi

}



function printResult() {

        date_now=`dateNow`

        if [ "$result" != "" ]; then

                result="Listed"

                printResultBase | tee -a "$log_file"

        else

                result="---" # Não listado

                printResultBase

        fi

}



#####################################################################################

#                                       Main

#####################################################################################



# Lista de blacklists. SenderBase é analisado separadamente

BLISTS="
b.barracudacentral.org
bl.spamcop.net
dnsbl.sorbs.net
spam.dnsbl.sorbs.net
ips.backscatterer.org
zen.spamhaus.org
korea.services.net
rbl.interserver.net
ubl.unsubscore.com
dnsbl.spfbl.net
spamhaus.org/sbl/
spamhaus.org/xbl/
spamhaus.org/pbl/
spamhaus.org/dbl/
spamhaus.org/drop/
justspam.org
exchange.xforce.ibmcloud.com
blacklist.lashback.com
abuseat.org
ipadmin.junkemailfilter.com
spamrats.com
0spam.fusionzero.com	
bl.konstant.no	
dnsbl.tornevall.org	
psbl.surriel.com	
rbl.interserver.net	
rbl.realtimeblacklist.com	
spamsources.fabel.dk	
mail-abuse.com	
torexit.dan.me.uk	
bl.suomispam.net 	
rbl.dns-servicios.com 	
rbl2.triumf.ca 	
spam.dnsbl.anonmails.de	
spam.pedantic.org 	
spam.spamrats.com 	
spamrbl.imp.ch	
st.technovision.dk	
talosintelligence.com	
z.mailspike.net	
bogons.cymru.com
combined.abuse.ch	
db.wpbl.info
dnsbl.anticaptcha.net	
dynip.rothen.com	
b.barracudacentral.org	
bl.spamcop.net	
blacklist.woody.ch	
db.wpbl.info
dnsbl.spfbl.net	
korea.services.net	
spamrbl.imp.ch	
ubl.unsubscore.com
aspews.ext.sorbs.net
bb.barracudacentral.org
block.dnsbl.sorbs.net
bl.score.senderscore.com
bl.spamcop.net
cbl.abuseat.org
cbl.anti-spam.org.cn
cblless.anti-spam.org.cn
dnsbl.sorbs.net
dnsbl.spfbl.net
http.dnsbl.sorbs.net
l1.bbfh.ext.sorbs.net
l2.bbfh.ext.sorbs.net
l4.bbfh.ext.sorbs.net
misc.dnsbl.sorbs.net
new.spam.dnsbl.sorbs.net
old.spam.dnsbl.sorbs.net
pbl.spamhaus.org
problems.dnsbl.sorbs.net
proxies.dnsbl.sorbs.net
recent.spam.dnsbl.sorbs.net
relays.dnsbl.sorbs.net
safe.dnsbl.sorbs.net
sbl.spamhaus.org
smtp.dnsbl.sorbs.net
socks.dnsbl.sorbs.net
spam.dnsbl.sorbs.net
talosintelligence.com
truncate.gbudb.net
web.dnsbl.sorbs.net
xbl.spamhaus.org
zen.spamhaus.org
zombie.dnsbl.sorbs.net
cbl.abuseat.org
dnsbl.sorbs.net
bl.spamcop.net
zen.spamhaus.org
dnsbl.spfbl.net
csi.cloudmark.com
"



script_name=$(basename $0 .sh)

emails="rbl@servhost.com.br"

mail="/bin/mail"

log_file="/tmp/$script_name.log"

sign_mail="------------------\n$script_name $version" #Assinatura da notificacao via email

link_sederbase="talosintelligence.com/reputation_center"

block_printResultSenderbase="0" # disable

msg_printResultSenderbase=""



# Define se usa IP passado via argumento ou "lista de IPs" informadas neste codigo.

if [ "$2" != "" ]; then

        echo "Error: Informe apenas 1 IP ou nenhum para usar a lista pre-determinada."

        exit 1

elif [ "$1" != "" ]; then

        ips="$1"

else

        getIps

fi



# limpa log

> "$log_file"



# Cria IP reverso

i=0

for ip in $ips; do

        reverse[$i]=$(echo "$ip" | sed -ne "s~^\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)$~\4.\3.\2.\1~p")

        if [ "x${reverse[$i]}" = "x" ]; then

                echo "Error: '$ip' nao parece ser um IP valido."

                exit 1

        fi

        (( i++ ))

done



# Faz checagem nas blacklists

i=0

for ip in $ips; do

        #echo "[$ip]" #debug

        reverse_dns=$(dig +short -x "$ip")

        if [ "$reverse_dns" == "" ]; then

                reverse_dns="reverseNull"

        fi

        # Chama funcao printResultSenderbase

        printResultSenderbase

        # Demais blacklists

        for BL in ${BLISTS} ; do

                result="$(dig +short -t a ${reverse[$i]}.${BL}.)"

                printResult

        done

        sleep "$(( ( RANDOM % 10 )  + 5 ))" # Random de ~5s a ~20s

        (( i++ ))

done



# Print in body mail if this script blocked in SenderBase

if [ "$block_printResultSenderbase" == "1" ]; then

        msg_printResultSenderbase="SenderBase blocked the `hostname -i` to queries.\n"

fi



# Send mail - Se identar o echo, pode bugar

if [ "`wc -l "$log_file" | awk '{print $1}'`" != "0" ]; then

echo "To: $emails

From: root@grauded.grautecnico.com.br

Subject: [$script_name]

Content-Type: text/html; charset=\"utf-8\"



<pre>`cat \"$log_file\"`</pre>

<pre>`echo -e \"$msg_printResultSenderbase\"`</pre>

<pre>`echo -e \"$notes_mail\"`</pre>

<pre>`echo -e \"\n\n$sign_mail\"`</pre>" | "$msmtp" --read-recipients

fi



# senderbase

# dig +short txt 55.145.202.186.rf.senderbase.org



# Fontes de pesquisas

# http://www.redhat.com/archives/rhl-list/2003-December/msg01341.html

# http://h3manth.com/content/methods-submit-form-post-using-curl-perl-python-ruby-lynx

# Numero random em um determinado range pelo shuf

# http://stackoverflow.com/questions/2556190/random-number-from-a-range-in-a-bash-script


