[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs/releases)
![](https://img.shields.io/github/license/Antynea/grub-btrfs.svg)

## 💻 grub-btrfs 

##### BTC donation address: `1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt`
- - -
### 🔎 Description:
Improves grub by adding "btrfs snapshots" to the grub menu.

You can boot your system on a "snapshot" from the grub menu.  
Supports manual snapshots, snapper, timeshift ...

##### Warning: booting on read-only snapshots can be tricky

If you choose to do it, `/var/log` or even `/var` must be on a separate subvolume.  
Otherwise, make sure your snapshots are writeable.  
See [this ticket](https://github.com/Antynea/grub-btrfs/issues/92) for more info.

This project includes its own solution.  
Refer to the [documentation](https://github.com/Antynea/grub-btrfs/blob/master/initramfs/readme.md).

- - -
### ✨ What features does grub-btrfs have?
* Automatically list snapshots existing on root partition (btrfs).
* Automatically detect if `/boot` is in separate partition.
* Automatically detect kernel, initramfs and intel/amd microcode in `/boot` directory on snapshots.
* Automatically create corresponding "menuentry" in `grub.cfg`
* Automatically detect the type/tags and descriptions/comments of snapper/timeshift snapshots.
* Automatically generate `grub.cfg` if you use the provided systemd/ openRC service.

- - -
### 🛠️ Installation:
#### Arch Linux
The package is available in the community repository [grub-btrfs](https://archlinux.org/packages/community/any/grub-btrfs/)
```
pacman -S grub-btrfs
```

#### Gentoo
grub-btrfs is only available in the Gentoo User Repository (GURU) and not in the official Gentoo repository.  
If you have not activated the GURU yet, do so by running:
```
emerge -av app-eselect/eselect-repository 
eselect repository enable guru 
emaint sync -r guru 
```
If you are using Systemd on Gentoo, make sure the USE-Flag `systemd` is set. (Either globally in make.conf or in package.use for the package app-backup/grub-btrfs)
Without systemd USE-Flag the OpenRC-daemon of grub-btrfs will be installed.

Emerge grub-btrfs via 
`emerge app-backup/grub-btrfs`

#### Kali Linux
[grub-btrfs](http://pkg.kali.org/pkg/grub-btrfs) is available in the Kali Linux repository and can be installed with:  
```
apt install grub-btrfs
```
Booting into read-only snapshots is fully supported when choosing "btrfs" as file system during a standard Kali Linux installation following [this walk-through](https://www.kali.org/docs/installation/btrfs/).  

#### Manual
* Run `make install` or look into Makefile for instructions on where to put each file.
* Run `make help` to check what options are available. 
* Dependencies:
  * [btrfs-progs](https://archlinux.org/packages/core/x86_64/btrfs-progs/)
  * [grub](https://archlinux.org/packages/core/x86_64/grub/)
  * [bash >4](https://archlinux.org/packages/core/x86_64/bash/)
  * [gawk](https://archlinux.org/packages/core/x86_64/gawk/)
  * (optional for the daemon)[inotify-tools](https://archlinux.org/packages/community/x86_64/inotify-tools/)

- - -
### Usage
After installation the grub main menu needs to be generated to make a menuentry for the snapshots sub menu. Depending on the Linux distribution the commands for that are different:
* On **Arch Linux** or **Gentoo** use `grub-mkconfig -o /boot/grub/grub.cfg`.  
* On **Fedora** use `grub2-mkconfig -o /boot/grub2/grub.cfg`  
* On **Debian-like** distribution `update-grub` is an alias to `grub-mkconfig ...`

Once the entry for the sub menu was generated grub-btrfs puts the actual sub menu into the file grub-btrfs.cfg. So to generate snapshot entries in the sub menu it is usually enough to run only the script with `sudo /etc/grub.d/41_snapshots-btrfs`.
Read further below on how to automate this process. 

### ⚙️ Customization:

You have the possibility to modify many parameters in `/etc/default/grub-btrfs/config`.  
For further information see [config file](https://github.com/Antynea/grub-btrfs/blob/master/config) or `man grub-btrfs`

#### Warning:
Some file locations and command names differ from distribution to distribution. Initially the configuration is set up to work with Arch and Gentoo (and many other distributions) out of the box, which are using the `grub-mkconfig` command. 
However, Fedora for example uses a different command, `grub2-mkconfig`.
Edit `GRUB_BTRFS_MKCONFIG` variable in `/etc/default/grub-btrfs/config` file to reflect this. (e.g. `GRUB_BTRFS_MKCONFIG=/sbin/grub2-mkconfig` for Fedora)

On most distributions and installs, the grub installation resides in `/boot/grub`. If grub is installed in a different place, change the variable `GRUB_BTRFS_MKCONFIG` in the config file accordingly. For Fedora this is `GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"`. Also the command to check the grub scripts is different on some system, for Fedora it is `GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check`

#### grub-btrfsd daemon

Grub-btrfs comes with a daemon script that automatically updates the grub menu when it sees a snapshot being created or deleted in a directory it is given via command line.

The daemon can be configured by passing different command line arguments to it. This can be change by either running  
```bash
sudo systemctl edit --full grub-btrfsd
```
(when using systemd) or by editing `/etc/conf.d/grub-btrfsd` (when using openRC). In either case the daemon must be restarted for the changes to take effect with
```bash
sudo systemctl restart grub-btrfsd # for systemd
```
or
```
sudo rc-service grub-btrfsd restart # for openRC
```

It is also possible to start the daemon without systemd or openRC. If you want to do this, the daemon should be stopped with
```bash
sudo systemctl stop grub-btrfsd # for systemd
```
or
```bash
sudo rc-service grub-btrfsd stop # for openRC
```
Then the daemon can be manually run and played around with with the command `grub-btrfsd`. 
For additional information on daemon script and its arguments, run `grub-btrfsd -h` and see `man grub-btrfsd`

- - -
### 🪀 Automatically update grub upon snapshot
Grub-btrfs comes with its own daemon, that watches the snapshot directory for you and updates the grub menu automatically every time a snapshot is created or deleted. 
By default this daemon watches the directory `/.snapshots` for changes (new snapshots or deletion of snapshots) and triggers the grub menu creation if a snapshot is found. 
Therefore, if Snapper is used with its default directory, the daemon can just be started and nothing needs to be configured. For configuration like Timeshift, or Snapper with a different directory, see further below. 

To start it now, run 
```bash
sudo systemctl start grub-btrfsd # for systemd
```
or
```bash
sudo rc-service grub-btrfsd start # for openRC
```

To activate it during system startup, run 
```bash
sudo systemctl enable grub-btrfsd # for systemd
```
or
```bash
sudo rc-config add grub-btrfsd default # for openRC
```

#### 💼 Snapshots not in `/.snapshots`
NOTE: This works also for Timeshift versions < 22.06, the path to watch would be `/run/timeshift/backup/timeshift-btrfs/snapshots`.

##### Systemd
By default the daemon is watching the directory `/.snapshots`. If the daemon should watch a different directory, it can be edited with
```bash
sudo systemctl edit --full grub-btrfsd # for systemd
```
What should be edited is the `/.snapshots`-part in the line that says `ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots`. 
So this is what the file should look afterwards:
``` bash
[Unit]
Description=Regenerate grub-btrfs.cfg

[Service]
Type=simple
LogLevelMax=notice
# Set the possible paths for `grub-mkconfig`
Environment="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
# Load environment variables from the configuration
EnvironmentFile=/etc/default/grub-btrfs/config
# Start the daemon, usage of it is:
# grub-btrfsd [-h, --help] [-t, --timeshift-auto] [-l, --log-file LOG_FILE] SNAPSHOTS_DIR
# SNAPSHOTS_DIR         Snapshot directory to watch, without effect when --timeshift-auto
# Optional arguments:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
ExecStart=/usr/bin/grub-btrfsd --syslog /path/to/your/snapshot/directory

[Install]
WantedBy=multi-user.target
```

When done, the service should be restarted with
``` bash
sudo systemctl restart grub-btrfsd # for systemd
```

##### OpenRC
Arguments are passed to grub-btrfsd via the file `/etc/conf.d/grub-btrfsd`. 
The variable `snapshots` defines, where the daemon will watch for snapshots. 

After editing, the file should looks like this:
``` bash
# Copyright 2022 Pascal Jaeger
# Distributed under the terms of the GNU General Public License v3

## Where to locate the root snapshots
#snapshots="/.snapshots" # Snapper in the root directory
#snapshots="/run/timeshift/backup/timeshift-btrfs/snapshots" # Timeshift < v22.06
snapshots="/path/to/your/snapshot/directory"

## Optional arguments to run with the daemon
# Possible options are:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory for timeshift >= 22.06
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
# Uncomment the line to activate the option
optional_args+="--syslog " # write to syslog by default
#optional_args+="--timeshift-auto "
#optional_args+="--log-file /var/log/grub-btrfsd.log "
#optional_args+="--verbose "
```

After that, the daemon should be restarted with
``` bash
sudo rc-service grub-btrfsd restart # for openRC
```

#### 🌟 Timeshift >= version 22.06
Newer Timeshift versions create a new directory named after their process ID in `/run/timeshift` every time they are started. The PID is going to be different every time. 
Therefore the daemon can not simply watch a directory, it watches `/run/timeshift` first, if a directory is created it gets Timeshifts current PID, then watches a directory in that newly created directory from Timeshift. 
Anyhow, to activate this mode of the daemon, `--timeshift-auto` must be passed to the daemon as a command line argument. 

##### Systemd
To pass `--timeshift-auto` to grub-btrfsd, the servicefile of grub-btrfsd can be edited with
```bash
sudo systemctl edit --full grub-btrfsd # for systemd
```

The line that says 
```bash 
ExecStart=/usr/bin/grub-btrfsd /.snapshots --syslog

```

should be edited into 
``` bash
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto
```

So the file looks like this, afterwards:
``` bash
[Unit]
Description=Regenerate grub-btrfs.cfg

[Service]
Type=simple
LogLevelMax=notice
# Set the possible paths for `grub-mkconfig`
Environment="PATH=/sbin:/bin:/usr/sbin:/usr/bin"
# Load environment variables from the configuration
EnvironmentFile=/etc/default/grub-btrfs/config
# Start the daemon, usage of it is:
# grub-btrfsd [-h, --help] [-t, --timeshift-auto] [-l, --log-file LOG_FILE] SNAPSHOTS_DIR
# SNAPSHOTS_DIR         Snapshot directory to watch, without effect when --timeshift-auto
# Optional arguments:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto

[Install]
WantedBy=multi-user.target
```

When done, the service must be restarted with
``` bash
sudo systemctl restart grub-btrfsd # for systemd
```

Note:
You can view your change with `systemctl cat grub-btrfsd`.
To revert change use `systemctl revert grub-btrfsd`.

##### OpenRC 
Arguments are passed to grub-btrfsd via the file `/etc/conf.d/grub-btrfsd`. 
The variable `optional_args` defines, which optional arguments get passed to the daemon. 
Uncomment `#optional_args+="--timeshift-auto "` to pass the command line option `--timeshift-auto` to it. 

After the change, the file should look like this:
(Note that there is no need to comment out the `snapshots` variable. It is ignored when `--timeshift-auto` is active.)
``` bash
# Copyright 2022 Pascal Jaeger
# Distributed under the terms of the GNU General Public License v3

## Where to locate the root snapshots
snapshots="/.snapshots" # Snapper in the root directory
#snapshots="/run/timeshift/backup/timeshift-btrfs/snapshots" # Timeshift < v22.06

## Optional arguments to run with the daemon
# Possible options are:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory for timeshift >= 22.06
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
# Uncomment the line to activate the option
optional_args+="--syslog " # write to syslog by default
optional_args+="--timeshift-auto "
#optional_args+="--log-file /var/log/grub-btrfsd.log "
#optional_args+="--verbose "
```


After that, the daemon should be restarted with
``` bash
sudo rc-service grub-btrfsd restart # for openRC
```

----
### ❇️ Automatically update grub upon restart/boot:
#### Systemd
[Look at this comment](https://github.com/Antynea/grub-btrfs/issues/138#issuecomment-766918328)  
Currently not implemented

#### OpenRC
If you would like the grub-btrfs menu to automatically update on system restart/ shutdown, just add the following script as `/etc/local.d/grub-btrfs-update.stop`:
```bash
#!/usr/bin/env bash

description="Update the grub btrfs snapshots menu"
name="grub-btrfs-update"

depend()
{
	use localmount
}
	
bash -c 'if [ -s "${GRUB_BTRFS_GRUB_DIRNAME:-/boot/grub}/grub-btrfs.cfg" ]; then /etc/grub.d/41_snapshots-btrfs; else {GRUB_BTRFS_MKCONFIG:-grub-mkconfig} -o {GRUB_BTRFS_GRUB_DIRNAME:-/boot/grub}/grub.cfg; fi' 
```

Make your script executable with `chmod a+x /etc/local.d/grub-btrfs-update.stop`.

* The extension `.stop` at the end of the filename indicates to locald that this script should be run at shutdown. 
 If you want to run the menu update on startup instead, rename the file to `grub-btrfs-update.start`
* Works for snapper and timeshift

- - -
### Special thanks for assistance and contributions
* [Maxim Baz](https://github.com/maximbaz)
* [Schievel1](https://github.com/Antynea/grub-btrfs/discussions/173#discussioncomment-1438790)
* [All contributors](https://github.com/Antynea/grub-btrfs/graphs/contributors)
- - -
