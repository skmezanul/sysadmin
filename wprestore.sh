#!/bin/bash

<<'INFO'

Autor: Renan Pessoa ~ HDBR
E-Mail: renan.s@hostdime.com.br

Script desenvolvido para reinstalar os arquivos CORE do WordPress, essencial para corrigir problemas de acesso após algum arquivo ser bloqueado ou comprometido.

INFO

<< 'CHANGELOG'

1.0 - 09 Fevereiro 2017 [ Autores: Renan Pessoa ]
  * Versão inicial

CHANGELOG

#. Adiciona cores .#
BD="\e[1m";
RS="\e[0;00m";
R1="\e[31m";
R2="\E[1;31m";
Y1="\e[1;33m";
G1="\e[1;32m";
G2="\e[90m";


#. Diretório atual .#
DIR=$PWD;

#. Versão do WordPress.#
wp_versao=$(grep -s '^$wp_version' $DIR/wp-includes/version.php | cut -d= -f2| cut -d"'" -f2);

#. Verifica se existe alguma versão do WordPress no diretório corrente .#
if [[ -z $wp_versao ]];then

 echo -e "${R2}Não foi encontrado nenhuma instalação do Wordpress no diretório corrente $RS";

  DIR_HOME=$(pwd | cut -d"/" -f1,2,3);

  if [[ ! -z `echo $DIR_HOME | grep "home"` ]];then

      sugestao=$(find $DIR_HOME -type d -name "wp-admin");

      if [[ ! -z $sugestao ]];then
        echo -e "\n${Y1}=>${RS} Procurando por instalações do Wordpress"
        echo -e "\nFoi identificado instalações do Wordpress nos seguintes diretórios: $RS";
        echo -e "----------------------------------------"
        echo -e "$sugestao" |  sed 's/wp-admin//';
        echo -e "----------------------------------------"
        exit;
      fi
  fi
  exit;
fi


skip_content=1;

if [[ $1 == "-content" ]] || [[ $1 == "--content" ]];then

  echo -e "\n${Y1}=>${RS} A opção '-content' está ativada, os arquivos do diretório wp-content também serão substituidos !";
  skip_content=0;
fi


  echo -e "\n${G1}=>${RS} Versão do Wordpress identificada: ${Y1}${wp_versao}${RS}";

  echo -e "\n${G1}=>${RS} Baixando arquivos do Wordpress\n";
  
  echo -e "-----------------------------------------------------------------------------\n"
  wget --no-check-certificate https://wordpress.org/wordpress-$wp_versao.tar.gz
  echo -en "-----------------------------------------------------------------------------"

  [[ `echo $?` -ge 1 ]] && echo -e "${R2}Ocorreu um erro ao realizar o download do Wordpress${RS}" && exit;

  echo -e "\n\n${G1}=>${RS} Descompactando arquivo";

  mkdir wordpress_novo 2> /dev/null; #. Cria diretório .#

  tar xfz wordpress-$wp_versao.tar.gz -C $DIR/wordpress_novo; #. Descompacta o arquivo baixado .#
  
  echo -e "\n${G1}=>${RS} Fazendo backup dos diretórios que serão modificados";

  if [[ -d $DIR/wp-includes_ORIGINAL ]] || [[ -d $DIR/wp-admin_ORIGINAL ]] || [[ -d $DIR/wp-content_ORIGINAL ]];then

    mv ./wp-includes{,_ORIGINAL_`date | awk '{print $4}'`} 2> /dev/null;
    mv ./wp-admin{,_ORIGINAL_`date | awk '{print $4}'`} 2> /dev/null;
    [[ $skip_content = 0 ]] && mv ./wp-content{,_ORIGINAL_`date | awk '{print $4}'`} 2> /dev/null

  else

    mv ./wp-includes{,_ORIGINAL} 2> /dev/null;
    mv ./wp-admin{,_ORIGINAL} 2> /dev/null;
    [[ $skip_content = 0 ]] && mv ./wp-content{,_ORIGINAL} 2> /dev/null
  fi

  echo -e "\n${G1}=>${RS} Substituindo os diretórios do Wordpress";
  echo -e "\nPor padrão os arquivos do diretório 'wp-content' NÃO são substituidos, se deseja que este diretório também seja substituido execute novamente o script utilizando o parametro "$Y1"-content"$RS"";

  cd wordpress_novo/wordpress/

  [[ $skip_content = 1 ]] && rm -fr wp-content/;
  
  echo -e "\n${G1}=>${RS} Verificando arquivos do WordPress bloqueados\n";
  
  #. Lista os arquivos CORE do WordPress .#
  find $PWD -type f > /tmp/arquivos_temporario.txt 

  #. Verifica o atributo dos arquivos .#
  arquivos=$(find $DIR -type f -exec lsattr {} \;)

  #. Gera uma lista com os arquivos que estão bloqueados com chattr .#
  lista_bloqueados=$(echo "$arquivos" | grep "\-ia\-" | awk '{print $2}' | sed 's|'$DIR'||;s|/||');

  #. Varre a lista de arquivos bloqueados e desbloqueia .#
  for arq in $lista_bloqueados;do
    if grep -qs "$arq" /tmp/arquivos_temporario.txt;then
      echo -e "${Y1}=>${RS} Arquivo ${R2}${DIR}/${arq}${RS} foi desbloqueado";
      chattr -ia ${DIR}/${arq};
    fi
  done

  #. Copia os arquivos .#
  yes | cp -R * $DIR;

  cd $DIR;
 
  arquivos_modificados=$(ls -1 $DIR/wordpress_novo/wordpress/);

  echo -e "\n${G1}=>${RS} Removendo arquivos baixados";
  
  rm -rf ./wordpress_novo/ wordpress-$wp_versao.tar.gz;
  
  echo -e "\n${G1}=>${RS} Corrigindo as permissões dos arquivos por favor aguarde...";

  bash <(curl -ks https://codex.hostdime.com/scripts/download/fixhome) `pwd | cut -d"/" -f3` &> /dev/null;

  echo -e "\n${Y1}Arquivos e diretórios modificados ${RS}";
  echo -e "--------------------------------------";
  echo -e "$arquivos_modificados";
  echo -e "--------------------------------------";
