### grub-btrfs


This is a version 1.xx of grub-btrfs

#### Description

grub-btrfs, add support for btrfs snapshots into grub menu

#### What does grub-btrfs v1.xx do :

Simple rollback using snapshots you made previous.

Makes a list of all snapshots, kernels, initramfs present on the filesystem and then creates a corresponding input with name and date of snapshots in grub.cfg, which ensures a very easy rollback.

#### TO DO

* in progress ...
* verify compatibility with manjaro and snapper (but I don't use them, so it will take some time)


