# ProLUG 101  
## Unit 3 Worksheet  


## Table of Contents
* [Unit 3 Worksheet](#unit-3-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions:](#discussion-questions:) 
    * [Unit 3 Discussion Post 1](#unit-3-discussion-post-1) 
    * [Unit 3 Discussion Post 2](#unit-3-discussion-post-2) 
* [Definitions and Terminology](#definitions-and-terminology) 
* [Notes During Lecture/Class:](#notes-during-lecture/class:) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Logical Volume Management](#logical-volume-management) 
    * [LVM Step by Step](#lvm-step-by-step) 
        * [LVM Tools](#lvm-tools) 
    * [Implementing RAID on Logical Volumes with mdadm](#implementing-raid-on-logical-volumes-with-mdadm) 
    * [Resizing Logical Volumes](#resizing-logical-volumes) 
    * [LVM Snapshots](#lvm-snapshots) 
    * [Creating a Logical Volume from Raw Disks](#creating-a-logical-volume-from-raw-disks) 
* [Lab and Assignment](#lab-and-assignment) 
* [Reflection Questions](#reflection-questions) 


## Instructions  

Fill out this sheet as you progress through the lab and discussions. Turn in the sheet to scott.champine@simple2serious.com for grading and feedback.  

## Discussion Questions:  

### Unit 3 Discussion Post 1
What does the term triage mean to you? Have you ever had to triage something?  
To triage is to sort by order of importance. I've only ever triaged in troubleshooting code. This was just a way to figure out what I should work on first - e.g., fixing problematic API calls is more important than making the output look good. 
1. Scan the chapter [here](https://google.github.io/building-secure-and-reliable-systems/raw/ch17.html) for keywords and pull out what you think will help you to better understand how to triage an incident.  

    * Indicent Response (IR)  
    * Triage: The first step in the IR is triage. Always assume the worst-case  
      scenario, assume that an account is compromised if the security team has any  
      suspicion.  
    * Incident Handling  
    * Coordinated Vulnerability Disclosures (CVDs) 
    * Incident Management (IMAG)  
        * IMAG is based on a formal process called the Incident Command System (ICS)  
            * This is used by first responders around the world.  
        * IMAG is tasked with formalizing IR processes to ensure success in these  
          areas of incident handling:  
            * Command: Issuing a declaration, "Our team is declaring an incident  
                       involving [incident], and I am the Incident Commander (IC)"  
            * Control: The IC directs the response and ensures the responders are  
                       moving forward to accomplish specific goals at all times.  
                * The IC is responsible for making sure all responders know what to  
                  do at each step.  
            * Communications: The IC and their leads must maintain constant  
                              communication with everyone involved.  



2. Read the section called "Operation Security" in this same chapter: 
    [here](https://google.github.io/building-secure-and-reliable-systems/raw/ch17.html)  
   what important concepts do you learn about how we behave during an operational response to an incident?  

    * Operational Security (OpSec): The practice of keeping your response activity secret.  
        * OpSec DON'Ts:  
            * Don't log into compromised servers. Could expose useful auth credentials to the attacker  
            * Don't document incidents in a place that an attacker could monitor (e.g., email).  
            * Don't connect to the attacker's Command and Control (CC) servers. This could clue them into your response.  
            * Don't perform port scanning or domain lookups for the attacker's machines.  
            * Don't lock accounts or change passwords of compromised users before  
              your investigation is complete.  
            * Don't take systems offline before you understand the full scope of the attack.  
            * Don't allow your analysis workstations to be accessed with the same  
              credentials the attacker may have stolen.  
        * OpSec DOs:  
            * Have meetings and discussions in person. If that's not possible, use  
              new machines and infrastructure (not accessible by the compromised machines).  
                * E.g., a new temporary cloud-based environment for responders to communicate.  
            * Ensure your machines have remote agents or key-based auth methods. This  
              allows you to collect evidence without revealing login credentials.  
            * Be specific about confidentiality when asking for help. 
            * Consider the conclusions a smart attacker could make based on your actions.  


### Unit 3 Discussion Post 2
Ask google, find a blog, or ask an AI about high availability. (Here’s one if you need it: https://docs.aws.amazon.com/pdfs/whitepapers/latest/real-time-communication-on-aws/real-time-communication-on-aws.pdf#high-availability-and-scalability-on-aws)  
1.  What are some important terms you read about?  

* High Availability (HA)  
* Single points of failure (SPOF)  
* Floating IP Pattern 
    * Implements an active/standby setup.  
        * One node is active, taking all the load. The other is waiting to take over when the active node fails.  
    * Used to achieve automatic failover between the active server and a standby server.  
    * The active node has a secondary virtual IP address. 
    * The nodes are monitored for failures, and the monitoring script assigns the virtual IP to the standby node, which takes over when the active node fails.  
    * So, this virtual IP floats between the active and standby nodes.  
    * Considered (by AWS) the best configuration for HA setups.  



2.  Why do you think understanding HA will help you better in the context of triaging incidents?  
If HA is a priority (which I'd assume it always is), then understanding HA can give you a better understanding of which incidents are more important than others based on how they affect uptime/availability, thus allowing you to triage an incident based on how it affects HA. 


## Definitions and Terminology  

 
* Five 9’s - The availability of a system or a service at 99.999 percent of a given timespan.  
    * This is typically measured over a year.  
    * This would mean that the system/service is down for 5.24 minutes every year.  

* Single point of failure (SPOF) - A single component of the system that is crucial to the system's overall functionality, without any redundant backup  
    * To avoid a disk being a SPOF, you could implement RAID (Redundant Array of
      Independent Disks) for storage, or use load balancers for web servers so that no 
      single server’s failure can bring down the service.  
      ```bash  
      # Example: Use RAID to prevent a storage device being a SPOF  
      mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1  
      ```

* Key Performance Indicators (KPI) - A type of performance measurement. 
    * These are measurable values that demonstrate how effectively a system or service is 
      performing in terms of availability, performance, and reliability.  
    * KPIs for sysadmins are typically ticket queue time (how long a ticket sits in  
      queue), and ticket turnover time (how quickly trouble tickets are resolved).  
    * A KPI for a web server could be average response times, error rates, or CPU usage.  
    * E.g., if CPU utilization is a KPI, monitor it regularly:  
      ```bash  
      sar -u 1 5  
      ```
    * Kanban boards are a common way to track trouble tickets and measure KPIs.  

* SLI (Service level indicator) - A specific metric that is used to measure the 
  performance or availability of a system or a service  
    * These could be things like latency, throughput, or uptime  
* SLO (Service Level Objective) - Achievable target values that are set for SLIs.  
    * Represents the goals a service should meet in terms of performance, availability, or other SLIs.  
  
* SLA (Service Level Agreement) - Formal agreements between service providers and clients.  
    * These agreements typically include SLOs, penalties for unmet SLOs, and other conditions for service.  
* Active-Standby - A setup used for HA. One server takes all the load while another server waits to take some of the load in case the active server fails (or manually taken offline). 
    * This setup provides a redundancy mechanism to ensure High Availability (HA).  
* Active-Active - A setup in which two servers are both active and taking all the load, without any backup servers.
* MTTD - Mean time to detect  
    * The average amount of time it takes to detect a failure.  
    * Used as a metric for measuring how quickly issues are identified.  
* MTTR - Mean time to resolve  
    * The average amount of time it takes to resolve/fix a failure. 
    * This includes the time taken to detect, diagnose, and fix the issue, and bring the server back to normal operation.  
* MTBF - Mean time between failures  
    * MTBF is the predicted amount of time between one failure and the next in a system.  
    * This is a measure of the reliability of a system, and a higher MTBF indicates fewer expected failures over time.  






## Notes During Lecture/Class:  
 
### Links  
https://www.techopedia.com/definition/14235/five-nines  
https://linuxize.com/post/bash-heredoc/  
https://joplinapp.org/  
https://github.com/org-roam/org-roam  
https://www.notion.so/  

### Terms  
* Mount Points: These are **directories** in a file system where additional storage (disks, 
  partitions, or network shares) are attached (mounted) for the operating system to use.  

* Triage - Sorting issues by order of importance.  
* HA (High Availability)  
* Logical volume management  
* RAID  
* Mount Points  
* Key Performance Indicators (KPI)  
* Journals - Tool used to go back to older state of file system  

* PPDIOO:  
    * Prepare  
    * Plan  
    * Design  
    * Implement  
    * Operate  
    * Optimize  


* Individual Contributor (IC): A person that spends more time doing hands-on work and  
  less time in meetings.  
* GUID Partition Table (GPT)

### Useful tools  


* `mount`
    * `mount -o remount /boot/efi` - Remount the `/boot/efi` file system (the boot partition).  
    * Without args, `mount` will dump every file system that's mounted, in the order they were mounted.  
        * `mount` reads from `/etc/mtab` when it does this.  
            * Never edit `/etc/mtab` in real-time yourself. 
    * Syntax for mounting a file system to a directory:  
    ```bash  
    mount -t type /dev/device directory  
    ```
    This example tells the kernel to attach the filesystem found on `/dev/device` (which is the 
    given `type`) at the directory `dir`.  
    * `mount -t xfs`: Tells `mount` that the `-t`ype of file system is `xfs`.  
        * `ext4` and `xfs` are the most common file system formats in the industry.  

    * By default, mount will use `/etc/fstab` if either `device` or `directory` are omitted.
        * The `/etc/fstab` (file system tables) file contains info about the file systems and 
          their mount points.  
        * `mount` uses this file to determine how to mount certain filesystems automatically,
          when the user doesn't specify exactly how to mount them.  
        * If you want to override mount options from `/etc/fstab`, use the `-o` option:  
          ```bash  
          mount /device/or/directory -o options  
          ```
        * The mount options from the command line will be appended to the list of options from `/etc/fstab`.  
        * The mount program does not read the `/etc/fstab` file if both `device` and `directory` are given. 




Weird things about `mount`:  
* The same filesystem can be mounted more than once.  
* In some cases (e.g., network filesystems) the same filesystem can be mounted on the 
  same mountpoint multiple times.  

Example of making and mounting a file system:  
```bash  
mkfs.ext4 /dev/xvdc1  
mount -t ext4 /dev/xvdc1 /directory  
```
This uses an existing partition (`/dev/xvdc1`), formats it with the `ext4` format,
and mounts it to the directory `/directory`


* `umount`: Unmount a file system.  
    * If a file system has file handles open in it, you can't unmount it.  
    * This will force it to unmount (NOT recommended!):  
      ```bash  
      umount -l /boot/efi  
      ```
        * This could potentially leave zombie processes running.  

    * To check if there are any files open in a file system:  
      ```bash  
      du /boot/efi  
      lsof /boot/efi
      ```
      If `du` hangs, there is something is wrong with the file system.  
      `lsof` will list all the file open in the file system.  


* `lsof` - Lists all open files and the processes that are using them.  
  ```bash  
  lsof /proc  
  ```
    * Shows process IDs (PIDs).  
    * You can check the PID of the shell you're in (with `echo $$`) against the
      output of `lsof` to see if you're currently in that file system.  
    * You can check your shell's PID against `lsof /root` to see if you're currently  
      in that file system.  

---
* `journalctl` 
    * Log analysis tools like `journalctl` can be used to quickly triage system issues 
      based on error severity.
      ```bash
      journalctl -p 3 -xb
      ```
        * `-x`: Add explanatory help texts from the message catalog.  
        * `-b`: Show only the latest boot.  

* `mkfs`
    * `mkfs.<Tab>` will show all the different types of file systems you can make using bash completion.  
        * e.g., `mkfs.ext4`, `mkfs.xfs`, etc.
    * This will format a block device with the given type.  
    * All inode pointers on the block device are deleted when formatted with `mkfs`, but 
      the data still remains on the disk. Forensic tools can recover that data.  

* `sar`: Collect, report, or save system activity information.  
* `lsblk`: Lists all mount points that are block devices  
* `blkid`: Locates and prints block device attributes. Shows the TYPE of filesystem.
* `tune2fs`: Shows information about a block device/file system  
  ```bash  
  tune2fs -l /dev/vda1  # -l lists all the information about the file system  
  ```
    * Shows when a file system was created, mounted, etc.  
    * This command can also tune a file system (mount it as root)  
    * Can use `tune2fs` to fix file systems, but not when they're mounted.  

* `dumpe2fs`: Get more verbose information about a file system/block device  
  ```bash  
  dumpe2fs /dev/vda1  
  ```
    * This command has a bunch of repair functions.  
    * This is usually used for very low-level troubleshooting.  



* `mdadm`: Manage MD devices (AKA Linux Software RAID).  
    * This is used to create and manage RAID devices. 
    
* `dd`
* `mttr`

* `fsck` - never run on mounted file systems  
* `df -h`: Show disk space usage (in a `-h`uman readable format)
* `w`: Shows who is logged in on the system.  


* `fdisk`: Disk partitioning tool. 
    * This allows you to view, modify, create, and delete disk partitions  
    * E.g., `fdisk /dev/xvdc`  
        * Any changes made with `fdisk` need to be written with `w` to be saved.  
  * Example: List all `xvd` partitions  
    ```bash  
    fdisk -l | grep -i xvd  
    ```
    This will list all partitions of a particular type (`xvd` in this example).  
    * This can be used with many disk partition table formats: `GPT`, `MBR`, `Sun`, `SGI` and `BSD` partition tables.
        * `GPT` (GUID Partition Table) is part of the UEFI specification. This is the modern replacement for the older `MBR` partitioning system.  
        * `MBR` (Master Boot Record) was used on older BIOS-based systems.  
        * `Sun` is used on Solaris-based systems or on SPARC architecture.   
        * `SGI` (Silicon Graphics Inc) partition tables are specific to `IRIX`. Used in legacy SGI hardware and systems runnin IRIX.  
        * `BSD` (Berkeley Software Distribution) partition tables are used on BSD-based systems. Sometimes called disklabels.  
    * `fdisk` has other programs in the same family for editing GUID Partition Tables (GPT): 
        * `cgdisk`: Curses-based GPT editor 
        * `gdisk`: Non-curses-based, feature-rich GPT editor
        * `sgdisk`: GPT editor driven via command-line options.






---  





Get information about the PVs, VGs, and LVs:  
* `pvs` - physical volumes  
* `vgs` - volume groups  
* `lvs` - logical volumes  
Get more verbose information about the PVs, VGs, and LVs:  
* `pvdisplay` 
* `vgdisplay`
* `lvdisplay`

## Logical Volume Management  
At a high level, Logical Volume Management (LVM) is a way to aggregate multiple physical volumes into a single  
logical volume (a single block device) where data can be stored.  

* Logical Volume Management (LVM) is way to turn raw disks into a more manageable format. 
    * **Raw disks** are loaded into LVM with `pvcreate`   
        * `pvcreate` gives permission to LVM to use these disks.  
        * These will now be **physical volumes**.  
    * The physical volumes are aggregated (grouped) with `vgcreate`
        * All those disks will then be part of the same **volume group**.  
    * The physical volumes in the volume group are then turned into logical volumes `lvcreate`  
        * The logical volume is then formatted with `mkfs`  
        * `ext4` and `xfs` are the most common file system formats.  
        * Once created, logical volumes will show up in `/dev/mapper/myvg-mylv`,
          or `/dev/myvg/mylv` (depending on which version of Linux you're using).  
    * Finally, the logical volume is mounted with `mount`


```bash  
mkfs.xfs /dev/xvda  # create a new file system (using the disk /dev/xvda)  
mkdir /space 
mount /dev/xvda /space # Mount the new file system, the mount point is /space  
cd /space  
lsof .  
umount /space # error, since it's in use. "target is busy"  
cd /tmp  
umount /space # now works  
```
When formatting a new file system, it does not actually remove any data.  
It removes the inode pointers to all the data on that block device, and uses it's own inode format. 




### LVM Step by Step  

LVM starts with turning **raw disks** into **physical volumes**.  
Then, those physical volumes are aggregated into a **volume group**.  
The storage space of all the disks in the volume group can then be used by a **logical volume**.  
That logical volume is then formatted with `mkfs` and mounted with `mount`.  
Each logical volume is considered a single block device, and can be resized without damaging the data it contains.  

---  
Terms:  
* **Raw disks** are unformatted, unpartitioned disks that are available for use in the LVM setup.  
    * Before raw disks can be used by LVM, they are initialized as **physical volumes (PV)** using `pvcreate`.  
    * `pvcreate` gives permission to LVM to use these raw disks as storage devices.  
    * E.g.:  
        ```bash  
        sudo pvcreate /dev/sdb /dev/sdc  
        ```
        This initializes `/dev/sdb` and `/dev/sdc` as physical volumes.  
    * Once physical volumes are created, they lose their original file systems and are 
      treated as chunks of storage.  
    * View details of your physical volumes with `pvs` and `pvdisplay`.  

* Once physical volumes are created, they are aggregated (grouped) together into 
  a **volume group (VG)** using `vgcreate`.  
    * A volume group is essentially a pool of storage made up of the physical volumes created with `pvcreate`.  
    * You can allocate space from this group when creating logical volumes.  
    * E.g.:  
        ```bash  
        sudo vgcreate my_volume_group /dev/sdb /dev/sdc  
        ```
        This creates a volume group named `my_volume_group` that includes `/dev/sdb` and `/dev/sdc`.  
    * Multiple physical volumes can be grouped together in a volume group, providing larger, unified storage area.  
    * View details of your volume groups with `vgs` and `vgdisplay`.  

* The next step is to create **logical volumes (LV)** from the volume group using `lvcreate`. 
    * Logical volumes act like partitions inside a volume group, but they are much more flexible because you can resize them on the fly and span them across multiple physical volumes.  
    * E.g.:  
        ```bash  
        sudo lvcreate -L 50G -n my_logical_volume my_volume_group  
        ```
        This creates a 50GB logical volume named `my_logical_volume` from the `my_volume_group` volume group.  
    * View details of your logical volumes with `lvs` and `lvdisplay`.  


* Once the logical volume is created, it needs to be formatted with a filesystem so it can be used to store data.  
  This is done with `mkfs`.  
    * The most common filesystems on the industry-level are `ext4` and `xfs`. 
    * E.g.:  
        ```bash  
        sudo mkfs.ext4 /dev/my_volume_group/my_logical_volume  
        ```
        This formats the logical volume with the `ext4` filesystem.  


* After formatting, the logical volume is ready to be mounted and used like any other filesystem.  
    * E.g.:  
        ```bash  
        sudo mount /dev/my_volume_group/my_logical_volume /mnt/my_mount_point  
        ```
        This mounts the logical volume to `/mnt/my_mount_point`.  


#### LVM Tools
Tools for managing Physical Volumes, Volume Groups, and Logical Volumes (PV, VG, LV):
* `lvmdiskscan`: Displays all storage devices
* `vgscan`: Scans all physical devices, searches for VGs
* `pvdata`: Displays debugging information about PV, reads VGDA
* `pvscan`: Scans PVs and displays active
* `pvcreate`: Creates a PV from 8e type partition
* `vgcreate`: Creates VG using PVs
* `pvmove`: Moves data from one PV to another inside one VG
* `vgreduce`: Removes PV from VG
* `pvdisplay`: Displays information about physical volumes
* `vgdisplay`: Displays information about volume groups
* `lvdisplay`: Displays information about logical volumes
* `vgchange`: Activates or deactivates VG
* `vgexport`: Makes VGs unknown to the system, used prior to importing them on a different system
* `vgimport`: Imports VG from a different system
* `vgsplit`: Splits PV from existing VG into new one
* `vgmerge`: Merges two VGs
* `lvcreate`: Creates LV inside VG
* `lvextend`: Increases the size of LV
* `lvreduce`: Decreases the size of LV





### Implementing RAID on Logical Volumes with mdadm

If redundancy or performance is a concern, you can configure RAID (Redundant Array of 
Independent Disks) using a tool like `mdadm` (Multiple Disk Admin). 
RAID and LVM are separate technologies.  

* RAID provides redundancy and performance benefits, while LVM provides flexibility in managing storage. You can use them together, but they serve different purposes.  
* Example (creating RAID 1 for redundancy):  
    ```bash  
    sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb /dev/sdc  
    ```
    This creates a RAID 1 array (mirrored) with `/dev/sdb` and `/dev/sdc`.  
    Then you can use `md0` as a physical volume in your LVM setup.  

### Resizing Logical Volumes  
One of LVM's best features is the ability to resize logical volumes dynamically.  
You can both extend or reduce the size of a logical volume.  
This is a major advantage, because you can resize a logical volume without disrupting  
the data on the volume.  

* To extend a logical volume, use `lvextend` and `resize2fs`:  
  ```bash  
  sudo lvextend -L +20G /dev/my_volume_group/my_logical_volume  
  sudo resize2fs /dev/my_volume_group/my_logical_volume  
  ```
* To reduce the size of a logical volume, it's a bit more complicated. You need to  
  unmount the filesystem first. 
    * Be careful when doing this, you could lose data if you reduce it too much.  

### LVM Snapshots  
LVM supports snapshots, which allow you to capture the state of a logical volume at a  
given point in time. 
This could be extremely useful for backups, disaster recovery, or testing.  

To create a snapshot, use `lvcreate` with the `--snapshot` option.  
* Example of creating a snapshot:  
  ```bash  
  sudo lvcreate --size 1G --snapshot --name my_snapshot /dev/volume_group/logical_volume  
  ```

### Creating a Logical Volume from Raw Disks  
```bash  
fdisk -l | grep -i xvd  # See all xvd-type raw disks  
vgcreate vg1 /dev/xvdb /dev/xvdc  # Make a volume group called vg1, with the two physical volumes xvdb and xvdc  
pvs # Show all physical volumes  
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





## Lab and Assignment  
Unit3_ProLUG_LVM_and_RAID - To be completed outside of lecture time  
    Start thinking about your project ideas (more to come in future weeks):  
        Topics:  
1.  System Stability  
2.  System Performance  
3.  System Security  
4.  System monitoring  
5.  Kubernetes  
6.  Programming/Automation  

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.  
### Digging Deeper  
1.  If uptime is so important to us, why is it so important to us to also understand how our systems can fail? Why would we focus on the thing that does not drive uptime?  

If uptime is important, it's important to understand how our systems can fail so that we can take measures to prevent them from failing. Or, if they do fail, we can understand how to fix the failing components. Understanding which parts of a system are more likely to fail can also help; we can take measures to create redundant backups of parts of the system that are more likely to fail to ensure maximum uptime. 
I'd argue that system failures *can* drive uptime in this way.  


2.  Start reading about SLOs: https://sre.google/workbook/implementing-slos/  
How does this help you operationally? Does it make sense that keeping systems within defined parameters will help keep them operating longer?  

Having SLOs will help us know when we need to take action to keep our systems operating within the defined parameters. It does make sense that having a set of performance objectives can help them operate longer if those objectives have been proven to be reasonably achievable under normal circumstances. With proper monitoring we can know how, when, and what parts of the systems we need to work on, and why we need to work on them.  


## Reflection Questions  
1.  What questions do you still have about this week?  

Once a logical volume is created, how can it be reverted back to its original form (raw disks)?



2.  How are you going to use what you’ve learned in your current role?  

I'm not working, but I'll be using this knowledge to further my goal of become a systems engineer.  



