# ProLUG 101  
## Unit 4 Worksheet  


## Table of Contents
* [Unit 4 Worksheet](#unit-4-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 4 Discussion Post 1](#unit-4-discussion-post-1) 
    * [Unit 4 Discussion Post 2](#unit-4-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 


## Instructions  
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.  

## Discussion Questions:  
### Unit 4 Discussion Post 1:  
 
Read this article: https://cio-wiki.org/wiki/Operations_Bridge  

1. What terms and concepts are new to you?  
    * Operations bridge: A centralized platform used for monitoring and managing infrastructure and services.  
        * Used to consolidate and correlate data from multiple sources:  
            * Infrastructure components (hardware)  
            * Applications/services  
            * Logs  
            * Events  

2. Which pro seems the most important to you? Why?  

Out of the many pros listed in the article, one of the most important seems (to me) to be proactive monitoring and issue resolution.  
If we have the ability to detect potential issues before they escalate into incidents, then those potential incidents can be avoided, providing a method of incident mitigation.   
Honorable mention to the automation capabilities that an operations bridge can provide.  


3. Which con seems the most costly, or difficult to overcome to you? Why?  

The con that seems the most costly for an operations bridge is that it requires regular updates and maintenance.  
This is because maintenance and updates could affect uptime and availability, and potentially hinder the admin's capabilities of handling incidents if they're relying on the operations bridge to carry out tasks.  
The most difficult to overcome may be the initial setup and configuration of the operations bridge. All the capabilities it provides means there are a lot of moving parts, and I imagine setting that up can be a daunting task.  



### Unit 4 Discussion Post 2:  
 
Your team has no documentation around how to check out a server during an incident.  
 
Write out a procedure of what you think an operations person should be doing on the 
system they suspect is not working properly.  
 
This may help, to get you started 
(https://zeltser.com/media/docs/security-incident-survey-cheat-sheet.pdf?msc=Cheat+Sheet+Blog)  
You may use AI for this, but let us know if you do.  


Indentify the scope of the issue; is it a security incident or a local issue?  
For the sake of this discussion, I'm going to assume it's a potential security issue.  
If there's a server acting unusual:  

* Don't do anything that may alert an attacker.  
* If there's ANY suspicion of a security incident, continue without accessing many 
  files or installing new tools to retain the attacker's footprints.  

1. Gather data  
    * Check system logs, security logs, and application logs for unusual events.  
    * Check all your normal system health indicators: uptime, load, memory, disk space, etc.  
    * Check network configuration and connections. Take note of unusual settings, connections, or ports.  
      ```bash  
      # Network configuration:  
      netstat -nr  
      arp -a  
      # Network connections  
      netstat -nao  
      netstat -vb  
      # Ports  
      netstat -ultnp  
      ss -ultnp  
      ```
        * If you have a network sniffer (e.g., wireshark, tcpdump) already installed or otherwise available, use it to look for suspicious activity.  
    * Check the list of users for accounts that do not belong there.  
      ```bash  
      cat /etc/passwd  
      users  
      groups  
      ```
    * Check running processes and scheduled jobs. Take note of any that don't belong there.  
      ```bash  
      # Check scheduled jobs  
      cat /etc/crontab  
      ls /etc/cron*  
      # Check running processes  
      ps -ef  
      ps aux 
      ```
    * Look for files that don't belong there. Check for files created recently.  
      ```bash  
      find /bin -ctime -1  # Find files in /bin that were changed in the last day  
      find /etc -ctime -1  
      find /dev -ctime -1  
      ```

2. Decide whether or not to escalate the issue. 
    * If you think there's a potential security incident, escalate the issue to the appropriate parties.  
    

## Definitions/Terminology  
* Detection: When an issue is detected and an admin is alerted. Drives MTTD.  
* Response: The actions taken when an incident occurs: triage, investigation, containment, and analysis & tracking. 
* Mitigation: Limiting the damage that an incident inflicts by reducing the scope of the issue, or by preventing the issue from happening in the first place.  
* Reporting: The process of notifying the appropriate parties of an incident 
* Recovery: The plan of action to take in order to get the system back to running at  
  the level it was before (handling the load it was before, at the functional  
  requirements)  
    * Functional and non-functional requirements (for a web server):  
        * Functional requirements: Can the web server respond to an API call in less than 100ms? (i.e., if it passes all the tests we need it to pass locally)  
        * Non-functional requirements: Can the web server handle 5k concurrent connections like it could before? (i.e., "how it behaves in the wild")  
* Remediation: The actions taken to completely resolve the root cause of the incident. 
    * E.g., patching vulnerabilities, updating configurations, or implementing additional controls to prevent the incident from reoccuring.  
* Lessons Learned: Analyzing the incident and extracting the lessons we can learn 
  from the incident, and how we can improve the system to avoid similar incidents in the future.  
* After action review: A structured review process conducted after the incident was  
  resolved to evaluate what happened, why it happened, and how to improve.  
* Operations Bridge: A centralized platform used for monitoring and managing infrastructure and services.  


## Notes During Lecture/Class:  
Timestamp everything! 
Take notes about every action you take, and get things in writing whenever possible.  
Test your assumptions about your system  

If you reboot a system yourself either inside a "change window" or during the  
recovery phase of a larger incident, it is not considered an incident. Otherwise, any 
unplanned reboot is considered an incident.  

### Links:  
https://github.com/dokksterr/linux-hardening-checklist  
https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/  
https://www.sans.org/information-security-policy/  
sans.org - security policy templates  
https://www.sans.org/posters  

### Terms:  
* Redlining: Take someone who's never seen a project before and run them through it.  
    * Smoothing docs to make sure no one can mess it up.  

* Incident response lifecycle:  
    * Response capability (Policy, procedure, a team)  
        * This is handled before an incident happens.  
        * A team needs to be defined beforehand  
    * Invident response and handling (triage, investigation, containment, and analysis 
      & tracking)  
    * Recovery (recovery / repair)  
    * Debriefing  
* Incident bridge  
* Stateful node: A node that has persistent states (services will not be reset on reboot)  
* Stateless node: (services will not be reset on reboot)  


### Useful tools:  

* `rmp`: Rocky package manager  
    * `rpm -qa`: List all installed packages.  
    * `rpm -qi <package>`: Show information about a package.  
* `dnf`: Installer for packages on rocky linux  
    * `dnf whatprovides <command>`: Find out what package provides a command.  

* `inotify-tools`:  
    * `ionotifywait -m /path/to/monitor`: Monitor a file or directory for changes.  
    * `iowait`
    * `ionotify`

* `systemctl`: System and service manager  
  ```bash  
  systemctl status service  # Show the status of the service  
  systemctl status sshd  
  systemctl list-units --state=failed  
  ```
    * `systemctl list-units --state=failed`: Lists if any units (e.g., systemd processes) came up and broke when they tried to start on the system.  
* `systemd-analyze`: Analyze system startup time  
  ```bash  
  systemd-analyze blame # Show what service takes the longest to start  
  systemd-analyze critical-chain sshd.service # Show the "critical path" to sshd.service  
  ```
    * The `critical-chain` subcommand will show the "critical path" to a service. The 
      critical path is the shortest path from a service to the target service.  
      In other words, it will show all the other services (dependencies) that needed to be 
      started before the target service could be started.  
    
      


General system info:  
* `last`: Shows who was last to log in  
    * `last | tac`: Show newest to oldest (reverse the output)  
* Show the kernel parameters that were passed to the Linux kernel at boot time:  
  ```bash  
  cat /proc/cmdline   
  # Output: BOOT_IMAGE=/vmlinuz-5.15.0-122-generic root=/dev/mapper/ubuntu--vg-ubuntu--lv ro  
  ```

* `sar`: System Activity Reporter. Used to view system activity info.  
  ```bash
  sar -1  # View yesterday's system activity
  sar -o /tmp/sar.log 2 5  # Output to /tmp/sar.log, run every 2 seconds 5 times
  ```
    * `sar` is good for showing long periods of activity and system loads. It is
      *not* good for spikes or high traffic loads.  
    * This tool shows the 10 minute weighted average of the system.  


* Show information about the OS and kernel on the current system:  
  ```bash  
  cat /etc/*release  # Show the OS name and version 
  uname -r           # Show the kernel release 
  ```
* `uname -a`: Prints system information in the order:  
    * `-s`: Kernel name (Linux)  
    * `-n`: Network node hostname  
    * `-r`: Kernel release that is currently running 
    * `-v`: Kernel version that is currently running  
    * `-m`: Machine hardware name (`x86_64`)  
    * `-p`: Processor type (`x86_64`)  
    * `-i`: Hardware platform (`x86_64`)  
    * `-o`: OS name (`GNU/Linux`)  

* `grubby --default-kernel`: Shows the default kernel (the kernel that will be booted on next reboot)  
    * If `uname -r` and `grubby --default-kernel` are different, then you may need to reboot.  

* `iostat`: Part of the `sysstat` package. Shows disk and CPU statistics.  
    ```bash
    iostat -c  # Show CPU stats
    iostat -d  # Show disk stats
    iostat -xz # Show what is being used
    ```
    * `-x`: Extended statistics 
    * `-z`: Show zero values (unused devices)  
* `free -m` (memory stats)  
* `top` (h for help): An interactive process/system stat viewer.  


Network/port info:
* `ss -ntulp`: Show all open ports (which ports your system is listening on).  
    * `netstat -ntulp` also does this (`netstat` is being deprecated, use `ss`)  
* `tcpdump`: Network packet capture  
  ```bash  
  sudo tcpdump -i enp0s31f6 # Capture packets from the given network interface  
  ```


Process info:
* `ps -ef`: Shows all processes running 
    * `-e`: List everything  
    * `-f`: Show in full-format listing  
* `ps -ef | wc -l`: Count the number of running processes  
* `ps aux`  
    * `a`: Show processes from all users.  
    * `u`: User-friendly format.  
    * `x`: Include processes that aren't attached to a terminal.  


Filesystem info:  
* `df`: Filesystem disk space usage  
  ```bash  
  df -h /dev/sda  
  ```
* `du`: Disk usage of a directory or file  
  ```bash  
  du -h /home/kolkhis/notes  
  ```

* `dmesg`: Shows kernel logs  
* `dmesg | grep NET`  
* `mount`
* `mount | grep -i home`
    * `grep /home /etc/fstab` (check `f`ile`s`ystem `tab`le)  

* `cat /proc/meminfo`: Check the amount of memory (RAM) in the system
* `cat /proc/cpuinfo`: Check the CPU information
  ```bash
  cat /proc/cpuinfo | grep -i 'proc' | wc -l  # Check the number of processors in the system
  ```



---  




## Lab and Assignment  
Unit4_Lab_Operate_Running_Systems - To be completed outside of lecture time  
	Begin working on your project from the Project Guide  
		Topics:  
1.	System Stability  
2.	System Performance  
3.	System Security  
4.	System monitoring  
5.	Kubernetes  
6.	Programming/Automation  

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.  


## Digging Deeper  
1.	Read about battle drills here (https://en.wikipedia.org/wiki/Battle_drill)  
* Why might it be important to practice incident handling before an incident occurs?  

Whenever something goes wrong, it's easy to lose track of the procedure in the chaos.  
Practicing incident handling before an incident occurs can help you remember what you  
need to do, in what order, what to look for, and what to do when you find something.  
It can also be useful in helping you remember best practices, what NOT to do when an  
incident occurs.  

* Why might it be important to understand your tools before an incident occurs?  

Understanding your tools before an incident occurs is fundamental in understanding  
what tools you need to use for what tasks, and in what way to use them, to resolve an 
incident. 
If you don't understand your tools, you won't be able to use them effectively.  


## Reflection Questions  
1.	What questions do you still have about this week?  

What are the most common RAID setups in enterprise environments? 
Are RAID arrays and Logical Volumes typically used in tandem?


2.	How much better has your note taken gotten since you started? What do you still need to work on? Have you started using a different tool? Have you taken more notes?  

It's gotten a bit better - I'm still working on it. The live-lecture type of learning
is very new to me, but I'm starting to get a bit less sloppy.
I'm now writing down names of tools, terms, and phrases I'm not familiar with to look
up on my own later instead of trying to finish notes on a single topic before moving
onto the next.  



