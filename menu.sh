#!/bin/bash
clear
## Menu principal
MenuPrincipal() {
clear
echo "  __  __                               _            _             _ ";
echo " |  \/  |                             (_)          (_)           | |";
echo " | \  / | ___ _ __  _   _   _ __  _ __ _ _ __   ___ _ _ __   __ _| |";
echo " | |\/| |/ _ | '_ \| | | | | '_ \| '__| | '_ \ / __| | '_ \ / _\` | |";
echo " | |  | |  __| | | | |_| | | |_) | |  | | | | | (__| | |_) | (_| | |";
echo " |_|  |_|\___|_| |_|\__,_| | .__/|_|  |_|_| |_|\___|_| .__/ \__,_|_|";
echo "                           | |                       | |            ";
echo "                           |_|                       |_|            ";
echo "Por Antonio Cano Madrigal";
echo " ";
echo 1.DHCP.
echo 2.DNS
echo 3.SAMBA
echo 4.Servidor Web
echo 5.Copias de seguridad
echo 6.Opciones del servidor.
echo 7.Seguridad.
echo 8.salir
echo "";
echo -n "Selecciona una opción: " 
read opcion 
case $opcion in
1) MenuDHCP;;
2) MenuDNS;;
3) MenuSAMBA;;
4) MenuWEB;;
5) MenuBACKUP;;
6) MenuSERVER;;
7) MenuSEC;;
8) break;;
esac
}
###########DHCP###########
	##Menu DHCP
MenuDHCP() {
		clear;
 		echo "  _____  _    _  _____ _____  ";
echo " |  __ \| |  | |/ ____|  __ \ ";
echo " | |  | | |__| | |    | |__) |";
echo " | |  | |  __  | |    |  ___/ ";
echo " | |__| | |  | | |____| |     ";
echo " |_____/|_|  |_|\_____|_|     ";
echo "                              ";
echo "                              ";
		echo ¿Que deseas hacer?;
		echo 1. Ver concesiones;
		echo 2. Añadir IP estatica.;
		echo 3. Instalación;
		echo 4. Reiniciar servidor;
		echo 5.Ver estado del servidor;
		echo 6.Menu principal;
		echo -n "Elige una opcion:";
		read opciondhcp;
			## Submenu de DHCP
			case $opciondhcp in
				1) cat /var/lib/dhcp/dhcpd.leases;;
				2)echo -n "Introduce nombre del host: "
				read nombrehost
				echo -n "Introduce MAC del host(xx:xx:xx:xx:xx:xx): "
				read machost
				echo -n "introduce IP: "
				read iphost
				sudo echo "host $nombrehost {
hardware ethernet $machost;
 fixed-address $iphost;}" >> /etc/dhcp/dhcpd.conf;;
				3)echo ASEGURATE DE TENER CONEXION A INTERNET
				  echo instalando isc-dhcp-server...
					sudo apt-get install -y isc-dhcp-server
				 clear
				## para ver la tarjeta de red si no se sabe 
				ip a
				echo -n "Introduce la interfaz de escucha: "
				read int
				#cambia la tarjeta de red en el archivo isc-dhcp-server
				sed -i 's|INTERFACESv4=""|INTERFACESv4="'$int'"|g' /etc/default/isc-dhcp-server
				clear
				 echo interfaz cambiada.
				## Aqui se extraen las variables para cambiar en el archivo de configuración
				echo -n "introduce el nombre de dominio: "
				read dominiodhcp
				echo -n "introduce la ip del servidor DNS: "
				read servidordhcp
				echo -n "introduce direccion de red: "
				read reddhcp
				echo -n "introduce mascara de red: "
				read maskdhcp
				echo -n "Introduce la direccion de gateway: "
				read gatewaydhcp
				echo -n "introduce la direccion de broadcast: "
				read broadcastdhcp
				echo -n "introduce primera direccion usable por el dhcp: "
				read range1dhcp
				echo -n "introduce la ultima direccion usable por el dhcp: "
				read range2dhcp
				echo aplicando configuración...
				## Backup del archivo de configuracion principal
				sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.copy
				## Vaciamos el fichero 
				sudo cat /dev/null > /etc/dhcp/dhcpd.conf
## Plantilla del fichero de configuración.
echo "# No permitimos actualizaciones dinamicas de dns
ddns-update-style none;

# Nombre de dominio y del servidor
option domain-name dominiodhcp;
option domain-name-servers serverdomain, 8.8.8.8;


# Tiempos de concesion por defecto 1 dia, maximo 2 dias
default-lease-time 86400;
max-lease-time 172800;

# estes es el servidor autorizado de mi red.
authoritative;

# para guardar los archivos de log en syslog.
log-facility local7;

# ambito para nuestra subred

subnet red1 netmask mascara {
  range rango1 rango2;
  option broadcast-address difusion;
  option routers pedhcp;
}


" >> /etc/dhcp/dhcpd.conf
## sustitucion de los datos introducidos en el fichero de configuracion
sed -i 's|dominiodhcp|"'$dominiodhcp'"|g' /etc/dhcp/dhcpd.conf
sed -i 's|serverdomain|'$servidordhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|red1|'$reddhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|mascara|'$maskdhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|rango1|'$range1dhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|rango2|'$range2dhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|difusion|'$broadcastdhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|pedhcp|'$gatewaydhcp'|g' /etc/dhcp/dhcpd.conf
sudo service isc-dhcp-server restart
echo DHCP configurado!!;;
				4) echo -n "Se va a reiniciar el servidor, ¿quieres continuar? (y/n). "
					read reiniciaryn
						if [ $reiniciaryn = y ] 
						then
							sudo service isc-dhcp-server restart
							echo Servidor reiniciado.
						else
							echo Vale, no se reinicia.
						fi;;
				5) sudo service isc-dhcp-server status;;
				6) MenuPrincipal;;
		#fin del submenu dhcp
		esac
}
########### DNS ############
MenuDNS() {
clear;
echo "  _____  _   _  _____ ";
echo " |  __ \| \ | |/ ____|";
echo " | |  | |  \| | (___  ";
echo " | |  | | . \` |\___ \ ";
echo " | |__| | |\  |____) |";
echo " |_____/|_| \_|_____/ ";
echo "                      ";
echo "                      ";
echo 1.Añadir zona
echo 2.Añadir registro a zona
echo 3.Instalación
echo 4.Menu principal
echo -n "Elige una opcion: "
read opciondns
case $opciondns in
		#Submenu DNS
		1)clear
		 echo se va a proceder a crear una zona nueva.
#introducion de datos de la zona
		echo -n "¿Quieres crear una zona directa o inversa? (d/i): "
		read diroinv
			if [ $diroinv = d ]
			then
		echo Has seleccionado crear una zona directa
		sleep 2
		echo -n "Introduce el nombre de la zona: "
		read newnamezone
		echo -n "¿Va a ser un servidor primario o secundario?(p/s): "
		read priosec
		if [ $priosec = p ]
		then
		tipodns=master
			else
		tipodns=slave
		fi
	echo -n "Introduce el nombre del fichero de configuración (se le añade db. delante por defecto): "
		read newnameconf
		dbnew=db.$newnameconf
#plantilla de la zona directa
echo "zone newnamezone {
        type priosec;
        file newnameconf;
};" >> /etc/bind/named.conf.local
#sustitucion de datos
sed -i 's|newnamezone|"'$newnamezone'"|g' /etc/bind/named.conf.local
sed -i 's|newnameconf|"'/etc/bind/$dbnew'"|g' /etc/bind/named.conf.local
sed -i 's|priosec|'$tipodns'|g' /etc/bind/named.conf.local
#creacion archivo configuracion de zona
if [ -f /etc/bind/$dbnew ]
	then
cat /dev/null > /etc/bind/$dbnew
	else
touch /etc/bind/$dbnew
fi
#introducion de la plantilla de zona
echo "
sus	86400
@	IN	SOA	nombresubd. root.domain. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;

; Registros para servidores DNS de mi dominio
@	IN	NS	nombreserver." >> /etc/bind/$dbnew
#añadir datos
echo se ha creado el archivo $dbnew en /etc/bind/
sleep 3
clear
cat /etc/hosts
echo -n "introduce el nombre completo de tu servidor: "
read nombreserver
echo -n "introduce el nombre de tu dominio: "
read domain
#sustitucion de datos
echo -n "¿La zona es un subdominio?(s/n): "
read subdom
	if [ $subdom = s ]
		then
	echo -n "Introduce nombre de subdominio: "
	read subdomname
	sed -i 's|nombresubd|'$subdomname.$domain'|g' /etc/bind/$dbnew
		else
sed -i 's|nombresubd|'$nombreserver'|g' /etc/bind/$dbnew
fi
sed -i 's|sus|$TTL|g' /etc/bind/$dbnew
sed -i 's|nombreserver|'$nombreserver'|g' /etc/bind/$dbnew
sed -i 's|domain|'$domain'|g' /etc/bind/$dbnew
#################### FIN ZONA DIRECTA ########################
echo "Se ha añadido el servidor a la zona directa, para añadir más usa la opción de añadir del menu DNS"
#################### Zona inversa ############################
#opcion crear zona inversa al hacer la directa
	echo -n "¿Quieres crear la zona inversa de esta zona?(s/n): "
	read crearinv
		if [ $crearinv = s ]
			then
		echo se va a crear la zona inversa
		echo -n "Introduce la IP invertida ejem(192.168.10.1 seria 10.168.192): "
		read ipinvz
		invadd=$ipinvz.in-addr.arpa
		echo -n "Introduce nombre del archivo de configuración (se añade db. delante por defecto): "
		read newnameinvconf
		newdbinv=db.$newnameinvconf
		if [ -f /etc/bind/$newdbinv ]
        		then
		cat /dev/null > /etc/bind/$newdbinv
        		else
		touch /etc/bind/$newdbinv
		fi

echo "zone invadd {
        type priosec;
        file newinvzonename;
};" >> /etc/bind/named.conf.local
	#sustitucion de datos
sed -i 's|invadd|"'$invadd'"|g' /etc/bind/named.conf.local
sed -i 's|priosec|'$tipodns'|g' /etc/bind/named.conf.local
sed -i 's|newinvzonename|"'/etc/bind/$newdbinv'"|g' /etc/bind/named.conf.local
#configuracion del archivo de zona inversa
#cargar platilla zona inversa
if [ -f /etc/bind/$newdbinv ]
        then
cat /dev/null > /etc/bind/$newdbinv
        else
touch /etc/bind/$newdbinv
fi

echo "; configuración de la zona inversa.

sus     86400
@       IN      SOA     nombresubd. root.domain. (
                              1         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                          86400 )       ; Negative Cache TTL
;

; Registros para servidores DNS de mi dominio
@       IN      NS      nombreserver." >> /etc/bind/$newdbinv

## si es subdominio
if [ $subdom = s ]
                then
sed -i 's|nombresubd|'$subdomname.$domain'|g' /etc/bind/$newdbinv
                else
sed -i 's|nombresubd|'$nombreserver'|g' /etc/bind/$newdbinv
fi

#sustitucion de datos de la zona inversa
sed -i 's|sus|$TTL|g' /etc/bind/$newdbinv
sed -i 's|nombreserver|'$nombreserver'|g' /etc/bind/$newdbinv
sed -i 's|domain|'$domain'|g' /etc/bind/$newdbinv

echo Zonas creadas
else 
echo zona directa creada
fi
############################################
#else si no se elige directa desde el principio
############################################
else
clear
echo se va a proceder a crear una zona inversa
clear
echo -n "¿Va a ser un servidor primario o secundario?(p/s): "
read priosec
if [ $priosec = p ]
                then
                tipodns=master
                        else
                tipodns=slave
                fi
echo -n "Introduce la IP de tu servidor a la inversa, ej:para la 192.168.10.1 seria 10.168.192 "
read ipinversa
echo -n "introduce el nombre para la zona inversa(db. se añade automaticamente): "
read nameinversa
invname=db.$nameinversa
#platilla zona inversa
echo "zone ipinversa {
	type tipodns;
	file invname;
};" >> /etc/bind/named.conf.local
#sustitucion de datos
sed -i 's|ipinversa|"'$ipinversa.in-addr.arpa'"|g' /etc/bind/named.conf.local
sed -i 's|tipodns|'$tipodns'|g' /etc/bind/named.conf.local
sed -i 's|invname|"'/etc/bind/$invname'"|g' /etc/bind/named.conf.local
#configuracion del archivo de zona inversa
#cargar platilla zona inversa
if [ -f /etc/bind/$invname ]
        then
cat /dev/null > /etc/bind/$invname
        else
touch /etc/bind/$invname
fi

echo "; configuración de la zona inversa.

sus	86400
@	IN	SOA	nombreserver. root.domain. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;

; Registros para servidores DNS de mi dominio
@	IN	NS	nombreserver." >> /etc/bind/$invname
## pedir datos server
clear
cat /etc/hosts
echo -n "introduce el nombre completo de tu servidor: "
read nombreserver
echo -n "introduce el nombre de tu dominio: "
read domain

echo -n "¿La zona es un subdominio?(s/n): "
read subdom
        if [ $subdom = s ]
                then
        echo -n "Introduce nombre de subdominio: "
        read subdomname
        sed -i 's|nombresubd|'$subdomname.$domain'|g' /etc/bind/$invname
                else
sed -i 's|nombresubd|'$nombreserver'|g' /etc/bind/$invname
fi

#sustitucion de datos de la zona inversa
sed -i 's|sus|$TTL|g' /etc/bind/$invname
sed -i 's|nombreserver|'$nombreserver'|g' /etc/bind/$invname
sed -i 's|domain|'$domain'|g' /etc/bind/$invname
echo zona inversa creada
fi

;;
######################################## Opcion añadir registro ###########################################################################
	2)clear 
	echo Tipos de registro.
	echo " "
	echo "1. Registro A (especifica una IPv4 para un nombre)"
	echo "2. Registro AAA (especifica una IPv6 para un nombre)"
	echo "3. Registro CNAME (crea un alias para un registro A o AAA)"
	echo "4. Registro MX (indica los servidores encargados para la entrega de correo)"
	echo "5. Registro PTR asocia IP a nombres (solo sirve para zona inversa)"
	echo -n Selecciona una opcion
	read opcSOA
case $opcSOA in
		1)clear
			echo Has seleccionado registro A.
			echo Selecciona una zona
			ls /etc/bind/db.*	
			sleep 2
			echo -n "Escribe el nombre completo: " 
			read zonaSOA
			echo -n "¿Quieres añadir una entrada A en $zonaSOA? (s/n) "
			read ponerA
			while [ $ponerA = s ]
				do
			echo -n "introduce nombre de la maquina:  "
			read nombreA
			echo -n "introduce la IP "
			read PCIP
			echo $nombreA      IN      A     $PCIP >> /etc/bind/$zonaSOA
			echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
			read ponerA
			done
		;;
	        2)clear 
		        echo Has seleccionado registro AAA.
		        echo Selecciona una zona
		        ls /etc/bind/db.*
		        sleep 2
		        echo -n "Escribe el nombre completo: " 
		        read zonaSOA
		        echo -n "¿Quieres añadir una entrada AAA en $zonaSOA? (s/n) "
		        read ponerAAA
		        while [ $ponerAAA = s ]
		                do
			echo -n "introduce nombre de la maquina:  "
			read nombreAAA
			echo -n "introduce la IP "
			read PCIP
			echo $nombreAAA      IN     AAA     $PCIP >> /etc/bind/$zonaSOA
			echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
			read ponerAAA
			done
		;;

3)clear 
		        echo Has seleccionado registro CNAME.
		        echo Selecciona una zona
		        ls /etc/bind/db.*
		        sleep 2
		        echo -n "Escribe el nombre completo: " 
		        read zonaSOA
		        echo -n "¿Quieres añadir una entrada CNAME en $zonaSOA? (s/n) "
		        read ponerCNAME
		        while [ $ponerCNAME = s ]
		                do
			cat /etc/bind/$zonaSOA
			sleep 1
			echo -n "introduce alias de la maquina:  "
			read cname
			echo -n "introduce nombre verdadero: "
			read realname
			echo $cname      IN      CNAME     $realname >> /etc/bind/$zonaSOA
			echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
			read ponerCNAME
			done
		;;

4)clear 
        		echo Has seleccionado registro MX.
		        echo Selecciona una zona
		        ls /etc/bind/db.*
		        sleep 2
		        echo -n "Escribe el nombre completo: " 
		        read zonaSOA
		        echo -n "¿Quieres añadir una entrada A en $zonaSOA? (s/n) "
		        read ponerMX
		        while [ $ponerMX = s ]
		                do
			echo -n "introduce nombre del dominio:  "
			read nombreMX
			echo -n "introduce el FQDN del servidor "
			read fqdn
			echo $nombreMX      IN      A     $fqdn >> /etc/bind/$zonaSOA
			echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
			read ponerMX
			done
;;
5) clear
			echo Has seleccionado registro PTR
			echo selecciona una zona inversa
			ls /etc/bind/db.*
			sleep2
			echo -n "Escribe el nombre completo: "
			read zonaSOA
			echo -n "¿Quieres añadir una entrada PTR en $zonaSOA? (s/n) "
			read ponerPTR
			while [ $ponerPTR = s ]
			do
			echo -n "introduce nombre de la maquina:  "
			read nombreentradainv
			echo -n "introduce el ultimo numero de la IP ej:192.168.10.1 seria 1 "
			read ipmaquinainv
			echo $ipmaquinainv      IN      PTR     $nombreentradainv. >> /etc/bind/$zonaSOA
			echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
			read ponerPTR
			done
;;
esac 
;;

######################################## Instalacion del servidor DNS ###########################################################################
	3)echo Se va a empezar a instalar y configurar el servidor DNS
		echo ASEGURATE DE TENER CONEXION A INTERNET
		sleep 3
		apt-get install -y bind9
#vaciamos y cargamos plantilla del reenviador que normalmente es google
cat /dev/null > /etc/bind/named.conf.options
echo "options {
	directory sus1;

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the addresses replacing 
	// the all-0's placeholder.

	forwarders {
		8.8.8.8;
	 };

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	dnssec-validation auto;

	auth-nxdomain no;    # conform to RFC1035
	listen-on-v6 { any; };
};" >> /etc/bind/named.conf.options

sed -i 's|sus1|"'/var/cache/bind'"|g' /etc/bind/named.conf.options

#Creacion de la zona directa
echo -n "Se va a crear la zona directa,¿que nombre le quieres asignar? "
read nombrezd
echo -n "Indica el nombre del archivo de configuracion (se añade db. por defecto)"
read  nombreconfzona
zonename=db.$nombreconfzona
#plantilla de la 1º zona directa
cat /dev/null > /etc/bind/named.conf.local
echo "zone nombrezd {
        type master;
        file zonename;
};" >> /etc/bind/named.conf.local 
#sustitucion de datos
sed -i 's|nombrezd|"'$nombrezd'"|g' /etc/bind/named.conf.local
sed -i 's|zonename|"'/etc/bind/$zonename'"|g' /etc/bind/named.conf.local
#creacion archivo configuracion de zona
if [ -f /etc/bind/$zonename ]
	then
cat /dev/null > /etc/bind/$zonename
	else
touch /etc/bind/$zonename
fi
#introducion de la plantilla de zona
echo " 
sus	86400
@	IN	SOA	nombreserver. root.domain. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;

; Registros para servidores DNS de mi dominio
@	IN	NS	nombreserver." >> /etc/bind/$zonename
#añadir datos
echo se ha creado el archivo $zonename en /etc/bind/
sleep 3
clear
cat /etc/hosts
echo -n "introduce el nombre completo de tu servidor: "
read nombreserver
echo -n "introduce el nombre de tu dominio: "
read domain
#sustitucion de datos
sed -i 's|sus|$TTL|g' /etc/bind/$zonename
sed -i 's|nombreserver|'$nombreserver'|g' /etc/bind/$zonename
sed -i 's|domain|'$domain'|g' /etc/bind/$zonename
#introdución de entradas durante instalacion
echo "Aqui solo puedes añadir un registro que asocie nombre con IP para añadir una entrada de otro tipo hazlo desde el Menu DNS"
echo "Se recomienda añadir el servidor actual"
sleep 1
echo "¿Deseas añadir algun registro?(s/n): "
read ponerentrada
while [ $ponerentrada = s ]
do
echo -n "introduce nombre de la maquina:  "
read nombreentrada
echo -n "introduce IP de la maquina: "
read ipmaquina
echo $nombreentrada	IN	A	$ipmaquina >> /etc/bind/$zonename
echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
read ponerentrada
done

## ZONA INVERSA ##

echo "entrada/s añadidas, se va a proceder a crear la zona inversa"
sleep 3 
clear
echo -n "Introduce la IP de tu servidor a la inversa, ej:para la 192.168.10.1 seria 10.168.192 "
read ipinversa
echo -n "introduce el nombre para la zona inversa(db. se añade automaticamente): "
read nameinversa
invname=db.$nameinversa
#platilla zona inversa
touch /etc/bind/$invname
echo "zone ipinversa {
	type master;
	file nombreinv;
};" >> /etc/bind/named.conf.local
#sustitucion de datos
sed -i 's|ipinversa|"'$ipinversa.in-addr.arpa'"|g' /etc/bind/named.conf.local
sed -i 's|nombreinv|"'/etc/bind/$invname'"|g' /etc/bind/named.conf.local
#configuracion del archivo de zona inversa
#cargar platilla zona inversa
if [ -f /etc/bind/$invname ]
        then
cat /dev/null > /etc/bind/$invname
        else
touch /etc/bind/$invname
fi

echo "; configuración de la zona inversa.

sus	86400
@	IN	SOA	nombreserver. root.domain. (
			      1		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			  86400 )	; Negative Cache TTL
;

; Registros para servidores DNS de mi dominio
@	IN	NS	nombreserver." >> /etc/bind/$invname
#sustitucion de datos de la zona inversa
sed -i 's|sus|$TTL|g' /etc/bind/$invname
sed -i 's|nombreserver|'$nombreserver'|g' /etc/bind/$invname
sed -i 's|domain|'$domain'|g' /etc/bind/$invname
#introdución de entradas durante instalacion
echo "Aqui solo puedes añadir un registro que asocie una IP con un nombre para añadir una entrada de otro tipo hazlo desde el Menu DNS"
echo "Se recomienda añadir los mismos que añasite en la directa"
sleep 1
echo "¿Deseas añadir algun registro?(s/n): "
read ponerentradainv
while [ $ponerentradainv = s ]
do
echo -n "introduce nombre de la maquina:  "
read nombreentradainv
echo -n "introduce el ultimo numero de la IP ej:192.168.10.1 seria 1 "
read ipmaquinainv
echo $ipmaquinainv	IN	PTR	$nombreentradainv. >> /etc/bind/$invname
echo -n "entrada añadida, ¿quieres añadir otra más? (s/n): "
read ponerentradainv
done
service bind9 restart
echo "Configuración del DNS completada"


#Registros de asociación de nombres a IP
#1	IN	PTR	serverACM.dominioacm.edu.
#añadir entrada A zona directa
#serverACM.dominioacm.edu.	IN	A	192.168.20.1

;;
4) MenuPrincipal;;
esac
}
#########################Menu SAMBA#####################################################################
MenuSAMBA() {
clear
echo "                      _           ";
echo "                     | |          ";
echo "  ___  __ _ _ __ ___ | |__   __ _ ";
echo " / __|/ _\` | '_ \` _ \| '_ \ / _\` |";
echo " \__ \ (_| | | | | | | |_) | (_| |";
echo " |___/\__,_|_| |_| |_|_.__/ \__,_|";
echo "                                  ";
echo "                                  ";
echo 1. Instalacion
echo 2. Usuarios samba
echo 3. Añadir recurso a samba.
echo 4. Montar recurso samba.
echo 5. Menu principal
echo -n "selecciona una opcion: "
read optsamba
case  $optsamba in
	1)echo "Se va a proceder a instalar samba"
	apt-get -y install samba
	apt-get -y install samba-common-tools
	apt-get -y install samba-client
	apt-get -y install cifs-utils
	#habilitamos el inicio de samba al inicio del sistema
	systemctl start smb
	systemctl enable smb
	echo samba instalado
	sleep 1
	clear
	#Pregunta si se quiere crear un recurso
	echo -n "¿Quieres compartir un recurso ahora? (y/n)"
	read smbcompnow
	if [ $smbcompnow = y ]
	then
	#pide datos del recurso
	echo -n "introduce nombre del recurso: "
	read smbname
	echo -n "introduce la ruta absoluta del directorio a compartir  "
	read smbpath
	echo -n "¿Va a ser publica? (yes/no): "
	read smbpublic
	echo -n "¿Permisos de escritura? (yes/no): "
	read smbwrite
		else
		exit
	fi
	#plantilla recurso
echo "
[nombresamba]

path=rutaabs

public=publica

writable=escritura

guest ok=inv " >> /etc/samba/smb.conf
#sustitucion de datos
sed -i 's|nombresamba|'$smbname'|g' /etc/samba/smb.conf
sed -i 's|rutaabs|'$smbpath'|g' /etc/samba/smb.conf
sed -i 's|publica|'$smbpublic'|g' /etc/samba/smb.conf
sed -i 's|escritura|'$smbwrite'|g' /etc/samba/smb.conf
sed -i 's|inv|'$smbpublic'|g' /etc/samba/smb.conf
service smbd restart
;;
#fin instalacion samba
2) clear
 echo "¿Quieres añadir o eliminar un usuario? (a/q) "
read smbusuaddel
if [ $smbusuaddel = a ]
	then
echo  se va a proceder a crear un usuario samba.
echo -n "¿Añadir un usuario nuevo o usar uno existente? new/exist "
read createususamba
	if [ $createususamba = exist ]
	then
	echo "Introduce el nombre del usuario existente "
	read existusu
	sudo smbpasswd -a $existusu
		else
	echo "Introduce el nombre del nuevo usuario "
	read newusu
	sudo adduser $newusu
	sudo smbpasswd -a $newusu
	fi
	else 
echo Se va a proceder a eliminar un usuario samba.
echo -n "¿Que usuario quieres eliminar? "
read smbusudel
sudo smbpasswd -x $smbusudel
fi
;;
3) clear
echo se va a compartir un recurso.
echo -n "introduce nombre del recurso: "
        read smbname
        echo -n "introduce la ruta absoluta del directorio a compartir  "
        read smbpath
        echo -n "¿Va a ser publica? (yes/no): "
        read smbpublic
        echo -n "¿Permisos de escritura? (yes/no): "
        read smbwrite
#plantilla recurso
echo "
[nombresamba]

path=rutaabs

public=publica

writable=escritura

guest ok=inv " >> /etc/samba/smb.conf
#sustitucion de datos
sed -i 's|nombresamba|'$smbname'|g' /etc/samba/smb.conf
sed -i 's|rutaabs|'$smbpath'|g' /etc/samba/smb.conf
sed -i 's|publica|'$smbpublic'|g' /etc/samba/smb.conf
sed -i 's|escritura|'$smbwrite'|g' /etc/samba/smb.conf
sed -i 's|inv|'$smbpublic'|g' /etc/samba/smb.conf
service smbd restart
;;
4) clear
echo "Se va a proceder a montar un recurso samba"
echo -n "¿Donde quieres montar el recurso?: "
read montarsmb
echo ""
echo -n "Introduce la ruta del directorio a montar ej:(//192.168.1.100/share): "
read recursomount
echo ""
echo -n "Introduce nombre de usuario para acceder al recurso: "
read ususmb
if [ -d $montarsmb ]
then
sudo mount.cifs $recursomount $montarsmb -o user=$ususmb
else
sudo mkdir $montarsmb
sudo mount.cifs $recursomount $montarsmb -o user=$ususmb
fi
echo "Recurso montado!"
;;
5) MenuPrincipal;;
esac

}
############################SERVER WEB##################################################################
MenuWEB() {
clear
echo " __          __  _     ";
echo " \ \        / / | |    ";
echo "  \ \  /\  / /__| |__  ";
echo "   \ \/  \/ / _ \ '_ \ ";
echo "    \  /\  /  __/ |_) |";
echo "     \/  \/ \___|_.__/ ";
echo "                       ";
echo "                       ";
	echo "¿Que deseas hacer?"
	echo 1. "Instalar LAMP+Wordpress"
	echo 2. "Menu principal"
	echo -n "Elige una opción: "
	read webopt
		case $webopt in
			1) clear
			echo "Se va a empezar a intalar LAMP"
			sleep 2
			clear
			sudo apt-get update
			sudo apt-get install -y curl
			sudo apt-get install -y apache2
			#Permite trafico HTTP/HTTPS en el servidor
			sudo ufw allow in "Apache Full"
			sudo apt-get install -y mariadb-server
			clear
			echo "Configuracion de MySQL"
			sleep 2
			sudo mysql_secure_installation
			clear
			sudo apt-get install -y php libapache2-mod-php php-mysql
			clear
			echo "Introduce el nombre de la base de datos para wordpress"
			read wpdb
			echo "Configurando base de datos para wordpress"
			sudo mysql -e "CREATE DATABASE $wpdb DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
			echo "Selecciona nombre de usuario para Wordpress"
			read wpuser
			echo "Selecciona contraseña para el usuario de wordpress"
			read -s wppass
			sudo mysql -e "GRANT ALL ON $wpdb.* TO '$wpuser'@'localhost' IDENTIFIED BY '$wppass';"
			sudo mysql -e "FLUSH PRIVILEGES;"
			sudo apt install -y php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
			sudo systemctl restart apache2
					clear
					echo "============================================"
					echo "configuracion de wordpress"
					echo "============================================"
					echo "¿Ejecutar instalación? (y/n)"
					read  run
					if [ "$run" == n ] ; then
					exit
					else
					echo "============================================"
					echo "Se esta instalando Wordpress."
					echo "============================================"
					#Cambiar al directorio del server web para realizar la instalacion
					cd /var/www/html
					#Descargar Wordpress
					curl -O https://wordpress.org/latest.tar.gz
					#unzip wordpress
					tar -zxvf latest.tar.gz
					#Cambiar al directorio wordpress
					cd wordpress
					#copiar del directorio padre
					cp -rf . ..
					#mover hacia el directorio padre
					cd ..
					#Eliminar todo del directorio wordpress
					rm -R wordpress
					#creando wp config
					cp wp-config-sample.php wp-config.php
					#buscar y reemplazar la configuracion
					perl -pi -e "s/database_name_here/$wpdb/g" wp-config.php
					perl -pi -e "s/username_here/$wpuser/g" wp-config.php
					perl -pi -e "s/password_here/$wppass/g" wp-config.php

					#introducir WP salts
					perl -i -pe'
					  BEGIN {
					    @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
					    push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
					    sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
					  }
					  s/put your unique phrase here/salt()/ge
					' wp-config.php

					#create uploads folder and set permissions
					mkdir wp-content/uploads
					chmod 775 wp-content/uploads
					service apache2 restart
					echo "Cleaning..."
					#remove zip file
					rm latest.tar.gz
					echo "========================="
					echo "Instalación completa."
					echo "========================="
					fi
					;;
				2) MenuPrincipal;;
				esac
				
}
#############################BACKUP#################################################################
MenuBACKUP() {		
clear
echo "  ____             _                ";
echo " |  _ \           | |               ";
echo " | |_) | __ _  ___| | ___   _ _ __  ";
echo " |  _ < / _\` |/ __| |/ / | | | '_ \ ";
echo " | |_) | (_| | (__|   <| |_| | |_) |";
echo " |____/ \__,_|\___|_|\_\\__,_| .__/ ";
echo "                             | |    ";
echo "                             |_|    ";
echo ""
echo ""
				echo "¿Que deseas hacer?"
				echo 1. Copiar.
				echo 2. Recuperar.
				echo 3. Programar copia.
				echo 4. Menu principal.
				echo -n "Elige una opcion: "
				read backupopt
					case $backupopt in
						1) clear
						echo -n "¿Quieres hacer una copia completa o intermental? (c/i): "
						read backupcominc
							if [ $backupcominc = c ]
							then
								echo se va a hacer una copia completa.
								DATE=$(date +%Y-%m-%d-%H%M%S)
								echo "Introduce ruta completa del destino (sin / al final): "
								read DESTINOFBK
								echo "Introduce nombre de la copia(Se le añade por defecto la fecha): "
								read NOMBREFBK
								echo "Introduce ruta completa de/los achivos que quieres hacer la copia (separados por un espacio): "
								read SOURCEFBK
								tar -cvzpf $DESTINOFBK/$NOMBREFBK-$DATE.tar.gz $SOURCEFBK
								echo se ha creado la copia en $DESTINOFBK
									else
								echo se va a hacer una copia incremental.
								DATE=$(date +%Y-%m-%d)
								echo "Introduce ruta completa del destino (sin / al final): "
                                                                read DESTINOIBK
                                                                echo "Introduce nombre de la copia(Se le añade por defecto la fecha): "
                                                                read NOMBREIBK
                                                               	ls $DESTINOIBK
								 echo "Introduce ruta completa de/los achivos que quieres hacer la copia (separados por un espacio): "
                                                                read SOURCEIBK
                                                                tar -cvzpf $DESTINOIBK/$NOMBREIBK-$DATE.tar.gz  -g $DESTINOIBK/$NOMBREIBK.snap $SOURCEIBK
                                                                echo se ha creado la copia en $DESTINOIBK
							fi
							;;
						2)clear
							echo "Introduce la ruta del archivo que quieres extraer: "
							read EXTSOURCE
							echo " "
							echo ""
							ls $EXTSOURCE
							sleep 1
							echo ""
							echo "Introduce el archivo comprimido para extraer: "
							read DESTINOTAR
							echo ""
							echo "Introduce la ruta de destino para extraer: "
							read DESTINOEXT
							tar -xvzf $EXTSOURCE/$DESTINOTAR -C $DESTINOEXT
							;;
						3)clear
							echo Se va a programar una copia de seguridad.
							if [ ! -e /copias ]; then
								sudo mkdir /copias
							fi
							echo "Atención!
							      Por defecto las copias completas se realizan los domingos a las 23:00 y las incrementales todos los dias a la misma hora.
							      Eso se puede cambiar en el script que se crea en /copias y la hora en /etc/crontab."
							sleep 3
							echo "Introduce la ruta que deseas hacer una copia: "
							read sourceprog
							echo "Introduce nombre de la copia"
							read progname
							echo "Introduce la ruta donde quieres guardar la copia: "
							read progdest
							touch /copias/$progname.sh
							echo "
							#!/BIN/BASH
							#copia completa cada mes, cada semana y incremental cada dia.
							#calcular  fecha

							diasemana="'`date +%a`'"

							diames="'`date +%d`'"

							diaymes="'`date +%d%b`'"

							######copias######

							# REALIZA COPIA COMPLETA TODOS LOS DIA 1 DE CADA MES #

							if [ "'$diames'" = 01 ]; then

							tar -cf $progdest/$progname-"'$diaymes'".tar $sourceprog

							fi

							## REALIZA LA COPIA DE SEGURIDAD COMPLETA TODOS LOS DOMINGOS.

							if [ "'$diasemana'" == dom ]; then

							fechahoy="'`date +%d-%b`'"


							tar -cd $progdest/"'$fechahoy'"-$progname-comp.tar $sourceprog
							else
							tar -cvzpf $progdest/$progname-"'$fechahoy'".tar.gz -g $progdest/$progname.snap $progdest
							fi" >> /copias/$progname.sh
							sudo sed -i '$i 00 23	* * * root /copias/'$progname'.sh' /etc/crontab
							echo "Copia programada, para editar o borrar la copia borra el archivo .sh generado en /copias y la entrada en /etc/crontab."
							;;
							4) MenuPrincipal;;
							esac
}
##############################################################################################
MenuSERVER() {
	clear;

echo "   _____                 _     _            ";
echo "  / ____|               (_)   | |           ";
echo " | (___   ___ _ ____   ___  __| | ___  _ __ ";
echo "  \___ \ / _ | '__\ \ / | |/ _\` |/ _ \| '__|";
echo "  ____) |  __| |   \ V /| | (_| | (_) | |   ";
echo " |_____/ \___|_|    \_/ |_|\__,_|\___/|_|   ";
echo "                                            ";
echo "                                            ";
	echo 1. Modificar /etc/hosts;
	echo 2. Modificar hostname;
	echo 3. Usar servidor como enrutador.
	echo 4. VPN.
	echo 5. VNC.
	echo 6. Menu principal.;
	echo -n "elige una opcion: " ;
	read submenuopciones;
			# submenu opciones
			case $submenuopciones in 
				1)ETC_HOSTS=/etc/hosts
# Pregunta si quiere añadir o eliminar

echo "¿Quieres añadir o eliminar el hostname?(poner/quitar):" 
read respuestahost

clear
# muestra el archivo hosts y pausa la pantalla durante 3 segundos
cat $ETC_HOSTS
sleep 3

# si quiere poner pide IP y nombre, si quiere borrar solo el nombre.
if [ $respuestahost = poner ]
	then
# pide IP
echo -n "¿Que IP quieres asignar al nuevo host?:"  
read newip4hn
IP=$newip4hn
# pide nombre
echo -n introduce nuevo nombre de host: 
read newhn
	else
# Si dice quitar solo pide nombre 
echo -n introduce el nombre de host a eliminar: 
read newhn
fi
# Hostname para  add/remove.
HOSTNAME=$newhn

#funcion de eliminar
removehost() {
    echo "Eliminando host";
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
    then
        echo "$HOSTNAME encontrado en tu $ETC_HOSTS, eliminando...";
        sudo sed -i".bak" "/$HOSTNAME/d" $ETC_HOSTS
    else
        echo "$HOSTNAME no ha sido encontrado en tu $ETC_HOSTS";
    fi
}

addhost() {
    echo "añadiendo host";
    HOSTS_LINE="$IP\t$HOSTNAME"
    if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
        then
            echo "$HOSTNAME ya existe : $(grep $HOSTNAME $ETC_HOSTS)"
        else
            echo "añadiendo $HOSTNAME en tu $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $HOSTNAME /etc/hosts)" ]
                then
                    echo "$HOSTNAME se ha añadido correctamente \n $(grep $HOSTNAME /etc/hosts)";
                else
                    echo "Error al añadir $HOSTNAME, intentalo de nuevo!";
            fi
    fi
}

# ejecuta las funciones
if [ $respuestahost = poner ]
	 then
addhost
	else 
removehost
fi;;
				2)echo -n "introduce nuevo hostname: "
				read newhostname
				 cat /dev/null > /etc/hostname
				echo $newhostname >> /etc/hostname;;
				3) clear
				echo vas a proceder a usar este servidor como enrutador para los clientes que lo tengan como puerta de enlace.
				echo "Esta instalado iptables-persistent en esta maquina (s/n): "
				read iptabresp
				sleep 1
				if [ $iptabresp = n ]
				then
				echo Se va a proceder a la instalación
				sleep 2
				apt-get update
				apt-get install -y iptables-persistent
				sudo service netfilter-persistent start
				else
				clear
  				sysctl -w net.ipv4.ip_forward=1
				sed -i '/net.ipv4.ip_forward/s/^#//g' /etc/sysctl.conf
				sysctl -p
				iptables -A FORWARD -j ACCEPT
				clear
				echo "introduce direccion de red de escucha y mascara (192.168.33.0/24): "
				read iptred
				ip a
				sleep 1
				echo "Introduce la interfaz con salida a internet: "
				read iptint
				iptables -t nat -A POSTROUTING -s $iptred -o $iptint -j MASQUERADE
				iptables-save > /etc/iptables/rules.v4
				echo "Configuración realizada!"
				fi
				;;
				4)clear
				echo "La configuración de usuario y contraseña se hace desde /etc/ppp/chap-secrets, si ya esta instalado cancela"
						sleep 3						
						echo "se va a proceder a instalar el servidor."
					sudo apt-get install -y pptpd
					clear
					echo "Se va a proceder a configurar el servicio PPTP"
					echo "Introduce tu direccion IP"
					read ippptp
					echo "Introduce el rango de direcciones para la VPN (Formato: 192.168.0.10-20)"
					read pptprange
					sudo cat /dev/null > /etc/pptpd.conf
					echo "
					###############################################################################
# "'$Id'"
#
# Sample Poptop configuration file /etc/pptpd.conf
#
# Changes are effective when pptpd is restarted.
###############################################################################


option /etc/ppp/pptpd-options


logwtmp

localip $ippptp
remoteip $pptprange
# or
#localip 192.168.0.234-238,192.168.0.245
#remoteip 192.168.1.234-238,192.168.1.245 
" >> /etc/pptpd.conf
				echo "Introduce nombre del servidor PPTP"
				read namepptp
				echo "Introduce la direccion DNS principal"
				read dnspptp1
				echo "Introduce la direccion DNS alternativa"
				read dnspptp2
				sudo cat /dev/null > /etc/ppp/pptpd-options
				echo "
name $namepptp

# domain mydomain.net





refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128






ms-dns $dnspptp1
ms-dns $dnspptp2


#ms-wins 10.0.0.3
#ms-wins 10.0.0.4


proxyarp


nodefaultroute



lock


nobsdcomp


novj
novjccomp


nologfd
" >> /etc/ppp/pptpd-options
				sed -i 's|nombresrv|'$namepptp'|g' /etc/ppp/pptpd-options
				sed -i 's|dnspptp1|'$dnspptp1'|g' /etc/ppp/pptpd-options
				sed -i 's|dnspptp2|'$dnspptp2'|g' /etc/ppp/pptpd-options
				echo "Introduce nombre de usuario para VPN"
				read userpptp
				echo "Introduce contraseña para VPN"
				read -s passpptp
				sudo cat /dev/null > /etc/ppp/chap-secrets
				echo " 
				# Secrets for authentication using CHAP
# client        server  secret                  IP addresses
nombre	serverr	pass	*
" >> /etc/ppp/chap-secrets
				sed -i 's|nombre|'$userpptp'|g' /etc/ppp/chap-secrets
				sed -i 's|serverr|'$namepptp'|g' /etc/ppp/chap-secrets
				sed -i 's|pass|'$passpptp'|g' /etc/ppp/chap-secrets
clear
				echo "PPTP instalado"
				echo "AVISO:
				Si deseas que sea accesible desde internet es necesario abrir el puerto 1723 en el router o firewall"			
				sleep 3			
				;;
				5) echo cargando...
				clear
				echo "Se va a proceder a instalar VNC"
				sleep 3
				echo "Selecciona el entorno de escritorio que deseas instalar"
				echo "1. Gnome"
				echo "2. LXDE"
				echo "3. Xfce"
				echo "  "
				echo "¿Cual deseas instalar?"
				read entorno
				case $entorno in
					1) sudo apt-get install -y --no-install-recommends ubuntu-desktop gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal gnome-core
					sudo apt-get install -y tightvncserver
                                	sudo vncserver;;
					2) sudo apt-get install xorg lxde-core
					sudo apt-get install -y tightvncserver
                                	sudo vncserver;;
					3) sudo apt-get install xfce4 xfce4-goodies
					sudo apt-get install -y tightvncserver
                                	sudo vncserver;;
				esac ;;
				6)MenuPrincipal;;
				esac 
				}
#############################################SEGURIDAD#######################################################################
MenuSEC() {
clear
echo "   _____                       _     _           _ ";
echo "  / ____|                     (_)   | |         | |";
echo " | (___   ___  __ _ _   _ _ __ _  __| | __ _  __| |";
echo "  \___ \ / _ \/ _\` | | | | '__| |/ _\` |/ _\` |/ _\` |";
echo "  ____) |  __/ (_| | |_| | |  | | (_| | (_| | (_| |";
echo " |_____/ \___|\__, |\__,_|_|  |_|\__,_|\__,_|\__,_|";
echo "               __/ |                               ";
echo "              |___/                                ";
echo ""
echo ""
	echo 1.Cambiar puertos de servicios.
	echo 2. Bloquear usuario root de ssh
	echo 3.PortKnocking
	echo 4.Menu principal
	echo -n "Elige una opcion: "
	echo ""
	read optsec
		case $optsec in 
			1) echo cargando...
			clear
			echo "Selecciona el servicio que quieres cambiar el puerto: "
			echo "1. ssh"
			echo "2. VNC"
			echo ""
			echo -n "Selecciona una opcion: "
			read optport
			case $optport in
				1) clear	
					portact=`sudo cat /etc/ssh/sshd_config  | grep "Port " | cut -f2 -d " "`
					echo -n "El puerto actual de ssh es $portact, ¿quieres cambiarlo? [s/n]: "
					read cambiar
					if [ $cambiar = s ]
						then
					echo -n "seleciona nuevo puerto: "
					read nuevoport
					sudo perl -pi -e 's/^#?Port '$portact'$/Port '$nuevoport'/' /etc/ssh/sshd_config
					echo "Puerto ssh cambiado al $nuevoport, para conectarte  usa -p y el puerto."
					service ssh restart && service ssh status
					else 
					exit
					fi
;;
				2) echo vnc;

			esac ;;
			2) clear
			sudo sed -i "s/.*PermitRootLogin.*/PermitRootLogin no/g" /etc/ssh/sshd_config
			echo "Usuario root deshabilitado!"
			sudo service ssh restart
;;
			3) clear
				echo "Se va a proceder a instalar el demos knock."
				sleep 2
				sudo apt-get install -y knockd
					sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
                                        sudo iptables -A INPUT -p tcp --dport 22 -j REJECT
                                        sudo netfilter-persistent save
                                        sudo netfilter-persistent reload
				clear
				echo -n "introduce 3 puertos separados con comas y sin espacios para abrir ssh. ejem(10,20,30): "
				read portapertura
				echo "   "
				echo "   "
				echo -n "Introduce 3 puertos separados con comas y sin espacios para cerrar ssh. ejem(10,20,30): "
				read portcerrado
				echo "   "
				echo "   "
				echo -n "Introduce tu interfaz de red: "
				read intknk
				portact=`sudo cat /etc/ssh/sshd_config  | grep "Port " | cut -f2 -d " "`
				sudo cat /dev/null > /etc/knockd.conf
				sudo echo  "
 [options]
        UseSyslog
	interface = $intknk
[openSSH]
        sequence    = $portapertura
        seq_timeout = 5
        command     = /sbin/iptables -A INPUT -s %IP% -p tcp --dport $portact -j ACCEPT
        tcpflags    = syn

[closeSSH]
        sequence    = $portcerrado
        seq_timeout = 5
        command     = /sbin/iptables -D INPUT -s %IP% -p tcp --dport $portact -j ACCEPT
        tcpflags    = syn" >> /etc/knockd.conf
		sudo cat /dev/null > /etc/default/knockd
		sudo echo "
		# control if we start knockd at init or not
# 1 = start
# anything else = don't start
# PLEASE EDIT /etc/knockd.conf BEFORE ENABLING
START_KNOCKD=1

# command line options
KNOCKD_OPTS="-i $intknk" " >> /etc/default/knockd
		sudo service knockd start
		sudo service knockd restart
;;
			4) MenuPrincipal;;
		esac
}					
MenuPrincipal
