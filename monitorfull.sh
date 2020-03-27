#!/bin/bash


###  Script de monitoracao via cron - LINUX
###  Este script pode ser utilizado para monitorar o seu ambiente e enviar alarme atraves de e-mail
###  Podemos monitorar CPU, Memoria, Discos e algum processo.
###  Podemos utilizar o arquivo de historio (..historico/HISTORICO..txt) para usar em outras aplicacoes.

###  Blog pontosh
###  Shell Script, fazendo o trabalho pesado com inteligencia e minimo esforço
###  Por Claudio Santos (25/02/2014)
###  www.pontosh.wordpress.com
###  pontosh.br@gmail.com

###  Pre - Requisitos :
###  Pacotes : mailx, sendmail (ou postfix), sysstat, sudo
###  Sudo configurado para permitir executar os comandos touch e chown no /etc/threshold.env
###  Sendmail ou postfix com relay devidamente configurado 


###  Controle de Versao :
###  V 1.0 : 25/02/2015 -  19:00  - Revisor Claudio Santos
###     Desc : Edicao Inicial do script
###  V 1.0 : 02/03/2015 -  23:00  - Revisor Claudio Santos
###     Desc : Testes e validacao.


##########################################################

#### Verificando a Distribuicao Linux

if [ -f /etc/debian_version ]
then
  LINUX_DISTRO="debian"
else
  if [ -f /etc/redhat-release ]
  then
     LINUX_DISTRO="redhat"
  else
     if [ -f /etc/SuSE-release ]
     then
        LINUX_DISTRO="suse"
     else
        LINUX_DISTRO="other"
     fi
   fi
fi

####  DEFINICAO DE VARIAVEIS DO AMBIENTE

ARQ_THRESHOLD=/etc/thresholds.env    ## Arquivo de Threshold

TIMESTAMP=`date +"%d/%m/%Y-%T"`
DATA_DIA=`date +"%d-%m-%Y"`
HORA_EV=`date +"%T"`
HSTN=`hostname`
UP_TIME=`uptime | awk ' { print $3 } '`
LOAD_AVRG=`cat /proc/loadavg`
LOAD_1=`echo $LOAD_AVRG | awk ' { print $1 } ' | cut -d . -f 1`
LOAD_5=`echo $LOAD_AVRG | awk ' { print $2 } ' | cut -d . -f 1`
LOAD_15=`echo $LOAD_AVRG | awk ' { print $3 } ' | cut -d . -f 1`
WAIT_IO=`/usr/bin/iostat -c  1 3 | tail -2 | head -1 | awk ' { print $4 } ' | cut -d . -f 1`
FS_TODOS=""
ALARMES_COLETADOS=""
LST_FS=`df -PlT | grep -i ext | awk ' { print $7 } '`
ALARME=0
###  Caso nao encontre os arquivos de thresholds, e criado uma configuracao nova - Funcao cria_configuracao
cria_configuracao()
{
###  Definicao dos Thresholds - Default

if [ -e $ARQ_THRESHOLD ]
then
        source $ARQ_THRESHOLD
        D_DIR_SCRIPT=$DIR_SCRIPT
	D_CPU_RQUEUE_THRESHOLD=$CPU_RQUEUE_THRESHOLD
	D_CPU_IDLE_THRESHOLD=$CPU_IDLE_THRESHOLD
	D_CPU_WAIT_THRESHOLD=$CPU_WAIT_THRESHOLD
	D_MEM_PERC_LIVRE_THRESHOLD=$MEM_PERC_LIVRE_THRESHOLD
	D_LOAD_1_THRESHOLD=$LOAD_1_THRESHOLD
	D_LOAD_5_THRESHOLD=$LOAD_5_THRESHOLD
	D_LOAD_15_THRESHOLD=$LOAD_15_THRESHOLD
	D_FS_PERC_USADO_THRESHOLD=$FS_PERC_USADO_THRESHOLD
	D_PG_PERC_THRESHOLD=$PG_PERC_THRESHOLD
        D_DEST_MAIL=$DESTINATARIOS
else
	D_DIR_SCRIPT="`echo ~`/monitora"
	D_CPU_RQUEUE_THRESHOLD=30
	D_CPU_IDLE_THRESHOLD=10
	D_CPU_WAIT_THRESHOLD=30
	D_MEM_PERC_LIVRE_THRESHOLD=10
	D_LOAD_1_THRESHOLD=16
	D_LOAD_5_THRESHOLD=12
	D_LOAD_15_THRESHOLD=8
	D_FS_PERC_USADO_THRESHOLD=80
	D_PG_PERC_THRESHOLD=60
        D_DEST_MAIL=""
fi


#####
echo "============================================================"
echo "Criacao/Reconfiguracao de arquivos de threshold e diretorios"
echo "Definicao dos thresholds    ================================"
echo ""

echo "Definir o diretorio de Configuracao."
echo "   [ Enter para DEFAULT : $D_DIR_SCRIPT ]"
read I_D_DIR_SCRIPT
if [[ $I_D_DIR_SCRIPT = "" ]]
then
   DIR_SCRIPT=$D_DIR_SCRIPT
else
   DIR_SCRIPT=$I_D_DIR_SCRIPT
fi

echo "Definir Threshold de fila de execucao de CPU."
echo "   [ Enter para DEFAULT : $D_CPU_RQUEUE_THRESHOLD ]"
echo "   [ Valores Validos : de 0 a 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_CPU_RQUEUE_THRESHOLD
if [[ $I_CPU_RQUEUE_THRESHOLD = "" ]]
then
   CPU_RQUEUE_THRESHOLD=$D_CPU_RQUEUE_THRESHOLD
else
   CPU_RQUEUE_THRESHOLD=$I_CPU_RQUEUE_THRESHOLD
fi

echo "Definir Threshold de CPU Idle."
echo "   [ Enter para DEFAULT : $D_CPU_IDLE_THRESHOLD ]"
echo "   [ Valores Validos : de 0 a 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_CPU_IDLE_THRESHOLD
if [[ $I_CPU_IDLE_THRESHOLD = "" ]]
then
   CPU_IDLE_THRESHOLD=$D_CPU_IDLE_THRESHOLD
else
   CPU_IDLE_THRESHOLD=$I_CPU_IDLE_THRESHOLD
fi


echo "Definir Threshold de CPU Wait."
echo "   [ Enter para DEFAULT : $D_CPU_WAIT_THRESHOLD ]"
echo "   [ Valores Validos : de 0 a 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_CPU_WAIT_THRESHOLD
if [[ $I_CPU_WAIT_THRESHOLD = "" ]]
then
   CPU_WAIT_THRESHOLD=$D_CPU_WAIT_THRESHOLD
else
   CPU_WAIT_THRESHOLD=$I_CPU_WAIT_THRESHOLD
fi



echo "Definir Threshold de perc. de memoria livre."
echo "   [ Enter para DEFAULT : $D_MEM_PERC_LIVRE_THRESHOLD ]"
echo "   [ Valores Validos : de 0 a 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_MEM_PERC_LIVRE_THRESHOLD
if [[ $I_MEM_PERC_LIVRE_THRESHOLD = "" ]]
then
   MEM_PERC_LIVRE_THRESHOLD=$D_MEM_PERC_LIVRE_THRESHOLD
else
   MEM_PERC_LIVRE_THRESHOLD=$I_MEM_PERC_LIVRE_THRESHOLD
fi


echo "Definir Threshold de Load Average (1 minuto)."
echo "   [ Enter para DEFAULT : $D_LOAD_1_THRESHOLD ]"
echo "   [ Valores Validos : A partir de 0 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_LOAD_1_THRESHOLD
if [[ $I_LOAD_1_THRESHOLD = "" ]]
then
   LOAD_1_THRESHOLD=$D_LOAD_1_THRESHOLD
else
   LOAD_1_THRESHOLD=$I_LOAD_1_THRESHOLD
fi

echo "Definir Threshold de Load Average (5 minutos)."
echo "   [ Enter para DEFAULT : $D_LOAD_5_THRESHOLD ]"
echo "   [ Valores Validos : A partir de 0 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_LOAD_5_THRESHOLD
if [[ $I_LOAD_5_THRESHOLD = "" ]]
then
   LOAD_5_THRESHOLD=$D_LOAD_5_THRESHOLD
else
   LOAD_5_THRESHOLD=$I_LOAD_5_THRESHOLD
fi

echo "Definir Threshold de Load Average (15 minutos)."
echo "   [ Enter para DEFAULT : $D_LOAD_15_THRESHOLD ]"
echo "   [ Valores Validos : A partir de 0 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_LOAD_15_THRESHOLD
if [[ $I_LOAD_15_THRESHOLD = "" ]]
then
   LOAD_15_THRESHOLD=$D_LOAD_15_THRESHOLD
else
   LOAD_15_THRESHOLD=$I_LOAD_15_THRESHOLD
fi


echo "Definir Threshold de percentagem de uso dos Filesystems :"
echo " $LST_FS "
echo "   [ Enter para DEFAULT : $D_FS_PERC_USADO_THRESHOLD ]"
echo "   [ Valores Validos : Entre 0 e 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_FS_PERC_USADO_THRESHOLD
if [[ $I_FS_PERC_USADO_THRESHOLD = "" ]]
then 
   FS_PERC_USADO_THRESHOLD=$D_FS_PERC_USADO_THRESHOLD
else
   FS_PERC_USADO_THRESHOLD=$I_FS_PERC_USADO_THRESHOLD
fi

echo "Definir Threshold de uso de Area de Paginacao. "
echo "   [ Enter para DEFAULT : $D_PG_PERC_THRESHOLD ]"
echo "   [ Valores Validos : Entre 0 e 100 ]"
echo "   [ 0 para desativar monitoracao ]"
read I_PG_PERC_THRESHOLD
if [[ $I_PG_PERC_THRESHOLD = "" ]]
then
   PG_PERC_THRESHOLD=$D_PG_PERC_THRESHOLD
else
   PG_PERC_THRESHOLD=$I_PG_PERC_THRESHOLD
fi

echo "Definir destinatarios de e-mail para alertas. "
echo "Enderecos definidos anteriormente : "
echo $D_DEST_MAIL
echo "   [ Entrar com os enderecos, separados por , e sem espacos ]"
echo "   [ Ou <enter> para manter a lista antiga ]"
read I_DEST_MAIL
if [[ $I_DEST_MAIL = "" ]]
then
   DEST_MAIL=$D_DEST_MAIL
else
   DEST_MAIL=`echo $I_DEST_MAIL | tr -d " "`
fi



sudo touch $ARQ_THRESHOLD
sudo chown `whoami` $ARQ_THRESHOLD

echo "DIR_SCRIPT="'"'$DIR_SCRIPT'"' >$ARQ_THRESHOLD
echo "CPU_RQUEUE_THRESHOLD="$CPU_RQUEUE_THRESHOLD >>$ARQ_THRESHOLD
echo "CPU_IDLE_THRESHOLD="$CPU_IDLE_THRESHOLD >>$ARQ_THRESHOLD
echo "CPU_WAIT_THRESHOLD="$CPU_WAIT_THRESHOLD >>$ARQ_THRESHOLD
echo "MEM_PERC_LIVRE_THRESHOLD="$MEM_PERC_LIVRE_THRESHOLD >>$ARQ_THRESHOLD
echo "LOAD_1_THRESHOLD="$LOAD_1_THRESHOLD >>$ARQ_THRESHOLD
echo "LOAD_5_THRESHOLD="$LOAD_5_THRESHOLD >>$ARQ_THRESHOLD
echo "LOAD_15_THRESHOLD="$LOAD_15_THRESHOLD >>$ARQ_THRESHOLD
echo "FS_PERC_USADO_THRESHOLD="$FS_PERC_USADO_THRESHOLD >>$ARQ_THRESHOLD
echo "PG_PERC_THRESHOLD="$PG_PERC_THRESHOLD >>$ARQ_THRESHOLD
echo "DESTINATARIOS="'"'$DEST_MAIL'"' >>$ARQ_THRESHOLD

mkdir -p $DIR_SCRIPT
mkdir -p $DIR_SCRIPT/historico
cp monitor.sh $DIR_SCRIPT/
chmod 775 $DIR_SCRIPT/monitor.sh

echo "Definir o periodo de monitoracao na Cron :"
echo "   [ Entrar com o intervalo em minutos. Ex. 10 para execucao a cada 10 minutos ]"
echo "   [ 0 para desativar a cron de monitoracao ]"
read I_CRON_INTERVAL

if [[ $I_CRON_INTERVAL = 0 ]]
then
   crontab -l | grep -v "##Monitoracao do" | grep -v "/monitor.sh" >/tmp/cron.tmp
   cat /tmp/cron.tmp | crontab -
else
   crontab -l | grep -v "##Monitoracao do" | grep -v "/monitor.sh" >/tmp/cron.tmp
   echo "##Monitoracao do servidor a cada $I_CRON_INTERVAL Minutos" >>/tmp/cron.tmp
   echo "*/"$I_CRON_INTERVAL" * * * * $DIR_SCRIPT/monitor.sh 1>>/dev/null 2>>/dev/null" >>/tmp/cron.tmp
   cat /tmp/cron.tmp | crontab -
   rm -f /tmp/cron.tmp
fi

echo ""
echo ""
echo "=============================================================="
echo "Criacao de arquivos de thresholds finalizado"
exit

}

clear

if [[ $1 = "-configurar" ]]

then
   ##cria_configuracao()
   echo "Criar config!!!"
   cria_configuracao       ### Executa o 
fi

if [ -e $ARQ_THRESHOLD ]
then
   echo "Verificando config - OK!"
   echo "Carregando thresholds"
   echo "Distribuicao Linux baseado em $LINUX_DISTRO "
   source $ARQ_THRESHOLD
else   
   echo "Arquivo de Threshold nao encontrado !"
   echo "Rodar o shell script com a opcao -configurar :"
   echo "./monitor.sh -configurar"
   sleep 3
   exit
fi

ARQ_MAIL="$DIR_SCRIPT/mail.txt"
ARQ_HISTORICO="$DIR_SCRIPT/historico/HISTORICO_$DATA_DIA.txt"
ARQ_ALARME="$DIR_SCRIPT/ALARMES.txt"


if [ -e $ARQ_ALARME ]
then
    XX="ARQ. Existe"
else
    echo "0,0,0,0,0,0,0" >>$ARQ_ALARME
fi

mv $ARQ_ALARME $ARQ_ALARME.tmp
tail -600 $ARQ_ALARME.tmp >$ARQ_ALARME

printf "\n" >$ARQ_MAIL
printf " ----- EMAIL DE ALERTA ----- \n" >>$ARQ_MAIL
printf "  Servidor                 : $HSTN\n" >>$ARQ_MAIL
printf "  Data/Hora do evento      : $TIMESTAMP\n" >>$ARQ_MAIL
printf "  Uptime da Maquina        : $UP_TIME dias\n"  >>$ARQ_MAIL
printf "  Recurso(s) Monitorado(s) : CPU (Fila de Execucao, Idle e CPU Wait), MEMORIA, PAGINACAO, LOAD AVERAGE, WAIT IO E FILESYSTEMS\n" >>$ARQ_MAIL
printf "\n" >>$ARQ_MAIL
printf "Eventos :\n" >>$ARQ_MAIL


###### Monitoracao CPU
COLETA_CPU=`vmstat 1 3 | awk ' { print $1","$15","$16 } ' | tail -1`
CPU_RQUEUE=`echo $COLETA_CPU | cut -d , -f 1`
CPU_IDLE=`echo $COLETA_CPU | cut -d , -f 2`
CPU_WAIT=`echo $COLETA_CPU | cut -d , -f 3`



if [ $CPU_RQUEUE_THRESHOLD -eq 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $CPU_RQUEUE -ge $CPU_RQUEUE_THRESHOLD ]
   then
      printf "Fila de Execucao de CPU maior que o esperado : $CPU_RQUEUE \n" >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$CPU_RQUEUE"
      ALARME=1
   fi
fi


if [ $CPU_IDLE_THRESHOLD -eq 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $CPU_IDLE_THRESHOLD -ge $CPU_IDLE ]
   then
      echo "Uso de CPU : $CPU_IDLE % de CPU Livre " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$CPU_IDLE"
      ALARME=1
   fi
fi

if [ $CPU_WAIT_THRESHOLD -eq 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $CPU_WAIT -ge $CPU_WAIT_THRESHOLD ]
   then
      printf "Taxa de Waiting :  CPU WAIT = $CPU_WAIT \n" >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$CPU_WAIT"
      ALARME=1
   fi
fi

###### Monitoracao Memoria
COLETA_MEMORIA=`/usr/bin/free -m | grep "Mem:" | awk ' { print $3","$4 } '`
MEM_TT_USADO=`echo $COLETA_MEMORIA | cut -d , -f 1`
MEM_TT_LIVRE=`echo $COLETA_MEMORIA | cut -d , -f 2`
MEM_PERC_LIVRE=$(($MEM_TT_LIVRE*100/$MEM_TT_USADO))


if [ $MEM_PERC_LIVRE_THRESHOLD = 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $MEM_PERC_LIVRE -lt $MEM_PERC_LIVRE_THRESHOLD ]
   then
      echo "Uso de memoria : $MEM_PERC_LIVRE % Livre " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$MEM_PERC_LIVRE"
      ALARME=1
    fi
fi


###### Monitoracao Area de Paginacao
PG_TOTAL=$((`/usr/bin/free -m | grep "Swap:" | awk ' { print $3 } '`*100))
PG_USO=`/usr/bin/free -m | grep "Swap:" | awk ' { print $4 } '`
PG_PERC=$(($PG_TOTAL/$PG_USO))

if [ $PG_PERC_THRESHOLD = 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $PG_PERC -ge $PG_PERC_THRESHOLD ]
   then
      printf "\n" >>$ARQ_MAIL
      echo "Uso de Area de Paginacao : $PG_PERC % Utilizado " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$PG_PERC"
      ALARME=1
   fi
fi

###### Monitoracao LOAD AVERAGE

if [ $LOAD_1_THRESHOLD = 0 ]
then
    MONIT="Threshold Desativado"
else
   if [ $LOAD_1 -ge $LOAD_1_THRESHOLD ]
   then
      printf "\n" >>$ARQ_MAIL
      echo "Load Average 1 Min. : $LOAD_1 " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$LOAD_1"
      ALARME=1
   fi
fi

if [ $LOAD_5_THRESHOLD = 0 ]
then
   MONIT="Threshold Desativado"
else
   if [ $LOAD_5 -ge $LOAD_5_THRESHOLD ]
   then
      printf "\n" >>$ARQ_MAIL
      echo "Load Average 5 Min. : $LOAD_5 " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$LOAD_5"
      ALARME=1
   fi
fi


if [ $LOAD_15_THRESHOLD = 0 ]
then
   MONIT="Threshold Desativado"
else
   if [ $LOAD_15 -ge $LOAD_15_THRESHOLD ]
   then
      printf "\n" >>$ARQ_MAIL
      echo "Load Average 15 Min. : $LOAD_15 " >>$ARQ_MAIL
      ALARMES_COLETADOS="$ALARMES_COLETADOS,$LOAD_15"
     ALARME=1
   fi
fi


###### Monitoracao Filesystem
### Filesystems Padrao

if [ $FS_PERC_USADO_THRESHOLD = 0 ]
then
   MONIT="Threshold Desativado"
else
   for FS in $LST_FS
   do
      FS_PERC_USADO=`df -P $FS  | awk ' { print $5 } ' | tail -1 | tr -d "%"`
      if [ $FS_PERC_USADO -ge $FS_PERC_USADO_THRESHOLD ]
      then
         printf "\n" >>$ARQ_MAIL
         echo "Uso de Filesystem : $FS esta com $FS_PERC_USADO % de Utilizacao " >>$ARQ_MAIL
         ALARMES_COLETADOS="$ALARMES_COLETADOS,$FS_PERC_USADO"
         ALARME=1
      fi
      FS_TODOS="$FS_TODOS$FS : $FS_PERC_USADO,"
   done
fi

#####################################################

echo $ALARMES_COLETADOS >>$ARQ_ALARME
printf "\n \n " >>$ARQ_MAIL
echo "Este e um e-mail automatico gerado por script, por favor nao responda" >>$ARQ_MAIL

###### Criacao do arquivo de controle - estatistica
if [ -f $ARQ_HISTORICO ]
then
   HISTORICO_ARQUIVO="Arquivo Encontrado"
else
   echo "Data,Hora,Hostname,CPU RunQueue,CPU Idle,CPU Wait,MEM Livre,Uso PAGINACAO,LOAD 1min.,LOAD 5min.,LOAD 15min,FILESYSTEMS" >>$ARQ_HISTORICO
fi

echo "$DATA_DIA,$HORA_EV,$HSTN,$CPU_RQUEUE,$CPU_IDLE,$CPU_WAIT,$MEM_PERC_LIVRE,$PG_PERC,$LOAD_1,$LOAD_5,$LOAD_15,$FS_TODOS" >>$ARQ_HISTORICO


###### Envio de Email de alerta
if [ $ALARME -eq 1 ]
then
   if [[ $ALARMES_COLETADOS != `tail -2 $ARQ_ALARME | head -1` ]]
   then
      #echo "mandando email"
      ###  *****   Primeiro Alarme   -  Envia Email
      mailx -s "Monitoracao Linux - $HSTN - $TIMESTAMP" -v $DESTINATARIOS <$ARQ_MAIL
   fi
fi
