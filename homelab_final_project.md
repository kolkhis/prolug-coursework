
# ProLUG 101 Final Project

## Table of Contents
* [Initial System Setup (Installation)](#initial-system-setup-installation) 
* [Set up a New User](#set-up-a-new-user) 
* [Package Setup](#package-setup) 
* [Troubleshooting Installation](#troubleshooting-installation) 
    * [Troubleshooting Steps Taken](#troubleshooting-steps-taken) 
        * [Reconfiguing BIOS (UEFI)](#reconfiguing-bios-uefi) 
        * [Re-scanning for Drives](#re-scanning-for-drives) 
        * [Updating Firmware](#updating-firmware) 
        * [Hardware RAID Controller Device settings](#hardware-raid-controller-device-settings) 
* [Send input to `fdisk` (or `gdisk`) without entering the interactive prompt](#send-input-to-fdisk-or-gdisk-without-entering-the-interactive-prompt) 
* [Initial Setup Troubleshooting TL;DR](#initial-setup-troubleshooting-tldr) 


## My Hardware
Machine: Dell PowerEdge R730
* Specs:
    * Memory:
        * 32GB RAM (DDR4 RDIMM)
    * CPU:
        * Intel(R) Xeon(R) CPU E5-2690 v3 @ 2.60GHz (two of these)
        * 12 cores per socket (24 cores), 2 threads per core (48 threads)
        * x86_64 Architecture 


## Initial System Setup (Installation)
Create bootable media (flash drive) with Proxmox VE.

* Boot system - Insert flash drive into system and power on.
* Press F11 during initial setup to enter the Boot Manager.  
* Select "One Shot UEFI Boot"
* Select the bootable media containing Proxmox VE
* Select "Proxmox VE (Terminal UI)"
    * This is where I ran into an error (see [troubleshooting installation](#troubleshooting-installation)). 
    * Under "Advanced options" there is a "Proxmox VE (Terminal UI, Debug Mode)"
      option. It will drop you into a shell after each step in the installation, and you 
      can run commands to troubleshoot if you're having issues.  


---

System setup highlights:
* Choose disk: Choose the disk you want to install Proxmox VE on.
    * This will be your boot drive.  
* Set password: The password you'll use for root user access to the system.  
* Set hostname: needs to be a Fully Qualified Domain Name (FQDN)
    * An FQDN needs to look like a bit like a URL, with a host name and a domain name: 
        * `hostname.domainname`
        * Mine: `home-pve.lab`
    * The Proxmox installer should automatically detect and populate the rest of the network
      configuration for you.  


Once you hit "Install", it should install Proxmox VE and then reboot.  

---

Log into the system.

## Set up a New User


Doing everything as `root` could be dangerous, and is considered a bad practice by a
lot of people.  

Following the "Rule of Least Privilege", it's best to have a user account in 
the `sudo` group, instead of doing everything as `root`.  

We also don't want to SSH into any box as `root`, so I'll create a new user.  


```bash
useradd -m kolkhis
usermod -aG sudo kolkhis
```
* `useradd -m`: Make the user's home directory.
* `usermod -aG`: `-a`ppend `-G`roup. This adds the user to the `sudo` group without 
  affecting other group memeberships.  

or just:
```bash
useradd -m -G sudo kolkhis
```
* `-m`: Create home directory.
* `-G`: Add the user to the specified group(s).  

---

If you forgot to specify `-m` when creating the user, you'll have to create a home 
directory for him.
```bash
mkdir -p /home/kolkhis
cp -r /etc/skel/. /home/kolkhis
chown -R kolkhis:kolkhis /home/kolkhis
chmod 700 /home/kolkhis
```
* `mkdir -p`: Create the directory (including `-p`arent directories if needed)
* `cp -r /etc/skel/. /home/kolkhis`: Copy default user files to the new user's home dir.  
* `chown -R kolkhis:kolkhis /home/kolkhis`: Change the ownership of the new user's
  dir to the user `kolkhis` and the group `kolkhis`.  
* `chmod 700 /home/kolkhis`: Change the permissions of the new user's home dir to
  full permissions for the user and no persmissions for the group and others.  

---

Then, as `root`, set a password for the user:
```bash
passwd kolkhis
```


---


## Setting up Storage for the Homelab
I had a bit of trouble deciding how to go about setting up storage.  
I want it to be accessible from the network, and easy to manage.  
I looked at Ceph for this, but initial setup seems like a steep learning curve.  

So, I'm going to start with LVM to get things up and running.
I may migrate to Ceph down the road when everything else is set up and stable.  

I already created a partition earlier using `gdisk`, so I'll turn that into a single
logical volume using the `ext4` filesystem.  
```bash
# For pvs/pvdisplay, vgs/vgdisplay, lvs/lvdisplay
sudo apt install liblinux-lvm-perl

```






## Package Setup

Proxmox uses Debian as its base OS.  
Version: `Debian GNU/Linux 12 (bookworm)`  

Normal Debian is a pretty minimal operating system, and doesn't ship with a lot of 
the tools we use regularly. So, we need to install them.  
Debian-based distributions use `apt` for package management.  

`sudo` was not on the system by default, so I had to install it.
```bash
apt-get install sudo
```
I also wanted some tools to check on the system:
```bash
sudo apt-get install sysstat
```

---

I couldn't find some LVM commands (`lvs`, `lvdisplay`, etc.), so I had to go and [find out where the commands were](#troubleshooting-logical-volume-management-lvm).  

After doing that, I provisioned the entire partition I made on the 800GB SSD as a single logical volume for
storage.  
```bash
pvcreate /dev/sdb1
vgcreate vg1 /dev/sdb1
lvcreate vg1 -n storage -l 100%FREE 
```

Got an error when running `lvcreate`:
```plaintext
kolkhis@home-pve:~/scratch$ sudo lvcreate vg1 -n storage -l 100%FREE
[sudo] password for kolkhis:
Interrupted initialization of logical volume vg1/storage at position 0 and size 4096.
Aborting. Failed to wipe start of new LV.
Error writing device /dev/sdb1 at 7168 length 1024.
WARNING: bcache_invalidate: block (0, 0) still dirty.
Failed to write metadata to /dev/sdb1.
Failed to write VG vg1.
Manual intervention may be required to remove abandoned LV(s) before retrying.
```
After this happened the device no longer showed up in `lsblk` or `fdisk -l`.  
The light on the disk's caddy was blinking, so I reaseated the disk and it was recognized again.  


---

## Troubleshooting Write-ups

### Troubleshooting Logical Volume Management (LVM)

When trying to create a new logical volume from the second disk, I ran into a problem
where I did not have the `pvs`/`pvdisplay`, `vgs`/`vgdisplay`, or `lvs`/`lvdisplay`
commands on the system.

With a quick `apt search lvdisplay` I find the package:
```plaintext
`liblinux-lvm-perl/stable 0.17-4 all`
    Perl module to access LVM status information
 Linux::LVM parses the output from vgdisplay, pvdisplay, and lvdisplay and
 makes it available as a Perl hash.
```

Looking at the ProLUG lab environment:
```bash
dnf whatprovides pvs
```
Shows the package:
```plaintext
lvm2-9:2.03.23-2.el9.x86_64 : Userland logical volume management tools
```

After installing `liblinux-lvm-perl` on my homelab I did not have access to the commands `pvs`/`pvdisplay`, `vgs`/`vgdisplay`, or `lvs`/`lvdisplay`.
I'll try installing the `lvm2` package:
```plaintext
kolkhis@home-pve:~/scratch$ sudo apt install lvm2
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
lvm2 is already the newest version (2.03.16-2).
0 upgraded, 0 newly installed, 0 to remove and 77 not upgraded.
```
The package is already installed.  

I decide to search for the binary itself. It must be on the system somewhere since
I have the package installed.  
```bash
sudo find / -name pvs 2>/dev/null
# Output:
# /usr/sbin/pvs
# /usr/share/bash-completion/completions/pvs
```
So, the commands are there, but not in the path.
I'll add `/usr/sbin` to my `$PATH` environment variable in `~/.bashrc`.  
```bash
export PATH="$PATH:/usr/sbin"
```

---

#### Creating the Logical Volume (TS)
After finding the executables, I tried to create the logical volume again, but got an error when running `lvcreate`:
```plaintext
kolkhis@home-pve:~/scratch$ sudo lvcreate vg1 -n storage -l 100%FREE
[sudo] password for kolkhis:
Interrupted initialization of logical volume vg1/storage at position 0 and size 4096.
Aborting. Failed to wipe start of new LV.
Error writing device /dev/sdb1 at 7168 length 1024.
WARNING: bcache_invalidate: block (0, 0) still dirty.
Failed to write metadata to /dev/sdb1.
Failed to write VG vg1.
Manual intervention may be required to remove abandoned LV(s) before retrying.
```
After this happened the device no longer showed up in `lsblk` or `fdisk -l`.  
The light on the disk's caddy was blinking, so I reaseated the disk and it was recognized again.  


I decided to try to recreate the LV:
```bash
sudo lvremove vg1  # Removes LVs that are using vg1
sudo lvcreate vg1 -n storage -l 100%FREE  # try creating again
```
Same error.

After some research I decided to wipe the disk to make sure all signatures and metadata, like LVM/RAID/filesystem data, was removed.  

Clear the signatures using `wipefs`:  
```bash
sudo wipefs -a /dev/sdb1
# Output:
# /dev/sdb1: 8 bytes were erased at offset 0x00000218 (LVM2_member): 4c 56 4d 32 20 30 30 31
```

Zero out the start of the partition with `dd`:  
```bash
sudo dd if=/dev/zero of=/dev/sdb1 bs=1M count=100
```

I'll reinitialize it as a physical volume:
```bash
sudo pvcreate /dev/sdb1
```
I'll remake the volume group too, in case it was corrupted by earlier attempts:
```bash
sudo vgremove vg1
```

Now I'll try making the LV again:
```bash
sudo lvcreate -l 100%FREE -n storage vg1
```
Same issue.  

Though, with `lvs`, the logical volume is listed. 
When using `lvdisplay` I get the following output:
```bash
  --- Logical volume ---
  LV Path                /dev/vg1/storage
  LV Name                storage
  VG Name                vg1
  LV UUID                oIGNGn-uerx-YrAi-giDl-xTtf-1beQ-V7IWzc
  LV Write Access        read/write
  LV Creation host, time home-pve.lab, 2024-11-19 08:59:35 -0500
  LV Status              NOT available
  LV Size                745.21 GiB
  Current LE             190774
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
```
* `LV Status` is `NOT available`. 

The logical volume storage is visible in the output of `lvs` with the expected size after the disk reseat, it does indicate that lvcreate partially succeeded... but the recurring errors and need to reseat the disk are serious red flags.

I can manually activate the LV with `lvchange`
```bash
lvchange -ay vg1/storage
```
This changes the output of `lvdisplay` to show `LV Status` as `available`.  

I'll now try to format and mount the logical volume. 
```bash
sudo mkfs.ext4 /dev/mapper/vg1-storage
mke2fs 1.47.0 (5-Feb-2023)
Discarding device blocks: done
Creating filesystem with 195352576 4k blocks and 48840704 inodes
Filesystem UUID: d7ae3783-8b2a-4778-80b7-fda888e85e13
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208,
        4096000, 7962624, 11239424, 20480000, 23887872, 71663616, 78675968,
        102400000
Allocating group tables: done
Writing inode tables: done
Creating journal (262144 blocks): done
Writing superblocks and filesystem accounting information: mkfs.ext4: Input/output error while writing out and closing file system
```
Got an error at the end, and had to reseat the disk for it to be recognized by the system again.  


As per ChatGPT's advice, I'm going to try to use the `smartctl` tool to check for
signs of hardware failure.  





### Troubleshooting Installation
First Error: 
`The installer could not find any supported hard disks.` 

I have an 800GB SSD in drive bay 0.  

I hit "OK" and was dropped into a bash shell on the Proxmox VE system.
I need to check out the disks:

```plaintext
root@proxmox:/# lsblk
loop0
loop1
sda - mounted /cdrom
- sda1
- sda2
- sda3
- sda4
sr0 
(partial output, can't copy/paste it here)
root@proxmox:/# fdisk -l
124000 cylinders, 24 heads, 20 sectors/track, 61440000 sectors
Units: sectors of 1 * 512 = 512 bytes

Device  Boot  StartCHS      EndCHS      StartLBA EndLBA  Sectors Size  Id Type
/dev/sda1     0,0,2         1014,23,20  1        2716387 2726387 1331M ee EFI GPT
```

The `sda` disk is the flash drive with the bootable media.  
I'm not seeing any drive close to 800GB, so that means my SSD is not being detected
by the system.  


I have another SSD I can test, a 240GB SATA drive. I will set that up in a caddy and
install it (the drive bays on the machine are hot-swappable, so I should be able to
do this without rebooting the system).  

---

### Installation Troubleshooting Steps Taken

#### Reconfiguing BIOS (UEFI)

I wound up switching up some ~BIOS~ UEFI settings.
The "Embedded SATA" setting was set to "RAID Mode", I tried both "AHCI" and "ATA",
and both produced the same error.  
It's currently sitting in AHCI mode right now.

After switching to AHCI mode, I added a second disk (the aforementioned 240GB SATA SSD), and that one was not recognized either.

---

#### Re-scanning for Drives 
Using the Proxmox shell, I'll re-scan for drives with this nifty command I found:
```bash
echo "- - -" | sudo tee /sys/class/scsi_disk/hosts*/scan
```

This did not change the output of either `lsblk` or `fdisk -l`

---

#### Updating Firmware
In boot, press F10 to get to the Lifecycle Controller.
Go down to Firmware Update, and go to the Update firmware link.  
Select HTTPS for the update method, this will search for firmware from Dell.  

#### Hardware RAID Controller Device settings
Under "device settings" (after hitting F2 for system setup at boot), I checked the "disk settings" and finally found signs of life for the two SSDs I have in the system. It seems they were configured for RAID. This does make sense considering they as used devices that were formerly used in enterprise environments.  
There are some options here for operations to perform on the disks:
* `blink` 
* `unblink` 
* `clear`

I'm trying `clear` on both of the SSDs. 
Then I'll reboot and see if the disks are then recognized by the system when trying to install Proxmox.  

This did not help.

---

There was also an option I overlooked in the "Device Settings", under the Hardware RAID Controller, that says "Convert to Non-RAID Disk". 
I did this for both the disks currently in the system. 
Rebooting into the Proxmox VE installer...

---

The installer now boots correctly and recognizes the disks. 
However, when I select "Install Proxmox VE (Terminal UI)" using the 800GB SSD, it fails 
on the step `creating LV`, at 3%, with the error:
```error
unable to create swap
```
I tried doing this 2 times, and the 800GB SSD stopped being recognized by the system after the second time. 

I boot into the proxmox shell using  "Install Proxmox VE (Terminal UI, Debug Mode)" in the installer. 
I now see the 240GB disk in `lsblk` and `fdisk -l` as `/dev/sda`.
The 800 GB disk is not being detected.
Since I have access to this disk right now, I'm going to try and format it using the tools offered by the Proxmox shell.
The 240GB disk does not contain a partition table, and I assume the 800 GB disk is the same, since I followed the same exact steps for each of these drives.
I'm wondering if the reason this is failing is because the drives don't already have partition tables on them.  
I want to put a GPT partition table on it (since MBR is deprecated), so I'll use `gdisk` to do that

```bash
gdisk /dev/sda
o  # Create a new empty GPT partition table
n  # Create a new partition
p  # Make it the primary partition
# Use defaults
w  # Write changes (otherwise they won't be applied)
```

I went on with the installation from here.
It got past the "Creating LV" step, and it's chugging along nicely. 
The installation was successful on the 240GB SSD.  


I still need to figure out what to do about the 800 GB disk.
I now know I need to create a partition table on it.
After reseating the disk, I was able to see it using `lsblk`. 

It still had some data on it from trying to install proxmox. I deleted the partition using `gdisk`, created a GPT partition table on the disk, and a partition, using `gdisk` with the same commands as before.  

I tried to install Proxmox VE again on the 800GB disk, it got past the 3% error, but it failed at around 89%: `failure: unable to initialize physical volume /dev/sda3`
I decided to keep the 240GB SSD installation and use the 800GB SSD for storage.  




## Initial Setup Troubleshooting TL;DR:
I have 2 disks in the system. A 240GB SSD in Bay 0 and an 800GB SSD in bay 1.  
The disks were not being recognized by the system. When trying to run the proxmox installer from USB, I kept getting the error `The installer couldn't find any supported hard disks.`

I hit `OK` and was dropped into a bash shell on the Proxmox VE system. Cool! I have a shell to use for troubleshooting.  
I went into the BIOS, changed the Embedded SATA controller to AHCI mode from RAID mode. Still nothing.  
After a lot of hair pulling, I finally found some signs of disk life in the Hardware RAID Controller's device settings, under "Physical Disk Management".

The disks were configured as RAID disks for the Hardware RAID Controller. 
I went to the hardware RAID controller under Device Settings, went to "Physical Disk Management", and converted the disks to "Non-RAID" disks.

The Proxmox Installer was now able to see the disks.  
Then when trying to install Proxmox VE on the 800GB disk, it failed at "Creating LV" (3%) with the error: `unable to create swap volume`

After failing to install twice with this error, I entered the Proxmox shell and tried to format the 800 GB disk. But it was not visible with `lsblk`/`fdisk -l`. Neither of the disks were.  

I read somewhere that RAID configuration could be problematic with disks, so I cleared the RAID controller's configuration.  
I rebooted after doing this.

This time I ran the installer in Debug Mode.  
Booting into the proxmox shell, I was able to see the 240 GB SSD in `lsblk` and `fdisk -l` as `/dev/sda`.
I decided to install the Proxmox VE on the 240 GB SSD.
It did not have a partition table. I thought this may be why it's acting up, so I created one using `gdisk` (for GPT partition table, since MBR is only for older systems). 
I also created a partition on the disk while in `gdisk`.  
I continued the installation after doing that and it worked.  


After I booted into Proxmox, I was able to see the 800 GB SSD in `fdisk -l`/`lsblk`. I formatted it the same way I formatted the other one.

Then I tried installing again on the 800GB drive. It failed with a different error: 
`Unable to initialize physical volume /dev/sda3`

F#$! it. I can still use it for storage on the system, so I will keep the 240 drive as my boot drive.

I did a small write-up (a summary of all the notes I took while troubleshooting), if anyone is interested

## Misc
Restarting services after changing hostname:
```bash
sudo systemctl restart pvedaemon pveproxy pvestatd
```
