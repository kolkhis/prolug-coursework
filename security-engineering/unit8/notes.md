# Unit 8 Notes


## Last Week
alerting is when we send messages outside of a closed system.    
how? alertmanager to discord  
grafana to discord  
when? set priority (severity), warnings, criticals, high watermarks  
    - do we have windows of alerts? e.g., timeframes when alerts can occur



## This week

What is the lifecycle of a system?
- dealing with a stateful (or a fat) system.
    - has memory, persistence
What is configuration drift?
How do we deal with configuration drift?
- Operational practices
    - The fact they exist, doesn't affect us from an admin standpoint.
  - change management activities
- technical practices
    - what can we do? with bash, ansible, etc. to control drift on the system
- system built in tools
    - AIDE (kinda like a builtin tripwire)
- custom automation
    - checking drift (just checks things)
    - fixing drift (always potentially disruptive and/or destructive)

* Reductio Ad Absurdum: Reduce something to its absurd logical conclusion.  
    - We do 2 things at the command line: We set configurations and we check configurations.

### Why Configuration Drift Sucks
The problem is configuration drift means that we may be falling out of security 
compliance, may not be able to work on the system as effectively, may turn on/off a 
service across the environment but may not work because a different version was 
installed on the system.  

One of the worst things that can happen in an environment is configuration drift.



---

## System build and config management

We have run books and build books
- Build books are for rebuilding the system
    - Terraform, scripts, etc
- Run books are for runtime configuration
    - Ansible

1. Build systems according to baseline and release to ops -- build and run books created
    - Applies to system build books (applied to rebuild system)

    - Run books updated because:
        - Operation admin teams make changes to fix systems
        - Operation admin teams make changes for user requests
        - Operation admin teams make changes for security fixes

Smth to build to systems exactly how they should be at their baseline.  

## Theory of config management

Concepts:

- Configuration Item (CI) : Hardware software, docs, or other componenet that needs to be
  managed.
- Baseline: Set of CIs that have been formally agreed upon and serve as a basis for
  future changes
- Change Control: The process of managing and approving changes to CIs.  
- Change Control: Process of managing and approving changes to CIs. 
- Configuration Status accounting: Documenting and tracking info about CIs and their changes.
- Configuration Audit: Evaluating configs to ensure they meet requirements


Goals:

* Consistency: Ensure that the system is built and operates as intended
* Traceability Track changes to CIs and their impact on the system
* Accountability: Define who is responsible for changes
* Control: Manage changes to minimize errors and disruptions
* Efficiency: Automate configuration tasks

RACI model:
- RACI is a project management acronym for the different responsibility types within 
  a project: 
    - Responsible
    - Accountable
    - Consulted
    - and Informed.

---

## Hashing
Use hash integrity (or hash file integrity) in your automation.  

1. take file
2. hash it
3. put hash next to it
4. wait 3 years
5. check the hash again

---

Config management tools:
* Version control
* IaC
* Automation and orchestration
* Change tracking
* Compliance and auditing

Examples of config management tools
* Git
* Puppet, Check, Ansible: For infra automation
* Docker, k8s: For contrainer orchaestration
* Terraform: For IaC (infrastructure as code)
    - Python (Bodo3 to tie into AWS)

---

### System Deployment Process

1. Someone requests server
    - Api call
    - vmware manual deploy
    * tf kickoff
    * ansible pb

2. Server build starts
    - maybe a container is stood up
    - maybe a golden img is cloned to a new VM
    - maybe a physical machine is allocated

2. prebaked elements were already built into img. Artifacts are tracked in CMDB
    - All of STIGs are baked in
    - All LDAP configs are baked in

2. Personalization/user space/customization are built into the img as it is called.
    * Maybe as a httpd/db/app server.
    - These things are on a server by server and env by env basis.  

2. Typically final checkout occurs before handing over to users

---

AIDE does all the hashing to make sure nothing is changed on your system.  
Supports many different types of hashes.  

---

summary:  
system born, doesn't know who it is, comes with img, configure it.
config drift: Noise in the system. will never remove config drift from a system.  
how to deal w/ config drift? op practices (follow the rules), change management
activities, technical practices (apply technical tools to make sure things don't
change [permissions, services and software only where they should be, AIDE to track
changes]), custom automation (e.g., ansible) to chedck for drift, also fix drift

## TODO
<https://killercoda.com/het-tanis/course/Linux-Labs/203-updating-golden-image>
Look at bash pipeline variable for finding exit codees of pipeline commands

`hwclock`

Cron daily runs at 3:14 AM every morning on a linux system.  

Remove the `update-aide.conf` fomr lab


Track with AIDE:  
`/etc/sssd/sssd.conf`
`/etc/krb5.conf`

These two files should never change on the system.  

On older systems:
`/etc/samba.conf`


