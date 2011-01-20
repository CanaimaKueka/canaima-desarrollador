Documentación para el Ayudante "empaquetar" de Canaima Desarrollador

Uso:
  canaima-desarrollador empaquetar <directorio> <mensaje> <procesadores>

Éste ayudante te permite empaquetar un proyecto de forma automatizada, siguiendo
la metodología git-buildpackage, que se centra en el siguiente diagrama:

COMMIT > REFLEJAR CAMBIOS > COMMIT > CREAR PAQUETE > PUSH > GIT-BUILDPACKAGE
         EN EL CHANGELOG             FUENTE

Parámetros:

  directorio		Nombre de la carpeta dentro del directorio del 
			desarrollador donde se encuentra el proyecto a empaquetar.

  mensaje		[auto|*]
			Mensaje representativo de los cambios para el primer
			commit. El segundo commit es sólo para el changelog.
			Colocando la palabra "auto", se autogenera el mensaje.

  procesadores		[1-n]
			Número de procesadores con que cuenta tu computadora para
			optimizar el proceso de empaquetamiento.

NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN
DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN.

Opciones de Ayuda:
  --ayuda			Muestra ésta ayuda.

Para mayor información, puedes recurrir a la entrada del manual para
canaima-desarrollador (man canaima-desarrollador).

Contacto: desarroladores@canaima.softwarelibre.gob.ve

