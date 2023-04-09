[![GitHub release](https://img.shields.io/github/release/Antynea/grub-btrfs.svg)](https://github.com/Antynea/grub-btrfs/releases)
![](https://img.shields.io/github/license/Antynea/grub-btrfs.svg)

## 💻 grub-btrfs 

##### BTC donation address: `1Lbvz244WA8xbpHek9W2Y12cakM6rDe5Rt`
- - -
### 🔎 Description:
Improves grub by adding a btrfs snapshots sub-menu to the grub menu.

grub-btrfs supports manual snapshots as well as snapper and timeshift created snapshots.

##### Warning: booting read-only snapshots can be tricky

If you wish to use read-only snapshots, `/var/log` or even `/var` must be on a separate subvolume.
Otherwise, make sure your snapshots are writable.
See [this ticket](https://github.com/Antynea/grub-btrfs/issues/92) for more info.

This project includes its own solution.
Refer to the [documentation](https://github.com/Antynea/grub-btrfs/blob/master/initramfs/readme.md).

- - -
### ✨ What features does grub-btrfs have?
* Automatically lists snapshots existing on the btrfs root partition.
* Automatically detect if `/boot` is in a separate partition.
* Automatically detect kernel, initramfs and Intel/AMD microcode in `/boot` directory within snapshots.
* Automatically create corresponding menu entries in `grub.cfg`
* Automatically detect the type/tags and descriptions/comments of Snapper/Timeshift snapshots.
* Automatically generate `grub.cfg` if you use the provided Systemd/ OpenRC service.

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
Without Systemd USE-Flag the OpenRC-daemon of grub-btrfs will be installed.

Emerge grub-btrfs via 
`emerge app-backup/grub-btrfs`

#### Kali Linux
[grub-btrfs](http://pkg.kali.org/pkg/grub-btrfs) is available in the Kali Linux repository and can be installed with:  
```
apt install grub-btrfs
```
Booting into read-only snapshots is fully supported when choosing btrfs as the file system during a standard Kali Linux installation following [this walk-through](https://www.kali.org/docs/installation/btrfs/).

#### Manual
* Run `make install`
* Run `make help` to check what options are available. 
* Dependencies:
  * [btrfs-progs](https://archlinux.org/packages/core/x86_64/btrfs-progs/)
  * [grub](https://archlinux.org/packages/core/x86_64/grub/)
  * [bash >4](https://archlinux.org/packages/core/x86_64/bash/)
  * [gawk](https://archlinux.org/packages/core/x86_64/gawk/)
  * (only when using the grub-btrfsd daemon)[inotify-tools](https://archlinux.org/packages/community/x86_64/inotify-tools/)

- - -
### 📚 Usage
After installation the grub main menu needs to be generated to make a menuentry for the snapshots sub-menu. Depending on the Linux distribution the commands for that are different:
* On **Arch Linux** or **Gentoo** use `grub-mkconfig -o /boot/grub/grub.cfg`.  
* On **Fedora** use `grub2-mkconfig -o /boot/grub2/grub.cfg`  
* On **Debian and Ubuntu based** distributions `update-grub` is a script that runs `grub-mkconfig ...`

Once the entries for the snapshots sub-menu are generated, grub-btrfs updates `grub-btrfs.cfg`. To generate snapshot entries in the sub-menu it is usually enough to just run the script with `sudo /etc/grub.d/41_snapshots-btrfs`.
Read on for details of how to automate this process.

### ⚙️ Customization:

You have the possibility to modify many parameters in `/etc/default/grub-btrfs/config`.
For further information see [config file](https://github.com/Antynea/grub-btrfs/blob/master/config) or `man grub-btrfs`

#### Warning:
Some file locations and command names differ from distribution to distribution. Initially the configuration is set up to work with Arch and Gentoo (and many other distributions) out of the box, which are using the `grub-mkconfig` command. 
However Fedora, for example, uses a different command, `grub2-mkconfig`.
Edit the `GRUB_BTRFS_MKCONFIG` variable in `/etc/default/grub-btrfs/config` file to reflect this. (e.g. `GRUB_BTRFS_MKCONFIG=/sbin/grub2-mkconfig` for Fedora)

On most distributions, the grub installation resides in `/boot/grub`. If grub is installed in a different place, change the variable `GRUB_BTRFS_MKCONFIG` in the config file accordingly. For Fedora this is `GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"`. The command to check the grub scripts is different on some system, for Fedora it is `GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check`

#### Customization of the grub-btrfsd daemon

Grub-btrfs comes with a daemon script that automatically updates the grub menu when it sees a snapshot being created or deleted in a directory it is given via command line. You must install `inotify-tools` before you can use grub-btrfsd.

The daemon can be configured by passing different command line arguments to it. 
The available arguments are:
* `SNAPSHOTS_DIRS`
This argument specifies the (space separated) paths where grub-btrfsd looks for newly created snapshots and snapshot deletions. It is usually defined by the program used to make snapshots.
E.g. for Snapper this would be `/.snapshots`. It is possible to define more than one directory here, all directories will inherit the same settings (recursive etc.).
This argument is not necessary to provide if `--timeshift-auto` is set. 
* `-c / --no-color`
Disable colors in output.
* `-l / --log-file`
This arguments specifies a file where grub-btrfsd should write log messages.
* `-r / --recursive`
Watch the snapshots directory recursively
* `-s / --syslog`
* `-o / --timeshift-old`
Look for snapshots in `/run/timeshift/backup/timeshift-btrfs` instead of `/run/timeshift/$PID/backup/timeshift-btrfs.` This is to be used for Timeshift versions <22.06. You must also use `--timeshift-auto` if using this option.
* `-t / --timeshift-auto`
This is a flag to activate the auto-detection of the path where Timeshift stores snapshots. Newer versions (>=22.06) of Timeshift mount their snapshots to `/run/timeshift/$PID/backup/timeshift-btrfs`. Where `$PID` is the process ID of the currently running Timeshift session. The PID changes every time Timeshift is opened. grub-btrfsd can automatically take care of the detection of the correct PID and directory if this flag is set. In this case the argument `SNAPSHOTS_DIRS` has no effect.
* `-v / --verbose`
Let the log of the daemon be more verbose
* `-h / --help`
Displays a short help message.
- - - 
##### Systemd instructions
To edit the arguments that are passed to the daemon, use:
```bash
sudo systemctl edit --full grub-btrfsd
```
after that the Daemon must be restarted with:
```bash
sudo systemctl restart grub-btrfsd 
```

It is also possible to start the daemon without using systemd for troubleshooting purposes for example. If you want to do this, a running daemon should be stopped with:
```bash
sudo systemctl stop grub-btrfsd 
```
Then the daemon can be manually run and played around with using the command `/usr/bin/grub-btrfsd`. 
For additional information on the daemon script and its arguments, run `grub-btrfsd -h` and see `man grub-btrfsd`
- - -
##### OpenRC instructions
To edit the arguments that are passed to the daemon edit the file `/etc/conf.d/grub-btrfsd`.  
After that restart the daemon with:
```
sudo rc-service grub-btrfsd restart 
```

It is also possible to start the daemon without using OpenRC for troubleshooting purposes for example. If you want to do this, a running daemon should be stopped with:
```bash
sudo rc-service grub-btrfsd stop 
```
Then the daemon can be manually run and played around with using the command `grub-btrfsd`. 
For additional information on daemon script and its arguments, run `grub-btrfsd -h` and see `man grub-btrfsd`

- - - 
### 🪀 Automatically update grub upon snapshot
Grub-btrfsd is a daemon daemon that watches the snapshot directory for you and updates the grub menu automatically every time a snapshot is created or deleted. 
By default this daemon watches the directory `/.snapshots` for changes (creation or deletion of snapshots) and triggers the grub menu creation if a snapshot is found. 
Therefore, if Snapper is used with its default directory, the daemon can just be started and nothing needs to be configured. See the instructions below to configure grub-btrfsd for use with Timeshift or when using an alternative snapshots directory with Snapper.
- - - 
#### SystemD instructions
To start the daemon run:
```bash
sudo systemctl start grub-btrfsd
```

To activate it during system startup, run:
```bash
sudo systemctl enable grub-btrfsd
```

##### 💼 Snapshots not in `/.snapshots`
By default the daemon is watching the directory `/.snapshots`. If the daemon should watch a different directory, it can be edited with:
```bash
sudo systemctl edit --full grub-btrfsd 
```
You need to edit the `/.snapshots` part in the line that says `ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots`.
This is what the file should look like afterwards:
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
# grub-btrfsd [-h, --help] [-t, --timeshift-auto] [-l, --log-file LOG_FILE] SNAPSHOTS_DIRS
# SNAPSHOTS_DIRS         Snapshot directories to watch, without effect when --timeshift-auto
# Optional arguments:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory
# -o, --timeshift-old   Activate for timeshift versions <22.06
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
ExecStart=/usr/bin/grub-btrfsd --syslog /.snapshots

[Install]
WantedBy=multi-user.target
```

When done, the service should be restarted with:
``` bash
sudo systemctl restart grub-btrfsd 
```

##### 🌟 Timeshift
Newer Timeshift versions (>= 22.06) create a new directory named after their process ID in `/run/timeshift` every time they are started. The PID will be different every time.
Therefore the daemon cannot simply watch a directory. It monitors `/run/timeshift` and if a directory is created it gets Timeshifts current PID then watches a directory in that newly created directory from Timeshift.
To activate this mode of the daemon, `--timeshift-auto` must be passed to the daemon as a command line argument.

To pass `--timeshift-auto` to grub-btrfsd, the .service-file of grub-btrfsd can be edited with
```bash
sudo systemctl edit --full grub-btrfsd 
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
# grub-btrfsd [-h, --help] [-t, --timeshift-auto] [-l, --log-file LOG_FILE] SNAPSHOTS_DIRS
# SNAPSHOTS_DIRS         Snapshot directories to watch, without effect when --timeshift-auto
# Optional arguments:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto

[Install]
WantedBy=multi-user.target
```

If you are using an older release of Timeshift (before 22.06), you also need to add `--timeshift-old` so that your ExecStart line would look like:

```
ExecStart=/usr/bin/grub-btrfsd --syslog --timeshift-auto --timeshift-old
```

When done, the service must be restarted with
``` bash
sudo systemctl restart grub-btrfsd 
```

Note:
You can view your change with `systemctl cat grub-btrfsd`.
To revert all the changes use `systemctl revert grub-btrfsd`.

##### ❇️ Automatically update grub upon restart/boot:
[Look at this comment](https://github.com/Antynea/grub-btrfs/issues/138#issuecomment-766918328)  
Currently not implemented
- - -
#### OpenRC instructions
To start the daemon run
```bash
sudo rc-service grub-btrfsd start 
```

To activate it during system startup, run 
```bash
sudo rc-config add grub-btrfsd default 
```

##### 💼 Snapshots not in `/.snapshots`
NOTE: This works also for Timeshift versions < 22.06, the path to watch would be `/run/timeshift/backup/timeshift-btrfs/snapshots`.

By default the daemon is watching the directory `/.snapshots`. If the daemon should watch a different directory, it can be edited by passing different arguments to it.
Arguments are passed to grub-btrfsd via the file `/etc/conf.d/grub-btrfsd`. 
The variable `snapshots` defines, where the daemon will watch for snapshots. 

After editing, the file should look like this:
``` bash
# Copyright 2022 Pascal Jaeger
# Distributed under the terms of the GNU General Public License v3

## Where to locate the root snapshots
snapshots="/.snapshots" # Snapper in the root directory
#snapshots="/run/timeshift/backup/timeshift-btrfs/snapshots" # Timeshift < v22.06

## Optional arguments to run with the daemon
# Append options to this like this:
# optional_args="--syslog --timeshift-auto --verbose"
# Possible options are:
# -t, --timeshift-auto  Automatically detect Timeshifts snapshot directory for timeshift >= 22.06
# -o, --timeshift-old   Look for snapshots in directory of Timeshift <v22.06 (requires --timeshift-auto)
# -l, --log-file        Specify a logfile to write to
# -v, --verbose         Let the log of the daemon be more verbose
# -s, --syslog          Write to syslog
optional_args="--syslog"
```

After that, the daemon should be restarted with
``` bash
sudo rc-service grub-btrfsd restart
```

##### ❇️ Automatically update grub upon restart/boot:
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

Make your script executable with `sudo chmod a+x /etc/local.d/grub-btrfs-update.stop`.

* The extension `.stop` at the end of the filename indicates to the locald-daemon that this script should be run at shutdown. 
 If you want to run the menu update on system startup instead, rename the file to `grub-btrfs-update.start`
* Works for Snapper and Timeshift
- - -
### Troubleshooting
If there are problems don't hesitate [to file an issue](https://github.com/Antynea/grub-btrfs/issues/new/choose). 

#### Version
To help the best we would like to know the version of grub-btrfs used. Please run:
``` bash
sudo /etc/grub.d/41_snapshots-btrfs --version
```
or 
``` bash
sudo /usr/bin/grub-btrfsd --help
```
to get the currently running version of grub-btrfs.

#### Verbose mode of the daemon
If you have problems with the daemon, you can run it with the `--verbose`-flag. To do so you can run:
``` bash
sudo /usr/bin/grub-btrfsd --verbose --timeshift-auto` (for timeshift)
# or 
sudo /usr/bin/grub-btrfsd /.snapshots --verbose` (for snapper)
```
Or pass `--verbose` to the daemon using the Systemd .service-file or the OpenRC conf.d file respectively. (see Daemon installation instructions how to do that)

- - -
### Development
Grub-btrfs uses a rudimentary system of automatic versioning to tell apart different commits. This is helpful when users report problems and it is not immediately clear what version they are using. 
We therefore have the following script in `.git/hooks/pre-commit`:

``` bash
#!/bin/sh

echo "Doing pre commit hook with version bump"
version="$(git describe --tags --abbrev=0)-$(git rev-parse --abbrev-ref HEAD)-$(date -u -Iseconds)"
echo "New version is ${version}"
sed -i "s/GRUB_BTRFS_VERSION=.*/GRUB_BTRFS_VERSION=${version}/" config
git add config
```

This automatically sets the version in the `config`-file to `[lasttag]-[branch-name]-[current-date-in-UTC]`.
In order to create a Tag we don't want to have this long version. In this case we set the version manually in `config` and commit with `git commit --no-verify`. This avoids running the hook. 

### Special thanks for assistance and contributions
* [Maxim Baz](https://github.com/maximbaz)
* [Schievel1](https://github.com/Antynea/grub-btrfs/discussions/173#discussioncomment-1438790)
* [All contributors](https://github.com/Antynea/grub-btrfs/graphs/contributors)
- - -
