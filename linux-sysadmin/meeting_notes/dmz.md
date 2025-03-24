# DMZ

Home router - 
In the WAN connection part of the router, some routers have a DMZ option.  
You can set up port forwarding rules to make certain connections go to outside of the DMZ.  


WAN vs LAN
* At home, the LAN is what we control, the WAN is what we don't control.  

In a company, the WAN might be the campus.
* The LAN is what we own/bought.  
* Things we're going to rent in perpituity, those are the WAN.  


Reflexive access control lists

SPI - stateful packet inspection

The router keeps track of packets that enter and exit
it filters tcp syn packets so nothing can make a connection request to the inside

Network ACL (Access control list)

If you let traffic out on port 80, it will allow traffic back in

---

## User Jailing
Let people in with air-gapped environment
- Jump box

SSHD - 
Make a jail within this file
```sshd_config
Match User user1
ChrootDirectory /var/chroot_user1
```
In this /var/chroot directory
You have a /bin/ dir, with all the binaries a user will need. 
- a basic `bash` with some binaries

Add a user in /etc/passwd and give the user a custom shell as a script - `bastion.sh`
You can specify a bash script as a user's shell in `/etc/passwd`.  

Give them a script as a shell that is on a timer and accepts input (with choices).  
Give the user only `curl`, `ssh`, and `bash`.  


## Wazuh

## Diagrams
Two types of diagrams - physical and logical
