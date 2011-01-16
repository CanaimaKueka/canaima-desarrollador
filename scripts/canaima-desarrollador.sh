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

# Función para chequear que ciertas condiciones se cumplan para el
# correcto funcionamiento de canaima-desarrollador
# Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
CHECK

# Función para cargar los datos del desarrollador especificados en
# ${CONF} (nombre, correo, etc.)
# Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
DEV-DATA

# Case encargado de interpretar los parámetros introducidos a
# canaima-desarrollador y ejecutar la función correspondiente
case ${1} in

#------ AYUDANTES CREADORES --------------------------------------------------------------------------------------------#
#=======================================================================================================================#

crear-proyecto|debianizar)
# Guardemos los parámetros en variables para usarlos después
opcion=${1}
nombre=${2}
version=${3}
destino=${4}
licencia=${5}

# Comprobaciones varias
# El nombre del proyecto está vacío
[ -z "${nombre}" ] && echo -e ${ROJO}"Olvidaste ponerle un nombre al paquete."${FIN} && exit 1
# El nombre del proyecto contiene un carácter inválido 
[ $( echo "${nombre}" | grep -c "[\?\*\+\.\\\/\%\$\#\@\!\~\=\^\<\>]" ) != 0 ] && echo -e ${ROJO}"Caracteres no permitidos en el nombre del paquete. Trata algo con letras, \"-\" y \"_\" solamente."${FIN} && exit 1
# Si estamos debianizando, ¿El directorio coincide con el nombre y versión del paquete?
[ ${opcion} == "debianizar" ] && [ ! -e "${DEV_DIR}${nombre}-${version}"] && echo -e ${ROJO}"¡Hey! No encuentro ningún directorio llamado \"${nombre}-${version}\" en ${DEV_DIR}"${FIN} && exit 1
# ¿Me dijiste un destino válido?
[ ${destino} != "canaima" ] && [ ${destino} != "personal" ] && echo -e ${ROJO}"Sólo conozco los destinos \"personal\" y \"canaima\". ¿Para quien carrizo es \"${destino}\"?"${FIN} && exit 1
# La versión está vacía
[ -z "${version}" ] && version="1.0+0" && echo -e ${AMARILLO}"No me dijiste la versión. Asumiendo 1.0+0"${FIN}
# El destino está vacío
[ -z "${destino}" ] && destino="personal" && echo -e ${AMARILLO}"No me dijiste si era un proyecto personal o para Canaima GNU/Linux. Asumo que es personal."${FIN}
# La licencia está vacía
[ -z "${licencia}" ] && licencia="gpl3" && echo -e ${AMARILLO}"No especificaste la licencia del paquete. Asumiré que es GPL3."${FIN}

CREAR-PROYECTO
;;

crear-fuente)
# Guardando directorio en variable para utilizarlo después
directorio=${2}

# Garanticemos que el directorio siempre tiene escrita la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
directorio_nombre=$( basename "${directorio}" )

# Comprobaciones varias
# El directorio está vacío
[ -z "${directorio#${DEV_DIR}}" ] && echo -e ${ROJO}"¡Se te olvidó decirme cual era el directorio del proyecto del cuál deseas generar el paquete fuente!"${FIN} && exit 1
# El directorio no existe
[ ! -d "${directorio}" ] && echo -e ${ROJO}"El directorio no existe o no es un directorio."${FIN} && exit 1
# ¿Tenemos debian/changelog?
[ ! -e "${directorio}/debian/changelog" ] && echo -e ${ROJO}"Ésto no parece ser un proyecto de empaquetamiento. Debianizalo antes de continuar."${FIN} && exit 1

CREAR-FUENTE
;;

empaquetar)
# Guardamos los parámetros en variables para usarlas después
directorio=${2}
mensaje=${3}
procesadores=${4}

# Garanticemos que el directorio siempre tiene escrita la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
directorio_nombre=$( basename "${directorio}" )

# Comprobaciones varias
# No especificaste el directorio
[ -z "${directorio#${DEV_DIR}}" ] && echo -e ${ROJO}"Éste programa es espectacular... Pero no te lee la mente. Especifica un proyecto a empaquetar."${FIN} && exit 1
# Tal vez te comiste el parámetro directoriorio o especificaste un directorio con espacios
[ $( echo "${directorio#${DEV_DIR}}" | grep -c " " ) != 0 ] && echo -e ${ROJO}"Sospecho dos cosas: o te saltaste el nombre del directorio, o especificaste un directorio con espacios."${FIN} && exit 1
# No especificaste un mensaje para el commit
[ -z "${mensaje}" ] && mensaje="auto" && echo -e ${AMARILLO}"Mensaje de commit vacío. Autogenerando."${FIN}
# No especificaste número de procesadores
[ -z "${procesadores}" ] && procesadores=0 && echo -e ${AMARILLO}"No me dijiste si tenías más de un procesador. Asumiendo uno sólo."${FIN}

# cálculo de los threads (n+1)
procesadores=$[ ${procesadores}+1 ]

EMPAQUETAR
;;

#------ AYUDANTES GIT --------------------------------------------------------------------------------------------#
#=======================================================================================================================#

descargar|clonar|clone)
# Guardemos el segundo argumento en la varible "proyecto"
proyecto=${2}
# Función. Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
DESCARGAR
;;

registrar|commit)
# Guardemos los parámetros en variables para usarlos después
directorio=${2}
mensaje=${3}

[ -z "${directorio}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner a cuál proyecto querías hacer commit!"${FIN} && exit 1

[ $( echo "${directorio}" | grep -c " " ) != 0 ] && echo -e ${ROJO}"¿Que pasó? Pusiste el mensaje pero no el proyecto al que querías hacer commit."${FIN} && exit 1
di
directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

COMMIT
;;

enviar|push)

directorio=${2}

[ -z "${directorio}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner a cuál proyecto querías hacer push!"${FIN} && exit 1

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

PUSH
;;

actualizar|pull)

directorio=${2}

[ -z "${directorio}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner cuál proyecto querías actualizar!"${FIN} && exit 1

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )

PULL
;;

empaquetar-todo)
procesadores=${2}
EMPAQUETAR-TODO
;;

enviar-todo|push-todo)
PUSH-TODO
;;

actualizar-todo|pull-todo)
PULL-TODO
;;

registrar-todo|commit-todo)
mensaje="auto"
COMMIT-TODO
;;

reg-env-todo|commit-push-todo)
COMMIT-TODO
PUSH-TODO
;;

descargar-todo|clonar-todo)
# Función. Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
DESCARGAR-TODO
;;

listar-remotos)
# Función. Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
LISTAR-REMOTOS
;;

listar-locales)
# Función. Ver /usr/share/canaima-desarrollador/funciones-desarrollador.sh
LISTAR-LOCALES
;;

--ayuda|--help|'')

# Extrayendo la versión de canaima-desarrollador
VERSION=$( dpkg-query --status canaima-desarrollador | grep "Version: " | awk '{print $2}' )

# Imprimiendo la ayuda
echo -e ${BOLD}"CANAIMA-DESARROLLADOR - ¡Tu abuela empaqueta! (Versión: ${VERSION})"${FIN}
echo "Canaima Desarrollador es una herramienta destinada a facilitar la creación de"
echo "software para Canaima GNU/Linux."
echo "Para mayor información, consulta la documentación de cada ayudante o la entrada"
echo "del manual para canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Uso:"
echo -e ${BOLD}"  canaima-desarrollador [AYUDANTE] [PARÁMETRO-1] [PARÁMETRO-2] ... [PARÁMETRO-N]"${FIN}
echo ""
echo "AYUDANTES CREADORES"
echo -e ${BOLD}"  crear-proyecto${FIN}	Crea un proyecto de empaquetamiento al estilo Canaima."
echo -e ${BOLD}"  debianizar${FIN}		Alista un proyecto de software existente para ser empaquetado."
echo -e ${BOLD}"  empaquetar${FIN}		Crea un paquete binario a partir de un proyecto de software."
echo -e ${BOLD}"  crear-fuente${FIN}		Crea un paquete fuente a partir de un proyecto de software."
echo ""
echo "AYUDANTES GIT"
echo -e ${BOLD}"  clonar${FIN}		Descarga un proyecto existente en el repositorio de código y lo"
echo "			ubica en la carpeta del desarrollador."
echo -e ${BOLD}"  registrar${FIN}		Registra los cambios hechos localmente para un proyecto específico."
echo -e ${BOLD}"  enviar${FIN}		Envía los cambios al repositorio de código de un proyecto específico."
echo -e ${BOLD}"  actualizar${FIN}		Actualiza tu código local con el del repositorio de código para"
echo "			un proyecto en específico."
echo ""
echo "AYUDANTES MASIVOS"
echo -e ${BOLD}"  empaquetar-todo${FIN}	Empaqueta todo lo existente en la carpeta del desarrollador."
echo -e ${BOLD}"  enviar-todo${FIN}		Envía todo lo existente en la carpeta del desarrollador al"
echo "			repositorio de código."
echo -e ${BOLD}"  registrar-todo${FIN}	Registra todo lo existente en la carpeta del desarrollador al"
echo "			repositorio de código."
echo -e ${BOLD}"  reg-env-todo${FIN}		Registra y envía todo lo existente en la carpeta del desarrollador al"
echo "			repositorio de código."
echo -e ${BOLD}"  clonar-todo${FIN}		Descarga todo lo existente en el repositorio de código y lo coloca en"
echo "			la carpeta del desarrollador."
echo -e ${BOLD}"  actualizar-todo${FIN}	Actualiza todo lo existente en la carpeta del desarrollador con lo"
echo "			encontrado en el repositorio de código."
echo ""
echo "AYUDANTES INFORMATIVOS"
echo -e ${BOLD}"  listar-fuentes${FIN}	Lista los proyectos existentes en el repositorio de código."
echo -e ${BOLD}"  listar-locales${FIN}	Lista los proyectos existentes en la carpeta del desarrollador."
echo ""
echo "Opciones de Ayuda:"
echo -e ${BOLD}"  --ayuda${FIN}			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la documentación específica de"
echo "cada ayudante. Por ejemplo:"
echo "  canaima-desarrollador empaquetar --ayuda"
echo ""
echo "Contacto: desarroladores@canaima.softwarelibre.gob.ve"
echo ""
;;

esac

exit 0
