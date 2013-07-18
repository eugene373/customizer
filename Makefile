VERSION = 4.0.0
DESTDIR = 

all: static

static: clean
	mkdir -p build
	cd build && python2 ../pyinstaller/pyinstaller.py --strip --onefile \
		--name=customizer --noconfirm ../src/main.py
	
install:
	install -vdm755 $(DESTDIR)/etc/ $(DESTDIR)/usr/sbin $(DESTDIR)/usr/share/customizer/ \
		$(DESTDIR)/usr/share/menu $(DESTDIR)/usr/share/applications
	install -vm755 build/dist/customizer $(DESTDIR)/usr/sbin/customizer
	install -vm644 data/customizer.conf $(DESTDIR)/etc/customizer.conf
	# install -vm644 data/customizer.desktop $(DESTDIR)/usr/share/applications/customizer.desktop
	# install -vm644 data/customizer.menu $(DESTDIR)/usr/share/menu/customizer

uninstall:
	$(RM) $(DESTDIR)/usr/sbin/customizer
	$(RM) $(DESTDIR)/etc/customizer.conf
	$(RM) $(DESTDIR)/usr/share/customizer/
	# $(RM) $(DESTDIR)/usr/share/applications/customizer.desktop
	# $(RM) $(DESTDIR)/usr/share/menu/customizer
	
bump:
	sed 's|^app_version.*|app_version = "$(VERSION)"|' -i src/lib/argparser.py
	git log > ChangeLog

dist: clean
	git archive HEAD --prefix=customizer-$(VERSION)/ | xz > customizer-$(VERSION).tar.xz

clean:
	$(RM) -r build $(shell find -name '*.pyc') *.tar.xz

.PHONY: all bump static install uninstall dist clean
