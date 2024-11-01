# ProLUG 101

## Unit 7 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.

## Discussion Questions:
### Unit 7 Discussion Post 1
Why is software versioning so important to software security? Can you find 3 reasons, from the internet, AI, or your peers? 
1. CVEs (Common Vulnerability Exposures). These are publications on the latest known security vulnerabilities in software. It's important to make sure your software's versions are newer than the last CVEs regarding each piece of software.  
2. Compatibility. Software often pushes "breaking changes," which means that an
   update may contain software that could make your current configurations or
   dependencies on that software package obsolete. If you have written code that
   depends on a tool, if that tool has just pushed a critical change then it could
   change the way your code works. This could cause unpredictable behavior, and
   unpredictable code being run on your servers is always a security risk.  
3. Potential unknown security risks. If a company updates to the newest version of a
   software package that just dropped, there's a chance there may be some critical
   security vulnerability that has not been discovered yet. As long as the package
   version is newer than the latest CVE, there should be no need to update it if it
   works as intended.  


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
  * If the OS is RedHat-based (Rocky, RHEL, CentOS), then `yum`/`dnf` is used:   
  ```bash
  cat /etc/yum.repos.d/*.repo
  ```
  Each `.repo` file defines a repository with URLs and configurations for `yum` or
  `dnf` to use.  
* For openSUSE: `zypper repos`
* To scan for common repository names in `/etc`:
  ```bash
  grep -rE '^.deb |^.repo ' /etc/*
  ```
  This searches for filenames in `/etc` that are common repository names.  


2.	How would you check another server to see if the software was installed there?

I could SSH into that server, then do a check for the software they need. 
For Debian-based:
```bash
dpkg -l | grep -i 'software_name'
```
For RedHat-based: 
```bash
rpm -qa | grep -i 'software_name'
```
If the software wasn't on the other server, I'd want to check that the repos were
properly configured there by checking the repos as I did in the first question.  


3.	If you find the software, how might you figure out when it was installed? (Time/Date)

Depending on the OS being used, the package managers have some commands that will
show when a specific package was installed.  

For Debian-based:
```bash
apt list --installed package_name
```

For RedHat-based:
```bash
rpm -qi package_name | grep -i 'install'
yum history list package_name
```



## Unit 7 Discussion Post 3
(After you have completed the lab) - Looking at the concept of group install from DNF or Yum. Why do you think an administrator may never want to use that in a running system? Why might an engineer want to or not want to use that? This is a thought exercise, so it’s not a “right or wrong” answer it’s for you to think about.

1.	What is the concept of software bloat, and how do you think it relates?


2.	What is the concept of a security baseline, and how do you think it relates?

3.	How do you think something like this affects performance baselines?


## Definitions/Terminology
* Yum: Yellowdog Updater, Modified. A package manager for RedHat-based systems.  
* DNF: DNF is a package manager for RPM-based Linux distributions.  
* Repo: A repository is a collection of software packages that the package managers are allowed to draw from.  
* GPG Key: Gnu Privacy Guard key. A key that is used, among other things, to sign
  packages to verify authenticity.  
* Software dependency: A software package that another package depends on. If a package is missing a dependency then it cannot be used.   
* Software version
* Semantic Version


## Notes During Lecture/Class:

* How do we update?
    * RedHat-based systems:
        * `dnf`: `yum update`  
    * Debian-based systems:  
        * `dpkg`: `apt update`/`apt upgrade`

For stateful nodes in enterprise:
* You want to use a controlled internal repo for patching.
* You download the software repos and then mirror it (mirrored internal controlled repo).   

You shouldn't update the kernel unless you're ready to reboot that box.  
The kernel is never actually updated. It installs the new kernel, and then moves over to that kernel.  

---

* When do we update?
    * Stateful nodes need to be patched.  
        * This is because 
    * Stateless nodes don't get patched. The node will live its full life, and will come up with a new image (which may be patched).  

Where are software packages stored?
When were they last updated?
What files are brought in by the package?

---


### Links:
https://semver.org/


### Terms:
Repos (Repositories): Can be local or remote.  
* All packages come from a repo.  
* Repos can be enabled or disabled as you wish (`dnf config-manager --disable/enable repo`).  
* You can force GPG verification of all software found in the repositories.  


### Useful tools:
* `rmp`: RedHat Package Manager
    * `rpm -qi systemd`: Show information about the given package
    * `rpm -q systemd`: See if the package is installed
    * `rpm -qc systemd`: Show what files the 
    * `rpm -ql systemd`: Show all files the package brings in
    * `rpm -qR systemd`: Show all dependencies of the package (Required packages)
    * `rpm -q -changelog systemd`: Show the changelog of the package. 

* `dnf`: 
  ```bash
  dnf config-manager --disable repo_name
  dnf repolist
  ```
    * `dnf update --exclude=kernel*`: Update everything except for the kernel.  
    * `dnf search mariadb`: Search for a specific package
    * `dnf search all mariadb`: Search for a package, including everything matches
      the package name
    * `dnf update systemd`: Update a package
    * `dnf repolist`: Show the list of repos
    * `dnf history`: Show history of installed packages
    * Config file: `/etc/dnf/dnf.conf`
* `yum`
    * Config file: `/etc/yum.conf`
    * `/etc/yum/yum.repos.d` 
    * `yum update`
* `rpm -qi kernel-core`: shows information about a package


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
The naming convention is as follows:
```plaintext
package X.Y.Z
```
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


Reflection Questions
1.	What questions do you still have about this week?


2.	How does security as a system administrator differ from what you expected?




