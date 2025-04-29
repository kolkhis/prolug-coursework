# ProLUG Security Engineering
## Unit 5 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

## Discussion Questions:

### Unit 5 Discussion Post 1
Review the rocky documentation on Software management in Linux.
<https://docs.rockylinux.org/books/admin_guide/13-softwares/>

1. What do you already understand about the process?  
    - The installation process of packages, with rpm directly (`rpm -i pkg.rpm`) or with dnf (`dnf install -y pkg`).  
    - The querying of packages on the system. `rpm -q pkg`.  
    - Updating packages with `dnf update`.  

2. What new things did you learn or pick up?  
    - You can use `rpm -ivh pkg.rpm` to install a package with verbose output and a progress bar.  
    - `dnf grouplist` - lists groups.  
        - Groups are collections of packages that group applications based on their
          purpose.  
          E.g., "Server with GUI" holds packages that are required for a server with
          a graphical user interface.  
          These packages can be bulk installed with `dnf groupinstall "Group Name"`.  
3. What are the DNF plugins?  

    - They are a set of additional tools on top of `dnf` that help you manage installed packages.  
      ```bash
      dnf install dnf-plugins-core
      ```
      <https://dnf-plugins-core.readthedocs.io/en/latest/index.html>
    - Provides utilities like `dnf config-manager`, `dnf download` (to just download the RPMs without installing), and `dnf versionlock`.  

- What is the use of the versionlock plugin?  
    - `versionlock` allows you to lock a package at a specific version. It prevents DNF from updating it when you run `dnf update`.  
      This is useful when you need to stay on a specific/stable version of a package for compatibility or security.  
    - You need to install an extra package for this plugin before you can use it.  
      ```bash
      dnf install python3-dnf-plugin-versionlock  # Install the versionlock plugin
      dnf versionlock add ansible # Lock the current version of ansible
      ```

4. What is an EPEL?  
    - Extra Packages for Enterprise Linux.  
    - It's a repo of additional packages build and maintained by the "EPEL Fedora Special Interest Group", and contains software that's not included in official RHEL/Rocky repos.  
    - These packages aren't included in official repos because they're not considered necessary in enterprise environments (e.g., desktop utilities).  

- Why do you need to consider this when using one?  
    - EPEL packages have no official support from RHEL.  
    - These packages could also be removed from the EPEL repo and disappear.  


### Unit 5 Discussion Post 2
Do a google search for “patching enterprise Linux” and try to wade through all of the noise.

1. What blogs (or AI) do you find that enumerates a list of steps or checklists to consider?
    - <https://jetpatch.com/blog/patch-management/the-ultimate-guide-to-linux-server-patch-management/>
    - <https://www.helixstorm.com/blog/patch-management-best-practices/>
    - Chat Gippity

2. After looking at that, how does patching a fleet of systems in the enterprise 
   differ from pushing "update now" on your local desktop?

    - Patching a personal workstation is very different than patching an entire enterprise fleet of servers.  
      If updating a personal workstation, you can just do a `dnf update` or `apt update && apt upgrade -y`, and we don't need to worry about breaking anything (probably, usually, maybe).  


- What seems to be the major considerations?  
    - Security is one of the main ones. Older versions of software can be vulnerable to attacks.  
      - Security compliance, if applicable (like HIPAA).  
    - Maintaining compatibility with everything else.  
    - How patching may affect downtime, and how to plan for that.  
    - Coordinating with other teams to find an optimal timeframe.  
- What seems to be the major roadblocks?  
    - There are major roadblocks that are not technical (humans).  
    - Testing new versions of software. Changes need to be validated so they don't break anything.  
    - Legacy systems that can't be patched without breaking (or can't be patched at all [e.g., CentOS 7]).  
    - Complex dependency chains that make patching a non-trivial task.  


## Definitions/Terminology

- Patching: The process of updating software on systems.
    - Done to fix bugs, close security vulnerabilities, improve functionality, or
      meet compliance standards.  

- Repos: Repositories -- collections of software packages. Either stored on remote
  servers or locally. Linux systems pull updates and install new software from these
  repos.  
    - Software: A general repository of installable software.  
    - EPEL: Extra Packages for Enterprise Linux. A community-maintained repository
      (in AppStream) that contains packages not available/supported by RHEL/Rocky
      repositories.  
    - BaseOS v. Appstream (in RHEL/Rocky)
        - BaseOS contains the core operating system components and essential packages.
        - AppStream contains applications and tools (databases, webservers,
          languages) delivered as modules. AppStream contains the EPELs. Also allows multiple 
          versions of the same software to be available using dnf modules.

    - Other types you can find?
        - There are 3rd party repos like RPM Fusion and Remi that have extra/newer software.  
        - Local/internal repos can be created to control software versions and patch management.  

- httpd: The Apache HTTP Server Daemon. `httpd` is a fork of Apache2 used on RedHat systems.  

- GPG Key: Gnu Privacy Guard key. Used to sign and verify packages and repositories.  
    - Package managers (`dnf`, `apt`) use GPG keys to ensure the integrity of
      packages and repositories.  
    - When you install a package, the system checks its GPG signature against the
      trusted keys.  
        - These keys are located in `/etc/apt/keyrings` on Debian-base systems, and
          in `/etc/pki/rpm-gpg/` on RedHat-based systems.   
    - Repos can be configured to use GPG keys or not use them in their respective
      repo file.  
        - `/etc/apt/sources.list.d/` on Debian-based systems, with a
          `[signed-by=/etc/apt/keyrings/some-key.gpg]` entry.  
        - `/etc/yum.repos.d/` on RedHat-based systems with these lines in repository entries:
          ```ini
          [repo-name]
          name="some repo"
          gpgcheck=1
          gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-repo-name
          ```

- DNF/YUM: Package managers for RPM-based Linux distros (Rocky, RHEL, CentOS).  
    - DNF: Dandified YUM. An enhanced version of yum that most modern RH-based
      systems use.  
    - YUM: The older tool that was used in RHEL 7 and earlier.  


## Notes During Lecture/Class:

[notes](./notes.md)  


### Links:
- <https://wiki.rockylinux.org/rocky/repo/>
- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>
- <https://public.cyber.mil/stigs/downloads/>

### Terms:

### Useful tools:
- STIG Viewer 2.18
- SCC Tool (version varies by type of scan)
- OpenScap

## Lab and Assignment
Unit5_Repos_and_Patching - To be completed outside of lecture time.


## Digging Deeper
1. After completing the lab and worksheet, draw out how you would deploy a software repository into your system.
    - How are you going to update it?
    - What tools do you find that are useful in this space?

## Reflection Questions
1. Why is it that repos are controlled by root/admin functions and not any user, developer, or manager?
2. What questions do you still have about this week?
3. How are you going to use what you’ve learned in your current role?
