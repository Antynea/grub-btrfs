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
Distributions that use Dracut to make their initramfs (many of the Fedora based Distros) have to include the `overlayfs` module into the initramfs and pass either `rd.live.overlay.readonly=1` (to boot into the snapshot read only) or `rd.live.overlay.overlayfs=1` (to act like a livedisk, that is files can be changed but changes will be lost on the next boot) to their kernel command line in grub.

1. Include `overlayfs` module into dracut

```bash
echo 'add_dracutmodules+=" overlayfs "' | sudo tee /etc/dracut.conf.d/overlayfs.conf
```

2. Fix for dracut <109

Unfortunately, dracut version <109 has a bug that prevents overlayfs mount from properly working. [A fix has been committed into dracut version 109](https://github.com/dracut-ng/dracut-ng/commit/deeb670c28d12a478bbea95e29677e436d1912fb). If you are still on version < 109, instead of editing `/usr/lib/dracut/modules.d/70overlayfs/mount-overlayfs.sh` directly on your system, which will get overwritten on updates to the dracut package, we can duplicate the whole module with a lower priority number and carry out the patch there. As explained in this [very old notes about dracut](https://wwoods.fedorapeople.org/doc/dracut-notes.html):

> dracut refuses to overwrite files when installing things into the initramfs, so things installed by the the lower numbered modules have priority over the higher ones.

```bash
sudo cp -r /usr/lib/dracut/modules.d/70overlayfs /usr/lib/dracut/modules.d/69overlayfs
sudoedit /usr/lib/dracut/modules.d/69overlayfs/mount-overlayfs.sh
```

Edit the file as per [the commit](https://github.com/dracut-ng/dracut/commit/deeb670c28d12a478bbea95e29677e436d1912fb)

3. Regenerate the initramfs

```
# for current kernel's initramfs
sudo dracut -f
# for all kernels
sudo dracut -f --regenerate-all
```

4. Add kernel parameter and regenerate grub snapshot-submenu

Grub-btrfs provides the variable `GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS` in `/etc/default/grub-btrfs/config` to add any command to the kernel command line. Set it to `GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="rd.live.overlay.overlayfs=1"` to make snapshots immutable when booted into. 
After changing this run `sudo /etc/grub.d/41_snapshots-btrfs` to generate a new snapshot-submenu with the parameter added. 

#### Debian based distros

1. Copy [grub-btrfs-overlayfs-hook](Debian/grub-btrfs-overlayfs-hook) script to initramfs-tools hooks directory:
`sudo cp grub-btrfs-overlayfs-hook /etc/initramfs-tools/hooks/`

2. Copy [grub-btrfs-overlayfs-boot](Debian/grub-btrfs-overlayfs-boot) script to initramfs-tools local-bottom scripts directory:
`sudo cp grub-btrfs-overlayfs-boot /etc/initramfs-tools/scripts/local-bottom/`

3. Update your initramfs
`sudo update-initramfs -u`


#### Other distribution
Refer to your distribution's documentation or contribute to this project to add a paragraph.
#
