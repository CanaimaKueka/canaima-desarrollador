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

VARIABLES="/usr/share/canaima-desarrollador/conf/variables.conf"

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
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"crear-proyecto\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador crear-proyecto <nombre> <versión> <destino> <licencia>"
echo "  canaima-desarrollador debianizar <nombre> <versión> <destino> <licencia>"
echo "  c-d crear-proyecto <nombre> <versión> <destino> <licencia>"
echo "  c-d debianizar <nombre> <versión> <destino> <licencia>"
echo ""
echo "Para crear un proyecto desde cero o debianizar uno existente, debes especificar"
echo "lo siguiente:"
echo ""
echo "  nombre		Un nombre para tu proyecto, que puede contener letras, números,"
echo "			puntos y guiones. Cualquier otro caracter no está permitido."
echo ""
echo "  versión		La versión inicial de tu proyecto. Se permiten números, guiones,"
echo "			puntos, letras o dashes (~)."
echo ""
echo "  destino		[canaima|personal]"
echo "			Especifica si es un proyecto de empaquetamiento para Canaima"
echo "			GNU/Linux o si es un proyecto personal."
echo ""
echo "  licencia	[apache|artistic|bsd|gpl|gpl2|gpl3|lgpl|lgpl2|lgpl3]"
echo "			Especifica el tipo de licencia bajo el cuál distribuirás tu"
echo "			trabajo."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Si estás debianizando un proyecto existente, lo que ingreses en <nombre> y"
echo "<versión> se utilizará para determinar cuál es el nomnre de la carpeta a"
echo "debianizar dentro del directorio del desarrollador, suponiendo que tiene el"
echo "nombre <nombre>-<versión>. Si no se llama así, habrá un error."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardemos los parámetros en variables para usarlos después
opcion=${1}
nombre=${2}
version=${3}
destino=${4}
licencia=${5}
CREAR-PROYECTO
fi
;;

crear-fuente)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"crear-fuente\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador crear-fuente <directorio>"
echo "  c-d crear-fuente <directorio>"
echo ""
echo "Crea un paquete fuente .tar.gz del proyecto de empaquetamiento contenido en"
echo "<directorio> y lo guarda en el depósito de fuentes. El directorio debe"
echo "contener un proyecto debianizado."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardando directorio en variable para utilizarlo después
directorio=${2}
CREAR-FUENTE
fi
;;

empaquetar)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"empaquetar\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador empaquetar <directorio> <mensaje> <procesadores>"
echo "  c-d empaquetar <directorio> <mensaje> <procesadores>"
echo ""
echo "Éste ayudante te permite empaquetar un proyecto de forma automatizada, siguiendo"
echo "la metodología git-buildpackage, que se centra en el siguiente diagrama:"
echo ""
echo "COMMIT > REFLEJAR CAMBIOS > COMMIT > CREAR PAQUETE > PUSH > GIT-BUILDPACKAGE"
echo "         EN EL CHANGELOG             FUENTE"
echo ""
echo "Parámetros:"
echo ""
echo "  directorio	Nombre de la carpeta dentro del directorio del "
echo "			desarrollador donde se encuentra el proyecto a empaquetar."
echo ""
echo "  mensaje		[auto|''|*]"
echo "			Mensaje representativo de los cambios para el primer"
echo "			commit. El segundo commit es sólo para el changelog."
echo "			Colocando la palabra \"auto\" o dejando el campo vacío, se"
echo "			autogenera el mensaje."
echo ""
echo "  procesadores	[1-n]"
echo "			Número de procesadores con que cuenta tu computadora para"
echo "			optimizar el proceso de empaquetamiento."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardamos los parámetros en variables para usarlas después
directorio=${2}
mensaje=${3}
procesadores=${4}
EMPAQUETAR
fi
;;

#------ AYUDANTES GIT --------------------------------------------------------------------------------------------#
#=================================================================================================================#
descargar|clonar|clone)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"descargar\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador descargar <proyecto>"
echo "  c-d descargar <proyecto>"
echo ""
echo "Éste ayudante te permite copiar a tu disco duro un proyecto que se encuentre en el"
echo "repositorio remoto para que puedas modificarlo según consideres. Utiliza git clone"
echo "para realizar tal operación."
echo ""
echo "Parámetros:"
echo ""
echo "  proyecto	[nombre|dirección]"
echo "			Nombre del proyecto (en caso de que éste se encuentre en el"
echo "			repositorio de Canaima GNU/Linux) o la dirección git pública"
echo "			del proyecto."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Éste ayudante se encarga además de realizar las siguientes operaciones por ti:"
echo ""
echo "  - Verifica e informa sobre el éxito de la descarga."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardemos el segundo argumento en la varible "proyecto"
proyecto=${2}
# Ejecutemos la función correspondiente
DESCARGAR
fi
;;

registrar|commit)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"registrar\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador registrar <directorio> <mensaje>"
echo "  c-d registrar <directorio> <mensaje>"
echo ""
echo "Éste ayudante te permite registar (o hacer commit de) los cambios hechos en un"
echo "proyecto mediante el versionamiento basado en git. Utiliza git commit para"
echo "lograr éste propósito."
echo ""
echo "Parámetros:"
echo ""
echo "  directorio	Nombre de la carpeta dentro del directorio del "
echo "			desarrollador a la que se quiere hacer commit."
echo ""
echo "  mensaje		[auto|''|*]"
echo "			Mensaje representativo de los cambios para el commit. "
echo "			Colocando la palabra \"auto\" o dejando el campo vacío,"
echo "			se autogenera el mensaje."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Éste ayudante se encarga además de realizar las siguientes operaciones por ti:"
echo ""
echo "  - Verifica la existencia de la rama git \"upstream\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de la rama git \"master\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de todos los elementos necesarios para ejecutar la "
echo "    acción git commit (carpetas, variables de entorno, etc..). En caso de encontrar"
echo "    algún error, aborta e informa."
echo "  - Autogenera el mensaje de commit, si se le instruye."
echo "  - Hace git checkout a la rama master, si nos encontramos en una rama diferente"
echo "    a la hora de hace commit."
echo "  - Hace un git merge de la rama master a la upstream, inmediatamente depués del"
echo "    commit."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardemos los parámetros en variables para usarlos después
directorio=${2}
mensaje=${3}
REGISTRAR
fi
;;

enviar|push)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"enviar\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador enviar <directorio>"
echo "  c-d enviar <directorio>"
echo ""
echo "Éste ayudante te permite enviar los cambios realizados al repositorio remoto"
echo "especificado en las configuraciones personales, mediante el uso de la acción"
echo "git push."
echo ""
echo "Parámetros:"
echo ""
echo "  directorio	Nombre de la carpeta dentro del directorio del "
echo "			desarrollador a la que se quiere hacer push."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Éste ayudante se encarga además de realizar las siguientes operaciones por ti:"
echo ""
echo "  - Verifica la existencia de la rama git \"upstream\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de la rama git \"master\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de todos los elementos necesarios para ejecutar la "
echo "    acción git push (carpetas, variables de entorno, etc..). En caso de encontrar"
echo "    algún error, aborta e informa."
echo "  - Configura el repositorio remoto para el proyecto, de acuerdo a los parámetros"
echo "    establecidos en ~/.config/canaima-desarrollador/usuario.conf"
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardando directorio en variable para utilizarlo después
directorio=${2}
ENVIAR
fi
;;

actualizar|pull)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"actualizar\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador actualizar <directorio>"
echo "  c-d actualizar <directorio>"
echo ""
echo "Éste ayudante te permite actualizar el código fuente de un determinado proyecto,"
echo "mediante la ejecución de \"git pull\" en la carpeta del proyecto."
echo ""
echo "Parámetros:"
echo ""
echo "  directorio	Nombre de la carpeta dentro del directorio del "
echo "			desarrollador a la que se quiere hacer git pull."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Éste ayudante se encarga además de realizar las siguientes operaciones por ti:"
echo ""
echo "  - Verifica la existencia de la rama git \"upstream\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de la rama git \"master\". En caso de no encontrarla,"
echo "    la crea."
echo "  - Verifica la existencia de todos los elementos necesarios para ejecutar la "
echo "    acción git pull (carpetas, variables de entorno, etc..). En caso de encontrar"
echo "    algún error, aborta e informa."
echo "  - Configura el repositorio remoto para el proyecto, de acuerdo a los parámetros"
echo "    establecidos en ~/.config/canaima-desarrollador/usuario.conf"
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardando directorio en variable para utilizarlo después
directorio=${2}
ACTUALIZAR
fi
;;

#------ AYUDANTES MASIVOS ----------------------------------------------------------------------------------------#
#=================================================================================================================#

descargar-todo|clonar-todo)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"descargar-todo\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador descargar-todo"
echo "  c-d descargar-todo"
echo ""
echo "Éste ayudante te permite copiar a tu disco duro todos los proyectos de Canaima"
echo "GNU/Linux que se encuentren en el repositorio remoto oficial. Utiliza git clone"
echo "para realizar tal operación."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
DESCARGAR-TODO
fi
;;

registrar-todo|commit-todo)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"registrar-todo\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador registrar-todo"
echo "  c-d registrar-todo"
echo ""
echo "Éste ayudante te permite registar (o hacer commit de) todos los cambios"
echo "hechos en todos los proyectos existentes en la carpeta del desarrollador."
echo "Utiliza git commit para lograr éste propósito. Asume un mensaje de "
echo "commit automático para todos."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
mensaje="auto"
REGISTRAR-TODO
fi
;;

enviar-todo|push-todo)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"enviar-todo\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador enviar-todo"
echo "  c-d enviar-todo"
echo ""
echo "Éste ayudante te permite enviar todos los cambios realizados en todos los "
echo "proyectos ubicados en la carpeta del desarrollador al repositorio remoto"
echo "especificado en las configuraciones personales, mediante el uso de la acción"
echo "git push."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
ENVIAR-TODO
fi
;;

actualizar-todo|pull-todo)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"actualizar-todo\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador actualizar-todo"
echo "  c-d actualizar-todo"
echo ""
echo "Éste ayudante te permite actualizar el código fuente de todos los"
echo "proyectos ubicados en la carpeta del desarrollador, mediante la ejecución"
echo "de "git pull" en la carpeta del proyecto."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
ACTUALIZAR-TODO
fi
;;

empaquetar-varios)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"empaquetar-varios\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador empaquetar-varios <para-empaquetar> <procesadores>"
echo "  c-d empaquetar-varios <para-empaquetar> <procesadores>"
echo ""
echo "Éste ayudante te permite empaquetar varios proyectos."
echo ""
echo "Parámetros:"
echo ""
echo "  para-empaquetar	Lista de los directorios dentro de la carpeta del"
echo "			desarrollador que contienen los proyectos que se quieren"
echo "			empaquetar, agrupados entre comillas."
echo ""
echo "  procesadores	[1-n]"
echo "			Número de procesadores con que cuenta tu computadora para"
echo "			optimizar el proceso de empaquetamiento."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
# Guardamos los parámetros en variables para usarlas después
PARA_EMPAQUETAR=${2}
mensaje="auto"
procesadores=${3}
EMPAQUETAR-VARIOS
fi
;;

empaquetar-todo)
if [ "${2}" == "--ayuda" ] || [ "${2}" == "--help" ] || [ -z "${2}" ]; then
echo "Documentación para el Ayudante \"empaquetar-todo\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador empaquetar-todo <para-empaquetar> <procesadores>"
echo "  c-d empaquetar-todo <para-empaquetar> <procesadores>"
echo ""
echo "Éste ayudante te permite empaquetar todos los proyectos existentes en la"
echo "carpeta del desarrollador."
echo ""
echo "Parámetros:"
echo ""
echo "  procesadores	[1-n]"
echo "			Número de procesadores con que cuenta tu computadora para"
echo "			optimizar el proceso de empaquetamiento."
echo ""
echo "NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN"
echo "DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
mensaje="auto"
procesadores=${2}
EMPAQUETAR-TODO
fi
;;


#------ AYUDANTES INFORMATIVOS -----------------------------------------------------------------------------------------#
#=======================================================================================================================#

listar-remotos)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"listar-remotos\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador listar-remotos"
echo "  c-d listar-remotos"
echo ""
echo "Muestra todos los proyectos contenidos en el repositorio remoto y"
echo "muestra su dirección git."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
LISTAR-REMOTOS
fi
;;

listar-locales)
if [ "${2}" == "--ayuda" ] || [ $"{2}" == "--help" ]; then
echo "Documentación para el Ayudante \"listar-locales\" de Canaima Desarrollador"
echo ""
echo "Uso:"
echo "  canaima-desarrollador listar-locales"
echo "  c-d listar-locales"
echo ""
echo "Muestra todos los proyectos contenidos en la carpeta del desarrollador y"
echo "los clasifica según su tipo."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda			Muestra ésta ayuda."
echo ""
echo "Para mayor información, puedes recurrir a la entrada del manual para"
echo "canaima-desarrollador (man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
echo ""
else
LISTAR-LOCALES
fi
;;

--ayuda|--help|'')
# Imprimiendo la ayuda
echo "Canaima Desarrollador es una herramienta destinada a facilitar la creación de"
echo "software para Canaima GNU/Linux."
echo ""
echo "Uso:"
echo "  canaima-desarrollador [AYUDANTE] [PARÁMETRO-1] [PARÁMETRO-2] ... [PARÁMETRO-N]"
echo "  c-d [AYUDANTE] [PARÁMETRO-1] [PARÁMETRO-2] ... [PARÁMETRO-N]"
echo ""
echo "AYUDANTES CREADORES"
echo "  crear-proyecto		Crea un proyecto de empaquetamiento al estilo Canaima."
echo "  debianizar		Alista un proyecto de software existente para ser empaquetado."
echo "  crear-fuente		Crea un paquete fuente a partir de un proyecto de software."
echo "  empaquetar		Crea un paquete binario a partir de un proyecto de software."
echo ""
echo "AYUDANTES GIT"
echo "  descargar		Descarga un proyecto existente en el repositorio de código y lo"
echo "				ubica en la carpeta del desarrollador."
echo "  registrar		Registra los cambios hechos localmente para un proyecto específico."
echo "  enviar			Envía los cambios al repositorio de código de un proyecto específico."
echo "  actualizar		Actualiza tu código local con el del repositorio de código para"
echo "				un proyecto en específico."
echo ""
echo "AYUDANTES MASIVOS"
echo ""
echo "  descargar-todo		Descarga todo lo existente en el repositorio de código y lo coloca en"
echo "				la carpeta del desarrollador."
echo "  registrar-todo		Registra todo lo existente en la carpeta del desarrollador al"
echo "				repositorio de código."
echo "  enviar-todo		Envía todo lo existente en la carpeta del desarrollador al"
echo "				repositorio de código."
echo "  actualizar-todo		Actualiza todo lo existente en la carpeta del desarrollador con lo"
echo "				encontrado en el repositorio de código."
echo "  empaquetar-varios	Crea los paquetes binarios de los proyectos especificados."
echo "  empaquetar-todo		Empaqueta todo lo existente en la carpeta del desarrollador."
echo "  "
echo "AYUDANTES INFORMATIVOS"
echo "  listar-remotos		Lista los proyectos existentes en el repositorio de código."
echo "  listar-locales		Lista los proyectos existentes en la carpeta del desarrollador."
echo ""
echo "Opciones de Ayuda:"
echo "  --ayuda				Muestra ésta ayuda."
echo ""
echo "Para mayor información, consulta la documentación de cada ayudante"
echo "(c-d [AYUDANTE] --ayuda) o la entrada del manual para canaima-desarrollador"
echo "(man canaima-desarrollador)."
echo ""
echo "Contacto: desarrolladores@listas.canaima.softwarelibre.gob.ve"
;;

*)
ERROR "No conozco el ayudante '"${1}"', échale un ojo a la documentación (man canaima-desarrollador)"
;;
esac

exit 0
