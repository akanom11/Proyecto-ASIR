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
echo 2.Opciones del servidor.
echo 3.Salir.
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
		echo 1. Crear ambito.;
		echo 2. Añadir IP estatica.;
		echo 3. Instalación;
		echo 4. Reiniciar servidor;
		echo 5.Ver estado del servidor;
		echo 6.Menu principal;
		echo -n "selecciona una opcion:";
		read opciondhcp;
			## Submenu de DHCP
			case $opciondhcp in
				1) echo has seleccionado la opcion 1;;
				2)echo has seleccionado la opcion 2;;
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


#host fantasia {
#  hardware ethernet 00:0C:29:61:78:B1;
#  fixed-address 192.168.20.60;}
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
	2)echo cargando;
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
