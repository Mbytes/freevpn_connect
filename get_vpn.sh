#!/bin/bash
#

#Url VPN
URLVPN=http://www.vpngate.net/api/iphone/

#LOGS
LISTSERVER=/tmp/vpnservers.log

#Data conexion seleccionada
VPNSELECT=/tmp/openvpn.select.txt

#Configuracion OPENVPN
VPNCFG=/tmp/openvpn.config

AHORA=$(date +%s)

#Recuperamos listado servidores disponibles
function GetVPN ()
{
  #existe y esta dentro del timeout
  if ! test -f ${LISTSERVER}
  then
    TFILEOUT=$(stat -c %Y ${LISTSERVER})
    echo "${TFILEOUT} - ${AHORA}"
    wget -O ${LISTSERVER} ${URLVPN}
  fi
}

#Como esta codificado
#HostName,IP,Score,Ping,Speed,CountryLong,CountryShort,NumVpnSessions,Uptime,TotalUsers,TotalTraffic,LogType,Operator,Message,OpenVPN_ConfigData_Base64

########
# PRINCIPAL
########

#Recuperamos listado servidores
GetVPN

#Contamos registros
REG=$(wc -l ${LISTSERVER}| awk '{print $1}')

#Creamos un Array de linea separado por ","
DATA=$(head -2 ${LISTSERVER} | tail -1 )
OIFS=$IFS
IFS=","

#Array DATOS
ADATA=($DATA)
IFS=${OIFS}

echo "Total VPN Activas = ${REG}"

#Podemos segun PAIS cualquier otro parametro, de momento a la mitad de registros

#Seleccion Registro aletorio
REGISTRO=$(shuf -i 1-${REG} -n 1)
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


