#/bin/bash
######
########Daniel Padovani - 14 set 2010
######
#A Linha abaixo limpa o arquivo antes de utilizado
touch /dev/null > /root/bkp/usohd.txt
#A linha abaixo pega o tamanho da partiçao em percentual
#altere onde esta escrito /SUAPARTICAO para a partição que deseja monitorar
#exemplo /home  ou /var ou simplismente o /
USO=`df -h / | tail -1 | awk '{print $5}'| sed "s/%//g"`
HOSTNAME=`echo $HOSTNAME`
#
#Abaixo aonde esta escrito 80 altere para o percentual que deseja que o alerta seja acionado
#enviado a notificacao atraves do email que o seu HD ultrapassou o persentual.
if [ "$USO" -gt "85" ]; then
#altere onde esta escrito /SUAPARTICAO para a partição que deseja monitorar
echo "Particao / do servidor '$HOSTNAME' esta com "$USO"% de uso! Favor verificar!" >> /root/bkp/usohd.txt
#else touch /root/bkp/usohd.txt
fi
#echo `cat /root/bkp/usohd.txt`
#####Ve se o arquivo ta vazio
if [ ! -s /root/bkp/usohd.txt ] ;then
echo "Arquivo esta vazio!"
else
#altere a linha abaixo aonde esta escrito seu@email.com.br pelo seu email correto
cat /root/bkp/usohd.txt | mail -s "[ Utilizacao do HD em "$(hostname)" ]" romeroayub@gmail.com
fi
