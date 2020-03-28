#!/bin/bash

{
if [[ -z $1 ]]; then
        echo "Como usar: sa-learn.sh nomedaconta";
else
        echo "adicionando as configurações SA para conta $1...";
        echo "use_auto_whitelist 0" >> /home/$1/.spamassassin/user_prefs;
        echo "score BAYES_999 7.0" >> /home/$1/.spamassassin/user_prefs;
        echo "score BAYES_99 6.0" >> /home/$1/.spamassassin/user_prefs;
        echo "score BAYES_95 4.5" >> /home/$1/.spamassassin/user_prefs;
        echo "score URIBL_DBL_SPAM 6.0" >> /home/$1/.spamassassin/user_prefs;
        echo "score URIBL_JP_SURBL 4.0" >> /home/$1/.spamassassin/user_prefs;
        echo "score URIBL_WS_SURBL 4.0" >> /home/$1/.spamassassin/user_prefs;
        echo "score URIBL_BLACK 6.0" >> /home/$1/.spamassassin/user_prefs;
        rm -fv /home/$1/.spamassassin/auto-whitelist;
        echo "Configurações Salvas :)";
        echo "";
        echo "Você deseja agora treinar o SA?";
        read INPUT;
        if [ "$INPUT" == "y" ]; then
                su $1 -s /bin/bash -c "/usr/local/cpanel/3rdparty/bin/sa-learn --dump magic";
                echo "";
                echo "Resetar as informações que já existem ?";
                read INPUT;
                if [ "$INPUT" == "s" ]; then
                        echo "Resetando...";
                        su $1 -s /bin/bash -c "/usr/local/cpanel/3rdparty/bin/sa-learn --clear";
                        su $1 -s /bin/bash -c "/usr/local/cpanel/3rdparty/bin/sa-learn --sync";
                fi
                echo "";
                echo "Por favor, informe o endereço de e-mail que os diretórios SPAM-TRAIN e o HAM-TRAIN estão criados:";
read ADDRESS;
                USERNAME=$(echo $ADDRESS | cut -d '@' -f1);
                DOMAINNAME=$(echo $ADDRESS | cut -d '@' -f2);
                su $1 -s /bin/bash -c "/usr/local/cpanel/3rdparty/bin/sa-learn --progress --spam /home/$1/mail/$DOMAINNAME/$USERNAME/.SPAM-TRAIN/cur/"
                su $1 -s /bin/bash -c "/usr/local/cpanel/3rdparty/bin/sa-learn --progress --ham /home/$1/mail/$DOMAINNAME/$USERNAME/.HAM-TRAIN/cur/"
                echo "";
                echo "O treinamento foi finalizado :)";
        else
                echo "Erro";
        fi
        echo "Saindo...";
fi
}
