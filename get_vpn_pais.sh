#!/bin/bash
#

#Url VPN
URLVPN=http://www.vpngate.net/api/iphone/

#LOGS
LISTSERVER=/tmp/vpngate.log

#Data conexion seleccionada
VPNSELECT=/tmp/openvpn.select.txt

#Configuracion OPENVPN
VPNCFG=/tmp/openvpn.config

#Recuperamos listado servidores disponibles
#wget -O ${LISTSERVER} ${URLVPN}

#Contamos registros
REG=$(wc -l ${LISTSERVER}| awk '{print $1}')

#Como esta codificado
#HostName,IP,Score,Ping,Speed,CountryLong,CountryShort,NumVpnSessions,Uptime,TotalUsers,TotalTraffic,LogType,Operator,Message,OpenVPN_ConfigData_Base64

#Creamos un Array de linea separado por ","
DATA=$(head -2 ${LISTSERVER} | tail -1 )
OIFS=$IFS
IFS=","

#Array DATOS
ADATA=($DATA)


echo "============================"
for ((i=0; i<${#ADATA[@]}; ++i));
do
  
  echo  ${ADATA[$i]} | grep -q CountryShort >/dev/null
  
  if test $? -eq 0
  then
    CAMPO=$i
  fi
done
IFS=${OIFS}

echo "CAMPO = ${CAMPO}"

echo "Total VPN Activas = ${REG}"


#Podemos segun PAIS cualquier otro parametro, de momento a la mitad de registros

#Mostramos cada Pais


  echo "${ADATA[$i]}" | grep -q "CountryShort"
  




exit
