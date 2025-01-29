# ProLUG 101  
## Unit 5 Worksheet  



## Table of Contents  
* [Unit 5 Worksheet](#unit-5-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 5 Discussion Post 1](#unit-5-discussion-post-1) 
    * [Unit 5 Discussion Post 2](#unit-5-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Users and Groups](#users-and-groups) 
    * [Scanning and Enumerating systems](#scanning-and-enumerating-systems) 
        * [Types of network scans](#types-of-network-scans) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper](#digging-deeper) 


## Instructions  
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.  

## Discussion Questions:  
### Unit 5 Discussion Post 1  
Review the page: https://attack.mitre.org/  
1. What terms and concepts are new to you?  
I'm familiar with most of the concepts here, but not all of the terminology:  
Persistence - Techniques that an attacker would use to *keep* access to systems across restarts, changed credentials, etc.  
Defense Evasion - Techniques that an attacker would use to avoid detection from security tools and personnel.  
Lateral Movement - Techniques that an attacker would use to gain access to, and control, systems on a network.  

2. Why, as a system administrator and not directly in security, do you think it’s so important to understand how your systems can be attacked? Isn’t it someone else’s problem to think about that?  

It's important for an administrator to understand the attack vectors of a system so that we can minimize the attack surface when setting up the system.  
If we don't know how our systems can be attacked then we won't be ready for the recovery procedure if an attack does happen. We won't know where to look, what to look for, or how to respond.  
Even if a system administrator does not have "security" in their title, they are still responsible for protecting the system. Everyone in tech, no matter the role, is at least partially responsible for security.  


3. What impact to the organization is data exfiltration? Even if you’re not a data owner or data custodian, why is it so important to understand the data on your systems?  

Data exfiltration is a major problem for organizations. If data is exfiltrated, then that company needs to tell the owner that their data has been stolen, and can hurt the company's reputation, and possibly lose business.  
Not being the owner or keeper of the data doesn't mean we shouldn't be concerned about protecting it. If data is stolen, there's sure to be some sort of reprocussions for all those who were responsible for keeping the system secure.  


### Unit 5 Discussion Post 2
Find a blog or article on the web that discusses the user environment in Linux. You may want to search for .bashrc or (dot) environment files in Linux. 
1. What types of customizations might you setup for your environment? Why?  

Setting certain shell options can help you navigate the filesystem and find files  
more quickly.  
E.g., setting `shopt -s globstar` will allow you to recusively search directories with `**`:  
```bash  
ls **  
```

Adding aliases and functions can also help save time and make your life easier when trying to carry out more complex tasks.  
For example, using aliases to add color to commands that support it, (e.g., `alias ls='ls --color=auto'`) makes it more readable and easier to parse (imo).  
If you're so inclined, customizing the shell prompt can make it more pleasant to look at for longer periods of time. This can be done by modifying the `PS1` environment variable.    
If you want to install a specific version of a tool, writing a function or script to download and compile it can be a convenient way to do it.  



2. What problems can you anticipate around helping users with their dot files?  

I imagine some people set weird environment variables that could cause problems.  
Some custom functions may affect their ability to use the shell.  
Depending on how they *manage* their dotfiles, if they have a custom tool they built to place them where they need to be via symlinks, it may overwrite existing files that need to be there for things to work properly.  
If a user doesn't really understand bash and tries to customize their environment with a bunch of plugins, it may not end very well.  


## Definitions/Terminology  
* Footprinting: Gathering information about a target system or network.  
    * Use tools like `nmap` and `netstat`/`ss` to find open ports and services.  
* Scanning: Probing a system or network using tools like `nmap` to find open ports and services, and find potential points of entry.  
* Enumeration: Extracting more detailed information about a target system or network: user accounts, shared resources and privileges, and other sensitive information.  
    * Emnumeration involves querying services like SMB, LDAP, and NFS.  
    * These services can reveal usernames, group memberships, and shared files/directories.  
        * SMB (Server Message Block)  
            * A network protocol mainly used for providing shared access to files, printers, and other network resources on Windows systems.  
            * Often used in mixed OS environments, where Linux systems need to access  
              Windows resources.  
        * LDAP (Lightweight Directory Access Protocol)  
            * A protocol used for accessing and managing directory information services. Directories often contain information about users, groups, and devices in a network.  
            * Used for "authentication and directory services" on multiple platforms,
              not just Linux.  
            * Can be implemented on Linux servers (`OpenLDAP`) or on Windows (`Active Directory`).  
        * NFS (Network File System): 
            * A protocol used for file sharing in Linux and Unix environments.  
            * Allows a system to access files over a network as if they were on a local disk.  
            * Often used in enterprise environments to share data between servers.  
            * Mostly used in Linux/Unix environments, but can be accessed from  
              Windows if NFS services are enabled.  
* System Hacking: Getting unauthorized access to a system, usually by exploiting a vulnerability.  
* Escalation of Privilege: The act of getting higher level access in a system. 
    * E.g., logging in as a normal user, *then* escalating privileges to root with `sudo -i` or `sudo su`. 
    * On systems that you don't have root credentials for, you'll need to be more creative in order to escalate privileges.  
* Rule of least privilege: A security principle that involves granting users and processes the minimum level of access they need in order to do what they need to do.  
    * i.e., giving a user *only* the permissions they need in order to do their work.  
* Covering Tracks: Taking actions to hide evidence of unauthorized activities on a system.  
    * This can involve clearing logs, modifying timestamps, or deleting temporary files to prevent detection.  
    * Tools like `logrotate` can be configured to securely manage logs and detect tampering.  
* Planting Backdoors: Creating a hidden method of gaining access to a system in the future.  
    * Backdoors can be things like hidden user accounts, modified file systems, open network ports, etc.. 
    * These are used by an attacker to re-enter the system without detection.  



## Notes During Lecture/Class:  

### Users and Groups:  

Creating new users on clusters:  
* Users should be generated on your cluster manager and fed down to all the nodes, so  
  that if a user is created on one system, it will also exist on all the other nodes.  


Main user files:  
* `/etc/passwd`
    * Users are stored in this file in the format:  
      ```plaintext  
      username:password:user_id:group_id:user_info:home_dir:login_shell  
      ```
        * The `password` field usually has an `x` (if a password exists).  
* `/etc/group`
    * Groups are stored in this file as:  
      ```plaintext  
      group_name:password:group_id:group_members  
      ```
        * Just like `/etc/passwd`, the `password` field usually has an `x` (if a password exists).  

* `/etc/shadow`
* `/etc/gshadow`
* `/etc/login.defs`
* `/etc/skel`
* `/etc/sudoers`
* `/etc/sudoers.d/`  
Permissions:  
```bash  
-rw-r--r--. 1 root root 3435 Oct 17 16:59 /etc/passwd  
-rw-r--r--. 1 root root 1399 Oct 17 16:59 /etc/group  
----------. 1 root root  614 Jul  8 01:06 /etc/shadow  
----------. 1 root root  361 Jul  6 05:16 /etc/gshadow  
-rw-r--r--. 1 root root 7778 Oct 30  2023 /etc/login.defs  
```

Passwords are hashed into `/etc/shadow` based on the algo in `/etc/login.defs`.  
They're never stored in `/etc/passwd`.  
```bash  
grep -i 'encrypt_method' /etc/login.defs  
```

When a user is created, the default files are pulled from `/etc/skel` and put in the
new user's home directory.  



### Scanning and Enumerating systems:  
* `nmap` (Network Mapper) is the tool of choice for scanning and enumerating systems.  
    * `nmap` can usually tell you the type of OS of a machine based on the ports that are open.  
      ```bash  
      nmap -O 192.168.1.100  # Check if the IP is up, and guess the OS of the host.  
      ```

#### Types of network scans  
* Network scan (sweep a range): Scanning a range of IP addresses to see what is up and what isn't.  
    * Ping sweeps: Scanning a range of IP addresses with an ICMP `ping` to see if  
      they are alive and reachable. This identifies systems that are up and responding.  
    * In a network scan, you're querying all devices within the specified range to identify active systems and map the network.  
    * Example:  
      ```bash  
      nmap -sn 192.168.1.0/24    # Perform a ping sweep across the entire subnet  
      ```


* Targeted Scan (deep scan of a single device): A more focused scan on a specific host or IP address.  
    * Targeted scans examine TCP and UDP ports (usually between 1-65534, leaving out 0 and 65535) to identify open ports and active services.  
    * Deep scan: Scanning all ports on a single host to gain as much information as possible about the system.  
    * Fuzz scan: Attempting various unexpected inputs on ports and services to see if they are vulnerable to attacks.  
    * Example:  
      ```bash  
      nmap -A 192.168.1.5    # Perform an aggressive scan on a specific IP (OS detection, version detection, script scanning)  
      ```

* Writing a report about the data  
    * After scanning, it's very important to document findings. IP addresses,
      hostnames, open ports, services, and potential vulnerabilities should all be  
      documented.  
    * To be safe, take notes on everything you find.  
    * A report can serve as a reference for remediation or further investigation.  

* Collect hostnames and IP addresses  
    * Collect the hostnames and IP addresses of systems on the network.  
        * This information can be gathered through DNS lookups (`dnslookup`), reverse DNS, or by examining response headers during scans.  
    * Example:  
      ```bash  
      nmap -sL 192.168.1.0/24    # List hosts in the network range (no scan)  
      ```

5. Open ports and services:  
    * Enumerating open ports and identifying running services can reveal vulnerabilities or misconfigurations.  
    * This can also indicate which services are exposed to the network and accessible from external sources.  
   * Example:  
     ```bash  
     nmap -sV 192.168.1.5    # Service version detection on open ports  
     ```

* Utilize output options in `nmap` to save scan results in various formats:  
  ```bash  
  nmap -oA fullscan 192.168.1.0/24    # Output in all formats: XML, Nmap, and Grepable  
  ```
* To avoid detection, use options like `--scan-delay` to slow down scans, reducing 
  the likelihood of triggering intrusion detection systems (IDS).  






---  

### Links:  
https://www.sans.org/blog/the-ultimate-list-of-cheatsheets  
https://assets.contentstack.io/v3/assets/blt36c2e63521272fdc/blte37ba962036d487b/5eb08aae26a7212f2db1c1da/NmapCheatSheetv1.1.pdf  


### Terms:  
* Problem exists between keyboard and chair.  
* White Box Scan:  
    * You have full knowledge about the target system before the scan. IP addresses, 
      network layout, and system configurations.  
    * Typically done internally.  
* Black Box Scan:  
    * You have no prior knowledge about the target system.  
    * This simulates an external attacker's perspective (trying to discover as much as possible without insider information).  
* Grey Box Scan:  
    * You have *some* knowledge about the target system.  
    * E.g., you may know IP addresses or some limited access credentials.  
    * This simulates an internal attacker's perspective.  
* ACL (Access Control List): 
    * A list of rules that controls permissions for access to files and directories on a system.  
    * Use `getfacl` and `setfacl` (part of the `acl` package) to view and modify ACLs.  
    * Default ACLs can be set on directories to apply to any new files created inside them  


### Useful tools:  

* `cat /etc/services`
* `useradd`
* `nmap`
    * `nmap -sC`: Run a default script scan on the target system (same as `-script=default`)  
        * Other Lua scripts can be used with `-script=<lua scripts>` (`man://nmap 127`)  
    * `nmap -sV`: Service version detection on open ports  
    * `nmap -p-`: scan ports from 1 through 65535. Scanning port zero is allowed if you specify it explicitly.  
    * `curl cht.sh/nmap`
    * `tldr nmap`
* `nc` (netcat)  
* `arp` (address resolution protocol)  
* `ss -ntulp`: List open ports and associated processes  

---  


Logs on rocky systems  
```plaintext  
/var/log/secure  
/var/log/messages  
```

Logs on debian-based systems:  
```plaintext  
/var/log/syslog  
/var/log/auth.log  
```

## Lab and Assignment  
Unit 5 Manage Users and Groups - To be completed outside of lecture time  
	Map the Internal ProLUG Network (192.168.200.0/24):  
1. Map the network from one of the rocky nodes.  
Using a template that you build or find from the internet, provide a 1 page summary of what you find in the network.  
 
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
1.	Read 

Reflection Questions  
1.	What questions do you still have about this week?  

Are Access Control Lists common (or used at all) in enterprise environements?  

2.	  




