[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs/releases)
![](https://img.shields.io/github/license/Antynea/grub-btrfs.svg)

## grub-btrfs

This is a version 4.xx of grub-btrfs
##### BTC donation address: `1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt`
##
### Description
Improves Grub by adding "btrfs snapshots" to the Grub menu.

You can start your system on a "snapshot" from the Grub menu.

Supports manual snapshots, snapper ...

##### Warning : it isn't recommended to start on read-only snapshot
##
### What does grub-btrfs v4.xx do :
* Automatically List snapshots existing on root partition (btrfs).
* Automatically Detect if "/boot" is in separate partition.
* Automatically Detect kernel, initramfs and intel microcode in "/boot" directory on snapshots.
* Automatically Create corresponding "menuentry" in `grub.cfg`
* Automatically detect snapper and use snapper's snapshot description if available.
* Automatically generate `grub.cfg` if you use the provided systemd service.
##
### Installation :
#### Arch Linux

```
pacman -S grub-btrfs
```

### Manual

* Run `make install` or look into Makefile for instructions on where to put each file.

NOTE: Generate your Grub menu after installation for the changes to take effect. (on Arch Linux use `grub-mkconfig -o /boot/grub/grub.cfg`)
##
### Customization:

You have the possibility to modify many parameters in `/etc/default/grub-btrfs/config`.

* GRUB_BTRFS_SUBMENUNAME="Arch Linux Snapshots"

	(Name appearing in the Grub menu.)

* GRUB_BTRFS_PREFIXENTRY="Snapshot:"

	(Add a name ahead your snapshots entries in the Grub menu.)
	
* GRUB_BTRFS_DISPLAY_PATH_SNAPSHOT="true"
	
	(Show full path snapshot or only name in the Grub menu, weird reaction with snapper)
	
* GRUB_BTRFS_TITLE_FORMAT="p/d/n"

 	(Custom title, shows/hides p"prefix" d"date" n"name" in the Grub menu, separator "/", custom order available)

* GRUB_BTRFS_LIMIT="50"

	(Limit the number of snapshots populated in the GRUB menu.)

* GRUB_BTRFS_SUBVOLUME_SORT="descending"

	(Sort the found subvolumes by newest first ("descending") or oldest first ("ascending"). 
	If "ascending" is chosen then the $GRUB_BTRFS_LIMIT oldest
	subvolumes will populate the menu.)

* GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND="true"
	
	(Show snapshots found during run "grub-mkconfig") 
	
* GRUB_BTRFS_SHOW_TOTAL_SNAPSHOTS_FOUND="true"
	
	(Show Total number of snapshots found during run "grub-mkconfig")

* GRUB_BTRFS_NKERNEL=("kernel-custom")

	(Use it only if you have a custom kernel name)

* GRUB_BTRFS_NINIT=("initramfs-custom.img" "initrd.img-custom")

	(Use it only if you have a custom initramfs name)

* GRUB_BTRFS_INTEL_UCODE=("intel-ucode.img")

	(Use it only if you have custom intel-ucode)

* GRUB_BTRFS_IGNORE_SPECIFIC_PATH=("var/lib/docker")

	(Ignore specific path during run "grub-mkconfig")

* GRUB_BTRFS_SNAPPER_CONFIG="root"													

	(Snapper's config name to use)

* GRUB_BTRFS_DISABLE="false"

	(Disable grub-btrfs)

* GRUB_BTRFS_DIRNAME="grub"

	(Name of the grub folder in `/boot/`, might be grub2 on some distributions )

* GRUB_BTRFS_OVERRIDE_BOOT_PARTITION_DETECTION="false"
	(Change to "true" if you have a boot partition in a different subvolume)

* GRUB_BTRFS_MKCONFIG=grub-mkconfig

    (Name or path of the 'grub-mkconfig' executable; might be 'grub2-mkconfig' on some distributions)
##
### Automatically update grub
If you would like Grub to automatically update when a snapshots is made or deleted:
* Mount your subvolume which contains snapshots to `/.snapshots`
* Use `systemctl start/enable grub-btrfs.path`
* `grub-btrfs.path` automatically (re)generate `grub.cfg` when a modification appear in `/.snapshots`
##
### Special thanks for assistance and contributions
* [maximbaz](https://github.com/maximbaz)
* [crossroads1112](https://github.com/crossroads1112)
* [penetal](https://github.com/penetal)
* [wesbarnett](https://github.com/wesbarnett)
* [Psykar](https://github.com/Psykar)
* [anyc](https://github.com/anyc)
* [daftaupe](https://github.com/daftaupe)
* [N-Parsons](https://github.com/N-Parsons)
##
