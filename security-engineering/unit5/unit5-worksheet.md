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
2. What new things did you learn or pick up?  
3. What are the DNF plugins?  
    - What is the use of the versionlock plugin?  
4. What is an EPEL?  
    >- Extra Packages for Enterprise Linux. What does it mean to be an EPEL tho?
    >  (what's supported and what's not -- possible unsupported configuration)  

    - Why do you need to consider this when using one?  


### Unit 5 Discussion Post 2
Do a google search for “patching enterprise Linux” and try to wade through all of the noise.

1. What blogs (or AI) do you find that enumerates a list of steps or checklists to consider?
2. After looking at that, how does patching a fleet of systems in the enterprise 
   differ from pushing "update now" on your local desktop?
    - What seems to be the major considerations?
    - What seems to be the major roadblocks?
        - There are major roadblocks that are not technological. If the dev team is
          not patching on schedule, if they're favored by the company, they may not
          be compelled to do what you say.  



## Definitions/Terminology
- Patching

- Repos

- Software

- EPEL

- BaseOS v. Appstream (in RHEL/Rocky)

- Other types you can find?

- httpd

- patching

- GPG Key

- DNF/YUM


## Notes During Lecture/Class:

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
