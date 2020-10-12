### Description :

Booting on a snapshot in read-only mode can be tricky.  
An elegant way is to boot this snapshot using overlayfs (included in the kernel).

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
copy the `overlay_snap_ro-install` file to `/etc/initcpio/install/overlaysnapro`  
copy the `overlay_snap_ro-hook` file to `/etc/initcpio/hooks/overlaysnapro`  
You must rename the files. (I did it above)

For example :  
overlay_snap_ro-install to overlaysnapro  
overlay_snap_ro-hook to overlaysnapro  
Keep in mind that the files must have exactly the same name to ensure a match.

Edit the file `/etc/mkinitcpio.conf`  
Added hook `overlaysnapro` at the end of the line `HOOKS`.

For example :  
`HOOKS=(base udev autodetect modconf block filesystems keyboard fsck overlaysnapro)`  
You notice that the name of the `hook' must match the name of the 2 installed files. (don't forget it)

Re-generate your initramfs  
`mkinitcpio -P` (option -p means, all preset present in `/etc/mkinitcpio.d`

#### Other distribution
Refer to your distribution's documentation  
or contribute to this project to add a paragraph.
