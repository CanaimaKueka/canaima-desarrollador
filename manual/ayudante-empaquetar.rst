Documentación para el Ayudante "crear-proyecto" de Canaima Desarrollador

Uso:
  canaima-desarrollador crear-proyecto <nombre> <versión> <destino> <licencia>
  canaima-desarrollador debianizar <nombre> <versión> <destino> <licencia>

Para crear un proyecto desde cero o debianizar uno existente, debes especificar
lo siguiente:

  nombre	Un nombre para tu proyecto, que puede contener letras, números,
		puntos y guiones. Cualquier otro caracter no está permitido.

  versión	La versión inicial de tu proyecto. Se permiten números, guiones,
		puntos, letras o dashes (~).

  destino	[canaima|personal]
		Especifica si es un proyecto de empaquetamiento para Canaima
		GNU/Linux o si es un proyecto personal.

  licencia	[apache|artistic|bsd|gpl|gpl2|gpl3|lgpl|lgpl2|lgpl3]
		Especifica el tipo de licencia bajo el cuál distribuirás tu
		trabajo.

NOTA: TODOS LOS PARÁMETROS SON NECESARIOS. LA ALTERACIÓN DEL ORDEN O LA OMISIÓN
DE ALGUNO PUEDE TRAER CONSECUENCIAS GRAVES. PRESTA ATENCIÓN.

Si estás debianizando un proyecto existente, lo que ingreses en <nombre> y
<versión> se utilizará para determinar cuál es el nomnre de la carpeta a
debianizar dentro del directorio del desarrollador, suponiendo que tiene el
nombre <nombre>-<versión>. Si no se llama así, habrá un error.

Opciones de Ayuda:
  --ayuda			Muestra ésta ayuda.

Para mayor información, puedes recurrir a la entrada del manual para
canaima-desarrollador (man canaima-desarrollador).

Contacto: desarroladores@canaima.softwarelibre.gob.ve

