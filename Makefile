PKGNAME ?= grub-btrfs
PREFIX ?= /usr

INITCPIO ?= false
SYSTEMD ?= true
OPENRC ?= false

BOOT_DIR_DEBIAN ?= /boot/grub
BOOT_DIR_FEDORA ?= /boot/grub2

GRUB_UPDATE_EXCLUDE ?= false
INSTALL_DOCS ?= true

SHARE_DIR = $(DESTDIR)$(PREFIX)/share
LIB_DIR = $(DESTDIR)$(PREFIX)/lib
BIN_DIR = $(DESTDIR)$(PREFIX)/bin
MAN_DIR = $(SHARE_DIR)/man

TEMP_DIR = ./temp


.PHONY: install uninstall clean help

install:
	@if test "$(shell id -u)" != 0; then \
		echo "You are not root, run this target as root please."; \
		exit 1; \
	fi
	@echo "					     	   Installing "
	@echo
	@echo "       ::::::::  :::::::::  :::    ::: :::::::::               ::::::::: ::::::::::: :::::::::  :::::::::: ::::::::      "
	@echo "      :+:    :+: :+:    :+: :+:    :+: :+:    :+:              :+:    :+:    :+:     :+:    :+: :+:       :+:    :+:     "
	@echo "     +:+        +:+    +:+ +:+    +:+ +:+    +:+              +:+    +:+    +:+     +:+    +:+ +:+       +:+             "
	@echo "    :#:        +#++:++#:  +#+    +:+ +#++:++#+ +#++:++#++:++ +#++:++#+     +#+     +#++:++#:  :#::+::#  +#++:++#++       "
	@echo "   +#+   +#+# +#+    +#+ +#+    +#+ +#+    +#+              +#+    +#+    +#+     +#+    +#+ +#+              +#+        "
	@echo "  #+#    #+# #+#    #+# #+#    #+# #+#    #+#              #+#    #+#    #+#     #+#    #+# #+#       #+#    #+#         "
	@echo "  ########  ###    ###  ########  #########               #########     ###     ###    ### ###        ########           "
	@echo
	@echo "  For further information visit https://github.com/Antynea/grub-btrfs or read the man page: 'man grub-btrfs'"
	@echo
	@rm -rf "${TEMP_DIR}"
	@mkdir "${TEMP_DIR}"
	@chmod 777 ${TEMP_DIR}
	@cp manpages/grub-btrfs.8.man ${TEMP_DIR}/grub-btrfs.8
	@if test "$(INSTALL_DOCS)" = true; then \
		echo "Installing manpages..."; \
		bzip2 ${TEMP_DIR}/grub-btrfs.8; \
		install -Dm644 -t "${MAN_DIR}/man8" "${TEMP_DIR}/grub-btrfs.8.bz2"; \
	fi
	@cp manpages/grub-btrfsd.8.man ${TEMP_DIR}/grub-btrfsd.8
	@if test "$(INSTALL_DOCS)" = true; then \
		bzip2 ${TEMP_DIR}/grub-btrfsd.8; \
		install -Dm644 -t "${MAN_DIR}/man8" "${TEMP_DIR}/grub-btrfsd.8.bz2"; \
	fi
	@install -Dm755 -t "$(DESTDIR)/etc/grub.d/" 41_snapshots-btrfs
	@install -Dm644 -t "$(DESTDIR)/etc/default/grub-btrfs/" config
	@install -Dm744 -t "$(BIN_DIR)/" grub-btrfsd;
	@# Systemd init system
	@if test "$(SYSTEMD)" = true; then \
		echo "Installing systemd .service file"; \
		install -Dm644 -t "$(LIB_DIR)/systemd/system/" grub-btrfsd.service; \
	 fi
	@# OpenRC init system
	@if test "$(OPENRC)" = true; then \
		echo "Installing openRC init.d & conf.d file"; \
		install -Dm744 grub-btrfsd.initd "$(DESTDIR)/etc/init.d/grub-btrfsd"; \
		install -Dm644 grub-btrfsd.confd "$(DESTDIR)/etc/conf.d/grub-btrfsd"; \
	 fi
	@# Arch Linux like distros only :
	@if test "$(INITCPIO)" = true; then \
		echo "Installing initcpio hook"; \
		install -Dm644 "initramfs/Arch Linux/overlay_snap_ro-install" "$(LIB_DIR)/initcpio/install/grub-btrfs-overlayfs"; \
		install -Dm644 "initramfs/Arch Linux/overlay_snap_ro-hook" "$(LIB_DIR)/initcpio/hooks/grub-btrfs-overlayfs"; \
	 fi
	@if test "$(INSTALL_DOCS)" = true; then \
		echo "Installing docs..."; \
		install -Dm644 -t "$(SHARE_DIR)/licenses/$(PKGNAME)/" LICENSE; \
		install -Dm644 -t "$(SHARE_DIR)/doc/$(PKGNAME)/" README.md; \
		install -Dm644 "initramfs/readme.md" "$(SHARE_DIR)/doc/$(PKGNAME)/initramfs-overlayfs.md"; \
	fi
	@if command -v grub-mkconfig > /dev/null && [ -e "$(BOOT_DIR_DEBIAN)/grub.cfg" ] && test "$(GRUB_UPDATE_EXCLUDE)" = false; then \
		echo "Updating the GRUB menu..."; \
		grub-mkconfig -o "$(BOOT_DIR_DEBIAN)/grub.cfg"; \
	 fi
	@if command -v grub2-mkconfig > /dev/null && [ -e "$(BOOT_DIR_FEDORA)/grub.cfg" ] && test "$(GRUB_UPDATE_EXCLUDE)" = false; then \
		echo "Updating the GRUB menu..."; \
		grub2-mkconfig -o "$(BOOT_DIR_FEDORA)/grub.cfg"; \
	fi

uninstall:
	@echo "Uninstalling grub-btrfs"
	@if test "$(shell id -u)" != 0; then \
		echo "You are not root, run this target as root please."; \
		exit 1; \
	fi
	@grub_dirname="$$(grep -oP '^[[:space:]]*GRUB_BTRFS_GRUB_DIRNAME=\K.*' "$(DESTDIR)/etc/default/grub-btrfs/config" | sed "s|\s*#.*||;s|(\s*\(.\+\)\s*)|\1|;s|['\"]||g")"; \
	 rm -f "$${grub_dirname:-/boot/grub}/grub-btrfs.cfg"
	@rm -f "$(DESTDIR)/etc/default/grub-btrfs/config"
	@rm -f "$(DESTDIR)/etc/grub.d/41_snapshots-btrfs"
	@rm -f "$(LIB_DIR)/systemd/system/grub-btrfsd.service"
	@rm -f "$(BIN_DIR)/grub-btrfsd;"
	@rm -f "$(DESTDIR)/etc/init.d/grub-btrfsd;"
	@rm -f "$(DESTDIR)/etc/conf.d/grub-btrfsd;"
	@rm -f "$(LIB_DIR)/initcpio/install/grub-btrfs-overlayfs"
	@rm -f "$(LIB_DIR)/initcpio/hooks/grub-btrfs-overlayfs"
	@rm -f "$(MAN_DIR)/man8/grub-btrfs.8.bz2"
	@rm -f "$(MAN_DIR)/man8/grub-btrfsd.8.bz2"
	@# Arch Linux UNlike distros only :
	@if test "$(INITCPIO)" != true && test -d "$(LIB_DIR)/initcpio"; then \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio/install" || :; \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio/hooks" || :; \
		rmdir --ignore-fail-on-non-empty "$(LIB_DIR)/initcpio" || :; \
	 fi
	@rm -f "$(SHARE_DIR)/doc/$(PKGNAME)/README.md"
	@rm -f "$(SHARE_DIR)/doc/$(PKGNAME)/initramfs-overlayfs.md"
	@rm -f "$(SHARE_DIR)/licenses/$(PKGNAME)/LICENSE"
	@rmdir --ignore-fail-on-non-empty "$(SHARE_DIR)/doc/$(PKGNAME)/" || :
	@rmdir --ignore-fail-on-non-empty "$(SHARE_DIR)/licenses/$(PKGNAME)/" || :
	@rmdir --ignore-fail-on-non-empty "$(DESTDIR)/etc/default/grub-btrfs" || :
	@if command -v grub-mkconfig > /dev/null && [ -e "$(BOOT_DIR_DEBIAN)/grub.cfg" ] && test "$(GRUB_UPDATE_EXCLUDE)" = false; then \
                echo "Updating the GRUB menu..."; \
                grub-mkconfig -o "$(BOOT_DIR_DEBIAN)/grub.cfg"; \
         fi
	@if command -v grub2-mkconfig > /dev/null && [ -e "$(BOOT_DIR_FEDORA)/grub.cfg" ] && test "$(GRUB_UPDATE_EXCLUDE)" = false; then \
		echo "Updating the GRUB menu..."; \
		grub2-mkconfig -o "$(BOOT_DIR_FEDORA)/grub.cfg"; \
	fi

clean:
	@echo "Deleting ./temp"
	@rm -rf "${TEMP_DIR}"

help:
	@echo
	@echo "Usage: $(MAKE) [ <parameter>=<value> ... ] [ <action> ]"
	@echo "Example: $(MAKE) OPENRC=true SYSTEMD=false install"
	@echo
	@echo "  actions: install"
	@echo "           uninstall"
	@echo "           help"
	@echo
	@echo "  parameter           | type | description                                           | defaults"
	@echo "  --------------------+------+-------------------------------------------------------+----------------------------"
	@echo "  DESTDIR             | path | install destination                                   | <unset>"
	@echo "  PREFIX              | path | system tree prefix                                    | '/usr'"
	@echo "  BOOT_DIR_DEBIAN     | path | boot data location (Debian, Ubuntu, Gentoo, Arch...)  | '/boot/grub'"
	@echo "  BOOT_DIR_FEDORA     | path | boot data location (Fedora, RHEL, CentOS, Rocky...)   | '/boot/grub2'"
	@echo "  SHARE_DIR           | path | shared data location                                  | '\$$(DESTDIR)\$$(PREFIX)/share'"
	@echo "  LIB_DIR             | path | system libraries location                             | '\$$(DESTDIR)\$$(PREFIX)/lib'"
	@echo "  PKGNAME             | name | name of the ditributed package                        | 'grub-btrfs'"
	@echo "  INITCPIO            | bool | include mkinitcpio hook                               | false"
	@echo "  SYSTEMD             | bool | include unit files                                    | true"
	@echo "  OPENRC              | bool | include OpenRc daemon                                 | false"
	@echo "  GRUB_UPDATE_EXCLUDE | bool | Do not update grub after installation                 | false"
	@echo
