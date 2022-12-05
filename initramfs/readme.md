### Description :

Booting on a snapshot in read-only mode can be tricky.  
An elegant way is to boot this snapshot using overlayfs (included in the kernel ≥ 3.18).

Using overlayfs, the booted snapshot will behave like a live-cd in non-persistent mode.  
The snapshot will not be modified, the system will be able to boot correctly, because a writeable folder will be included in the ram.  
(no more problems due to `/var` not open for writing)

Any changes in this system thus started will be lost when the system is rebooted/shutdown.

To do this, it is necessary to modify the initramfs.  
This means that any snapshot that does not include this modified initramfs will not be able to benefit from it.  
(except for separate boot partitions)
#
### Installation :
#### Arch Linux
1.
`Pacman -S grub-btrfs`  
Or if you use git  
copy the `overlay_snap_ro-install` file to `/etc/initcpio/install/grub-btrfs-overlayfs`  
copy the `overlay_snap_ro-hook` file to `/etc/initcpio/hooks/grub-btrfs-overlayfs`  
You must rename the files. (I did it above)

For example :  
`overlay_snap_ro-install` to `grub-btrfs-overlayfs`  
`overlay_snap_ro-hook` to `grub-btrfs-overlayfs`  
Keep in mind that the files must have exactly the same name to ensure a match.

2.
Edit the file `/etc/mkinitcpio.conf`  
Added hook `grub-btrfs-overlayfs` at the end of the line `HOOKS`.

For example :  
`HOOKS=(base udev autodetect modconf block filesystems keyboard fsck grub-btrfs-overlayfs)`  
You notice that the name of the `hook` must match the name of the 2 installed files. (don't forget it)

3.
Re-generate your initramfs  
`mkinitcpio -P` (option -P means, all preset present in `/etc/mkinitcpio.d`)

#### Dracut based distros
Distributions that use Dracut to make their initramfs (many of the Fedora based Distros) simply have to pass either `rd.live.overlay.readonly=1` (to boot into the snapshot read only) or `rd.live.overlay.overlayfs=1` (to act like a livedisk, that is files can be changed but changes will be lost on the next boot) to their kernel command line in grub. 
Grub-btrfs provides the variable `GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS` to add any command to the kernel command line. Set it to `GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"` to make snapshots immutable when booted into. 
After changing this run `sudo /etc/grub.d/41_snapshots-btrfs` to generate a new snapshot-submenu with the parameter added. 

#### Other distribution
Refer to your distribution's documentation or contribute to this project to add a paragraph.
#
