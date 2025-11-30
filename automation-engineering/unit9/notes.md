# Unit 9 Notes

Topic: Building and deploying Linux systems in an automated fashion.  


Lab: Build out Warewulf inside an env. 

## Lab buildout for Unit 9

Setup the version of go that works with Warewulf
```bash
apt -y update && apt -y install make git
rm -rf /usr/local/go
apt purge golang-go
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version
```

Install Ansible
```bash
apt -y install ansible
```

Build Warewulf on Ubuntu.
```bash
git clone https://github.com/warewulf/warewulf.git
cd warewulf 
make
time make install       #this may take 8 minutes
cp /usr/local/etc/warewulf/warewulf.conf.example /etc/warewulf/warewulf.conf
```

Install apptainer
```bash
add-apt-repository -y ppa:apptainer/ppa
apt update && apt install -y apptainer apptainer-suid
apptainer --version
```

Download and prepare an image

```bash
wwctl image import --build docker://ghcr.io/warewulf/warewulf-rockylinux:9 my-rocky-image
wwctl image list
uname -r
cat /etc/*release
wwctl image shell my-rocky-image
uname -r 
cat /etc/*release
dnf update # hit N, as we don't want to update now.
false
exit # What error code do we see? Why is that?
```

Find where that image is, for automated chroot activities.
```bash
find / -name warewulf
cd /var/local/warewulf/chroots/my-rocky-image/
```


Get a version of an OS downloaded

Modify the OS inside Warewulf
  - manually
  - with Ansible
    - Pre: Fix resolv.conf
        ```bash
        cd /var/local/warewulf/chroots/my-rocky-image/
        vi resolv.conf
        #add
        nameserver 8.8.8.8
        ```

```bash
wwctl image build prolug-rocky-image # after changing
```

---


Modify the OS inside Warewulf
  - manually
    - wwctl image shell my-rocky-image
      - make modifications
      - exit
  - with Ansible
    Pre: fix your resolv.conf 
    cd /var/local/warewulf/chroots/my-rocky-image/etc/
    vi resolv.conf
    #add the line
    nameserver 8.8.8.8
  
    1. mkdir /root/ansible
    2. cd /root/ansible
    3. vi /root/ansible/chroots
       #add the following lines
       [chroots]
       /var/local/warewulf/chroots/my-rocky-image/rootfs/ ansible_connection=chroot
    4. vi /root/ansible/package.yaml
       #add the following lines

```bash
wwctl overlay list
wwctl overlay list resolve -a
wwctl overlay cat resolve etc/ressolv.conf.ww
wwctl overlay show resolve etc/ressolv.conf.ww
wwctl overlay show resolve etc/ressolv.conf.ww --render=my-rocky-image
```

Little playbook:

```yaml
---
- name: Install telnet on all hosts
  hosts: chroots
  become: true  # This allows the tasks to run with elevated privileges 
  tasks:
   - name: Ensure telnet package is installed
     package:
       name: telnet
       state: present
```
