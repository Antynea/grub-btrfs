[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs/releases)
![](https://img.shields.io/github/license/Antynea/grub-btrfs.svg)

## grub-btrfs

This is a version 4.xx of grub-btrfs
##### BTC donation address: `1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt`
##
### Description
Improves Grub by adding "btrfs snapshots" to the Grub menu.

You can start your system on a "snapshot" from the Grub menu.  
Supports manual snapshots, snapper, timeshift ...

##### Warning: booting on read-only snapshots can be tricky

If you choose to do it, `/var/log` or even `/var` must be on a separate subvolume.  
Otherwise, make sure your snapshots are writeable.  
See [this ticket](https://github.com/Antynea/grub-btrfs/issues/92) for more info.

This project includes its own solution.  
Refer to the [documentation](https://github.com/Antynea/grub-btrfs/blob/master/initramfs/readme.md).

##
### What does grub-btrfs v4.xx do :
* Automatically List snapshots existing on root partition (btrfs).
* Automatically Detect if "/boot" is in separate partition.
* Automatically Detect kernel, initramfs and intel/amd microcode in "/boot" directory on snapshots.
* Automatically Create corresponding "menuentry" in `grub.cfg`
* Automatically detect snapper and use snapper's snapshot description if available.
* Automatically generate `grub.cfg` if you use the provided systemd service.

##
### Installation :
#### Arch Linux

```
pacman -S grub-btrfs
```

#### Manual

* Run `make install` or look into Makefile for instructions on where to put each file.

NOTE: Generate your Grub menu after installation for the changes to take effect.  
On Arch Linux use `grub-mkconfig -o /boot/grub/grub.cfg`.

##
### Customization:

You have the possibility to modify many parameters in `/etc/default/grub-btrfs/config`.  
See [config file](https://github.com/Antynea/grub-btrfs/blob/master/config) for more information.

##
### Automatically update grub
If you would like Grub to automatically update when a snapshot is made or deleted:
* Use `systemctl start/enable grub-btrfs.path`.
* `grub-btrfs.path` automatically (re)generates `grub.cfg` when a modification appears in `/.snapshots` folder (by default).
* If your snapshots aren't mounted in `/.snapshots`, you must modify the watch folder using `systemctl edit grub-btrfs.path`.  
	* For example: Timeshift mount its snapshots in `/run/timeshift/backup/timeshift-btrfs/snapshots` folder.

		Use `systemctl edit grub-btrfs.path`.
		Then wrote:
		```
		[Path]
		PathModified=/run/timeshift/backup/timeshift-btrfs/snapshots
		```
		and finally save.
	* You can view your change to `systemctl cat grub-btrfs.path`.
	* To revert change use `systemctl revert grub-btrfs.path`.
##### Warning:
by default, `grub-mkconfig` command is used.  
Might be `grub2-mkconfig` on some systems (Fedora ...).   
Edit `GRUB_BTRFS_MKCONFIG` variable in `/etc/default/grub-btrfs/config` file to reflect this.
##
### Special thanks for assistance and contributions
* [maximbaz](https://github.com/maximbaz)
* [All contributors](https://github.com/Antynea/grub-btrfs/graphs/contributors)
##
