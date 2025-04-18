# Unit 2 notes

STIGs and their focus

Fix them, Record them, and report them

Network standards and compliance.  

Killercoda SCC labs (hardening)

Relevant stigs
relevant tools
Verify the security settings?
    - tools to validate
    - configs
    - listening to connected ports
    - 

MAke sure headers are verified and locked down.  
Get rid of headers!
Search for keyword "header" in RHEL9 stig.  


Diamond intrusion model of analysis: 
- Summary: https://www.threatintel.academy/wp-content/uploads/2020/07/diamond_summary.pdf
- Original: https://www.activeresponse.org/wp-content/uploads/2013/07/diamond.pdf

Policies: High minded - ideas  
Procedures: How we react to events  

```bash
fips-mode-setup --check
cat /proc/cmdline
sestatus
cat /etc/selinux/confg
cat /etc/selinux/semanage.conf

ls -lZ /root # check if SELinux labeling is enabled

firewall-cmd --list-services
```

SCC tool (scanner)
STIGs and CIS benchmarks have a lot of crossover (a lot of similarities)  


## Remediation

Remediation is the thing that takes the longest. 
We know all the stigs and fixes. Why don't we just apply them when we build the
server?
That would fuckin break everything. 

Download and extract a STIG remediation tool -- `U_RHEL_9_V2R3_STIG_Ansible.zip`


Ansible:
the `sysctl` modifies the live system. But you need to modify the sysctl file too:
```yml
- name: stig rule
  sysctl:
    name: net.ipv4.conf.all.log_martians
    value: "{{ sysctl setting }}"
    sysctl_file: "{{ sysctl setting }}"
```

STIG a container:
Exec into container
```bash
cd /etc/sysctl.d
vi remediate.conf # -> then add all the right sysctl settings
```
Then when the system boots it'll read em all. 

---

Create an ansible playbook for openscap

```bash
dnf install -y openscap-scanner opernscap-utils openscap-scanner scap-security-guide
mkdir openscap && cd openscap

# generate the ansible
oscap xccdf generate fix --profile ospp --fix-type ansible /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.yml
```

Protip: Run it against chroot environments.  

```bash
# Or generate it as a bash script:
oscap xccdf generate fix --profile ospp --fix-type ansible /usr/share/xml/scap/ssg/content/ssg-rhel9-ds.xml > draft-disa-remediate.yml
```


## Martians 
Martians are little green aliens that carry packets from un-routable/impossible/invalid source addresses.
an example of a martian packet would be:
Packets with a source IP that shouldn't be routable:
- `127.0.0.1` from an external interface
- private ranges `192.168.x.x`, `10.x.x.x`, showing up where only public IPs should be
- Reserved or bogus IPs or malformed headers

