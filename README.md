=encoding utf8

=head1 grub-btrfs

This is a version 0.xx of grub-btrfs :

=head1 Desciption

grub-btrfs, add support for btrfs snapshots into grub menu

=head1 What does grub-btrfs v0.xx do :

Simple rollback using snapshots you made previous.

Makes a list of all snapshots, kernels, initramfs present on the filesystem and then creates a corresponding entered with name and date of snapshots in grub.cfg, which ensures a very easy rollback.

=head1 How to use it :

Edit 41_snapshots-btrfs file :

submenuname = name menu appear in grub
prefixentry = add a name ahead your snapshots entries
nkernel= name kernel you use it
ninit= name initramfs (ramdisk) you use it
intel_ucode= name intel microcode you use it

Generate grub.cfg (on Archlinux is grub-mkconfig -o /boot/grub/grub.cfg )

grub-btrfs automatically generates snapshots entries.

you will see it appear different entries, e.g : Prefixentry name of snapshot [2013-02-11 04:00:00]
