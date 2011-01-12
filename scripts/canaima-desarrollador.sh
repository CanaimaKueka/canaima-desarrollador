#!/bin/bash -e
#
# ==============================================================================
# PAQUETE: canaima-desarrollador
# ARCHIVO: canaima-desarrollador.sh
# DESCRIPCIÓN: Script de bash principal del paquete canaima-desarrollador
# COPYRIGHT:
#  (C) 2010 Luis Alejandro Martínez Faneyth <martinez.faneyth@gmail.com>
#  (C) 2010 Diego Alberto Aguilera Zambrano <daguilera85@gmail.com>
#  (C) 2010 Carlos Alejandro Guerrero Mora <guerrerocarlos@gmail.com>
#  (C) 2010 Francisco Javier Vásquez Guerrero <franjvasquezg@gmail.com>
# LICENCIA: GPL3
# ==============================================================================
#
# Este programa es software libre. Puede redistribuirlo y/o modificarlo bajo los
# términos de la Licencia Pública General de GNU (versión 3).

VARIABLES="/home/desarrollo/canaima-desarrollador-1.0+0/conf/variables.conf"

# Inicializando variables
. ${VARIABLES}

# Cargando configuración
. ${CONF}

# Cargando funciones
. ${FUNCIONES}

if [ ! -e "${CONF}" ] || [ -z "${REPO}" ] || [ -z "${REPO_USER}" ] || [ -z "${REPO_DIR}" ] || [ -z "${DEV_DIR}" ] || [ -z "${DEV_NAME}" ] || [ -z "${DEV_MAIL}" ] || [ -z "${DEV_GPG}" ]
then
echo -e ${ROJO}"Tu archivo de configuración ${CONF} presenta inconsistencias. Abortando."${FIN}
exit 1
fi

ESPACIOS

DEV-DATA

case ${1} in

crear-proyecto|debianizar)

opcion=${1}
nombre=${2}
version=${3}
destino=${4}
licencia=${5}

[ -z "${nombre}" ] && echo -e ${ROJO}"Olvidaste ponerle un nombre al paquete."${FIN} && exit 1

[ $( echo "${nombre}" | grep -c "[\?\*\+\.\\\/\%\$\#\@\!\~\=\^\<\>]" ) != 0 ] && echo -e ${ROJO}"Caracteres no permitidos en el nombre del paquete. Trata algo con letras, \"-\" y \"_\" solamente."${FIN} && exit 1

[ -z "${version}" ] && version="1.0+0" && echo -e ${AMARILLO}"No me dijiste la versión. Asumiendo 1.0+0"${FIN}

[ -z "${destino}" ] && destino="personal" && echo -e ${AMARILLO}"No me dijiste si era un proyecto personal o para Canaima GNU/Linux. Asumo que es personal."${FIN}

[ -z "${licencia}" ] && licencia="gpl3" && echo -e ${AMARILLO}"No especificaste la licencia del paquete. Asumiré que es GPL3."${FIN}

CREAR-PROYECTO
;;

commit)

directorio=${2}
mensaje=${3}

[ -z "${directorio}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner a cuál proyecto querías hacer commit!"${FIN} && exit 1

[ $( echo "${directorio}" | grep -c " " ) != 0 ] && echo -e ${ROJO}"¿Que pasó? Pusiste el mensaje pero no el proyecto al que querías hacer commit."${FIN} && exit 1

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

COMMIT

;;

push)

directorio=${2}

[ -z "${directorio}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner a cuál proyecto querías hacer push!"${FIN} && exit 1

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

PUSH

;;

crear-fuente)

directorio=${2}

[ -z "${directorio}" ] && echo -e ${ROJO}"¡Se te olvidó decirme cual era el directorio del proyecto del cuál deseas generar el paquete fuente!"${FIN} && exit 1

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

CREAR-FUENTE

;;

empaquetar)

directorio=${2}
mensaje=${3}
procesadores=${4}

[ -z "${directorio}" ] && echo -e ${ROJO}"Éste programa es espectacular... Pero no te lee la mente. Especifica un proyecto a empaquetar."${FIN} && exit 1

[ $( echo "${directorio}" | grep -c " " ) != 0 ] && echo -e ${ROJO}"Algo me dice que pusiste el mensaje del commit, pero no el proyecto."${FIN} && exit 1

[ -z "${mensaje}" ] && mensaje="auto" && echo -e ${AMARILLO}"Mensaje de commit vacío. Autogenerando."${FIN}

[ -z "${procesadores}" ] && procesadores=0 && echo -e ${AMARILLO}"No me dijiste si tenías más de un procesador. Asumiendo uno sólo."${FIN}

procesadores=$[ ${procesadores}+1 ]

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

EMPAQUETAR

;;

empaquetar-todo)
procesadores=${2}
EMPAQUETAR-TODO
;;

push-todo)
PUSH-TODO
;;

commit-todo)
mensaje="auto"
COMMIT-TODO
;;

commit-push-todo)
COMMIT-TODO
PUSH-TODO
;;

esac

exit 0
