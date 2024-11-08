
# ProLUG 101  
## Unit 2 Worksheet  

## Table of Contents
* [Unit 2 Worksheet](#unit-2-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 1 Discussion Post 1: Think about how week 1 went for you.](#unit-1-discussion-post-1-think-about-how-week-1-went-for-you) 
    * [Unit 1 Discussion Post 2](#unit-1-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 

## Instructions  
Fill out this sheet as you progress through the lab and discussions. Turn in the sheet to scott.champine@simple2serious.com for grading and feedback.  

## Discussion Questions:  

### Unit 1 Discussion Post 1: Think about how week 1 went for you.  
1.	Do you get everything you needed to done?  
 
I think so! 

2.	Do you need to allocate more time to the course, and if so, how do you plan to do it?  
 
Yes, I've found that I cannot move forward until I understand a command; what it's
doing, why, and how it works. I quickly fall behind during the lecture, so I need to 
spend more time on the recordings to fully understand what is going on.  

3.	How well did you take notes during the lecture? Do you need to improve this?  
 
I take a lot of notes, but not very quickly. I think that's why I need to spend more 
time on the recordings. I think I'd also benefit from coming up with a shorthand for
note taking. 


### Unit 1 Discussion Post 2: 
Read a blog, check a search engine, or ask an AI about SELINUX.  
What is the significance of contexts? What are the significance of labels?  

Security contexts are significant for SELinux-enabled systems. These contexts are used to set permissions for files and directories, and decides how users and processes can interact with these files. Contexts will allow certain files to only be accessible by the processes that need to interact with them.

---

Scenario:  
You follow your company instructions to add a new user to a set of 10 Linux servers.  
They cannot access just one (1) of the servers.  
When you review the differences in the servers you see that the server they cannot access is running SELINUX.  
On checking other users have no problem getting into the system.  
You find nothing in the documentation (typical) about this different system or how these users are accessing it.  
What do you do? Where do you check? (you may use any online resources to help you answer this.  
This is not a trick and it is not a “one answer solution”.  
This is for you to think through.)  

Answer:  
* I check if SELinux is enabled on the accessible servers for this user. 
* I look for any other differences between that server and the other servers. 
* I check if the SELinux user is different for the other users.  
  ```bash
  semanage login -l
  ```
* I check if the user is part of a different group than the other users who can
  access the server (checking if it's actually SELinux that is the cause). 
  ```bash
  groups problem_user
  groups other_user
  ```
* I look for any other differences between the problem user and the others.  
* I check the conditions in the environment the problem user is running in, and how
  they might differ from other users.


## Definitions/Terminology  

* Uptime – The amount of time since the last reboot  
    * To check how long the system has been running:  
      ```bash  
      uptime  
      ```
    * Useful for monitoring system stability and availability  
* Standard input (stdin) - The file descriptor `0`, used for input, usually from the  
  keyboard or another command.  
* Standard output (stdout) - The file descriptor `1`, used for output from a command  
* Standard error (stderr) - The file descriptor `2`, used for error messages  
* Mandatory Access Control (MAC) - Security model where permissions are set by the  
  system, not by individual users. 
    * With MAC, admins define rules based on security labels (with SELinux or AppArmor)  
    * SELinux: Controls access based on predefined policies. 
    * AppArmor: Enforces restrictions using profiles.  
    * To check if SELinux is enforcing:  
      ```bash  
      getenforce   # check if SELinux is enforcing  
      ```

* Discretionary Access Control (DAC) - Security model where users and process owners 
  control access to their resources (files/directories, etc).  
    * You'd use `chmod` to change permissions on a DAC-based security model.  
      ```bash  
      chmod 755 somefile  
      ```
* Security contexts (SELINUX) - A second layer of permissions used when SELinux is  
  enabled. Shown as `user:role:type:level`
    * An SELinux Context is a rule that defines access permissions for files/directory.  
    * It consists of 4 parts:  
        * User: SELinux user identity.    
            * This is not the same as a Linux user. It's an SELinux-specific user that 
              processes and objects are assigned to.  
            * E.g., `system_u` represents system processes.  
        * Role: This defines what a user or process is allowed to do on the system.  
            * E.g., `object_r` for files and directories, `system_r` for system processes.  
        * Type: Defines what a process can interact with.  
            * Processes are labeled with a type, and files/resources are labeled with  
              a different type.  
            * SELinux policies decide which types can access or interact with each  
              other. This is called the "type enforcement".  
        * Level  
    * To check the context of files with `ls -Z`:  
      ```bash  
      ls -Z /etc/passwd  
      ```
        * Output:  
          ```plaintext  
          system_u:object_r:passwd_file_t:s0 /etc/passwd  
          ```
        * `system_u`: System user  
        * `object_r`: The role, usually `object_r` for files and directories  
        * `passwd_file_t`: 

* SELINUX operating modes - The different modes at which SELinux enforces its rules.
    * Disabled
        * The system does not enforce SELinux policies, and it does not label any persistent 
          "objects" (files, directories, etc.) with a context.
    * Permissive
        * The system acts like SELinux is enforcing the policies set.
          It labels objects, and logs access denial entries in the logs, but
          it doesn't actually deny any operations. It's like a dry run.
    * Enforcing
        * Enforcing mode is the default. It enforces all the SELinux policies and labels objects.


## Notes During Lecture/Class:  
### Links:  
Where to find logs:
* DEB : 
    * `/var/log` (for system and application logs in diff files)
    * `var/log/syslog` (for aggregate) 
    * `dmesg` (for kernel ring buffer)
    * https://www.linuxfoundation.org/blog/blog/classic-sysadmin-viewing-linux-logs-from-the-command-line
* RHEL : 
    * `syslog` 
    * `rsyslog` (for backward compat) 
    * `journalctl` to query systemd-journald (for aggregate)
    * https://www.redhat.com/sysadmin/rsyslog-systemd-journald-linux-logs 


### Terms:  
LSM (Linux Security Module)
DAC (Discretionary Access Control)
MAC (Mandatory Access Control)
SELINUX
DHCP 
BOOTP  
Inventory  


### Useful tools:  
* `df` / `df -h`
* `vmstat`
* `nproc`
* `free`
* `uptime`
* `top`
* `iostat`
* `usermod`
* `semanage`
* `chcon`
* `restorecon`
* `audit2allow`
* `ps`
    * `ps -e` is "standard" syntax to see all processes.  
    * `ps aux` is BSD syntax (BSD options don't have a `-`)
        * `ps au` shows only proccesses that have a TTY (run in a shell)
    * To get security info:
        * `ps -eo euser,ruser,suser,fuser,f,comm,label`
        * `ps axZ`
        * `ps -eM`
    * To just get the SELinux labels:
        * `ps -eo label`

---  

## Lab and Assignment  
Unit2_ProLUG_LabEssentials2 - To be completed outside of lecture time  
	Compare SELINUX to Apparmor, following the below 2 tasks: 
a.	Read this article: https://www.redhat.com/sysadmin/apparmor-selinux-isolation  
b.	Do this lab: https://killercoda.com/killer-shell-cks/scenario/apparmor  

---

* AppArmor:
    * Isn't label-based like SELinux is.  
    * Uses security **profiles**, which are like SELinux security policies. 
        * Check profiles with `apparmor_status`
    * Controls fewer operations, which makes it less complicated
    * Does *not* have Multi-Level Security (MLS) or Multi-Category Security (MCS).
    * Not possible to keep separation between containers.
        * Separates containers from the host, but the policy is loose
        * Separation between each container is not possible due to lack of MCS.  

* SELinux:
    * Separates containers from each other *and* the host filesystem by default.  

* Both support a Type Enforcement security model, 
    * This is a type of MAC based on rules where users and processes are allowed to 
      access "objects" (files/dirs/sockets). 

* Key Differences:
    * AppArmor does not have MCS/MLS, SELinux does
    * AppArmor cannot separate containers from each other, SELinux does by default.  
    * AppArmor is more user-friendly, SELinux is more complicated 

---

Start thinking about your project ideas (more to come in future weeks):  
		Topics:  
1.	System Stability  
2.	System Performance  
3.	System Security  
4.	System monitoring  
5.	Kubernetes  
6.	Programming/Automation  

You will research, design, deploy, and document a system that improves your 
administration of Linux systems in some way.  

---  

## Digging Deeper  

1.	How does troubleshooting differ between system administration and system engineering? To clarify, how might you troubleshoot differently if you know a system was running v. if you’re building a new system out?  

Troubleshooting as an admin, you're coming to a system that was working properly before.  
As an engineer, you're building out a new system that you need to troubleshoot.  


2.	Investigate a troubleshooting methodology, by either google or AI search.  
    Does the methodology fit for you in an IT sense, why or why not?  

Troubleshooting methodology:
1. Define the problem
    * Ask questions like "what's working? what are the symptoms?"
    * Gather info via logs, system info, user feedback, etc.
    * Define the scope by identifying what is affected (a single user, a single
      system, etc) 
2. Reproduce the problem 
    * Try to recreate the problem by following the same steps as the user(s) who
      encountered it. 
    * Try to indentify the conditions in which the problem occurred. 
3. Establish a theory of probable cause
    * Based on the information gathered in the previous steps, start trying to
      identify the cause of the problem. 
    * Break the problem down into smaller pieces. Is it hardware, software,
      networking, permission, misconfiguration, etc?
4. Test the theory
    * Test small, simple solutions to verify or disprove your theory.  
    * If the theory proves wrong, go back to step 3.  

This methodology fits for troubleshooting in IT - it's a structured way to troubleshoot a problem. It takes into account different aspects of what could cause a problem, breaks it down into logical pieces, and tests those pieces to verify or disprove your theory as to what the problem is. This works for me because it's a structred way to troubleshoot a problem, and it's a way that I've done it in software development. 



## Reflection Questions  

1.	What questions do you still have about this week?  

We talked about having another method to turn on a server that was shut off (other 
than physically). I'm wondering what those methods are.

iDRAC was mentioned, and the refurbished server that I bought recently to use as a 
homelab (Dell PowerEdge R730) has an iDRAC interface. I'm interested in learning what 
it actually is, how to use it, and I'm wondering if there's a way to turn it on 
remotely.  


2.	How are you going to use what you’ve learned in your current role?  

I'm not working in a role (disabled), but I will use these skills to work towards my goal of
becoming a Linux systems engineer.


