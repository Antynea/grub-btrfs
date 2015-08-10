[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs)
  
### grub-btrfs


This is a version 0.xx of grub-btrfs

Version 1.xx release-candidate 
https://github.com/Antynea/grub-btrfs/tree/v1.xx?files=1

#### Description

grub-btrfs, add support for btrfs snapshots into grub menu

#### What does grub-btrfs v0.xx do :

Simple rollback using snapshots you made previous.

Makes a list of all snapshots, kernels, initramfs present on the filesystem and then creates a corresponding entered with name and date of snapshots in grub.cfg, which ensures a very easy rollback.

#### How to use it :

1. Add lines to /etc/default/grub as needed, defaults listed as examples:
2. 
	* submenuname = name menu appear in grub ( e.g: GRUB_BTRFS_SUBMENUNAME="ArchLinux Snapshots" )

	* prefixentry = add a name ahead your snapshots entries ( e.g: GRUB_BTRFS_PREFIXENTRY="Snapshot" )

	* nkernel= name kernel you use it ( e.g: GRUB_BTRFS_NKERNEL=("vmlinuz-linux") )

	* ninit= name initramfs (ramdisk) you use it ( e.g: GRUB_BTRFS_NINIT=("initramfs-linux.img" "initramfs-linux-fallback.img") )

	* intel_ucode= name intel microcode you use it ( e.g: GRUB_BTRFS_INTEL_UCODE=("intel-ucode.img") )

2. Generate grub.cfg (on Archlinux is grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

You will see it appear different entries, e.g : Prefixentry name of snapshot [2013-02-11 04:00:00]

#### Warning

Version 0.xx detect kernels,initramfs,intel microcode only in boot partition, not in snapshot.
If kernels,initramfs,intel microcode, are present in boot partition but not in snapshot, entry will be created but not fonctional, you don't boot it.

Version 1.xx will do it, release soon.
