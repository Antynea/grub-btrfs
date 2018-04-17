[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs)
  
## grub-btrfs

This is a version 3.xx of grub-btrfs
##### BTC donation address: 1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt
##
### Description

grub-btrfs, Include btrfs snapshots at boot options. (grub menu)
##
### What does grub-btrfs v3.xx do :

Simple rollback using snapshots you made previously.

* Automatically List snapshots existing on root partition (btrfs).

* Automatically Detect if "/boot" is in separate partition.

* Automatically Detect kernel, initramfs and intel microcode in "/boot" directory on snapshots.

* Automatically Create corresponding "menuentry" in grub.cfg , which ensures a very easy rollback.

* Automatically detect snapper and use snapper's snapshot description if available.
##
### How to customize it:

You have the possibility to modify many parameters.
Add this lines to /etc/default/grub:

* GRUB_BTRFS_SUBMENUNAME="Arch Linux Snapshots"

	(Name menu appearing in grub.)

* GRUB_BTRFS_PREFIXENTRY="Snapshot:"

	(Add a name ahead your snapshots entries.)
	
* GRUB_BTRFS_DISPLAY_PATH_SNAPSHOT="true"
	
	(Show full path snapshot or only name, weird reaction with snapper)
	
* GRUB_BTRFS_TITLE_FORMAT="p/d/n"

 	(Custom title, shows/hides p"prefix" d"date" n"name" in grub-menu, separator "/", custom order available)

* GRUB_BTRFS_NKERNEL=("kernel-custom")

	(Use it only if you have a custom kernel name)

* GRUB_BTRFS_NINIT=("initramfs-custom.img" "initrd.img-custom")

	(Use it only if you have a custom initramfs name)

* GRUB_BTRFS_INTEL_UCODE=("intel-ucode.img")

	(Use it only if you have custom intel-ucode)

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

* GRUB_BTRFS_IGNORE_SPECIFIC_PATH=("var/lib/docker")

	(Ignore specific path during run "grub-mkconfig")

* GRUB_BTRFS_SNAPPER_CONFIG="root"													

	(Snapper's config name to use)

* GRUB_BTRFS_DISABLE="true"

	(Disable grub-btrfs)


Generate grub.cfg (on Arch linux use grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

You will see it appear differents entries (e.g : Snapshot: 2018-01-03 15:08:41  @test1 )
##
### Automatically update grub

If you would like grub to automatically update when Snapper timeline snapshots and cleanups occur, simply install `10-update_grub.conf` in the following locations:

- `/etc/systemd/system/snapper-timeline.service.d/`
- `/etc/systemd/system/snapper-cleanup.service.d/`

Once the configuration files are in place, `systemctl daemon-reload` should be run to reload the units and make the changes active.

##
### Discussion
Pour les francophones : https://forums.archlinux.fr/viewtopic.php?f=18&t=17177
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
