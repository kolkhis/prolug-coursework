# Unit 5 Notes

If we're airgapping a system, we still need a way to load software onto it.  
We'll probably be doing that via a hosted repo (via HTTPD, fork of apache-2.4 in RH-based).  
Enforce TLS (HTTPS).  


Building repos. 
Enterprise patching.

Overview:
Why is control important for sec eng?
- what is fit for use?
    - Check it is a car. It has 4 wheels. They're inflated to 42PSI. Has a trunk.
    - Make sure everything is functioning properly and everything is there. 
- what is fit for warranty?
    - Does it start on the 5001st time when turning the key?
    - Do you bet your weekend on it?
    - basically make sure it's both functional *and* reliable.  
Why do we create a repo locally?
- For security and compatibility, so we know exactly what version of what tools we're using.  
- So we have the control and allow devices to still update even if they're airgapped. 

How do we create a repo locally?
- We use a `.repo` file in `/etc/yum.repos.d/`

How do we share repos via network?

How do we configure our repos?

How does enterprise patching differ from one-off patching of systems?

What is a lifecycle in engineering and how does it relate to patching?


---

In Apache2.4, you can STIG to 100.  

* Check apache user
```bash
grep -i apache /etc/passwd
# check config
systemctl cat apache
ps -ef | grep -i httpd
```

---

Building repo
All repos
```bash
cd /etc/yum.repos.d
mkdir old_archive
mv *.repo old_archive
dnf repolist # All repos were moved!
```

```bash
# Mount the ISO
mount -o loop /lab_work/repos_and_patching/Rocky-9.5....iso /mnt
mount -o loop,rw /lab_work/repos_and_patching/Rocky-9.5.... /mnt  # if you want r/w access (readonly by default)
chmod 644 rocky9.repo 
dnf clean all
dnf repolist

df -h # check mount
cat repos.conf
```

Mount an ISO with `mount -o loop`.  

Some repos will end with the OS version:
* `el8`: Enterprise Linux 8
* `el9`: Enterprise Linux 9

dnf/yum looks at `repomd.xml` to download all repo data.  

Could also take the other iso (Mellanox) and put it on the system, and use the command
"Create Repo".  
```bash
dnf whatprovides createrepo
```
This builds an XML file for the repo so that DNF/YUM know what packages are in it.  

