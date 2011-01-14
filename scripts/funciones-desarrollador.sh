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

function CHECK() {

[ -d "${DEV_DIR}" ] && echo -e ${ROJO}"¡La carpeta del desarrollador ${DEV_DIR} no existe!"${FIN} && exit 1

[ ! -e "${CONF}" ] && echo -e ${ROJO}"¡Tu archivo de configuración ${CONF} no existe!"${FIN} && exit 1

if [ -z "${REPO}" ] || [ -z "${REPO_USER}" ] || [ -z "${REPO_DIR}" ] || [ -z "${DEV_DIR}" ] || [ -z "${DEV_NAME}" ] || [ -z "${DEV_MAIL}" ] || [ -z "${DEV_GPG}" ] || [ -z "${DEPOSITO_LOGS}" ] || [ -z "${DEPOSITO_SOURCES}" ] || [ -z "${DEPOSITO_DEBS}" ]
then
echo -e ${ROJO}"Tu archivo de configuración ${CONF} presenta inconsistencias. Todas las variables deben estar llenas."${FIN} && exit 1
fi

[ ! -e ${DEPOSITO_LOGS} ] && mkdir -p ${DEPOSITO_LOGS}
[ ! -e ${DEPOSITO_SOURCES} ] && mkdir -p ${DEPOSITO_SOURCES}
[ ! -e ${DEPOSITO_DEBS} ] && mkdir -p ${DEPOSITO_DEBS}

ultimo_char_dev=${DEV_DIR#${DEV_DIR%?}}
ultimo_char_pla=${PLANTILLAS#${PLANTILLAS%?}}

[ ${ultimo_char_dev} != "/" ] && DEV_DIR="${DEV_DIR}/"
[ ${ultimo_char_pla} != "/" ] && PLANTILLAS="${PLANTILLAS}/"

if [ $( find ${DEV_DIR} -maxdepth 1 -name '* *' | wc -l ) != 0 ]
then
echo -e ${ROJO}"${DEV_DIR} contiene directorios con espacios en su nombre. Abortando."${FIN} && exit 1
fi

}

function DEV-DATA {

if [ -n "${DEV_NAME}" ] && [ -n "${DEV_MAIL}" ]
then

git config --global user.name "${DEV_NAME}"
git config --global user.email "${DEV_MAIL}"
export DEBFULLNAME="${DEV_NAME}"
export DEBEMAIL="${DEV_NAME}"

else
echo -e ${ROJO}"No has definido tu nombre de usuario ni correo. Edita ${CONF} para hacerlo."${FIN} && exit 1
fi

}

function DATOS-PROYECTO() {

CHANGELOG_PROYECTO="${directorio}/debian/changelog"

if [ -e "${CHANGELOG_PROYECTO}" ]
then

VERSION_PROYECTO=$( dpkg-parsechangelog -l${CHANGELOG_PROYECTO} | grep "Version: " | awk '{print $2}' )
NOMBRE_PROYECTO=$( dpkg-parsechangelog -l${CHANGELOG_PROYECTO} | grep "Source: " | awk '{print $2}' )
PAQUETE=1

else
echo -e ${ROJO}"${directorio_nombre} no contiene ningún proyecto de empaquetamiento."${FIN} && PAQUETE=0
fi

datos_proyecto_exec=1

}

function SET-REPOS() {

[ ${datos_proyecto_exec} == 0 ] && DATOS-PROYECTO

if [ ${PAQUETE} == 1 ]
then

case ${REPO} in

"gitorious.org")
repo_completo="${REPO_USER}@${REPO}:${REPO_DIR}/${NOMBRE_PROYECTO}.git"
;;

*)
repo_completo="${REPO_USER}@${REPO}:${REPO_DIR}/${NOMBRE_PROYECTO}/.git"
;;

esac

if [ $( git remote | grep -wc "origin" ) == 1 ]; then
if [ $( git remote show origin | grep -c "${repo_completo}" ) == 0 ]; then

[ $( git remote | grep -wc "origin_viejo" ) == 1 ] && git remote rm origin_viejo
git remote rename origin origin_viejo
git remote add origin ${repo_completo}

fi
else
git remote add origin ${repo_completo}
fi

echo -e ${AMARILLO}"Definiendo \"${repo_completo}\" como repositorio git \"origin\""${FIN}

else
echo -e ${ROJO}"No se verificarán los repositorios de éste proyecto, no está listo para empaquetar."${FIN}
fi

set_repos_exec=1

}

function COMMIT() {

[ ${datos_proyecto_exec} == 0 ] && DATOS-PROYECTO

if [ -d "${directorio}" ]
then

cd ${directorio}

echo -e ${AMARILLO}"Verificando paquete ${directorio_nombre} ..."${FIN}

if [ -e "${directorio}/.git" ]
then

[ $( git branch -l | grep -wc "master" ) == 0 ] && echo -e ${ROJO}"No existe la rama master, creando ..."${FIN} && git branch master
[ $( git branch -l | grep -wc "upstream" ) == 0 ] && echo -e ${ROJO}"No existe la rama upstream, creando ..."${FIN} && git branch upstream
[ $( git branch -l | grep -wc "* master" ) == 0 ] && echo -e ${ROJO}"No estás en la rama master. Te voy a pasar para allá."${FIN} && git checkout master

git add .

if [ $( git branch -l | grep -wc "* master" ) == 1 ]
then

commit_message=""

for archivos_modificados in $( git status -s | grep -w "[AM] " | awk '{print $2}' )
do
archivos_modificados=$( basename ${archivos_modificados} )
commit_message=${commit_message}"${archivos_modificados} "
done

if [ $( git status | grep -c "nothing to commit (working directory clean)" ) == 1 ]
then
echo -e ${VERDE}"No hay nada a que hacer commit"${FIN}
else

if [ -z "${mensaje}" ] || [ "${mensaje}" == "auto" ]
then
git commit -a -q -m "[ Mensaje autogenerado por canaima-desarrollador ] Los siguientes archivos han sido modificados/añadidos: ${commit_message}" && echo -e ${VERDE}"¡Commit!"${FIN}
else
git commit -a -q -m "${mensaje}" && echo -e ${VERDE}"¡Commit!"${FIN}
fi

git checkout upstream
git merge master > /dev/null 2>&1
git checkout master
echo -e ${AMARILLO}"Haciendo merge master -> upstream"${FIN}

fi

fi

else
echo -e ${ROJO}"${directorio} no parece un proyecto git. Me voy."${FIN}
fi

cd ${DEV_DIR}

else
echo -e ${ROJO}"${directorio} no existe o no es un directorio. Me lo salto."${FIN}
fi

}

function GIT-DCH() {

[ ${datos_proyecto_exec} == 0 ] && DATOS-PROYECTO

if [ -d "${directorio}" ]
then

cd ${directorio}

if [ -e "${directorio}/.git" ]
then

echo -e ${AMARILLO}"Registrando cambios en debian/changelog ..."${FIN}

ANTES_DCH=$( dpkg-parsechangelog | grep "Version: " | awk '{print $2}' )

export $EDITOR=true
git-dch --release --auto --id-length=7 --full > /dev/null 2>&1
export $EDITOR=""

DESPUES_DCH=$( dpkg-parsechangelog | grep "Version: " | awk '{print $2}' )

if [ ${DESPUES_DCH} != ${ANTES_DCH} ]
then

echo -e ${AMARILLO}"Nueva versión ${DESPUES_DCH}"${FIN}

[ $( ls ${DEV_DIR} | grep -wc "${NOMBRE_PROYECTO}-${DESPUES_DCH}" ) == 0  ] && mv $( pwd ) "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" && echo "git-dch no puso el nombre correcto al directorio. Lo voy a hacer."

[ $( ls ${DEV_DIR} | grep -wc "${NOMBRE_PROYECTO}-${DESPUES_DCH}" ) == 1  ] && [ $( pwd ) != "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" ] && cd "${DEV_DIR}${NOMBRE_PROYECTO}-${DESPUES_DCH}" && echo "Cambiando directorio a ${NOMBRE_PROYECTO}-${DESPUES_DCH}"

else
echo -e ${AMARILLO}"Misma versión ${DESPUES_DCH}"${FIN}
fi

else
echo -e ${ROJO}"${directorio} no parece un proyecto git. Me voy."${FIN}
fi

cd ${DEV_DIR}

else
echo -e ${ROJO}"${directorio} no existe o no es un directorio. Me lo salto."${FIN}
fi

}

function PUSH() {

if [ -d "${directorio}" ]
then

cd "${directorio}"

if [ -e "${directorio}/.git" ]
then

echo -e ${AMARILLO}"Enviando proyecto ${directorio_nombre} ..."${FIN}

[ ${set_repos_exec} == 0] && SET-REPOS

[ $( git branch -l | grep -wc "upstream" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama upstream, creando ..."${FIN} && git branch upstream
[ $( git branch -l | grep -wc "master" ) == 0 ] && echo -e ${ROJO}"Al proyecto le falta la rama master, creando ..."${FIN} && git branch master
[ $( git branch -l | grep -wc "master" ) == 1 ] && git push origin master upstream

echo -e ${AMARILLO} "Enviando tags ..."${FIN}
[ $( git branch -l | grep -wc master ) == 1 ] && git push --tags

else
echo -e ${ROJO}"${directorio} no parece un proyecto git. Me voy."${FIN}
fi

cd ${DEV_DIR}

else
echo -e ${ROJO}"${directorio} no existe o no es un directorio. Me lo salto."${FIN}
fi

}

function EMPAQUETAR() {

cd ${directorio}

COMMIT
GIT-DCH
COMMIT
CREAR-SOURCE
PUSH

git-buildpackage -tc --git-tag -j${procesadores}

}

function CREAR-PROYECTO() {

[ ! -e "${DEV_DIR}${nombre}-${version}" ] && mkdir -p "${DEV_DIR}${nombre}-${version}"

cd "${DEV_DIR}${nombre}-${version}"

echo "enter" | dh_make --createorig --cdbs --copyright ${licencia} --email ${DEV_MAIL} > /dev/null 2>&1

echo "Nombre del Paquete: ${nombre}"
echo "Versión: ${version}"
echo "Mantenedor: ${DEV_NAME}"
echo "Correo del Mantenedor: ${DEV_MAIL}"
echo "Licencia: ${licencia}"

rm -rf "${DEV_DIR}${nombre}-${version}.orig"
mkdir -p "${DEV_DIR}${nombre}-${version}/debian/ejemplos"
mv ${DEV_DIR}${nombre}-${version}/debian/*.* ${DEV_DIR}${nombre}-${version}/debian/ejemplos/

if [ ${destino} == "canaima" ]
then

CONTROL_MAINTAINER="Equipo de Desarrollo de Canaima GNU/Linux <desarrolladores@canaima.softwarelibre.gob.ve>"
CONTROL_UPLOADERS="José Miguel Parrella Romero <jparrella@onuva.com>, Carlos David Marrero <cdmarrero2040@gmail.com>, Orlando Andrés Fiol Carballo <ofiol@indesoft.org.ve>, Carlos Alejandro Guerrero Mora <guerrerocarlos@gmail.com>, Diego Alberto Aguilera Zambrano <diegoaguilera85@gmail.com>, Luis Alejandro Martínez Faneyth <martinez.faneyth@gmail.com>, Francisco Javier Vásquez Guerrero <franjvasquezg@gmail.com>"
CONTROL_STANDARDS="3.9.1"
CONTROL_HOMEPAGE="http://canaima.softwarelibre.gob.ve/"
CONTROL_VCSGIT="git://gitorious.org/canaima-gnu-linux/${nombre}.git"
CONTROL_VCSBROWSER="git://gitorious.org/canaima-gnu-linux/${nombre}.git"

elif [ ${destino} == "personal" ]
then

CONTROL_MAINTAINER="${DEV_NAME} <${DEV_MAIL}>"
CONTROL_UPLOADERS="${CONTROL_MAINTAINER}"
CONTROL_HOMEPAGE="Desconocido"
CONTROL_VCSGIT="Desconocido"
CONTROL_VCSBROWSER="Desconocido"

fi

CONTROL_DESCRIPTION="Insertar una descripción de no más de 60 caracteres."
CONTROL_LONG_DESCRIPTION="Insertar descripción larga, iniciando con un espacio."
CONTROL_ARCH="all"

case ${licencia} in
gpl3) LICENSE="GPL-3" ;;
apache) LICENSE="Apache-2.0" ;;
artistic) LICENSE="Artistic" ;;
bsd) LICENSE="BSD" ;;
gpl) LICENSE="GPL-1" ;;
gpl2) LICENSE="GPL-2" ;;
lgpl) LICENSE="LGPL-3" ;;
lgpl2) LICENSE="LGPL-2" ;;
lgpl3) LICENSE="LGPL-3" ;;
esac

COPIAR_PLANTILLAS_DEBIAN="preinst postinst prerm postrm rules copyright"
COPIAR_PLANTILLAS_PROYECTO="AUTHORS README TODO COPYING THANKS ${LICENSE} Makefile"

FECHA=$( date +%Y )

for plantillas_debian in ${COPIAR_PLANTILLAS_DEBIAN}
do

[ ! -e "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}" ] && cp -r "${PLANTILLAS}${plantillas_debian}" "${DEV_DIR}${nombre}-${version}/debian/"

sed -i "s/@AUTHOR_NAME@/${DEV_NAME}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@AUTHOR_MAIL@/${DEV_MAIL}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@YEAR@/${FECHA}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"
sed -i "s/@PAQUETE@/${nombre}/g" "${DEV_DIR}${nombre}-${version}/debian/${plantillas_debian}"

done

for plantillas_proyecto in ${COPIAR_PLANTILLAS_PROYECTO}
do

[ ! -e "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}" ] && cp -r "${PLANTILLAS}${plantillas_proyecto}" "${DEV_DIR}${nombre}-${version}/"

sed -i "s/@AUTHOR_NAME@/${DEV_NAME}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@AUTHOR_MAIL@/${DEV_MAIL}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@YEAR@/${FECHA}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"
sed -i "s/@PAQUETE@/${nombre}/g" "${DEV_DIR}${nombre}-${version}/${plantillas_proyecto}"

done

mv "${DEV_DIR}${nombre}-${version}/${LICENSE}" "${DEV_DIR}${nombre}-${version}/LICENSE"

sed -i "s/#Vcs-Browser:.*/#Vcs-Browser: ${CONTROL_VCSBROWSER}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Homepage:.*/Homepage: ${CONTROL_HOMEPAGE}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Maintainer:.*/Maintainer: ${CONTROL_MAINTAINER}\nUploaders: ${CONTROL_UPLOADERS}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Description:.*/Description: ${CONTROL_DESCRIPTION}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/<insert long description, indented with spaces>/${CONTROL_LONG_DESCRIPTION}/g" "${DEV_DIR}${nombre}-${version}/debian/control"
sed -i "s/Architecture:.*/Architecture: ${CONTROL_ARCH}/g" "${DEV_DIR}${nombre}-${version}/debian/control"

sed -i "s/Initial release (Closes: #nnnn)  <nnnn is the bug number of your ITP>/Versión inicial de ${nombre} para Canaima GNU\/Linux/g" "${DEV_DIR}${nombre}-${version}/debian/changelog"
sed -i "s/(.*)/(${version})/g" "${DEV_DIR}${nombre}-${version}/debian/changelog"

echo "3.0 (quilt)" > ${DEV_DIR}${nombre}-${version}/debian/source/format
echo "7" > ${DEV_DIR}${nombre}-${version}/debian/compat

if [ ! -e "${DEV_DIR}${nombre}-${version}/.git/" ]
then

git init > /dev/null 2>&1

echo -e ${AMARILLO}"Repositorio git inicializado"${FIN}

directorio="${DEV_DIR}${nombre}-${version}"
directorio_nombre=$( basename "${directorio}" )

SET-REPOS

fi

if [ ${opcion} == "crear-proyecto" ]; then
echo -e ${VERDE}"¡Proyecto ${nombre} creado!"${FIN}
elif [ ${opcion} == "debianizar" ]; then
echo -e ${VERDE}"¡Proyecto ${nombre} debianizado correctamente!"${FIN}
fi

echo -e ${AMARILLO}"Lee los comentarios en los archivos creados para mayor información"${FIN}

}

function CREAR-FUENTE() {

slash=${directorio#${directorio%?}}
[ ${slash} == "/" ] && directorio=${directorio%?}
cd ${DEV_DIR}
rm -rf "${directorio}.orig"
cp -r ${directorio} "${directorio}.orig"
dpkg-source --format="1.0" -i.git/ -I.git -b ${directorio}

}

function COMMIT-TODO() {

echo -e ${AMARILLO}"Haciendo commit de los cambios en todos los proyectos git de ${DEV_DIR} ..."${FIN}

[ $( ls -d ${DEV_DIR} | wc -l ) == 0 ] && echo -e ${ROJO}"No existen directorios. Nada a que hacer commit."${FIN} && exit 1

${COMMIT_NUMBER}=0
for directorio in $( ls -A ${DEV_DIR} )
do

directorio=${DEV_DIR}${directorio}
directorio_nombre=$( basename "${directorio}" )
COMMIT
[ ${COMMIT_DONE} == 1 ] && ${COMMIT_NUMBER}=$[ ${COMMIT_NUMBER}+1 ]

done

echo -e ${VERDE}"¡${COMMIT_NUMBER} commit completados!"${FIN}

}

function PUSH-TODO() {

ACCION="Subiendo proyectos git en ${DEV_DIR}"

echo -e ${VERDE}"===== ${ACCION} ====="${FIN}

[ $( ls -d ${DEV_DIR} | wc -l ) == 0 ] && echo -e ${ROJO}"No existen directorios. Nada que subir."${FIN} && exit 1

for directorio in $( ls -A ${DEV_DIR} )
do

PUSH

done

}

function DESCARGAR() {

cd ${DEV_DIR}

wget "http://gitorious.org/canaima-gnu-linux" > /dev/null 2>&1

FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )

if [ $( echo ${FUENTE} | grep -wc "git://gitorious.org/canaima-gnu-linux/${proyecto}.git" ) != 0 ]
then
descarga="git://gitorious.org/canaima-gnu-linux/${proyecto}.git"
git clone ${descarga}
else
echo -e ${VE}"¡${COMMIT_NUMBER} commit completados!"${FIN}
fi

rm canaima-gnu-linux

}

function LISTAR-DESCARGAS() {

RESULTADO=$( wget --no-verbose "http://gitorious.org/canaima-gnu-linux" )

FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )

for descarga in ${FUENTE}
do
nombre=${descarga#"git://gitorious.org/canaima-gnu-linux/"}
nombre=${nombre%".git"}
echo -e "${VERDE}Nombre:${FIN} ${nombre} | ${VERDE}Fuente:${FIN} ${descarga}"
done

rm canaima-gnu-linux
echo $RESULTADO
}

function DESCARGAR-TODO() {

wget --nv "http://gitorious.org/canaima-gnu-linux"

FUENTE=$( cat "canaima-gnu-linux" | grep "git clone git://gitorious.org/canaima-gnu-linux/" | awk '{print $3}' )

cd ${DEV_DIR}

for descarga in ${FUENTE}
do
nombre=${descarga#"git://gitorious.org/canaima-gnu-linux/"}
nombre=${nombre%".git"}
echo -e ${AMARILLO}"Descargando ${nombre} ..."${FIN}
git clone ${descarga}
[ -e "${DEV_DIR}${nombre}" ] && echo -e ${VERDE}"¡Descargado!"${FIN}
[ ! -e "${DEV_DIR}${nombre}" ] && echo -e ${ROJO}"Ooops...! Algo falló"${FIN}
done

rm canaima-gnu-linux

}

