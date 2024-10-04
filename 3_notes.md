
# Unit 3 Notes

### Terms:
Triage - Sort by order of importance.  
High availability
Logical volume management
RAID
Mount Points
Key Performance Indicators (KPI)



IDEA: Log when block devices are mounted.  



mount -a and systemctl daemon-reload


You can `cd` into a process with the process id `PID`
You can also use `pstree`

Don't ever try to unmount /proc

QUESTION: Can I mount different types of filesystems to a the main one? Say a btrfs to xfs or ext4?
A: Yes



* Where does work come from?
    * track and find issues that arise from normal monitoring
* Trouble tickets from users
    * The goal is to knock these out quick
    * Need to triage these incidents
        * usually the squeaky wheel gets the oil


AGILE:
1. Individuals and interactions over processes and tools
2. working software over compehensive documentation
3. Customer collaboration over contract negotiation
4. responding to change over following a plan





## Lab Tasks this week:
1. Build a LVM device from other block devices
2. Create a filesystem on a block device
3. Mount a filesystem on a Linux server
4. Make a mount point permanent
5. Build a software raid with `mdadm`
6. build a filesystem on a raid device


Send a msg to other user on server with `wall`:
`echo "Get off my server" | wall`
This will print output on all user's terminals

Schedule a shutdown for 5 minutes from now:  
```bash
shutdown -fr 5 min
```




### Useful tools:


* `sar` - Collect, report, or save system activity information.
* `lsblk` - Lists all mount points that are block devices
* blkid - Shows the TYPE of filesystem
* tune2fs - Show a information about a block device/file system
  ```bash
  tune2fs -l /dev/vda1  # -l lists all the information about the file system
  ```
    * Can also tune a file system (mount it as root)

* `dumpe2fs` - Get information about a file system/block device
  ```bash
  dumpe2fs /dev/vda1
  ```
    * Has a bunch of repair functions


* mount
    * Without args, `mount` will dump everything that is mounted, in the order they were
      mounted.  
        * Reads from `/etc/mtab`
        * Never edit this file in real-time yourself. 
    * `mount -o remount /boot/efi` - Remount the boot partition.  
* `umount` - unmount


* lsof - Lists all open files and the processes that are using them.  
  ```bash
  lsof /proc
  ```
* `dd`
* `mttr`

Look into:
* `mdadm`: manage MD devices (AKA Linux Software RAID).  
* fdisk
* cgdisk
* sgdisk



* fsck - never run on mounted file systems
* `df -h`
* `w` - shows who is logged in on the system.  

List all xvd partitions
```bash
fdisk -l | grep -i xvd
```

fdisk /dev/xvdc
- This command will allow you to modify, create, delete file systems (disk partitions)

---

```bash
mkfs.xfs /dev/xvda  # create a new file system
mkdir /space 
mount /dev/xvda /space # Mount the new file system, the mount point is /space
cd /space
lsof .
umount /space # error, since it's in use. "target is busy"  
cd /tmp
umount /space # now works
```
* `mount`
    * syntax:
    ```bash
    mount -t type /device/or/directory directory
    ```
    This tells the kernel to attach the filesystem found on `device` (which is of type `type`) 
    at the directory `dir`.
`mount -t xfs`: Tells `mount` that the `-t`ype of file system is `xfs`.  
If you want to override mount options from `/etc/fstab`, you have to use the -o option:
```bash
mount /device/or/directory -o options
```
The mount options from the command line will be appended to the list of options from `/etc/fstab`.

The mount program does not read the `/etc/fstab` file if both
device and dir are given. 

```bash
mount /dev/foo /dir
```




* `mkfs`
    * `mkfs.<Tab>` will show all the different types of file systems you can make (using bash completion).  


* Logical Volumes have UUIDs.  

Get information about the volumes:  
* `pvs` - physical volumes
* `vgs` - volume groups
* `lvs` - logical volumes  
Get more information about the volumes:
* `pvdisplay` 
* `vgdisplay`
* `lvdisplay`

### Logical Volume Management (LVM)
* Logical Volume Management is way to turn raw disks into a more manageable format. 
    * Raw disks are loaded into LVM with `pvcreate` (TODO: what are raw disks?)
    * Turned into physical volumes `vgcreate` (TODO: what are physical volumes?)
    * Then turned into logical volumes `lvcreate` (TODO: what are logical volumes?)
        * The logical volume is then formatted with `mkfs`
    * Finally, the logical volume is mounted with `mount`

```bash
fdisk -l | grep -i xvd
vgcreate vg1 /dev/xvdb /dev/xvdc  # Make a volume group vd1, with the two physical volumes xvdb and xvdc
pvs
vgextend vg1 /dev/xvde  # Add the 3rd physical volume to the volume group
lvcreate vg1 -n space -L 5G # Create a logical volume called space, with 5GB of storage space
lvs
# The logical volume will be stored in /dev/mapper/vg1-space
mkfs.ext4 /dev/mapper/vg1-space 
mount /dev/mapper/vg1-space /space
pvdisplay  # Show more information than pvs
vgdisplay
lvdisplay
```

