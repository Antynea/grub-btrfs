### grub-btrfs


This is a version 1.xx of grub-btrfs

#### Description

grub-btrfs, Include btrfs snapshots at boot options. (grub menu)

#### What does grub-btrfs v1.xx do :

Simple rollback using snapshots you made previously.

- Automatically List snapshots existing on root partition (btrfs).
- Automatically Detect kernel, initramfs and intel microcode in "/boot" directory on snapshots. (For custon name, see below.)
- Automatically Create corresponding menuentry in grub.cfg , which ensures a very easy rollback.


#### How to use it:

Add this lines to /etc/default/grub:

* GRUB_BTRFS_SUBMENUNAME="ArchLinux Snapshots" 					(Name menu appearing in grub.)
* GRUB_BTRFS_PREFIXENTRY="Snapshot:"        		   			(Add a name ahead your snapshots entries.)
* GRUB_BTRFS_NKERNEL=("vmlinuz-linux") 		 				(Use only if you have custom kernel name or auto-detect failed.)
* GRUB_BTRFS_NINIT=("initramfs-linux.img" "initramfs-linux-fallback.img")	(Use only if you have custom initramfs name or auto-detect failed.)
* GRUB_BTRFS_INTEL_UCODE=("intel-ucode.img") 					(Use only if you have custom intel-ucode or auto-detect failed.)

Generate grub.cfg (on Archlinux use grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

You will see it appear differents entries (e.g : Snapshot: my snapshot name overkill [2014-02-12 11:24:37])


#### TO DO

* verify compatibility with manjaro and snapper (but I don't use them, so it will take some time)
