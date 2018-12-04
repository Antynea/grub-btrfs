PKGNAME ?= grub-btrfs
PREFIX ?= /usr

SHARE_DIR = $(DESTDIR)$(PREFIX)/share
LIB_DIR = $(DESTDIR)$(PREFIX)/lib

.PHONY: install

install:
	@install -Dm755 -t "$(DESTDIR)/etc/grub.d" 41_snapshots-btrfs
	@install -Dm755 -t "$(DESTDIR)/etc/grub.d" 41_snapshots-btrfs_config
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/snapper-timeline.service.d" 10-update_grub.conf
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/snapper-cleanup.service.d" 10-update_grub.conf
	@install -Dm644 -t "$(SHARE_DIR)/licenses/$(PKGNAME)/" LICENSE
