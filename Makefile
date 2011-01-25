# Makefile

SHELL := sh -e

SCRIPTS =	"debian/preinst install" \
		"debian/postinst configure" \
		"debian/prerm remove" \
		"debian/postrm remove" \
		"scripts/canaima-desarrollador.sh" \
		"scripts/funciones-desarrollador.sh" \
		"scripts/manual-desarrollador.sh"

all: clean build clean

test:

	@echo -n "\n===== Comprobando posibles errores de sintaxis en los scripts de mantenedor =====\n"

	@for SCRIPT in $(SCRIPTS); \
	do \
		echo -n "$${SCRIPT}\n"; \
		bash -n $${SCRIPT}; \
	done

	@echo -n "¡TODO BIEN!\n=================================================================================\n\n"

build:

	# Generar la documentación con python-sphinx
	cd documentos
	rst2man --language="es" --title="CANAIMA DESARROLLADOR" man-canaima-desarrollador.rst canaima-desarrollador.1
	$(MAKE) latex
	$(MAKE) html
	cd latex
	$(MAKE) all-pdf
	

install:

	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/canaima-desarrollador/
	mkdir -p $(DESTDIR)/etc/skel/.config/canaima-desarrollador/
	mkdir -p $(DESTDIR)/usr/share/applications/
	cp -r desktop/manual-desarrollador.desktop $(DESTDIR)/usr/share/applications/
	cp -r scripts/canaima-desarrollador.sh $(DESTDIR)/usr/bin/canaima-desarrollador
	cp -r scripts/canaima-desarrollador.sh $(DESTDIR)/usr/bin/c-d
	cp -r scripts/manual-desarrollador.sh $(DESTDIR)/usr/bin/manual-desarrollador
	cp -r scripts plantillas $(DESTDIR)/usr/share/canaima-desarrollador/
	cp -r conf/variables.conf $(DESTDIR)/usr/share/canaima-desarrollador/
	cp -r conf/usuario.conf $(DESTDIR)/etc/skel/.config/canaima-desarrollador/

uninstall:

	rm -rf $(DESTDIR)/usr/share/canaima-bienvenido/
	rm -rf $(DESTDIR)/usr/bin/canaima-bienvenido
	rm -rf $(DESTDIR)/usr/bin/canaima-bienvenido-automatico
	rm -f $(DESTDIR)/etc/skel/Escritorio/canaima-bienvenido.desktop
	rm -f $(DESTDIR)/etc/skel/.config/autostart/canaima-bienvenido-automatico.desktop
	rm -f $(DESTDIR)/usr/share/applications/canaima-bienvenido.desktop

clean:

distclean:

reinstall: uninstall install
