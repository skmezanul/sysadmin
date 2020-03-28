#!/bin/bash
################################
# cPanel correccion de permisos 
# Felipe Montes Sered.NET
################################

UN=$(pwd | cut -d / -f3)

print() { printf "[${azul}+${NC}] $* \n" ; }
declare -x azul='\e[0;34m'
declare -x NC='\e[0m'

error() {
        print "Si considera que es un error, por favor, envie un informe de error a felipe@sered.net"
		quit
}

quit() {
	exit 2
}

pre_checks() {
        print "Sered.NET Permisos 2.0"
		## Verificamos instancia cPanel 
		if [[ ! -d '/usr/local/cpanel' ]]; then
			echo "ALERTA! Este servidor no parece tener instalado cPanel"
			error
		fi
        ## Verificamos DSO
        if [[ $(/usr/local/cpanel/bin/rebuild_phpconf --current | grep dso) =~ "PHP[4-5][ \t]+SAPI:[ \t]dso" ]]; then
                print "ALERTA! Este servidor es DSO. No ejecute este script con esta configuración de PHP"
                error
		fi
        if [[ $(pwd) =~ "^(/root|/bin|/usr|/var|/boot|/tmp|/dev|/home$)" ]]; then
                print "Estas en $(pwd). No ejecute este script aqui " 
		error
		fi
}

verificamos_usuario() {
        if [ ! -f /var/cpanel/users/${UN} ]; then
                print "El usuario no existe, abortando."
                error
        fi
}

verificamos_public_html(){
	if [ ! -d /home/${UN}/public_html ]; then
		print "Public_html no existe, creando directorio"
        	mkdir /home/${UN}/public_html
	fi
}

permisos_public_html(){
        cd /home/${UN}/public_html
        print "Asignando permisos 755 en /home/${UN}/public_html"
                find . -type d ! -perm 755 -exec chmod 755 '{}' \;
        print "Asignando permisos 644 en /home/${UN}/public_html"
                find . -type f ! -perm 644 -exec chmod 644 '{}' \;
        print "Correccion de ejecutables /home/${UN}/public_html"
                find . -iname "*.pl" -exec chmod 755 '{}' \; -o -iname "*.cgi" -exec chmod 755 '{}' \; -o -iname "*.fcgi" -exec chmod 755 '{}' \;
                find . ! -user ${UN} -exec chown ${UN}. -R '{}' \;
}

verificamos_htpass(){
		if [ -d /home/${UN}/.htpasswds ]; then
                print "Corrigiendo ${UN} archivos .htpasswds"
                chown -R ${UN}.nobody /home/${UN}/.htpasswds && chmod 750 /home/${UN}/.htpasswds
        fi
}

verificamos_home(){
        print "Corrigiendo ${UN} public_html y directorio home"
                chmod 711 /home/${UN}
                chown ${UN}.${UN} /home/${UN} -R > /dev/null 2>&1
                chmod 750 /home/${UN}/public_html
                chown ${UN}.nobody /home/${UN}/public_html
        if [ ! -L /home/${UN}/www ]; then
                cd /home/${UN}
                print "Corrigiendo ${UN} www Symlink"
                ln -s public_html www
        fi
}

verificamos_shadow_quota(){
	print "Corrigiendo /home/${UN}/etc/* passwd, shadow y quotas"
        chown ${UN}.mail /home/${UN}/etc/
		find /home/${UN}/etc/ -maxdepth 1 -type d -exec chown ${UN}.mail '{}' \;
		chown ${UN}.${UN} /home/${UN}/etc/quota > /dev/null 2>&1 && chmod 644 /home/${UN}/etc/quota > /dev/null 2>&1
		chown ${UN}.mail /home/${UN}/etc/shadow > /dev/null 2>&1 && chmod 600 /home/${UN}/etc/shadow > /dev/null 2>&1
        chown ${UN}.mail /home/${UN}/etc/passwd > /dev/null 2>&1 && chmod 644 /home/${UN}/etc/passwd > /dev/null 2>&1
	for shad in `ls /home/${UN}/etc/*/shadow`;do
                        chown ${UN}.mail $shad && chmod 640 $shad; done > /dev/null 2>&1
        for quot in `ls /home/${UN}/etc/*/quota` ;do
                        chown ${UN}.${UN} $quot && chmod 644 $quot; done > /dev/null 2>&1
        for pawd in `ls /home/${UN}/etc/*/passwd`;do
                        chown ${UN}.mail $pawd && chmod 644 $pawd; done > /dev/null 2>&1
}

verificamos_addon_docroot(){
        print "Corrigiendo directorios en dominios adicionales"
        for addonroot in $(grep "/home/${UN}" "/usr/local/apache/conf/httpd.conf" | grep DocumentRoot | awk '{print $2}');do
       		if [[ -d ${addonroot} ]] && [[ ${addonroot} != $PUB_HTML ]]; then
		    	chmod 750 ${addonroot} > /dev/null 2>&1
			chown ${UN}.nobody ${addonroot} 2>&1
            fi
        done
}

verificamos_permisos_mail(){
	print "Corrigiendo correos en ${UN}"
	/scripts/mailperm ${UN} > /dev/null 2>&1
}

verificamos_valiases(){
		print "Corrigiendo ${UN} valiases"
		for dom in $(grep "${UN}" /etc/userdomains | cut -d : -f1); do 
			if [[  -f /etc/valiases/$dom ]]; then 
			chown ${UN}.mail /etc/valiases/$dom 
			chmod 640 /etc/valiases/$dom 
			fi
		done
}

verificamos_mysql() {
       	for dir in MYSQL_DATA; do 
		if [[ -d /home/$UN/${dir} ]] ; then
		print "Directorios MySQL encontrados. asignando mysql:mysql"
		chown mysql:mysql /home/$UN/${dir} -R
		fi
	done
}

pre_checks
verificamos_usuario
verificamos_public_html
permisos_public_html
verificamos_home
verificamos_htpass
verificamos_shadow_quota
verificamos_addon_docroot
verificamos_permisos_mail
verificamos_valiases
verificamos_mysql
quit
