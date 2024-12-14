# ProLUG 101 - Unit 13

Topic: System hardening.


As an admin we don't really harden things.  
Administration at the end of the day is focused on keeping systems up.  
Anything you do in the hardening sense is more of an engineering thing.  


* STIG tool: Security Technical Implementation Guidelines
    * From the DoD Cyber Exchange.
    * STIG scans.
    * Scan thing - make a change - scan again

* DISA STIG Viewer: 2.17:STIG Explorer
    * Can open a STIG checklist from a file
    * You can make STIGs for specific devices.  

* OpenSCAP
* SCC/SEC? tool
* Radix

* Pulp: OSS fetch, upload, and distribute software packages on-prem or in the cloud.  

Each of the STIGs deals with a certain thing.  
Each STIG has a Rule Title, Discussion, Check Text, Fix Text, and then a section for "Comments" and "Finding Details" 


There are only a few you need to do a "manual verification" on.  
- set to `open` or declare it `not a finding`, `not applicable`, `not reviewed`
    * not reviewed is when they haven't been touched yet.  
    * `not a finding` means that the STIG is good.
* Take all of `/etc/*release` output in the `Finding Details` section.
    * The command you did, and its output.
    * The `Comments` are why you set it to its status (e.g., `not a finding`)
You need to be able to show ISSO, if you have a policy to update every 2 weeks, `dnf history` - Last update 11/29 - That update is too far back. Show the output that is pertinent to discussion, say `system is out of compliance, but ISSO has given a pass until pass acceptance testing`. That STIG would remain open.

There are Cat 1s that MUST be completed (`not a finding`), not `open`. 
* They can be `open`, but you must have a reason for the ISSO
Cat 2s are a little more lenient (except networking).  
Cat 3s are pretty small, but good for squeezing points.  

* Acceptance Testing

```bash
sysctl -a | grep -i net.ipv4  # RP filter
sysctl -a | grep -i net.ipv4.conf.all.rp_filter
```
## Tradeoff of security
Accessibility to the system.  
Security slows us down.  
I've heard people say "security is the enemy of productivity"




---


## Repositories
Hardened systems are systems that are patched.  
Controlling our repositories is important to system hardening.  
Understanding packaging and package methodology is important to keep a system hardened.  
```bash
dnf repolist # Just looking at flat files
```
These are in `/etc/yum.repos.d/`
vi 
```bash
vi /etc/yum.repos.d/epel.repo
```
Change 1 to 0, you can disable that repo.  

If you break repos, updates don't happen.  
---


https://public.cyber.mil/stigs/downloads/
https://pulpproject.org/
https://grafana.com/docs/grafana/latest/setup-grafana/installation/redhat-rhel-fedora/
https://open-scap.org/getting-started
https://www.openfoam.com/

`gpgkey` points to a gpg key file
`gpgcheck` tells dnf to ALWAYS checks the package
`repo_gpgcheck` tells dnf to always verify the repository with the GPG key


## Golden image
Get a base install image from a company.  
There's a lot that needs to happen ot this image 
* networking config
* agents
* hardening
* DNS/Static IP ranges

The golden is all the things that need to bet setup for our base level of security.  

 
Governance Risk and Compliance team will give you what that minimum standard is.  
Is it the STIG standard? PCI-DSS? CIS benchmark? A lot of these things can be done with Ansible or Bash scripts.  

* PCI-DSS: required if company wants to take credit cards
    * All default passwords changed.
    * all default accounts either disabled or remobved if not used
    * Benchmarks (CIS, STIG, OpenSCAP)
    * Software
        * Updated/patched
        * Only there if needed
        * only running if needed
    * HIDS (Host Intrusion Detection System)
        * Good logging systems
            * Loki
            * syslog running
    * HIPS (Host Intrusion Prevention System)
        * Tripwire
        * Fail2ban
    * Host level firewalls (on)
    * Connection cannot happen by root
        * inside /etc/ssh/sshd_config - no root allowed

## Firewall
No reason not to use a host firewall.  
* 22 80 139 65534
    * These are the only ports you really need in order to connect to a machine.  

isoquant curves: Input to a system
Julia  
OpenFoam: Finite Element Analysis Software



