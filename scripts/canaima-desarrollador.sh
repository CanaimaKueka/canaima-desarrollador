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

#------ AYUDANTES CREADORES --------------------------------------------------------------------------------------#
#=================================================================================================================#

crear-proyecto|debianizar)
# Guardemos los parámetros en variables para usarlos después
opcion=${1}
nombre=${2}
version=${3}
destino=${4}
licencia=${5}
CREAR-PROYECTO
;;

crear-fuente)
# Guardando directorio en variable para utilizarlo después
directorio=${2}
CREAR-FUENTE
;;

empaquetar)
# Guardamos los parámetros en variables para usarlas después
directorio=${2}
mensaje=${3}
procesadores=${4}
EMPAQUETAR
;;

#------ AYUDANTES GIT --------------------------------------------------------------------------------------------#
#=================================================================================================================#

descargar|clonar|clone)
# Guardemos el segundo argumento en la varible "proyecto"
proyecto=${2}
# Ejecutemos la función correspondiente
DESCARGAR
;;

registrar|commit)
# Guardemos los parámetros en variables para usarlos después
directorio=${2}
mensaje=${3}
# Ejecutemos la función correspondiente
REGISTRAR
;;

enviar|push)
# Guardando directorio en variable para utilizarlo después
directorio=${2}
# Ejecutemos la función correspondiente
ENVIAR
;;

actualizar|pull)
# Guardando directorio en variable para utilizarlo después
directorio=${2}
# Ejecutemos la función correspondiente
ACTUALIZAR
;;

#------ AYUDANTES MASIVOS ----------------------------------------------------------------------------------------#
#=================================================================================================================#

empaquetar-varios)
# Guardamos los parámetros en variables para usarlas después
PARA_EMPAQUETAR=${2}
mensaje="auto"
procesadores=${3}
EMPAQUETAR-VARIOS
;;

empaquetar-todo)
mensaje="auto"
procesadores=${2}
EMPAQUETAR-TODO
;;

enviar-todo|push-todo)
ENVIAR-TODO
;;

actualizar-todo|pull-todo)
ACTUALIZAR-TODO
;;

registrar-todo|commit-todo)
mensaje="auto"
REGISTRAR-TODO
;;

descargar-todo|clonar-todo)

DESCARGAR-TODO
;;

#------ AYUDANTES INFORMATIVOS --------------------------------------------------------------------------------------------#
#=======================================================================================================================#
listar-remotos)
LISTAR-REMOTOS
;;
listar-locales)
LISTAR-LOCALES
;;

--ayuda|--help|'')

# Imprimiendo la ayuda

;;

esac

exit 0
