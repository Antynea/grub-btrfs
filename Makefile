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
