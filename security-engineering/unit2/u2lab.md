<div class="flex-container">
        <img src="https://github.com/ProfessionalLinuxUsersGroup/img/blob/main/Assets/Logos/ProLUG_Round_Transparent_LOGO.png?raw=true" width="64" height="64"></img>
    <p>
        <h1>Unit 2 Lab - Network Standards and Compliance</h1>
    </p>
</div>

### Required Materials

Putty or other connection tool Lab Server

Root or sudo command access

STIG Viewer 2.18 (download from https://public.cyber.mil/stigs/downloads/ )

To qualify for the ProLUG certification download, fill out, and save the lab worksheet:

- <a href="./assets/downloads/u2/u2_lab.docx" target="_blank" download>📥 u2_lab(`.docx`)</a>

## Pre-Lab Warm-Up

---

**EXERCISES** (Warmup to quickly run through your system and familiarize yourself)

```bash
sysctl -a | grep -i ipv4 | grep -i forward
# Does this system appear to be set to forward? Why or why not?
# No -- ipv4 forwarding is set to: net.ipv4.ip_forward = 0

sysctl -a | grep -i ipv4 | grep -i martian
# What are martians and is this system allowing them?
```

Martians are little green aliens that carry packets from un-routable/impossible/invalid source addresses, like `127.0.0.1` from an external source.
The system does not seem to be *logging* them... All 'martians' entries are set to 0, 
but those entries are just `log_martians`, nothing about "allowing" martians. net.
`ipv4.conf.all.log_martians = 0` 
So, it seems the system is allowing martians and not logging them.

Upon further investigation, this setting seems to be blocking martians:  
`net.ipv4.conf.all.rp_filter = 1`

```bash
sysctl -a | grep -i panic
# How does this system handle panics?
```
Looks like the kernel is currently set to panic on an oops.  
Output:
```plaintext
[root@hammer5 ~]# sysctl -a | grep -i panic
kernel.hardlockup_panic = 1
kernel.hung_task_panic = 0
kernel.max_rcu_stall_to_panic = 0
kernel.panic = 0
kernel.panic_on_io_nmi = 0
kernel.panic_on_oops = 1
kernel.panic_on_rcu_stall = 0
kernel.panic_on_unrecovered_nmi = 0
kernel.panic_on_warn = 0
kernel.panic_print = 0
kernel.softlockup_panic = 0
kernel.unknown_nmi_panic = 0
vm.panic_on_oom = 0
```
This says that the kernel will panic on a CPU hard lockup, and a
kernel oopsie (a non-fatal bug).  


```bash
sysctl -a | grep -i crypto
# What are the settings you see? Is FIPS enabled?
```
I'm seeing these settings:
```plaintext
[root@hammer5 ~]# sysctl -a | grep -i crypto
crypto.fips_enabled = 0
crypto.fips_name = Rocky Linux 9 - Kernel Cryptographic API
crypto.fips_version = 5.14.0-427.18.1.el9_4.x86_64
```
The `fips` settings are "Federal Information Processing Standards."
FIPS mode enforces "FIPS 140-2" security standards.  
FIPS is not enabled on this system.  


```bash
cat /proc/cmdline
fips-mode-setup --check
sestatus
cat /etc/selinux/config
```

* What information about the security posture of the system can you see here?  

The security posture is geared more towards monitoring than actual policy enforcement.
FIPS mode is not enabled and SELinux is set to permissive.  

* Can you verify SELINUX status?  

It is set to permissive.  

* Can you verify FIPS status?

FIPS mode is not enabled.
```bash
[root@hammer5 ~]# fips-mode-setup --check
Installation of FIPS modules is not completed.
FIPS mode is disabled.
```

Download the STIG Viewer 2.18 from - <https://public.cyber.mil/stigs/downloads/>

<img src="./assets/downloads/u2/image2.png"></img>

Download the STIG for RHEL 9 and the import it into your STIG viewer

<img src="./assets/downloads/u2/image3.png"></img>

Create a checklist from the opened STIG for RHEL 9

<img src="./assets/downloads/u2/image4.png"></img>

## Lab 🧪

---

This lab is designed to have the engineer practice securing a Linux server or service against a set of configuration standards. These standards are sometimes called benchmarks, checklists, or guidelines. The engineer will be using STIG Viewer 2.18 to complete this lab.

### Network Service configuration

Connect to a hammer server  
Filter by ipv4 and see how many STIGs you have.

<img src="./assets/downloads/u2/image5.jpeg"></img>

#### Examine STIG V-257957

* What is the problem?  
    - RHEL 9 needs to be configured to use TCP syncookies.  
* What is the fix?  
    - Enable the `net.ipv4.tcp_syncookies` kernel parameter.
* What type of control is being implemented?  
    - This is a technical preventative control.  
* Is it set properly on your system?  
    - Yes: `net.ipv4.tcp_syncookies = 1`

```bash
sysctl -a | grep -i ipv4 | grep -i syncookies
```

<img src="./assets/downloads/u2/image6.png"></img>

* Can you remediate this finding?  
    * In this case it’s already correctly set.  
    * But if we needed to, we would set that value in `/etc/sysctl.d/00-remediate.conf`  
    * And then reload sysctl with `sysctl --system`

#### Check and remediate V-257958 STIG

* What is the problem?  
    - RHEL 9 needs to ignore ICMP redirect messages on ipv4 (ping packets).  
* What is the fix?  
    - Check net.ipv4.conf.all.accept_redirects
    - ```bash
      sysctl -a | grep -i ipv4 | grep -i accept_redirects
      ```
* What type of control is being implemented?  
    - Technical preventative control (prevents potential MITM attacks). 
* Is it set properly on your system?
    - No. `net.ipv4.conf.all.accept_redirects = 1`

<img src="./assets/downloads/u2/image7.png"></img>

* How would you go about remediating this on your system?
  ```bash
  if grep -ri 'net.ipv4.conf.all.accept_redirects' /etc/sysctl*; then
      find /etc -path '/etc/sysctl*' -name '*.conf' -type f -exec \
          sed -i '/net.ipv4.conf.all.accept_redirects/s/1/0/' {} +
  else
      printf "net.ipv4.conf.all.accept_redirects = 0\n" >> /etc/sysctl.d/99-remediate-stig-ipv4-icmp-redirects.conf
  fi
  sysctl --system # reload kernel parameters
  ```
  Check if the rule exists in `/etc/sysctl.conf` or any of the files in
  `/etc/sysctl.d/`, if it's there, replace the 1 with a 0, or if it's not there,
  add the rule to a new file in `/etc/sysctl.d/` with a name describing what the
  setting is for.  


#### Check and remediate V-257960 and V-257961 STIGs
* What is the problem? How are they related?  
    * RHEL 9 must log IPv4 packets with impossible addresses (martians)
    * RHEL 9 must log IPv4 packets with impossible addresses (martians) *by default*
* What is the fix?  
    - Set the `log_martians` kernel parameters for both `all` and `default`
      ```bash
      net.ipv4.conf.all.log_martians = 1
      net.ipv4.conf.default.log_martians = 1
      ```
* What type of control is being implemented?  
    - This is a technical preventative control. 
* Is it set properly on your system?
    - No, it's not:
      ```yaml
      [root@hammer5 ~]# sysctl -a | grep -i martians
      net.ipv4.conf.all.log_martians = 0
      net.ipv4.conf.default.log_martians = 0
      net.ipv4.conf.eth0.log_martians = 0
      net.ipv4.conf.lo.log_martians = 0
      ```
    - This setting doest not
    ```bash
    touch /etc/sysctl.d/99-remediate-stig-log-martians.conf
    printf "net.ipv4.conf.all.log_martians = 1\n" >> /etc/sysctl.d/99-remediate-stig-log-martians.conf
    printf "net.ipv4.conf.default.log_martians = 1\n" >> /etc/sysctl.d/99-remediate-stig-log-martians.conf
    sysctl --system
    ```

#### Filter by firewall

* How many STIGS do you see?
    * I see 6 STIGs when filtering for the word firewall (only 4 in the SS).

<img src="./assets/downloads/u2/image8.jpeg"></img>

* What do these STIGS appear to be trying to do? What types of controls are they?

These STIGs are trying both make sure `firewalld` is present and enabled, as well
as to lock down the firewall by employing a few different techniques:
* Configure with a deny-all/allow-by-exception policy.
* It also needs to be configured to restrict services' access to the network based 
  on the PPSM (Ports, Protocols, and Services Management) and CAL (Category Assignments 
  List) vulnerability assessments
* Rate limiting must be enabled via `nftables` (`FirewallBackend=nftables` in
  `/etc/firewalld/firewalld.conf`)


### Firewall port exposure

Scenario:

<blockquote>

Your team needs to use node_exporter with Prometheus to allow scraping of system information
back to your network monitoring solution. You are running a firewall, so you need to expose
the port that node_exporter runs on to the network outside of your system.

</blockquote>

#### Expose a network port through your firewall

```bash
# Verify that your firewall is running
systemctl status firewalld

# Verify that your firewall has the service defined
firewall-cmd --get-services | grep -i node
ls /usr/lib/firewalld/services | grep -i node

# Verify that the service is not currently enabled for node_exporter
fireall-cmd --list-services

# Examine the structure of the firewall .xml file
cat /usr/lib/firewalld/services/prometheus-node-exporter.xml

# Enable the service through your firewall
firewall-cmd --permanent --add-service=prometheus-node-exporter 

# Reload so the changes take effect
firewall-cmd --reload

# Verify that the service is currently enabled for node_exporter
firewall-cmd --list-services
```

### Automate STIG remediation on a system

There are many options and the STIG remediation steps are well known. Here the learner
will examine a few ways to generate Ansible and Shell fixes to your system. Then one can
apply all of them, or just some of them. This is the real value of a security engineer
focused Linux engineer, the trade-off between security and productivity.

#### Download and extract a STIG remediation tool

```bash
cd /root
mkdir stigs
cd stigs
wget -O U_RHEL_9_V2R4_STIG_Ansible.zip https://dl.dod.cyber.mil/wp-content/uploads/stigs/zip/U_RHEL_9_V2R4_STIG_Ansible.zip
unzip U_RHEL_9_V2R4_STIG_Ansible.zip
mkdir ansible
cp rhel9STIG-ansible.zip ansible/
cd ansible
unzip rhel9STIG-ansible.zip
```


#### Examine the default values for STIGS

```bash
cd /root/stigs/ansible/roles/rhel9STIG/defaults/
vim main.yml
```

Search for a few of the STIG numbers you used earlier and see their default values.

- use /257784 to search

#### Examine the playbook to see how those are applied in a running system.

```bash
vim /root/stigs/ansible/roles/rhel9STIG/tasks/main.yml
```

- use /257784 to search for the STIG from above and see how it is fixed in the playbook.

#### Create an Ansible playbook from OpenSCAP

```bash
dnf -y install openscap-scanner openscap-utils openscap-scanner scap-security-guide

# Generate the Ansible
oscap xccdf generate fix --profile ospp --fix-type ansible /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.yml

# Examine the file
vim draft-disa-remediate.yml

# Generate a BASH version
oscap xccdf generate fix --profile ospp --fix-type bash /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.sh

# Examine the file
vim draf-disa-remediate.sh
```
