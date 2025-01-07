# ProLUG 101
## Unit 13 Worksheet


## Table of Contents
* [Unit 13 Worksheet](#unit-13-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 13 Discussion Post 1](#unit-13-discussion-post-1) 
    * [Unit 13 Discussion Post 2](#unit-13-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper (optional)](#digging-deeper-optional) 
* [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.


## Discussion Questions:

### Unit 13 Discussion Post 1
Your security team comes to you with a discrepancy between
the production security baseline and something that is running on one of your servers in
production. There are 5 servers in a web cluster and only one of them is showing this
behavior. They want you to account for why something is different.

1. How are you going to validate that the difference between the systems?

I'll try to pinpoint the discrepency by checking the difference between the servers in the cluster.  
Differences in configurations, installed packages, running processes, and whether or not they're all running the same operating systems could all have an impact on the security baseline that is
being referenced.  


2. What are you going to look at to explain this?

First, logs. I'd check to see if there's any indication of the behavior that's being reported.  
If I can't identify anything obvious from the logs, I'd check on system configurations.  

I'd pull down critical config files from the problematic server and use tools like `diff` to check differences in configuration files:
```bash
diff /etc/config/file /other/config/file
```

I could use `rsync` in dry-run mode (`-n`) to pull down configuration files from `/etc` and `diff` them.  
```bash
rsync -avn --delete server1:/etc/ /tmp/server1-configs
rsync -avn --delete server2:/etc/ /tmp/server2-configs
diff -r /tmp/server1-configs /tmp/server2-configs
```
* Using `--delete` will make sure that if there are any existing files in `/tmp/server1-configs/` that don't exist in the remote source (`server1:/etc/`), they'll be deleted.


I'd also check running procsses (`ps -ef`), open ports (`ss -ntulp`), SELinux status (`sestatus`), firewall status and rules (`firewall-cmd`), and `journald` logs (`journalctl -xe`) on the problematic server and compare the status of each of those with the servers that are meeting the security baseline.  


3. What could be done to prevent this problem in the future?

Build and distribute a golden image that has the same defaults acros the board; OS,
default packages, configurations, etc.
This way, even if it doesn't prevent the problem completely, it will be easier to identify the issue if it arises again.  
If there's not one already, implement a system that provides a standardized way of configuring servers (i.e., Ansible). This way there's less room for error in server configurations that could comprimise the security baseline.  


### Unit 13 Discussion Post 2
Your team has been giving you more and more engineering
responsibilities. You are being asked to build out the next set of servers to integrate into the
development environment. Your team is going from RHEL 8 to Rocky 9.4.

1. How might you start to plan out your migration?

I'd inspect the script that this guide suggests, using the [migrate2rocky tool](https://docs.rockylinux.org/guides/migrate2rocky/).
  
This tool only supports RHEL 8 to Rocky 8 or RHEL 9 to Rocky 9, so I'd have to find
another way, but I would look at what the script is doing and see if there's any functionality that I could incorporate into our migration process.  

I'd look into the ways that the two operating systems differ.  

I'd plan to set up a test environment for this migration, which will mirror the production setup.
I'd use VMs or containers to test the migration first.  

I'd make sure there's disaster recovery plan. Backups of data, configs, and system states in case the migration goes badly.  
I'd plan to start the migration process with non-critical systems, and then gradually move on to critical systems if the process proves to be successful.  

I would use plan to Ansible to automate builds and configurations for the new Rocky servers.  



2. What are you going to check on the existing systems to baseline your build?

I would make sure there's an inventory of all the RHEL 8 servers, applications, and
configurations, and identify dependencies and critical services that need to function
on the OS.  

I'd write an Ansible playbook to hit each server and pull down this information to make sure everything is as we think it is:
* OS version and kernel version
  ```bash
  cat /etc/*release
  uname -r
  ```
* Repositories, packages, and dependencies
  ```bash
  rpm -qa > /safe/location/rhel_packages
  yum repolist > /safe/location/rhel_repolist
  ```
* System-critical configuration files 
  ```bash
  cat /etc/ssh/sshd_config # SSH authorization rules
  cat /etc/fstab        # Filesystem information
  cat /etc/sysctl.conf  # System variables
  ```
* Network configurations 
  ```bash
  ip r
  ip a
  ss -ntulp
  firewall-cmd --list-all
  ```
* SELinux/Audit policies
  ```bash
  sestatus
  getenforce
  cat /etc/audit/auditd.conf
  ```
* User accounts and groups
  ```bash
  cat /etc/passwd
  cat /etc/group
  cat /etc/sudoers
  ```
* The state of active services on the systems
  ```bash
  systemctl list-units --type=service
  ```
I'd save these files in a location that I can access after migration to validate (compare the new rocky files to the previous RHEL files).  

I'd verify that the services running on our RHEL 8 servers are compatible with Rocky 9.4, and check if any custom scripts or configs need to be modified in order to work with Rocky.  


3. What kind of validation plan might you use for your new Rocky 9.4 systems?

I would compare the files that I pulled down when creating a baseline for the RHEL 8 systems to the files on the new Rocky 9.4 servers, using `diff` on the files that we pulled down earlier to the new ones, and checking packages (`rpm -qa`) on the new Rocky servers. I'd also verify the services that need to be running are running using `systemctl status`.  
I would likely try to automate this process using Ansible.  


## Definitions/Terminology
- Hardening: The process of securing a system by reducing its attack surface.
    * This can include disabling useless/unused services, applying the rule of least
      privilege, and configuring secure SSH (key-based auth, no root login).  
- Pipeline: An automated workflow for building, testing, deploying, and monitoring applications or systems.  
    * Including automated security checks in CI/CD pipelines in important.
        * E.g., static code analysis and vulnerability scanning.  

- Change management (IT): A structured approach for managing changes to systems.  
    * Ensure they are documented, reviewed, approved, and implemented securely.  
    * Can include a Change Advisory Board (CAB) for reviewing proposed changes.  
    * Keep systems from changing without authorization.  
    * Keep systems updated with patching cycles and testing.  

- Security Standard: A documented set of rules, requirements, and best practices to
  secure systems and the data they contain.  
    * Used to provide a baseline for securing systems and to ensure compliance. 
    * PCI DSS (Payment Card Industry Data Security Standard)
    * ISO 27001 (Information Security Management System)

- Security Posture: The overall state of an organization's security, or an individual system's security, to minimize risks and enhance resilience against attacks.
    * This includes security policies, pracices, and controls.  
    * Components of a security posture are:
        * Vulnerability management
        * Incident response (IR) readiness
        * Configuration compliance

- Acceptable Risk: The level of risk an organization is willing to accept without
  further mitigation.  
    * Usually comes down to a balance between cost and security.  
    * Acceptable risk is usually documented in risk management policies.  
    * Example of acceptable risk: leaving a non-critical server with older hardware vulnerabilities online if mitigation costs are too high.  

- NIST 800-53: A security standard published by the National Institute of Standards and Technology, for use on federal systems.  
    * This standard is widely adopted as a framework for compliance in both the
      public and private sectors.  

- STIG: Security Technical Implementation Guidelines. Security standards published by
  the Defense Information Systems Agency (DISA) for systems used in the Department of
  Defense.  
    * STIGs are used to ensure compliance on systems with military-grade security
      requirements.  
    * Includes configuration guidelines for many platforms; Linux, Windows, network devices, etc.

- CIS Benchmark: Center for Internet Security security guidelines.  
    * Provides hardening recommendations for operating systems, cloud platforms, containers, and applications.  
    * E.g., CIS benchmarks for Linux, Dicker and AWS.  
    * There are tools, like CIS-Cat Pro, which can be used to implement CIS recommendations.  

- OpenSCAP: An open-source toolset that implements the Security Content Automation
  Protocol (SCAP). 
    * Used to scan and assess system compliance.  
    * It supports automated vulnerability scanning, compliance auditing with CIS/STIG/custom baselines, and is supported on Linux systems. 
    * Can be used regularly to scan for vulnerabilities and ensure compliance with
      your security baseline.  

- SCC Tool: SCAP Compliance Checker. A tool provided by DISA that uses SCAP to scan
  and validate system compliance with STIGs and other security standards.  
    * Outputs detailed compliance reports and is cross-platform.  

- HIDS: Host Intrusion Detection System. A security solution that goes on
  individual systems to monitor and detect unauthorized activity.  
    * Essential component of a hardened system.  
    * Monitors file integrity, logs, and system activity, and sends out alerts if any
      anomalies are detected.  
    * Some HIDS tools: OSSEC, AIDE (Advanced Intruction Detection Environment)

- HIPS: Host Intrustion Prevention System. Similar to HIDS but actively *prevents*
  malicious actions instead of just detecting them.  
    * An essential component of a hardened system.  
    * Blocks syspicious activity in realtime, and can protect against zero-day
      attacks.
    * Some HIPS tools: AppArmor, SELinux


## Notes During Lecture/Class:

### Links:
https://nvd.nist.gov/vuln/search
https://docs.rockylinux.org/guides/migrate2rocky/
https://public.cyber.mil/stigs/downloads/
https://pulpproject.org/
https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/
https://open-scap.org/getting-started
https://www.openfoam.com/

### Terms:
Security standards:
* PCI DSS: Payment Card Industry Data Security Standards
* ISO 27001: International Organization for Standardization 
    * Published jointly with the International Electrotechnical Commission 
* STIG: Secure Technical Implementation Guides
* SCC: SCAP Compliance Checker
* CIS: Center for Internet Security (benchmarks)

---

* Diamond model of intrusion analysis

* Security teams - Governance, Risk, Compliance

* Acceptance Testing: Formal testing according to user needs, requirements, and
  business processes conducted to determine whether a system satisfies the accepted
  criteria or not.  
    * This is the last phase of testing in Software Development, preceded by system
      testing, integration testing, and unit testing.  

* CIA Security Triad
    * Confidentiality (Viewing Data)
    * Integrity (Changing Data)
    * Availability (Accessing Data)

* Hardening best practices:
    * All default passwords changed.
    * All default accounts disabled or removed if unused.
        * E.g., `es`: ElasticSearch always comes with a user.  
        * Either disable the user or change the password for it.  
    * Benchmarks - CIS, STIG, OpenSCAP
    * Software
        * Updated/patched
        * Only there if needed
            * e.g., CUPS - printing service. Why would this be running on a webserver?
        * Only running if needed
    * HIDS (Host intrustion detection system)
    * Good logging systems
        * Loki
        * Syslog (running)
    * HIPS (Host instruction prevention system)
        * tripwire
        * fail2ban
    * Host level firewalls turned `on`
    * Root login disabled
        * `/etc/ssh/sshd_config`: `PermitRootLogin no`

Inside `yum` repositories:
* `gpgkey` points to a gpg key file
* `gpgcheck` tells dnf to ALWAYS checks the package
* `repo_gpgcheck` tells dnf to always verify the repository with the GPG key


The only way for someone to connect to a system is if a port is already open.  
Port number between `0` to `65534` (`65535` can't be used).  
`cat /etc/services` for the named ports.  


### Useful tools:
* OpenSCAP (Workbench)
* SCC Tool (Scanning)
* `oscap`
* Scanning tools
    * Nessus
    * Qualys
    * These willl produce reports that deal with risk and compliance
    * You need to have an accounting for any change from the baseline
    * e.g., "Change record"

* `boto3`: Python library that connects to the AWS API.  
    * Used for using ansible or python when interacting with the cloud.  

* `stat`: Show statistics about a file.  
  ```bash
  sudo stat -c "%a %n" /etc/ssh/*.pub
    644 /etc/ssh/ssh_host_dsa_key.pub
    644 /etc/ssh/ssh_host_ecdsa_key.pub
    644 /etc/ssh/ssh_host_ed25519_key.pub
    644 /etc/ssh/ssh_host_rsa_key.pub
  ```
    * `"%a %n"`: The permissions (octal notation) and name of the file.  
        * These are called format sequences.  
    * Other useful ones:
        * `%w`: Time of file creation.  
        * `%x`: Time of the last file access.  
        * `%y`: Time of the last data modification.  
        * `%z`: Time of the last status change.  

* Julia
* OpenFoam


* `sysctl -a`: Shows a list of the kernel parameters.  
  ```bash
  sysctl -a | grep -i net.ipv4  # RP filter
  sysctl -a | grep -i net.ipv4.conf.all.rp_filter
  ```


* STIG tool: Security Technical Implementation Guidelines tool.
    * From the DoD Cyber Exchange.  
    * Performs STIG scans.
        * Workflow: Scan thing -> make a change (fix text) -> scan again
    * Each of the STIGs deals with a certain thing.  
    * Each STIG has a Rule Title, Discussion, Check Text, Fix Text, and then a section for "Comments" and "Finding Details" 

* With each STIG:
    * There are only a few you need to do a "manual verification" on.  
    * Set to `open` or declare it `not a finding`, `not applicable`, or `not reviewed`
        * `not reviewed` is when the STIG hasn't been touched yet.  
        * `not a finding` means that the STIG is good.
    * Put as much relevant info as possible into `Finding Details`.
        * The command you did, and its output.
        * E.g., Take all of `/etc/*release` output in the `Finding Details` section.
    * The `Comments` is where you put justification for why you set it to its status (e.g., `not a finding`)

* DISA STIG Viewer: 2.17:STIG Explorer
    * Can open a STIG checklist from a file
    * You can make STIGs for specific devices.  

* OpenSCAP
* SCC tool
* Radix

* Repositories
    * Hardened systems are systems that are patched.  
    * Controlling our repositories is important to system hardening.  
    * Understanding packaging and package methodology is important to keep a system hardened.  
      ```bash
      dnf repolist # Just looking at flat files
      ```
      These are in `/etc/yum.repos.d/`
      ```bash
      vi /etc/yum.repos.d/epel.repo
      ```
      Change 1 to 0, you can disable that repo.  

* `/etc/audit/auditd.conf`: Contains security audit configuration.  

## Lab and Assignment
Unit 13 Lab System Hardening
Continue working on your project from the Project Guide
Topics:
1. System Stability
2. System Performance
3. System Security
4. System monitoring
5. Kubernetes
6. Programming/Automation
You will research, design, deploy, and document a system that improves your
administration of Linux systems in some way.


## Digging Deeper (optional)
1. Run through this lab: https://killercoda.com/het-tanis/course/Linux-Labs/107-server-startup-process
a. How does this help you better understand the discussion 13-2 question?

2. Run through this lab: https://killercoda.com/het-tanis/course/Linux-Labs/203-updating-golden-image
a. How does this help you better understand the process of hardening systems?


## Reflection Questions
1. What questions do you still have about this week?

How often do enterprise environments use things like STIGs?
Does this typically fall on sysadmins, or is it usually delegated to security teams?

Lab questions: Why are both ports 9080 and 35671 open with the same service (promtail)?  



2. How can you apply this now in your current role in IT? If you’re not in IT, how can you
look to put something like this into your resume or portfolio?

I'm not in any role, but I could put together a project in which I employ HIDS and HIPS in my homelab, and use
STIG tools to meet certain security standards.  


