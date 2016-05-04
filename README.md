[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs)
  
### grub-btrfs

This is a version 1.xx of grub-btrfs

#### Description

grub-btrfs, Include btrfs snapshots at boot options. (grub menu)

#### What does grub-btrfs v1.xx do :

Simple rollback using snapshots you made previously.

* Automatically List snapshots existing on root partition (btrfs).

* Automatically Detect if "/boot" is in separate partition.

* Automatically Detect kernel, initramfs and intel microcode in "/boot" directory on snapshots. (For custom name, see below.)

* Automatically Create corresponding "menuentry" in grub.cfg , which ensures a very easy rollback.


#### How to use it:

Add this lines to /etc/default/grub:

* GRUB_BTRFS_SUBMENUNAME="ArchLinux Snapshots"

	(Name menu appearing in grub.)

* GRUB_BTRFS_PREFIXENTRY="Snapshot:"

	(Add a name ahead your snapshots entries.)
	
* GRUB_BTRFS_DISPLAY_PATH_SNAPSHOT="true"
	
	(Show full path snapshot or only name)
	
* GRUB_BTRFS_TITLE_FORMAT="p/d/n"

 	(Custom title, shows/hides p"prefix" d"date" n"name" in grub-menu, separator "/", custom order available)

* GRUB_BTRFS_NKERNEL=("vmlinuz-linux")

	(Use only if you have a custom kernel name or auto-detect failed.)

* GRUB_BTRFS_NINIT=("initramfs-linux.img" "initramfs-linux-fallback.img")

	(Use only if you have a custom initramfs name or auto-detect failed.)

* GRUB_BTRFS_INTEL_UCODE=("intel-ucode.img")

	(Use only if you have custom intel-ucode or auto-detect failed.)

* GRUB_BTRFS_LIMIT="100"

	(Limit the number of snapshots populated in the GRUB menu.)

* GRUB_BTRFS_SUBVOLUME_SORT="descending"

	(Sort the found subvolumes by newest first ("descending") or oldest first ("ascending"). 
	If "ascending" is chosen then the $GRUB_BTRFS_LIMIT oldest
	subvolumes will populate the menu.)

* GRUB_BTRFS_SHOW_SNAPSHOTS_FOUND="true"
	
	(Show snapshots found during run "grub-mkconfig") 
	
* GRUB_BTRFS_SHOW_TOTAL_SNAPSHOTS_FOUND="true"
	
	(Show Total number of snapshots found during run "grub-mkconfig")

* GRUB_BTRFS_IGNORE_SPECIFIC_PATH=("var/lib/docker" "nosnapshot")

	(Ignore specific path during run "grub-mkconfig")

* GRUB_BTRFS_CREATE_ONLY_HARMONIZED_ENTRIES="false"

	(Create entries with matching version number instead of all possible combinations of kernel and initramfs)



Generate grub.cfg (on Archlinux use grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

You will see it appear differents entries (e.g : Snapshot: [2014-02-12 11:24:37] my snapshot name overkill )


#### TO DO

* Display name of microcode in menuentry when available


## discussion
Pour les francophones : https://forums.archlinux.fr/viewtopic.php?f=18&t=17177
