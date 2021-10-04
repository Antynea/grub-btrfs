[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs/releases)
![](https://img.shields.io/github/license/Antynea/grub-btrfs.svg)

## grub-btrfs

This is a version 4.xx of grub-btrfs
##### BTC donation address: `1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt`
##
### Description :
Improves Grub by adding "btrfs snapshots" to the Grub menu.

You can boot your system on a "snapshot" from the Grub menu.  
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
* Automatically detect the type/tags and descriptions/comments of snapper/timeshift snapshots.
* Automatically generate `grub.cfg` if you use the provided systemd service.

##
### Installation :
#### Arch Linux
The package is available in the community repository [grub-btrfs](https://archlinux.org/packages/community/any/grub-btrfs/)
```
pacman -S grub-btrfs
```

#### Manual

* Run `make install` or look into Makefile for instructions on where to put each file.
* Dependencies:
  * [btrfs-progs](https://archlinux.org/packages/core/x86_64/btrfs-progs/)
  * [grub](https://archlinux.org/packages/core/x86_64/grub/)

NOTE: Generate your Grub menu after installation for the changes to take effect.  
On Arch Linux use `grub-mkconfig -o /boot/grub/grub.cfg`.  
On Debian-like distribution `update-grub` is an alias to `grub-mkconfig ...`
##
### Customization :

You have the possibility to modify many parameters in `/etc/default/grub-btrfs/config`.  
See [config file](https://github.com/Antynea/grub-btrfs/blob/master/config) for more information.

##
### Automatically update grub
1- If you would like grub-btrfs menu to automatically update when a snapshot is created or deleted:
* Use `systemctl enable grub-btrfs.path`.
  * `grub-btrfs.path` automatically (re)generates `grub-btrfs.cfg` when a modification appears in `/.snapshots` mount point (by default).
  * If the `/.snapshots` mount point is already mounted, then use `systemctl start grub-btrfs.path` to start monitoring.  
    Otherwise, the unit will automatically start monitoring when the mount point will be available.
* If your snapshots location aren't mounted in `/.snapshots`, you must modify `grub-btrfs.path` unit using  
`systemctl edit --full grub-btrfs.path` and run `systemctl reenable grub-btrfs.path` for changes take effect.  
To find out the name of the `.mount` unit  
use `systemctl list-units -t mount`.  
	* For example: Timeshift mounts its snapshot folder in `/run/timeshift/backup/timeshift-btrfs/snapshots`.

		Use `systemctl edit --full grub-btrfs.path`.
		Then replace the whole block by:
		```
		[Unit]
		Description=Monitors for new snapshots
		DefaultDependencies=no
		Requires=run-timeshift-backup.mount
		After=run-timeshift-backup.mount
		BindsTo=run-timeshift-backup.mount

		[Path]
		PathModified=/run/timeshift/backup/timeshift-btrfs/snapshots

		[Install]
		WantedBy=run-timeshift-backup.mount
		```
		Then save and finally run `systemctl reenable grub-btrfs.path` for changes take effect.  
		Optional:  
		If the `/run/timeshift/backup/timeshift-btrfs/snapshots` mount point is already mounted,  
		then use `systemctl start grub-btrfs.path` to start monitoring.  
		Otherwise, the unit will automatically start monitoring when the mount point will be available.  
	* You can view your change to `systemctl cat grub-btrfs.path`.
	* To revert change use `systemctl revert grub-btrfs.path`.

2- If you would like grub-btrfs menu to automatically update on system restart/shutdown:  
[Look at this comment](https://github.com/Antynea/grub-btrfs/issues/138#issuecomment-766918328)  
Currently not implemented  
##### Warning :
by default, `grub-mkconfig` command is used.  
Might be `grub2-mkconfig` on some systems (Fedora ...).   
Edit `GRUB_BTRFS_MKCONFIG` variable in `/etc/default/grub-btrfs/config` file to reflect this.
##
### Special thanks for assistance and contributions
* [maximbaz](https://github.com/maximbaz)
* [All contributors](https://github.com/Antynea/grub-btrfs/graphs/contributors)
##
