PKGNAME ?= grub-btrfs
PREFIX ?= /usr

SHARE_DIR = $(DESTDIR)$(PREFIX)/share
LIB_DIR = $(DESTDIR)$(PREFIX)/lib

.PHONY: install uninstall

install:
	@install -Dm755 -t "$(DESTDIR)/etc/grub.d/" 41_snapshots-btrfs
	@install -Dm644 -t "$(DESTDIR)/etc/default/grub-btrfs/" config
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" grub-btrfs.service
	@install -Dm644 -t "$(LIB_DIR)/systemd/system/" grub-btrfs.path
	@install -Dm644 -t "$(SHARE_DIR)/licenses/$(PKGNAME)/" LICENSE
	@# Arch Linux like distros only :
	@if command -V mkinitcpio >/dev/null 2>&1; then \
		install -Dm644 "initramfs/Arch Linux/overlay_snap_ro-install" "$(LIB_DIR)/initcpio/install/grub-btrfs-overlayfs"; \
		install -Dm644 "initramfs/Arch Linux/overlay_snap_ro-hook" "$(LIB_DIR)/initcpio/hooks/grub-btrfs-overlayfs"; \
	 fi
	@install -Dm644 -t "$(SHARE_DIR)/doc/$(PKGNAME)/" README.md
	@install -Dm644 "initramfs/readme.md" "$(SHARE_DIR)/doc/$(PKGNAME)/initramfs-overlayfs.md"

uninstall:
	rm -f "$(DESTDIR)/etc/grub.d/41_snapshots-btrfs"
	rm -f "$(DESTDIR)/etc/default/grub-btrfs/config"
	rm -f "$(LIB_DIR)/systemd/system/grub-btrfs.service"
	rm -f "$(LIB_DIR)/systemd/system/grub-btrfs.path"
	rm -f "$(DESTDIR)/boot/grub/grub-btrfs.cfg"
	rm -f "$(LIB_DIR)/initcpio/install/grub-btrfs-overlayfs"
	rm -f "$(LIB_DIR)/initcpio/hooks/grub-btrfs-overlayfs"
	@# Arch Linux unlike distros only :
	if ! command -V mkinitcpio >/dev/null 2>&1; then \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio/install" || :; \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio/hooks" || :; \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio" || :; \
	fi
	rm -f "$(SHARE_DIR)/doc/$(PKGNAME)/README.md"
	rm -f "$(SHARE_DIR)/doc/$(PKGNAME)/initramfs-overlayfs.md"
	rm -f "$(SHARE_DIR)/licenses/$(PKGNAME)/LICENSE"
	rmdir --ignore-fail-on-non-empty "$(SHARE_DIR)/doc/$(PKGNAME)/" || :
	rmdir --ignore-fail-on-non-empty "$(SHARE_DIR)/licenses/$(PKGNAME)/" || :
	rmdir --ignore-fail-on-non-empty "$(DESTDIR)/etc/default/grub-btrfs" || :
