### grub-btrfs


This is a version 0.xx of grub-btrfs :

#### Desciption

grub-btrfs, add support for btrfs snapshots into grub menu

#### What does grub-btrfs v0.xx do :

Simple rollback using snapshots you made previous.

Makes a list of all snapshots, kernels, initramfs present on the filesystem and then creates a corresponding entered with name and date of snapshots in grub.cfg, which ensures a very easy rollback.

#### How to use it :

1. Edit 41_snapshots-btrfs file :

	* submenuname = name menu appear in grub ( e.g: submenuname="ArchLinux Snapshots" )

	* prefixentry = add a name ahead your snapshots entries ( e.g: prefixentry="Snapshot" )

	* nkernel= name kernel you use it ( e.g: nkernel=("vmlinuz-linux") )

	* ninit= name initramfs (ramdisk) you use it ( e.g: ninit=("initramfs-linux.img" "initramfs-linux-fallback.img") )

	* intel_ucode= name intel microcode you use it ( e.g: intel_ucode=("intel-ucode.img") )

2. Generate grub.cfg (on Archlinux is grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

you will see it appear different entries, e.g : Prefixentry name of snapshot [2013-02-11 04:00:00]
