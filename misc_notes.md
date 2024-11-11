# Misc Notes

## Tools
* `ionotifywait`
    * `iowait`
    * `ionotify`
* `/usr/lib/firewalld/`: The location of the firewalld configuration files.
* `logrotate`: Designed to manage log files.
    * `logratate` is normally run as a daily cron job.  
* `gcc`: The GNU C Compiler.  
  ```bash
  gcc -o hello hello.c
  ```

## Logical Volume Management (LVM) - Unit 3 Lab Solution

```bash
fdisk -l | grep lvm
blkid
umount /dev/mapper/VolGroupTest-lv_test
umount /dev/VolGroupTest/lv_test
lvremove /dev/mapper/VolGroupTest-lv_test
blkid

# Creating physical volumes, a volume group, and a logical volume
vgremove VolGroupTest
lvdisplay
vgdisplay
pvdisplay
pvremove /dev/md0  # Failed. Not a PV.  
lvdisplay 
pvdisplay
vgdisplay
fdisk -l | grep xvd
pvcreate /dev/xvda /dev/xvdb
blkid
vgcreate outer_space
pvcreate /dev/xvdc  # Failed. 
pvcreate /dev/xvdd
pvcreate /dev/xvde
ls
lsblk
umount /dev/md0
lvs; pvs; vgs
vgcreate outer_space /dev/xvda
lvcreate outer_space -n SpaceLV -L 15G # Fail - not enough space
# Use `-l +100%FREE` to use all available space in the VG.  
lvcreate outer_space -n SpaceLV -l +100%FREE

lvcreate outer_space -n SpaceLV -L 14G
lvs
mkfs.xfs /dev/mapper/outer_space-SpaceLV
lsblk
blkid /dev/mapper/outer_space-SpaceLV
mkdir /outer_space
mount /dev/mapper/outer_space-SpaceLV /outer_space/
cd /outer_space/
lsblk
history | tail -n 20 > LVM_creation_commands
vim LVM_creation_commands
history | tail -n 40 > LVM_creation_commands
```

Lab:
Write test:
```bash
for i in {1..10}; do time dd if=/dev/zero of=/space/testfile_$i bs=1024k count=1000 | tee -a /tmp/speedtest1.basiclvm
```
Read tests:
```bash
for i in seq 1 10; do time dd if=/space/testfile_$i of=/dev/null; done
```
Cleanup:
```bash
for i in seq 1 10; do rm -rf /space/testfile_$i; done
```

