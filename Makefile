PKGNAME ?= grub-btrfs
PREFIX ?= /usr

SHARE_DIR = $(DESTDIR)$(PREFIX)/share
LIB_DIR = $(DESTDIR)$(PREFIX)/lib

.PHONY: install

install:
	@install -Dm755 -t "$(DESTDIR)/etc/grub.d/" 41_snapshots-btrfs
	@install -Dm644 -t "$(DESTDIR)/etc/default/grub-btrfs/" config
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" grub-btrfs.service
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" grub-btrfs.path
	@install -Dm644 -t "$(SHARE_DIR)/licenses/$(PKGNAME)/" LICENSE

uninstall:
	rm -f "$(DESTDIR)/etc/grub.d/41_snapshots-btrfs"
	rm -f "$(DESTDIR)/etc/default/grub-btrfs/config"
	rmdir --ignore-fail-on-non-empty "$(DESTDIR)/etc/default/grub-btrfs"
	rm -f "$(LIB_DIR)/systemd/system/grub-btrfs.service"
	rm -f "$(LIB_DIR)/systemd/system/grub-btrfs.path"
	rm -f "$(SHARE_DIR)/licenses/$(PKGNAME)/LICENSE"
	rm -f "$(DESTDIR)/boot/grub/grub-btrfs.cfg"
