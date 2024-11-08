# ProLUG 101

## Unit 7 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.

## Discussion Questions:
### Unit 7 Discussion Post 1
Why is software versioning so important to software security? Can you find 3 reasons, from the internet, AI, or your peers? 
1. CVEs (Common Vulnerability Exposures). These are publications on the latest known security vulnerabilities in software. It's important to make sure your software's versions are newer than the last CVEs regarding each piece of software.  
2. Compatibility. Software often pushes "breaking changes," which means that an update may contain software that could make your current configurations or dependencies on that software package obsolete. If you have written code that depends on a tool, if that tool has just pushed a critical change then it could change the way your code works. This could cause unpredictable behavior, and unpredictable code being run on your servers is always a security risk.  
3. Potential unknown security risks. If a company updates to the newest version of a software package that just dropped, there's a chance there may be some critical security vulnerability that has not been discovered yet. As long as the package version is newer than the latest CVE, there should be no need to update it if it works as intended.  


### Unit 7 Discussion Post 2
You are new to a Linux team. A ticket has come in from an application team and has already been escalated to your manager. They want software installed on one of their servers but you cannot find any documentation and your security team is out to lunch and not responding. You remember from some early documentation that you read that all the software in the internal repos you currently have are approved for deployment on servers. You want to also verify by checking other servers that this software exists. This is an urgent ask and your manager is hovering.

1.	How can you check all the repos on your system to see which are active?

I'll need to first figure out what OS is running so I know which package manager is being used. That will tell me where to look:  
```bash
cat /etc/*release
```
* If the OS is Debian-based (Debian, Ubuntu, etc), then `apt` is being used. So, the repositories will be in `/etc/apt/`:
  ```bash
  cat /etc/apt/sources.list
  cat /etc/apt/sources.list.d/*.list
  ```
  * If the OS is RedHat-based (Rocky, RHEL, CentOS), then `yum`/`rpm`/`dnf` is used:   
  ```bash
  cat /etc/yum.repos.d/*.repo
  ```
  Each `.repo` file defines a repository with URLs and configurations for `yum` or `dnf` to use.  
* For openSUSE: `zypper repos`
* To manually scan for common repository names in `/etc`:
  ```bash
  grep -rE '^.deb |^.repo ' /etc/*
  ```
  This searches for filenames in `/etc` that are common repository names.  



2.	How would you check another server to see if the software was installed there?

I could SSH into that server, then do a check for the software that we need. 
* For Debian-based:
  ```bash
  # Using dpkg:
  dpkg -l | grep -i 'software_name'
  # Using apt:
  apt list --installed package_name 
  ```
  If the software was installed on the server a while ago, I might need to check
  older logs that have been archived and compressed using `zgrep`
  ```bash
  zgrep "install software_name" /var/log/dpkg.log.*.gz
  ```

* For RedHat-based: 
  ```bash
  rpm -qa | grep -i 'software_name'
  ```

If the software wasn't on the other server, I'd want to check that the repositories that contain the software were properly configured there by checking the repos as I did in the first question.  

Automating this task with a shell script would make it easier to do this for more than one server. It could also be written to take arguments so that this particular piece of software isn't hard-coded, making it reusable to check for other software in the future:  
```bash
#!/bin/bash

# Check for an argument
if [ $# -eq 0 ]; then 
    printf "You didn't provide any arguments.\n" && exit
fi

# Check the current OS
declare DISTRO_TYPE
DISTRO_TYPE="$(grep -i 'id_like' /etc/*release | awk -F= '{print $2}')"

case $DISTRO_TYPE in:
    (*rhel*|*centos*|*fedora*)
        if ! rpm -qa | grep -qi "$1"; then
            printf "Couldn't find the package %s on the system.\n" "$1" && exit
        else 
            printf "Package %s exists on this system.\n" "$1" && exit
        fi;
        ;;
    (*debian*)
        if ! dpkg -l | grep -qi "$1"; then
            printf "Couldn't find the package %s in the repositories.\n" "$1" && exit
        else 
            printf "Package %s exists on this system.\n" "$1" && exit
        fi;
        ;;
    (*)
        printf "Couldn't verify the existence of the package: %s\n" "$1"; 
        printf "Couldn't identify the operating system (not debian or redhat based)\n";
        exit; 
        ;;
esac
```
But since the task is urgent and the manager is hovering over me, I'd probably save this for another day.  


3.	If you find the software, how might you figure out when it was installed? (Time/Date)

Depending on the OS being used, the package managers have some commands that will show when a specific package was installed.  

* For Debian-based systems, you can check the `dpkg` logs to find out when it was installed:
  ```bash
  grep -i 'package_name' /var/log/dpkg.log
  # If it's an older compressed log, use zgrep
  zgrep -i 'package_name' /var/log/dpkg.log.*.gz
  ```

* For RedHat-based, you can either query `rpm` or check `yum history list`:
  ```bash
  rpm -qi package_name | grep -i 'install date'
  yum history list package_name
  ```
  
  

## Unit 7 Discussion Post 3
(After you have completed the lab) - Looking at the concept of group install from DNF or Yum. Why do you think an administrator may never want to use that in a running system? Why might an engineer want to or not want to use that? This is a thought exercise, so it’s not a “right or wrong” answer it’s for you to think about.

1.	What is the concept of software bloat, and how do you think it relates?

Software bloat is when a system has more software than is needed to perform its tasks operate smoothly. Unnecessary software can take up critical system resources (CPU, memory, disk space) without contributing to the essential functionality of what the system needs to run.  
Group installs could cause a system to experience software bloat, installing dependencies that might not be needed for the system to function.  


2.	What is the concept of a security baseline, and how do you think it relates?

A security baseline is a set of system configurations and the minimum amount of software a system needs for it to meet its security requirements. Going back to group installs, installing unnecessary dependencies could widen the attack surface of a machine, which would compromise the security baseline.  

3.	How do you think something like this affects performance baselines?

A performance baseline is the expected resource usage and responsiveness of a system wheen it is operating under normal conditions. If a system has installed a bunch of unnecessary software, it could be using up more resources than it needs to, which would affect the performance baseline.  


## Definitions/Terminology
* Yum: Yellowdog Updater, Modified. A package manager for RedHat-based systems.  
* DNF: DNF is a package manager for Linux distributions that use RPM, the RedHat
  Package Manager.  
* Repo: A repository is a collection of software packages that the package managers are allowed to draw from.  
* GPG Key: Gnu Privacy Guard key. A key that is used to sign things, such as software
  packages. Used to verify authenticity, making sure that it came from a trusted
  source.  
* Software dependency: A software package that another package depends on. If a package is missing a dependency then it cannot be used.   
* Software version: A number that is assigned to a software package to identify the version of the software.  
* Semantic Version: A versioning system that uses three numbers to respresent a
  software version.
    * Uses a naming convention of `<major.minor.patch>`
        * The `major` version **must** be incremented any time backwards-incompatible changes 
          are introduced the the public API.  
            * Major version `0` is for initial development, when anything is subject to change at any given time, before a stable public API is released.
            * When the stable public API is released, that is major version 1.
            * `1.0.0` defines the public API.
        * The `minor` version incremented when new, backwards-compatible features are introduced to the public API.
            * Whenever the minor version is incremented, the patch version must be set back to `0`.  
        * The `patch` version must be incremented when *only* backwards-compatible bug fixes are implemented.  


## Notes During Lecture/Class:


Misc notes:

You shouldn't update the kernel unless you're ready to reboot that box.  
The kernel is never actually "updated." The system installs the new kernel, and then moves over to that kernel, rather than updating the kernel in-place.  




---


### Links:
https://semver.org/


### Terms:
* Repos (Repositories): Collections of software packages that package managers are allowed to draw from.  
    * Can be local or remote.  
    * All packages come from a repo.  
    * Repos can be enabled or disabled as you wish (`dnf config-manager --disable/enable repo_name`).  
    * You can force GPG verification of all software found in the repositories.  
* Semantic Versioning: A versioning system that uses three numbers to represent a
  software version and what potential breaking changes it may have from other
  versions. 
* Stateful nodes: Nodes that maintiain their state (configurations, data, and files)
  across multiple sessions and reboots.  
    * Stateful nodes need to be patched regularly. These will not be coming up with a new image like stateless nodes, and persistence is needed.  
    * For stateful nodes in enterprise:
        * You want to use a controlled internal repo for patching.
        * You download the software repos and then mirror it (mirrored internal controlled repo).   
* Stateless nodes: Nodes that are ephemeral - they do not retain their state across
  sessions or reboots. 
    * Stateless nodes don't get patched. The node will live its full life, and will come up with a new image (which may be patched).  
    * These are easier to scale and redeploy with updated versions.  



### Useful tools:
* `rmp`: RedHat Package Manager
    * `rpm -qa`: Query all packages installed on the system.  
    * `rpm -qi systemd`: Show information about the given package
    * `rpm -q systemd`: See if the package is installed
    * `rpm -qc systemd`: Show the configuration files of the package.  
    * `rpm -ql systemd`: Show all files the package brings into the system.  
    * `rpm -qR systemd`: Show all dependencies of the package (required external packages).  
    * `rpm -q -changelog systemd`: Show the changelog of the package. 
    

* `dnf`: 
  ```bash
  dnf config-manager --disable repo_name
  dnf repolist
  ```
    * `dnf update --exclude=kernel*`: Update everything except for the kernel.  
    * `dnf update --exclude=kernel* --exclude=kernel-core`: Update everything except for the kernel and the kernel-core.
    * `dnf update systemd`: Update the given package only.  
    * `dnf search mariadb`: Search for a specific package.  
    * `dnf search all mariadb`: Search for a package, including everything matches
      the package name
    * `dnf repolist`: Show the list of repositories.  
    * `dnf history`: Show history of installed packages
    * Config file: `/etc/dnf/dnf.conf`
* `yum`
    * `yum repolist`: Shows the list of repositories (same as `dnf repolist`)
    * Repos for the system are stored in `/etc/yum/yum.repos.d` 
        * Files in this directory will be named `*.repo`, and will contain a list of
          repositories and their configuration info.
            * You can see if the repos are enabled, if they support GPG checking, shows
              their URLs and mirrors, GPG key location, etc..  
        * When a repo is added, it is enabled by default.  
        * Disable a repo with `dnf config-manager --disable repo_name`
    * `yum update`
    * Config file: `/etc/yum.conf`


## Lab and Assignment
Unit 7 Security Patching and Package Management
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
1.	What is semantic versioning? https://semver.org/
Semantic Versioning is a naming convention and best practices for software versions.  
It's a set of rules defining a way to convey what type of changes are being made with new versions.  
The naming convention follows the format:
```plaintext
package X.Y.Z
```
* `package` is the name of the software package.  
* `X` is the "Major Version."
    * Major version `0` is for initial development, when anything is subject to change at any given time, before a stable public API is released.
    * When the stable public API is released, that is major version 1.
        * `1.0.0` defines the public API.
    * The major version **must** be incremented any time backwards-incompatible changes are introduced the the public API.  
* `Y` is the "Minor Version."  
    * The minor version incremented when new, backwards-compatible features are introduced to the public API.
    * Whenever the minor version is incremented, the patch version must be set back to `0`.  
* `Z` is the "Patch Version." 
    * The patch version must be incremented when *only* backwards-compatible bug fixes are implemented.  
 
Whenever a version is released, that version can NOT be changed in any way. Any
changes must be released as a new version. 

A pre-release version can be denoted with a hyphen `-` after the version number, with
dot-delimited identifiers  after the hyhen. 
E.g.:
```plaintext
1.0.0-alpha.1
```


## Reflection Questions
1.	What questions do you still have about this week?

How often do system administrators update their systems? Are updates on a schedule?
Is a system only updated if a CVE is released on a package in use? Or are there
regular updates to newer versions to eliminate potential security risks?


2.	How does security as a system administrator differ from what you expected?

Security as a sysadmin is more of a process than a single tool. It's not just about
making sure ports are locked off and a firewall is set up correctly, software
versions need to be taken into account as well.  



