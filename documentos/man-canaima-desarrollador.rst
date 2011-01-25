=====================
canaima-desarrollador
=====================

-------------------------------------------------------------
Herramienta que facilita la creación de Software para Canaima
-------------------------------------------------------------

:Author: martinez.faneyth@gmail.com
:Date:   2011-01-22
:Copyright: Libre uso, modificación y distribución (GPL3)
:Version: 1.0+0
:Manual section: 1
:Manual group: Empaquetamiento

MODO DE USO
===========

**canaima-desarrollador [AYUDANTE] [PARÁMETRO-1] [PARÁMETRO-2] ... [PARÁMETRO-N] [--ayuda]**

**c-d [AYUDANTE] [PARÁMETRO-1] [PARÁMETRO-2] ... [PARÁMETRO-N] [--ayuda]**

DESCRIPCIÓN
===========

Canaima Desarrollador (C-D) es un compendio de herramientas y ayudantes que facilitan el proceso de desarrollo de software para Canaima GNU/Linux. Está diseñado para **facilitar el trabajo** a aquellas personas que participan en dicho proceso con regularidad, como también para **iniciar a los que deseen aprender** de una manera rápida y práctica.

C-D sigue dos líneas de acción principales para lograr éste cometido: **la práctica** y **la formativa**. La práctica permite:

* Agilizar los procesos para la creación de paquetes binarios canaima a partir de paquetes fuentes correctamente estructurados.
* Automatización personalizada de la creación de Paquetes Fuentes acordes a las Políticas de Canaima GNU/Linux.
* Creación de un depósito personal, por usuario, donde se guardan automáticamente y en carpetas separadas los siguientes tipos de archivo:

  - Proyectos en proceso de empaquetamiento
  - Paquetes Binarios (\*.deb)
  - Paquetes Fuente (\*.tar.gz, \*.dsc, \*.changes, \*.diff)
  - Registros provenientes de la creación de paquetes binarios (\*.build)

* Versionamiento asistido (basado en git) en los proyectos, brindando herramientas para realizar las siguientes operaciones, con un alto nivel de automatización y detección de posibles errores:

  - git clone
  - git commit
  - git push
  - git pull

* Ejecución de tareas en masa (empaquetar, hacer pull, push, commit, entre otros), para agilizar procesos repetitivos.

En el otro aspecto, el formativo, C-D incluye:

* El Manual del Desarrollador, resumen técnico-práctico de las herramientas cognitivas necesarias para desarrollar paquetes funcionales para Canaima GNU/Linux.
* La Guía de Referencia para el Desarrollador, compendio extenso y detallado que extiende y complementa el contenido del Manual del Desarrollador.
* Éste manual para el uso de Canaima Desarrollador.

AYUDANTES DE C-D
================

CREAR PROYECTO
--------------

Uso::

canaima-desarrollador crear-proyecto <nombre> <versión> <destino> <licencia>
canaima-desarrollador debianizar <nombre> <versión> <destino> <licencia>

Para crear un proyecto desde cero o debianizar uno existente, debes especificar lo siguiente:

:nombre: Un nombre para tu proyecto, que puede contener letras, números, puntos y guiones. Cualquier otro caracter no está permitido.

:versión: La versión inicial de tu proyecto. Se permiten números, guiones, puntos, letras o dashes (~).

:destino: [canaima|personal] Especifica si es un proyecto de empaquetamiento para Canaima GNU/Linux o si es un proyecto personal.

:licencia: [apache|artistic|bsd|gpl|gpl2|gpl3|lgpl|lgpl2|lgpl3] Especifica el tipo de licencia bajo el cuál distribuirás tu trabajo.

Si estás debianizando un proyecto existente, lo que ingreses en <nombre> y <versión> se utilizará para determinar cuál es el nomnre de la carpeta a debianizar dentro del directorio del desarrollador, suponiendo que tiene el nombre <nombre>-<versión>. Si no se llama así, habrá un error.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

CREAR FUENTE
~~~~~~~~~~~~

Uso::

  canaima-desarrollador crear-fuente <directorio>
  c-d crear-fuente <directorio>

Crea un paquete fuente .tar.gz del proyecto de empaquetamiento contenido en <directorio> y lo guarda en el depósito de fuentes. El directorio debe contener un proyecto debianizado.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

EMPAQUETAR
~~~~~~~~~~

Uso::

  canaima-desarrollador empaquetar <directorio> <mensaje> <procesadores>
  c-d empaquetar <directorio> <mensaje> <procesadores>

Éste ayudante te permite empaquetar un proyecto de forma automatizada, siguiendo la metodología git-buildpackage, que se centra en el siguiente diagrama:

COMMIT > REFLEJAR CAMBIOS EN EL CHANGELOG > COMMIT > CREAR PAQUETE FUENTE > PUSH > GIT-BUILDPACKAGE

Parámetros:

  directorio		Nombre de la carpeta dentro del directorio del desarrollador donde se encuentra el proyecto a empaquetar.

  mensaje		[auto|''|*] Mensaje representativo de los cambios para el primer commit. El segundo commit es sólo para el changelog. Colocando la palabra "auto" o dejando el campo vacío, se autogenera el mensaje.

  procesadores		[1-n] Número de procesadores con que cuenta tu computadora para optimizar el proceso de empaquetamiento.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

Ayudantes Git
-------------

DESCARGAR
~~~~~~~~~

Uso::

  canaima-desarrollador descargar <proyecto>
  c-d descargar <proyecto>

Éste ayudante te permite copiar a tu disco duro un proyecto que se encuentre en el repositorio remoto para que puedas modificarlo según consideres. Utiliza git clone para realizar tal operación.

Parámetros:

  proyecto		[nombre|dirección] Nombre del proyecto (en caso de que éste se encuentre en el repositorio de Canaima GNU/Linux) o la dirección git pública del proyecto.

Éste ayudante se encarga además de realizar las siguientes operaciones por ti:

  - Verifica e informa sobre el éxito de la descarga.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

REGISTRAR
~~~~~~~~~

Uso::

  canaima-desarrollador registrar <directorio> <mensaje>
  c-d registrar <directorio> <mensaje>

Éste ayudante te permite registar (o hacer commit de) los cambios hechos en un proyecto mediante el versionamiento basado en git. Utiliza git commit para lograr éste propósito.

Parámetros:

  directorio		Nombre de la carpeta dentro del directorio del desarrollador a la que se quiere hacer commit.

  mensaje		[auto|''|*] Mensaje representativo de los cambios para el commit. Colocando la palabra "auto" o dejando el campo vacío, se autogenera el mensaje.

Éste ayudante se encarga además de realizar las siguientes operaciones por ti:

  - Verifica la existencia de la rama git "upstream". En caso de no encontrarla, la crea.
  - Verifica la existencia de la rama git "master". En caso de no encontrarla, la crea.
  - Verifica la existencia de todos los elementos necesarios para ejecutar la acción git commit (carpetas, variables de entorno, etc..). En caso de encontrar algún error, aborta e informa.
  - Autogenera el mensaje de commit, si se le instruye.
  - Hace git checkout a la rama master, si nos encontramos en una rama diferente a la hora de hace commit.
  - Hace un git merge de la rama master a la upstream, inmediatamente depués del commit.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

ENVIAR
~~~~~~

Uso::

  canaima-desarrollador enviar <directorio>
  c-d enviar <directorio>

Éste ayudante te permite enviar los cambios realizados al repositorio remoto especificado en las configuraciones personales, mediante el uso de la acción git push.

Parámetros:

  directorio		Nombre de la carpeta dentro del directorio del desarrollador a la que se quiere hacer push.

Éste ayudante se encarga además de realizar las siguientes operaciones por ti:

  - Verifica la existencia de la rama git "upstream". En caso de no encontrarla, la crea.
  - Verifica la existencia de la rama git "master". En caso de no encontrarla, la crea.
  - Verifica la existencia de todos los elementos necesarios para ejecutar la acción git push (carpetas, variables de entorno, etc..). En caso de encontrar algún error, aborta e informa.
  - Configura el repositorio remoto para el proyecto, de acuerdo a los parámetros establecidos en ~/.config/canaima-desarrollador/usuario.conf

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

ACTUALIZAR
~~~~~~~~~~

Uso::

  canaima-desarrollador actualizar <directorio>
  c-d actualizar <directorio>

Éste ayudante te permite actualizar el código fuente de un determinado proyecto, mediante la ejecución de "git pull" en la carpeta del proyecto.

Parámetros:

  directorio		Nombre de la carpeta dentro del directorio del desarrollador a la que se quiere hacer git pull.

Éste ayudante se encarga además de realizar las siguientes operaciones por ti:

  - Verifica la existencia de la rama git "upstream". En caso de no encontrarla, la crea.
  - Verifica la existencia de la rama git "master". En caso de no encontrarla, la crea.
  - Verifica la existencia de todos los elementos necesarios para ejecutar la acción git pull (carpetas, variables de entorno, etc..). En caso de encontrar algún error, aborta e informa.
  - Configura el repositorio remoto para el proyecto, de acuerdo a los parámetros establecidos en ~/.config/canaima-desarrollador/usuario.conf

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

DESCARGAR TODO
~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador descargar-todo
  c-d descargar-todo

Éste ayudante te permite copiar a tu disco duro todos los proyectos de Canaima GNU/Linux que se encuentren en el repositorio remoto oficial. Utiliza git clone para realizar tal operación.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

REGISTRAR TODO
~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador registrar-todo
  c-d registrar-todo

Éste ayudante te permite registar (o hacer commit de) todos los cambios hechos en todos los proyectos existentes en la carpeta del desarrollador. Utiliza git commit para lograr éste propósito. Asume un mensaje de commit automático para todos.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

ENVIAR TODO
~~~~~~~~~~~

Uso::

  canaima-desarrollador enviar-todo
  c-d enviar-todo

Éste ayudante te permite enviar todos los cambios realizados en todos los proyectos ubicados en la carpeta del desarrollador al repositorio remoto especificado en las configuraciones personales, mediante el uso de la acción git push.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

ACTUALIZAR TODO
~~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador actualizar-todo
  c-d actualizar-todo

Éste ayudante te permite actualizar el código fuente de todos los proyectos ubicados en la carpeta del desarrollador, mediante la ejecución de "git pull" en la carpeta del proyecto.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

EMPAQUETAR VARIOS
~~~~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador empaquetar-varios <para-empaquetar> <procesadores>
  c-d empaquetar-varios <para-empaquetar> <procesadores>

Éste ayudante te permite empaquetar varios proyectos.

Parámetros:

  para-empaquetar	Lista de los directorios dentro de la carpeta del desarrollador que contienen los proyectos que se quieren	empaquetar, agrupados entre comillas.

  procesadores		[1-n] Número de procesadores con que cuenta tu computadora para optimizar el proceso de empaquetamiento.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

EMPAQUETAR TODO
~~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador empaquetar-todo <para-empaquetar> <procesadores>
  c-d empaquetar-todo <para-empaquetar> <procesadores>

Éste ayudante te permite empaquetar todos los proyectos existentes en la carpeta del desarrollador.

Parámetros:

  procesadores		[1-n] Número de procesadores con que cuenta tu computadora para optimizar el proceso de empaquetamiento.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

LISTAR REMOTOS
~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador listar-remotos
  c-d listar-remotos

Muestra todos los proyectos contenidos en el repositorio remoto y muestra su dirección git.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

LISTAR LOCALES
~~~~~~~~~~~~~~

Uso::

  canaima-desarrollador listar-locales
  c-d listar-locales

Muestra todos los proyectos contenidos en la carpeta del desarrollador y los clasifica según su tipo.

Opciones de Ayuda::

  --ayuda			Muestra la documentación para el ayudante.

Autores
-------

 * Luis Alejandro Martínez Faneyth <martinez.faneyth@gmail.com>
 * Diego Alberto Aguilera Zambrano <daguilera85@gmail.com>
 * Carlos Alejandro Guerrero Mora <guerrerocarlos@gmail.com>
 * Francisco Javier Vásquez Guerrero <franjvasquezg@gmail.com>

Contacto
--------

desarrolladores@listas.canaima.softwarelibre.gob.ve
