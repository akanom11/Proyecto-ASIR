#!/bin/bash
clear 
## Menu principal
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
echo 3.Opciones del servidor.
echo 4.Salir.
echo "";
echo -n "Selecciona una opción: " 
read opcion 
	## submenu DHCP 
	case $opcion in
		1) clear;
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
		echo -n "selecciona una opcion:";
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
				sudo echo "$nombrehost {
hardware ethernet $machost;
 fixed-address $iphost;}" >> /etc/dhcp/dhcpd.conf;;
				3)echo ASEGURATE DE TENER CONEXION A INTERNET
				  echo instalando isc-dhcp-server...
					sudo apt-get install isc-dhcp-server
				 clear
				## para ver la tarjeta de red si no se sabe 
				ip a
				echo -n introduce la interfaz de escucha.
				read int
				#cambia la tarjeta de red en el archivo isc-dhcp-server
				sed -i 's|INTERFACESv4=""|INTERFACESv4="'$int'"|g' /etc/default/isc-dhcp-server
				clear
				 echo interfaz cambiada.
				## Aqui se extraen las variables para cambiar en el archivo de configuración
				echo -n "introduce el nombre de dominio:"
				read dominiodhcp
				echo -n "introduce el nombre de dominio del servidor:"
				read servidordhcp
				echo -n "introduce direccion de red:"
				read reddhcp
				echo -n "introduce mascara de red:"
				read maskdhcp
				echo -n "introduce la direccion de broadcast:"
				read broadcastdhcp
				echo -n "introduce primera direccion usable por el dhcp:"
				read range1dhcp
				echo -n "introduce la ultima direccion usable por el dhcp:"
				read range2dhcp
				echo aplicando configuración...
				## Backup del archivo de configuracion principal
				sudo cp /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.copy
				## Vaciamos el fichero 
				sudo cat /dev/null > /etc/dhcp/dhcpd.conf
## Plantilla del fichero de configuración quitando las cosas 'no esenciales"
echo "# No permitimos actualizaciones dinamicas de dns
ddns-update-style none;

# Nombre de dominio y del servidor
option domain-name dominiodhcp;
option domain-name-servers serverdomain;


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
sudo service isc-dhcp-server restart
echo DHCP configurado!!;;
				4) echo -n Se va a reiniciar el servidor, ¿quieres continuar? y/n.  
					read reiniciaryn
						if [ $reiniciaryn = y ] 
						then
							sudo service isc-dhcp-server restart
							echo Servidor reiniciado.
						else 
							echo Vale, no se reinicia.
						fi;;
				5) sudo service isc-dhcp-server status;;
				6) sudo sh menu.sh;;	
		#fin del submenu dhcp
		esac
;;
2)clear;
echo "  _____  _   _  _____ ";
echo " |  __ \| \ | |/ ____|";
echo " | |  | |  \| | (___  ";
echo " | |  | | . \` |\___ \ ";
echo " | |__| | |\  |____) |";
echo " |_____/|_| \_|_____/ ";
echo "                      ";
echo "                      ";
echo 1.Añadir zona
echo 2.Instalación
echo -n "Elige una opcion: "
read opciondns
case $opciondns in 
		1) echo has elegido la opcion 1;;
		2)echo Se va a empezar a instalar y configurar el servidor DNS
		echo ASEGURATE DE TENER CONEXION A INTERNET
		sleep 3
		apt-get install bind9
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
echo $nombremaquina	IN	A	$ipmaquina >> /etc/bind/$zonename
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
@	IN	SOA	nombreserver. root.domain.edu. (
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



esac;;
3)echo cargando;
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
	echo 3. Menu principal.;
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
				3)sudo sh menu.sh;;
				esac
					;;
#fin del menu principal
esac
#fin del menu principal
