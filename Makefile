PREFIX=/usr

self=lvmsnapshot
version=0.3
manpages=$(self).1
all=manpages

all: $(all)

install: all
		install -d $(DESTDIR)$(PREFIX)/bin
		install -m 0755 $(self).sh $(DESTDIR)$(PREFIX)/bin/$(self)
		install -d $(DESTDIR)$(PREFIX)/share/man/man1
		install -m 0644 $(manpages) $(DESTDIR)$(PREFIX)/share/man/man1
		install -d $(DESTDIR)$(PREFIX)/share/doc/$(self)
		install -d $(DESTDIR)$(PREFIX)/share/doc/$(self)/examples
		install -m 0644 README.markdown $(DESTDIR)$(PREFIX)/share/doc/$(self)
		install -m 0644 lvmsnapshot.kvm.example.conf $(DESTDIR)$(PREFIX)/share/doc/$(self)/examples
		install -m 0644 lvmsnapshot.xen.example.conf $(DESTDIR)$(PREFIX)/share/doc/$(self)/examples

manpages: $(manpages)

$(self).1: README.markdown
		ronn < README.markdown > $(self).1

clean:
		rm -rf $(self).1

uninstall:
		rm -rf $(DESTDIR)$(PREFIX)/bin/$(self)
		rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/$(self).1
		rm -rf $(DESTDIR)$(PREFIX)/share/doc/$(self)

deb:
	make install DESTDIR=/tmp/lvmsnapshot
	fpm -s dir -t deb -n $(self) -a all -v $(version) -C /tmp/lvmsnapshot .

# Potentially harmful, used a non-standard option on purpose.
# If PREFIX=/usr/local and that's empty...
purge: uninstall
		rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/bin/
		rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/man/man1/
		rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/doc/
		rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(PREFIX)/share/zsh/vendor-completions/
