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
wget -O ${LISTSERVER} ${URLVPN}

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
IFS=${OIFS}

echo "Total VPN Activas = ${REG}"


#Podemos segun PAIS cualquier otro parametro, de momento a la mitad de registros
#REGISTRO=$(expr ${REG} / 2)
#echo "Registro Seleccionado = ${REGISTRO}"

#Seleccion Segundo
REGISTRO=$(date +%S)
echo "Registro Seleccionado = ${REGISTRO}"

#Cojemos seleccion
head -${REGISTRO} ${LISTSERVER} | tail -1  > ${VPNSELECT}

#Construimos Array datos registro para mostrar informacion
RDATA=$(cat ${VPNSELECT})
OIFS=$IFS
IFS=","

#Array Registro
ARDATA=($RDATA)

#Mostramos Datos Conexion Seleccionada
echo "============================"
for ((i=0; i<${#ARDATA[@]}; ++i));
do
  #No mostramos datos conexion
  echo "${ADATA[$i]}" | grep -q "Base64"
  
  if test $? -ne 0
  then
    echo "${ADATA[$i]} : ${ARDATA[$i]}";
  fi
  
done
IFS=${OIFS}
echo "============================"


#Extraemos Datos conexion y conectamos
cat  ${VPNSELECT} | awk -F, '{print $15}' | base64 -d -i > ${VPNCFG}

#Conectamos
sudo openvpn --verb 0 --config ${VPNCFG}


exit

--log file
--verb
              0 -- No output except fatal errors.
              1 to 4 -- Normal usage range.
              5 -- Output R and W characters to the console for each packet read and write, uppercase is used for TCP/UDP packets and lowercase is used for TUN/TAP packets.
              6 to 11 -- Debug info range (see errlevel.h for additional information on debug levels).

