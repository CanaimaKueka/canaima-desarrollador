#!/bin/bash -e
#
# ==============================================================================
# PAQUETE: canaima-desarrollador
# ARCHIVO: funciones-desarrollador.sh
# DESCRIPCIÓN: Funciones utilizadas por canaima-desarrollador.sh
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

PKG="canaima-desarrollador"

#------ AYUDANTES CREADORES --------------------------------------------------------------------------------------#
#=================================================================================================================#

function CREAR-PROYECTO() {
#-------------------------------------------------------------#
# Nombre de la Función: CREAR-PROYECTO
# Propósito: Crear o debianizar un proyecto de empaquetamiento.
# Dependencias:
#       - Requiere la carga del archivo ${CONF}
#-------------------------------------------------------------#

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
# Creamos la carpeta si no está crado (nuevo proyecto)
[ ! -e "${DEV_DIR}${nombre}-${version}" ] && mkdir -p "${DEV_DIR}${nombre}-${version}"
# Paramos si es un nuevo proyecto y la carpeta ya existe
[ ! -e "${DEV_DIR}${nombre}-${version}" ] && [ ${opcion} == "crear-proyecto" ] && echo -e ${ROJO}"Estamos creando un proyecto nuevo, pero la carpeta ${DEV_DIR}${nombre}-${version} ya existe."${FIN} && exit 1
# Accedemos al directorio
cd "${DEV_DIR}${nombre}-${version}"
# Creamos el proyecto mediante dh_make. Lo pasamos a través de un pipe que le pasa una string
# a stdin para saltarnos la confirmación que trae por defecto dh_make. También enviamos todas
# las salidas a /dev/null para no ver las cosas en pantalla.
echo "enter" | dh_make --createorig --cdbs --copyright ${licencia} --email ${DEV_MAIL} > /dev/null 2>&1
# Presentamos alguna información en pantalla a modo de informe.
echo "Nombre del Paquete: ${nombre}"
echo "Versión: ${version}"
echo "Mantenedor: ${DEV_NAME}"
echo "Correo del Mantenedor: ${DEV_MAIL}"
echo "Licencia: ${licencia}"
# Removemos el directorio .orig creado
rm -rf "${DEV_DIR}${nombre}-${version}.orig"

# A partir de aquí personalizamos un poco lo que dh_make colocó por defecto
# Creamos la carpeta debian/ejemplos y pasamos todos los ejemplos de debian a esa
# carpeta
mkdir -p "${DEV_DIR}${nombre}-${version}/debian/ejemplos"
mv ${DEV_DIR}${nombre}-${version}/debian/*.* ${DEV_DIR}${nombre}-${version}/debian/ejemplos/

# Si el proyecto es para Canaima GNU/Linux, entonces éstos son los campos a sustituir
# en debian/control
if [ ${destino} == "canaima" ]; then
CONTROL_MAINTAINER="Equipo de Desarrollo de Canaima GNU\/Linux <desarrolladores@canaima.softwarelibre.gob.ve>"
CONTROL_UPLOADERS="José Miguel Parrella Romero <jparrella@onuva.com>, Carlos David Marrero <cdmarrero2040@gmail.com>, Orlando Andrés Fiol Carballo <ofiol@indesoft.org.ve>, Carlos Alejandro Guerrero Mora <guerrerocarlos@gmail.com>, Diego Alberto Aguilera Zambrano <diegoaguilera85@gmail.com>, Luis Alejandro Martínez Faneyth <martinez.faneyth@gmail.com>, Francisco Javier Vásquez Guerrero <franjvasquezg@gmail.com>"
CONTROL_STANDARDS="3.9.1"
CONTROL_HOMEPAGE="http:\/\/canaima.softwarelibre.gob.ve\/"
CONTROL_VCSGIT="git:\/\/gitorious.org\/canaima-gnu-linux\/${nombre}.git"
CONTROL_VCSBROWSER="git:\/\/gitorious.org\/canaima-gnu-linux\/${nombre}.git"
# Si el proyecto es personal, entonces son éstos
elif [ ${destino} == "personal" ]; then
CONTROL_MAINTAINER="${DEV_NAME} <${DEV_MAIL}>"
CONTROL_UPLOADERS="${CONTROL_MAINTAINER}"
CONTROL_HOMEPAGE="Desconocido"
CONTROL_VCSGIT="Desconocido"
CONTROL_VCSBROWSER="Desconocido"
fi
# Campos comunes a sustituir en debian/control
CONTROL_DESCRIPTION="Insertar una descripción de no más de 60 caracteres."
CONTROL_LONG_DESCRIPTION="Insertar descripción larga, iniciando con un espacio."
CONTROL_ARCH="all"
# Asignando strings dependiendo de la licencia escogida
case ${licencia} in
gpl3) LICENSE="GPL-3" ;;
apache) LICENSE="Apache-2.0" ;;
artistic) LICENSE="Artistic" ;;
bsd) LICENSE="BSD" ;;
gpl) LICENSE="GPL-3" ;;
gpl2) LICENSE="GPL-2" ;;
gpl3) LICENSE="GPL-3" ;;
lgpl) LICENSE="LGPL-3" ;;
lgpl2) LICENSE="LGPL-2" ;;
lgpl3) LICENSE="LGPL-3" ;;
esac
# Lista de archivos a copiar en la carpeta debian del proyecto
COPIAR_PLANTILLAS_DEBIAN="preinst postinst prerm postrm rules copyright"
# Lista de archivos a copiar en la carpeta base del proyecto
COPIAR_PLANTILLAS_PROYECTO="AUTHORS README TODO COPYING THANKS ${LICENSE} Makefile"
# Determinando el año en que estamos
FECHA=$( date +%Y )
# Ciclo que recorre las plantillas declaradas en ${COPIAR_PLANTILLAS_DEBIAN}
# para copiarlas en la carpeta debian del proyecto (si no existen)
for plantillas_debian in ${COPIAR_PLANTILLAS_DEBIAN}; do
cp -r "${PLANTILLAS}${plantillas_debian}" "${DEV_DIR}${nombre}-${version}/debian/"
# Aprovechamos de sustituir algunos @TOKENS@ en las plantillas
sed -i "s/@AUTHOR_NAME@/${DEV_NAME}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@AUTHOR_MAIL@/${DEV_MAIL}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@YEAR@/${FECHA}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@PAQUETE@/${nombre}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
done

# Ciclo que recorre las plantillas declaradas en ${COPIAR_PLANTILLAS_PROYECTO}
# para copiarlas en el proyecto (si no existen)
for plantillas_proyecto in ${COPIAR_PLANTILLAS_PROYECTO}; do
cp -r "${PLANTILLAS}${plantillas_proyecto}" "${DEV_DIR}${nombre}-${version}/"
# Aprovechamos de sustituir algunos @TOKENS@ en las plantillas
sed -i "s/@AUTHOR_NAME@/${DEV_NAME}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@AUTHOR_MAIL@/${DEV_MAIL}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@YEAR@/${FECHA}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@PAQUETE@/${nombre}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
done
# Cambiamos el nombre al archivo de licencia
mv "${DEV_DIR}${nombre}-${version}/${LICENSE}" "${DEV_DIR}${nombre}-${version}/LICENSE"
# Sustituimos algunos campos de debian/control, por los valores que establecimos antes
sed -i "s/#Vcs-Git:.*/#Vcs-Git: ${CONTROL_VCSGIT}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Standards-Version:.*/Standards-Version: 3.9.1/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/#Vcs-Browser:.*/#Vcs-Browser: ${CONTROL_VCSBROWSER}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Homepage:.*/#Homepage: ${CONTROL_HOMEPAGE}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Maintainer:.*/Maintainer: ${CONTROL_MAINTAINER}\nUploaders: ${CONTROL_UPLOADERS}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Description:.*/Description: ${CONTROL_DESCRIPTION}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/<insert long description, indented with spaces>/${CONTROL_LONG_DESCRIPTION}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Architecture:.*/Architecture: ${CONTROL_ARCH}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
# Arreglamos algunas cosas en el debian/changelog
sed -i "s/Initial release (Closes: #nnnn)  <nnnn is the bug number of your ITP>/Versión inicial de ${nombre} para Canaima GNU\/Linux/g" "${DEV_DIR}${nombre}-${version}/debian/changelog"
sed -i "s/(.*)/(${version})/g" "${DEV_DIR}${nombre}-${version}/debian/changelog"
# Nos aseguramos de que el formato del paquete fuente y el nivel de compatibilidad sean apropiados
echo "3.0 (quilt)" > ${DEV_DIR}${nombre}-${version}/debian/source/format
echo "7" > ${DEV_DIR}${nombre}-${version}/debian/compat

# Si no existe la carpeta .git (proyecto nuevo)
if [ ! -e "${DEV_DIR}${nombre}-${version}/.git/" ]; then
# Inicializamos un proyecto git
git init > /dev/null 2>&1
echo -e ${AMARILLO}"Repositorio git inicializado"${FIN}
directorio="${DEV_DIR}${nombre}-${version}"
directorio_nombre=$( basename "${directorio}" )
# Configuramos el repositorio remoto
SET-REPOS
git add .
git commit -a -m "Versión inicial de ${nombre}-${version} para Canaima GNU/Linux"
fi
# Enviamos la notificación apropiada, dependiendo del target
# "crear-proyecto" o "debianizar"
if [ ${opcion} == "crear-proyecto" ]; then
echo -e ${VERDE}"¡Proyecto ${nombre} creado!"${FIN}
elif [ ${opcion} == "debianizar" ]; then
echo -e ${VERDE}"¡Proyecto ${nombre} debianizado correctamente!"${FIN}
fi
echo -e ${AMARILLO}"Lee los comentarios en los archivos creados para mayor información"${FIN}
}

function CREAR-FUENTE() {
#-------------------------------------------------------------#
# Nombre de la Función: CREAR-FUENTE
# Propósito: Crear un paquete fuente a partir de un proyecto
#            de empaquetamiento debian
# Dependencias:
#       - Requiere la carga del archivo ${CONF}
#-------------------------------------------------------------#

# Garanticemos que el directorio siempre tiene escrita la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
directorio_nombre=$( basename "${directorio}" )
# Comprobaciones varias
# El directorio está vacío
[ -z "${directorio#${DEV_DIR}}" ] && echo -e ${ROJO}"¡Se te olvidó decirme cual era el directorio del proyecto del cuál deseas generar el paquete fuente!"${FIN} && exit 1
# El directorio no existe
[ ! -d "${directorio}" ] && echo -e ${ROJO}"El directorio no existe o no es un directorio."${FIN} && exit 1
# Determinemos algunos datos de proyecto
DATOS-PROYECTO
# Determinemos si el directorio ingresado tiene un slash (/) al final
slash=${directorio#${directorio%?}}
# Si es así, lo removemos
[ ${slash} == "/" ] && directorio=${directorio%?}
# Ingresamos a la carpeta del desarrollador
cd ${DEV_DIR}
# Removemos cualquier carpeta .orig previamente creada
rm -rf "${directorio}.orig"
# Creamos un nuevo directorio .orig
cp -r ${directorio} "${directorio}.orig"
ADVERTENCIA "Creando paquete fuente ${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz"
# Creamos el paquete fuente
dpkg-source --format="1.0" -i.git/ -I.git -b ${directorio}
# Movamos las fuentes que estén en la carpeta del desarrollador a su
# lugar en el depósito
[ "${1}" != "no-mover" ] && MOVER fuentes
# Emitimos la notificación
if [ -e "${DEPOSITO_SOURCES}${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz" ] && [ "${1}" != "no-mover" ]; then
echo -e ${VERDE}"¡Fuente del proyecto ${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz creada y movida a ${DEPOSITO_SOURCES}!"${FIN}
elif [ -e "${DEV_DIR}${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz" ] && [ "${1}" == "no-mover" ];
echo -e ${VERDE}"¡Fuente del proyecto ${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz creada!"${FIN}
else
echo -e ${ROJO}"¡Epa! algo pasó durante la creación de ${NOMBRE_PROYECTO}_${VERSION_PROYECTO}.orig.tar.gz"${FIN}
fi
}

function EMPAQUETAR() {
#-------------------------------------------------------------#
# Nombre de la Función: EMPAQUETAR
# Propósito: Crear un paquete binario a partir de un proyecto
#            de empaquetamiento debian
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- git-buildpackage
#-------------------------------------------------------------#

[ -z ${DEV_GPG} ] && FIRMAR="-us -uc"

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
# Cálculo de los threads (n+1)
procesadores=$[ ${procesadores}+1 ]
# Accedemos al directorio
cd ${directorio}
# Hacemos commit de los (posibles) cambios hechos
REGISTRAR
# Lo reflejamos en debian/changelog
[ -z ${NO_COMMIT} ] && GIT-DCH
# Volvemos a hacer commit
[ -z ${NO_COMMIT} ] && REGISTRAR
# Creamos el paquete fuente (formato 1.0)
CREAR-FUENTE no-mover
# Hacemos push
ENVIAR
cd ${directorio}
# Empaquetamos
git-buildpackage ${FIRMAR} -tc --git-tag -j${procesadores}
# Movemos todo a sus depósitos
MOVER debs
MOVER logs
MOVER fuentes
# Nos devolvemos a la carpeta del desarrollador
cd ${DEV_DIR}
}

#------ AYUDANTES GIT --------------------------------------------------------------------------------------------#
#=======================================================================================================================#

function DESCARGAR() {
#-------------------------------------------------------------#
# Nombre de la Función: DESCARGAR
# Propósito: Clonar un proyecto almacenado en un repositorio
#            git remoto.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core, grep, wget
#-------------------------------------------------------------#

# No especificaste un proyecto
[ -z "${proyecto}" ] && echo -e ${ROJO}"No especificaste un proyecto."${FIN} && exit 1
# Acceder a la carpeta del desarrollador
cd ${DEV_DIR}
# Si la dirección está en formato SSH, hacer la descarga normalmente
if [ $( echo ${proyecto} | grep -c "[@:]") != 0 ]; then
nombre=${proyecto#"git@gitorious.org/canaima-gnu-linux/"}
nombre=${proyecto#"git://gitorious.org/canaima-gnu-linux/"}
nombre=${nombre%".git"}
git clone ${proyecto}
# Constatar el resultado de la clonación
[ -e "${DEV_DIR}${nombre}" ] && echo -e ${VERDE}"¡${nombre} Descargado!"${FIN}
[ ! -e "${DEV_DIR}${nombre}" ] && echo -e ${ROJO}"Ooops...! Algo falló con ${nombre}"${FIN}
# Si el parámetro de descarga no es una dirección, sino el nombre del paquete
# y el repositorio remoto es gitorious.org ...
elif [ $( echo ${proyecto} | grep -c "[@:]" ) == 0 ] && [ ${REPO} == "gitorious.org" ]; then
echo -e ${AMARILLO}"Verificando existencia de ${proyecto} en ${REPO} ..."${FIN}
# Obtenemos el index HTML de gitorious ...
wget "http://gitorious.org/canaima-gnu-linux" > /dev/null 2>&1
# Extraemos los datos interesantes ...
FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )
# Y comprobamos si el paquete está disponible para descarga
if [ $( echo ${FUENTE} | grep -wc "git://gitorious.org/canaima-gnu-linux/${proyecto}.git" ) != 0 ]; then
descarga="git://gitorious.org/canaima-gnu-linux/${proyecto}.git"
git clone ${descarga}
# Constatar el resultado de la clonación
[ -e "${DEV_DIR}${proyecto}" ] && echo -e ${VERDE}"¡${proyecto} Descargado!"${FIN}
[ ! -e "${DEV_DIR}${proyecto}" ] && echo -e ${ROJO}"Ooops...! Algo falló con ${proyecto}"${FIN}
else
echo -e ${ROJO}"Tal proyecto \"${proyecto}\"no existe en ${REPO}."${FIN}
fi
# Si el parámetro de descarga no es una dirección, sino el nombre del paquete
# y el repositorio remoto es diferente de gitorious.org, esa modalidad de descarga
# no está disponible.
elif [ $( echo ${proyecto} | grep -c "[@:]" ) == 0 ] && [ ${REPO} != "gitorious.org" ]; then
echo -e ${ROJO}"Esa modalidad de descarga no está disponible para ${REPO}"${FIN}
fi
# Nos devolvemos a la carpeta del desarrollador
cd ${DEV_DIR}
}

function REGISTRAR() {
#-------------------------------------------------------------#
# Nombre de la Función: REGISTRAR
# Propósito: Hacer git commit en el directorio especificado
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core, grep, awk
#-------------------------------------------------------------#

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
# El directorio no existe
[ ! -e "${directorio}" ] && echo -e ${ROJO}"El directorio no existe."${FIN} && exit 1
# El directorio no es un directorio
[ ! -d "${directorio}" ] && echo -e ${ROJO}"El directorio no es un directorio."${FIN} && exit 1
# El directorio no contiene un proyecto git
[ ! -e "${directorio}/.git" ] && echo -e ${ROJO}"El directorio no contiene un proyecto git."${FIN} && exit 1
# Ingresar al directorio
cd ${directorio}
# Emitir la notificación
echo -e ${AMARILLO}"Haciendo commit en el proyecto ${directorio_nombre} ..."${FIN}
# Asegurando que existan las ramas necesarias
[ $( git branch -l | grep -wc "master" ) == 0 ] && echo -e ${AMARILLO}"No existe la rama upstream, creando ..."${FIN} && git branch master
[ $( git branch -l | grep -wc "upstream" ) == 0 ] && echo -e ${AMARILLO}"No existe la rama upstream, creando ..."${FIN} && git branch upstream
[ $( git branch -l | grep -wc "* master" ) == 0 ] && echo -e ${AMARILLO}"No estás en la rama master. Te voy a pasar para allá."${FIN} && git checkout master
# Agregando todos los cambios
git add .
# Verificando que haya algún cambio desde el último commit
if [ $( git status | grep -c "nothing to commit (working directory clean)" ) == 1 ]; then
echo -e ${VERDE}"No hay nada a que hacer commit"${FIN}
NO_COMMIT=1
else
# Si el mensaje de commit está vacío, o está configurado en modo "auto"
if [ -z "${mensaje}" ] || [ "${mensaje}" == "auto" ]; then
commit_message=""
# Autogenerar el mensaje de commit
for archivos_modificados in $( git status -s | grep -w "[AM] " | awk '{print $2}' ); do
archivos_modificados=$( basename ${archivos_modificados} )
commit_message=${commit_message}"${archivos_modificados} "
done
# Ejecutar el commit
git commit -a -q -m "[ canaima-desarrollador ] Los siguientes archivos han sido modificados/añadidos: ${commit_message}" && echo -e ${VERDE}"¡Commit!"${FIN}
else
# Si un mensaje ha sido especificado, ejecutar el commit con ese mensaje
git commit -a -q -m "${mensaje}" && echo -e ${VERDE}"¡Commit!"${FIN}
fi
# Combinar los cambios de master a upstream
git checkout upstream
git merge master > /dev/null 2>&1
git checkout master
echo -e ${AMARILLO}"Haciendo merge master -> upstream"${FIN}
fi
# Volver a la carpeta del desarrollador
cd ${DEV_DIR}
}

function ENVIAR() {
#-------------------------------------------------------------#
# Nombre de la Función: ENVIAR
# Propósito: Hace git push de un proyecto en específico
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core, grep, wget
#-------------------------------------------------------------#

# Garanticemos que el directorio siempre tiene escrita la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
directorio_nombre=$( basename "${directorio}" )
# Comprobaciones varias
# No especificaste el directorio
[ -z "${directorio#${DEV_DIR}}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner a cuál proyecto querías hacer push!"${FIN} && exit 1
# El directorio no existe
[ ! -e "${directorio}" ] && echo -e ${ROJO}"El directorio no existe."${FIN} && exit 1
# El directorio no es un directorio
[ ! -d "${directorio}" ] && echo -e ${ROJO}"El directorio no es un directorio."${FIN} && exit 1
# El directorio no contiene un proyecto git
[ ! -e "${directorio}/.git" ] && echo -e ${ROJO}"El directorio no contiene un proyecto git."${FIN} && exit 1
# Accedemos al directorio
cd ${directorio}
# Emitimos la notificación
echo -e ${AMARILLO}"Haciendo push en el proyecto ${directorio_nombre} ..."${FIN}
# Configuramos los repositorios
SET-REPOS
# Asegurando que existan las ramas necesarias
[ $( git branch -l | grep -wc "upstream" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama upstream, creando ..."${FIN} && git branch upstream
[ $( git branch -l | grep -wc "master" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama master, creando ..."${FIN} && git branch master
# Hacemos push
[ $( git branch -l | grep -wc "master" ) == 1 ] && git push origin master upstream
# Y enviamos las tags
echo -e ${AMARILLO} "Enviando tags ..."${FIN}
[ $( git branch -l | grep -wc master ) == 1 ] && git push --tags
# Volvemos a la carpeta del desarrollador
cd ${DEV_DIR}
}

function ACTUALIZAR() {
#-------------------------------------------------------------#
# Nombre de la Función: ACTUALIZAR
# Propósito: Hace git pull en el proyecto especificado
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core, grep
#	- Funciones: SET-REPOS
#-------------------------------------------------------------#

# Garanticemos que el directorio siempre tiene escrita la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
directorio_nombre=$( basename "${directorio}" )
# Comprobaciones varias
# No especificaste el directorio
[ -z "${directorio#${DEV_DIR}}" ] && echo -e ${ROJO}"Descansa un poco... ¡Se te olvidó poner cuál proyecto querías actualizar!"${FIN} && exit 1
# El directorio no existe
[ ! -e "${directorio}" ] && echo -e ${ROJO}"El directorio no existe."${FIN} && exit 1
# El directorio no es un directorio
[ ! -d "${directorio}" ] && echo -e ${ROJO}"El directorio no es un directorio."${FIN} && exit 1
# El directorio no contiene un proyecto git
[ ! -e "${directorio}/.git" ] && echo -e ${ROJO}"El directorio no contiene un proyecto git."${FIN} && exit 1
# Accedemos al directorio
cd ${directorio}
# Emitimos la notificación
echo -e ${AMARILLO}"Actualizando proyecto ${directorio_nombre} ..."${FIN}
# Configuramos los repositorios
SET-REPOS
# Asegurando que existan las ramas necesarias
[ $( git branch -l | grep -wc "upstream" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama upstream, creando ..."${FIN} && git branch upstream
[ $( git branch -l | grep -wc "master" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama master, creando ..."${FIN} && git branch master
# Hacemos pull
[ $( git branch -l | grep -wc "master" ) == 1 ] && git pull origin master upstream
# Volvemos a la carpeta del desarrollador
cd ${DEV_DIR}
}

#------ AYUDANTES MASIVOS ----------------------------------------------------------------------------------------#
#=======================================================================================================================#

function DESCARGAR-TODO() {
#-------------------------------------------------------------#
# Nombre de la Función: DESCARGAR-TODO
# Propósito: Clonar todos los proyectos existentes en el
#            repositorio oficial git.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core, grep, wget, awk
#-------------------------------------------------------------#

# Accedemos a la carpeta del desarrollador
cd ${DEV_DIR}
# Descargamos la página HTML del repositorio oficial de Canaima GNU/Linux
wget "http://gitorious.org/canaima-gnu-linux" > /dev/null 2>&1
# Extraemos una lista de los datos interesantes
FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )
# Para cada elemento en la lista ...
for proyecto in ${FUENTE}; do DESCARGAR; done
# Borramos la página HTML descargada inicialmente
rm canaima-gnu-linux
}

function REGISTRAR-TODO() {
#-------------------------------------------------------------#
# Nombre de la Función: REGISTRAR-TODO
# Propósito: Hacer git commit a todos los proyectos en la
#            carpeta del desarrollador.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Funciones: REGISTRAR
#-------------------------------------------------------------#

# Para cada directorio en la carpeta del desarrollador, ejecutar la función REGISTRAR
for directorio in $( ls -A ${DEV_DIR} );do REGISTRAR;done
}

function ENVIAR-TODO() {
#-------------------------------------------------------------#
# Nombre de la Función: ENVIAR-TODO
# Propósito: Hace git push en todos los proyectos contenidos
#            dentro de la carpeta del desarrollador.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Funciones: ENVIAR
#-------------------------------------------------------------#

# Para cada directorio en la carpeta del desarrollador... ejecutar la función ENVIAR
for directorio in $( ls -A ${DEV_DIR} );do ENVIAR;done
}

function ACTUALIZAR-TODO() {
#-------------------------------------------------------------#
# Nombre de la Función: ACTUALIZAR-TODO
# Propósito: Hace git pull a todos los proyectos en la carpeta
#            del desarrollador.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Funciones: ACTUALIZAR
#-------------------------------------------------------------#

# Para cada directorio en la carpeta del desarrollador... ejecutar la función ACTUALIZAR
for directorio in $( ls -A ${DEV_DIR} );do ACTUALIZAR;done
}

function EMPAQUETAR-VARIOS() {
#-------------------------------------------------------------#
# Nombre de la Función: EMPAQUETAR-VARIOS
# Propósito: Empaqueta varios proyectos
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Funciones: EMPAQUETAR
#-------------------------------------------------------------#

# Comprobaciones varias
# No especificaste el directorio
[ -z "${PARA_EMPAQUETAR}" ] && echo -e ${ROJO}"No especificaste la lista de proyectos que querías empaquetar."${FIN} && exit 1
# No especificaste número de procesadores
[ -z "${procesadores}" ] && procesadores=0 && echo -e ${AMARILLO}"No me dijiste si tenías más de un procesador. Asumiendo uno sólo."${FIN}
# cálculo de los threads (n+1)
procesadores=$[ ${procesadores}+1 ]
# Para cada directorio especificado en ${PARA_EMPAQUETAR}... ejecutar la función EMPAQUETAR
for directorio in ${PARA_EMPAQUETAR};do EMPAQUETAR;done
}

function EMPAQUETAR-TODO() {
#-------------------------------------------------------------#
# Nombre de la Función: EMPAQUETAR-TODO
# Propósito: Empaquetar todos los proyectos en la carpeta del
#            desarrollador
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Funciones: EMPAQUETAR
#-------------------------------------------------------------#

# Para cada directorio en la carpeta del desarrollador... ejecutar la función EMPAQUETAR
for directorio in $( ls -A ${DEV_DIR} );do EMPAQUETAR;done
}

#------ AYUDANTES INFORMATIVOS -----------------------------------------------------------------------------------#
#=======================================================================================================================#

function LISTAR-REMOTOS() {
#-------------------------------------------------------------#
# Nombre de la Función: LISTAR-REMOTOS
# Propósito: Lista los proyectos existentes en el repositorio
#            oficial git de Canaima GNU/Linux
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#	- Paquetes: grep, wget, awk
#-------------------------------------------------------------#

# Descargamos la página HTML del repositorio oficial de Canaima GNU/Linux
wget "http://gitorious.org/canaima-gnu-linux" > /dev/null 2>&1
# Extraemos una lista de los datos interesantes
FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )
# Vamos imprimiéndolos uno a uno
for descarga in ${FUENTE}; do
nombre=${descarga#"git://gitorious.org/canaima-gnu-linux/"}
nombre=${nombre%".git"}
echo -e "${VERDE}Nombre:${FIN} ${nombre} | ${VERDE}Fuente:${FIN} ${descarga}"
done
# Borramos la página HTML descargada inicialmente
rm canaima-gnu-linux
}

function LISTAR-LOCALES() {
#-------------------------------------------------------------#
# Nombre de la Función: LISTAR-LOCALES
# Propósito: Lista los proyectos existentes en la carpeta del
#            desarrollador, clasificándolos.
# Dependencias:
# 	- Requiere la carga del archivo ${CONF}
#-------------------------------------------------------------#

# Para cada directorio en la carpeta del desarrollador...
for directorio in $( ls -A ${DEV_DIR} ); do
# Asegurarse que contiene la ruta completa
directorio=${DEV_DIR}${directorio#${DEV_DIR}}
# Obtener su nombre base
directorio_nombre=$( basename "${directorio}" )
# Imprimir si es un proyecto versionado (git), si contiene las reglas básicas de un paquete fuente (source),
# y si contiene las reglas básicas de un proyecto debian (debian)
if [ -e "${directorio}/.git" ] && [ -e "${directorio}/Makefile" ] && [ -e "${directorio}/debian/control" ]; then
echo -e "${VERDE}Nombre:${FIN} ${directorio_nombre} | ${VERDE}Tipo:${FIN} git, source, debian"
elif [ -e "${directorio}/.git" ] && [ -e "${directorio}/Makefile" ] && [ ! -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} git, source"
elif [ -e "${directorio}/.git" ] && [ ! -e "${directorio}/Makefile" ] && [ ! -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} git"
elif [ -e "${directorio}/.git" ] && [ ! -e "${directorio}/Makefile" ] && [ -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} git, debian"
elif [ ! -e "${directorio}/.git" ] && [ -e "${directorio}/Makefile" ] && [ -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} source, debian"
elif [ ! -e "${directorio}/.git" ] && [ ! -e "${directorio}/Makefile" ] && [ -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} debian"
elif [ ! -e "${directorio}/.git" ] && [ -e "${directorio}/Makefile" ] && [ ! -e "${directorio}/debian/control" ]; then
echo -e "${AMARILLO}Nombre:${FIN} ${directorio_nombre} | ${AMARILLO}Tipo:${FIN} source"
elif [ ! -e "${directorio}/.git" ] && [ ! -e "${directorio}/Makefile" ] && [ ! -e "${directorio}/debian/control" ]; then
echo -e "${ROJO}Nombre:${FIN} ${directorio_nombre} | ${ROJO}Tipo:${FIN} proyecto desconocido"
fi
done

}

#------ FUNCIONES COMPLEMENTARIAS --------------------------------------------------------------------------------#
#=======================================================================================================================#

function CHECK() {
#-------------------------------------------------------------#
# Nombre de la Función: CHECK
# Propósito: Comprobar que ciertos parámetros se cumplan al
#            inicio del script canaima-desarrollador.sh
# Dependencias:
#	- Requiere la carga del archivo ${VARIABLES} y ${CONF}
#	- Paquetes: findutils
#-------------------------------------------------------------#

# Faltan variables por definir en el archivo de configuración ${CONF}
if [ -z "${REPO}" ] || [ -z "${REPO_USER}" ] || [ -z "${REPO_DIR}" ] || [ -z "${DEV_DIR}" ] || [ -z "${DEV_NAME}" ] || [ -z "${DEV_MAIL}" ] || [ -z "${DEPOSITO_LOGS}" ] || [ -z "${DEPOSITO_SOURCES}" ] || [ -z "${DEPOSITO_DEBS}" ]; then
echo -e ${ROJO}"Tu archivo de configuración ${CONF} presenta inconsistencias. Todas las variables deben estar llenas."${FIN} && exit 1
fi
# La carpeta del desarrollador ${DEV_DIR} no existe
[ ! -d "${DEV_DIR}" ] && echo -e ${ROJO}"¡La carpeta del desarrollador ${DEV_DIR} no existe!"${FIN} && exit 1
# El archivo de configuración personal ${CONF} no existe
[ ! -e "${CONF}" ] && echo -e ${ROJO}"¡Tu archivo de configuración ${CONF} no existe!"${FIN} && exit 1
# Asegurando que existan las carpetas de depósito
[ ! -e ${DEPOSITO_LOGS} ] && mkdir -p ${DEPOSITO_LOGS}
[ ! -e ${DEPOSITO_SOURCES} ] && mkdir -p ${DEPOSITO_SOURCES}
[ ! -e ${DEPOSITO_DEBS} ] && mkdir -p ${DEPOSITO_DEBS}
# Asegurando que la carpeta del desarrollador y de las plantillas
# terminen con un slash (/) al final
ultimo_char_dev=${DEV_DIR#${DEV_DIR%?}}
ultimo_char_pla=${PLANTILLAS#${PLANTILLAS%?}}
[ ${ultimo_char_dev} != "/" ] && DEV_DIR="${DEV_DIR}/"
[ ${ultimo_char_pla} != "/" ] && PLANTILLAS="${PLANTILLAS}/"
# Verificando que no hayan carpetas con nombres que contengan espacios
if [ $( ls ${DEV_DIR} | grep -c " " ) != 0 ]; then
echo -e ${ROJO}"${DEV_DIR} contiene directorios con espacios en su nombre. Abortando."${FIN}
exit 1
else
echo "Iniciando Canaima Desarrollador ..."
fi
}

function DEV-DATA() {
#-------------------------------------------------------------#
# Nombre de la Función: DEV-DATA
# Propósito: Establecer el nombre y correo del desarrollador
#            tanto para versionamiento como empaquetamiento.
# Dependencias:
#	- Requiere la carga del archivo ${CONF}
#	- Paquetes: git-core
#-------------------------------------------------------------#

# Configurando git para que use los datos del desarrollador
git config --global user.name "${DEV_NAME}"
git config --global user.email "${DEV_MAIL}"
# Estableciendo las variables de entorno que utilizan los métodos de
# empaquetamiento.
export DEBFULLNAME="${DEV_NAME}"
export DEBEMAIL="${DEV_MAIL}"
}

function DATOS-PROYECTO() {
#-------------------------------------------------------------#
# Nombre de la Función: DATOS-PROYECTO
# Propósito: Determinar algunos datos del proyecto
# Dependencias:
#	- Requiere la carga del archivo ${VARIABLES}
# 	- Paquetes: grep, awk, dpkg-dev
#-------------------------------------------------------------#

# Ubicación del changelog dentro del proyecto
CHANGELOG_PROYECTO="${directorio}/debian/changelog"
# Si existe, entonces:
if [ -e "${CHANGELOG_PROYECTO}" ]; then
# Usemos dpkg-parsechangelog para que nos diga el nombre y versión del proyecto
VERSION_PROYECTO=$( dpkg-parsechangelog -l${CHANGELOG_PROYECTO} | grep "Version: " | awk '{print $2}' )
NOMBRE_PROYECTO=$( dpkg-parsechangelog -l${CHANGELOG_PROYECTO} | grep "Source: " | awk '{print $2}' )
PAQUETE=1
else
# De lo contrario, advertir que no es un proyecto de empaquetamiento debian
echo -e ${ROJO}"${directorio_nombre} no contiene ningún proyecto de empaquetamiento."${FIN} && PAQUETE=0
fi
}

function SET-REPOS() {
#-------------------------------------------------------------#
# Nombre de la Función: SET-REPOS
# Propósito: Establecer correctamente el repositorio remoto
# Dependencias:
#	- Requiere la carga del archivo ${VARIABLES} y ${CONF}
#	- Se debe ejecutar dentro del proyecto
#	- git-core
#-------------------------------------------------------------#

# Determinar los datos del proyecto
DATOS-PROYECTO
# Determinando la dirección SSH para cada servidor remoto posible
# Por ahora spolo diferenciamos entre gitorious.org y cualquier otro
case ${REPO} in
"gitorious.org") repo_completo="${REPO_USER}@${REPO}:${REPO_DIR}/${NOMBRE_PROYECTO}.git" ;;
*) repo_completo="${REPO_USER}@${REPO}:${REPO_DIR}/${NOMBRE_PROYECTO}/.git" ;;
esac
# Si existe una dirección remota llamada "origin", y su contenido no es el correcto ...
if [ $( git remote | grep -wc "origin" ) == 1 ] && [ $( git remote show origin | grep -c "${repo_completo}" ) == 0 ]; then
# Si ya existe un adirección "origin_viejo", bórrala
[ $( git remote | grep -wc "origin_viejo" ) == 1 ] && git remote rm origin_viejo
# Renombra el "origin" incorrecto a "origin_viejo"
git remote rename origin origin_viejo
fi
# Si "origin" no existe, entonces agrega el correcto
[ $( git remote | grep -wc "origin" ) == 0 ] && git remote add origin ${repo_completo} && echo -e ${AMARILLO}"Definiendo \"${repo_completo}\" como repositorio git \"origin\""${FIN}
echo "Repositorios establecidos"
}

function GIT-DCH() {
#-------------------------------------------------------------#
# Nombre de la Función: GIT-DCH
# Propósito: Registrar los cambios en debian/changelog, usando
#            los mensajes de commit
# Dependencias:
#	- Requiere la carga del archivo ${VARIABLES} y ${CONF}
#	- Paquetes: git-buildpackage, dpkg-dev
#-------------------------------------------------------------#

# Determinar los datos del proyecto
DATOS-PROYECTO
# Accedemos al directorio
cd ${directorio}
echo -e ${AMARILLO}"Registrando cambios en debian/changelog ..."${FIN}
# Determinamos la versión del proyecto antes de hacer git-dch
ANTES_DCH=$( dpkg-parsechangelog | grep "Version: " | awk '{print $2}' )
# Establecemos el editor como "true" para que no nos lleve al editor
# cuando le digamos git-dch
export EDITOR=true
# Ejecutamos git-dch y mandamos su salida a /dev/null
git-dch --release --auto --id-length=7 --full > /dev/null 2>&1
# Reestablecemos el valor anterior de la variable ${EDITOR}
export EDITOR=""
# Determinamos la versión del proyecto después de hacer git-dch
DESPUES_DCH=$( dpkg-parsechangelog | grep "Version: " | awk '{print $2}' )

# Si la versión cambió después de hacer git-dch ...
if [ ${DESPUES_DCH} != ${ANTES_DCH} ]; then
echo -e ${AMARILLO}"Nueva versión ${DESPUES_DCH}"${FIN}
# Si git-dch no cambió el directorio de nombre, luego del cambio de versión, hagámoslo por él
[ $( ls ${DEV_DIR} | grep -wc "${NOMBRE_PROYECTO}-${DESPUES_DCH}" ) == 0  ] && mv $( pwd ) "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" && echo "git-dch no puso el nombre correcto al directorio. Lo voy a hacer."
# Si ya tenemos el nombre correcto, entonces hay que cambiarse para allá
[ $( ls ${DEV_DIR} | grep -wc "${NOMBRE_PROYECTO}-${DESPUES_DCH}" ) == 1  ] && [ $( pwd ) != "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" ] && cd "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" && echo "Cambiando directorio a ${NOMBRE_PROYECTO}-${DESPUES_DCH}"
else
echo -e ${AMARILLO}"Misma versión ${DESPUES_DCH}"${FIN}
fi
# Nos devolvemos a la carpeta del desarrollador
cd ${DEV_DIR}
}

function MOVER() {
#-------------------------------------------------------------#
# Nombre de la Función: MOVER
# Propósito: Mover archivos a su depósito correspondiente
# Dependencias:
#       - Requiere la carga del archivo ${CONF}
#-------------------------------------------------------------#
case ${1} in
# Mover .debs
debs)
if [ $( ls ${DEV_DIR}*.deb 2>/dev/null | wc -l ) != 0 ]; then
mv ${DEV_DIR}*.deb ${DEPOSITO_DEBS}
EXITO "Paquetes Binarios .deb movidos a ${DEPOSITO_DEBS}"
else
ERROR "Ningún paquete .deb para mover"
fi
;;

# Mover .diff .changes .dsc .tar.gz
fuentes)
[ $( ls ${DEV_DIR}*.tar.gz 2>/dev/null | wc -l ) != 0 ] && mv ${DEV_DIR}*.tar.gz ${DEPOSITO_SOURCES}
[ $( ls ${DEV_DIR}*.diff.gz 2>/dev/null | wc -l ) != 0 ] && mv ${DEV_DIR}*.diff.gz ${DEPOSITO_SOURCES}
[ $( ls ${DEV_DIR}*.changes 2>/dev/null | wc -l ) != 0 ] && mv ${DEV_DIR}*.changes ${DEPOSITO_SOURCES}
[ $( ls ${DEV_DIR}*.dsc 2>/dev/null | wc -l ) != 0 ] && mv ${DEV_DIR}*.dsc ${DEPOSITO_SOURCES}
EXITO "Fuentes *.tar.gz *.diff.gz *.changes *.dsc movidas a ${DEPOSITO_SOURCES}"
;;

# Mover .build
logs)
if [ $( ls ${DEV_DIR}*.build 2>/dev/null | wc -l ) != 0 ]; then
mv ${DEV_DIR}*.build ${DEPOSITO_LOGS}
EXITO "Logs .build movidos a ${DEPOSITO_LOGS}"
else
ERROR "Ningún log .build para mover"
fi
;;
esac
}

function ERROR() {
echo -e ${ROJO}${1}${FIN}
exit 1
}

function ADVERTENCIA() {
echo -e ${AMARILLO}${1}${FIN}
}

function EXITO() {
echo -e ${VERDE}${1}${FIN}
}

