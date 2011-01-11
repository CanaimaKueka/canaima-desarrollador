# Makefile

SHELL := sh -e

SCRIPTS = "debian/preinst install" "debian/postinst configure" "debian/prerm remove" "debian/postrm remove"

all: test build

test:

	@echo -n "\n===== Comprobando posibles errores de sintaxis en los scripts de mantenedor =====\n\n"

	@for SCRIPT in $(SCRIPTS); \
	do \
		echo -n "$${SCRIPT}\n"; \
		bash -n $${SCRIPT}; \
	done

	@echo -n "\n=================================================================================\nHECHO!\n\n"

build:

	@echo "Nada para compilar!"

install:

	mkdir -p $(DESTDIR)/usr/bin/
	mkdir -p $(DESTDIR)/usr/share/canaima-bienvenido/
	mkdir -p $(DESTDIR)/etc/skel/Escritorio/
	mkdir -p $(DESTDIR)/etc/skel/.config/autostart/
	mkdir -p $(DESTDIR)/usr/share/applications/
	cp -r desktop/canaima-bienvenido.desktop $(DESTDIR)/usr/share/applications/
	cp -r desktop/canaima-bienvenido.desktop $(DESTDIR)/etc/skel/Escritorio/
	cp -r desktop/canaima-bienvenido-automatico.desktop $(DESTDIR)/etc/skel/.config/autostart/
	cp -r images/ $(DESTDIR)/usr/share/canaima-bienvenido/
	cp -r scripts/canaima-bienvenido.py $(DESTDIR)/usr/share/canaima-bienvenido/
	cp -r scripts/interfaz.glade $(DESTDIR)/usr/share/canaima-bienvenido/
	cp -r scripts/canaima-bienvenido.sh $(DESTDIR)/usr/bin/canaima-bienvenido
	cp -r scripts/canaima-bienvenido-automatico.sh $(DESTDIR)/usr/bin/canaima-bienvenido-automatico

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
