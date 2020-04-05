#!/bin/bash
clear 
## Menu principal
echo Bienvenido `whoami`.
echo " Selecciona una opción:"
echo 1.DHCP.
echo 2.Comprimir/Descomprimir archivos.
echo 3.Salir.
read opcion 
	## menu con case del principal 
	case $opcion in
		1) clear;
 		echo Menu DHCP;
		echo ¿Que deseas hacer?;
		echo 1. Crear ambito.;
		echo 2. Borrar ambito;
		echo 3. Instalación;
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
				sed -i 's|INTERFACES=""|INTERFACES="'$int'"|g' /etc/default/isc-dhcp-server
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
## Plantilla del fichero de configuración quitando las cosas "no esenciales"
echo "# No permitimos actualizaciones dinamicas de dns
ddns-update-style none;

# Nombre de dominio y del servidor
option domain-name dominio;
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
sed -i 's|dominio|INTERFACES="'$dominiodhcp'"|g' /etc/dhcp/dhcpd.conf
sed -i 's|serverdomain|'$servidordhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|red1|'$reddhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|mascara|'$maskdhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|rango1|'$range1dhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|rango2|'$range2dhcp'|g' /etc/dhcp/dhcpd.conf
sed -i 's|difusion|'$broadcastdhcp'|g' /etc/dhcp/dhcpd.conf
echo DHCP configurado!!;;
		esac
esac
