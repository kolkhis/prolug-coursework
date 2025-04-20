# Unit 4 Notes
So three major questions for today:
* What is air-gapped?
* What is a jail?
* What is a bastion?




Last week we looked at PAM.  

Most common thing you'll use with PAM is SSH. Has a set of directives that are in `/etc/pam.d`, that's how SSH interacts with those tools.  

* Air gapped systems 
    * We wanna keep completely on its own network.
    - we still need Ingress and Egress
    - A system that is almost completely separate, in all ways, from the rest of the
      world.  
    - Manual access required to get into it.

    - Benefits:
        - Really secure.
        - Don't need to patch as much.
        - Protection against remote attacks
        - Malware prevention (less susceptible, maybe)
        - Data exfil prevention. Have to be auth'd and get in, then exfil with valet nodes
        - Data integrity. Less processes touching data, not designed for data integrity.  
        - Regulatory compliance. Some frameworks require sensitive data move in and out of the network.  
        - Last line of defense 


    - Cons:
        - We give up functionality.  

    - Is it really that secure or do we use a zero-trust policy?

    - Physically isolated from all other networks (internet and other LANs)

    - Isolation is achieved by ensuring the system has no network interfaces connected to any
      other networks (Not completely isolated, sitll some traffic out)

    - 

* Jailing users
    - We jail a user in a bastion host

- Bastions
    - Used to give users access to systems, sometimes remotely.  
    - Several ways to create a bastion.
        - Chroot jail is one way.  

If we want airgap to be securely reached, we need a bastion to allow ingress/egress
of data. One way to do this is by jailing users.

We build bastions by jailing users and processes.  


## Jailing in Linux
Chroot jail: System sees the root of the filesystem as some lower "apparent root" /
dir. SSHD supports this natively.  

Linux Containers (LSC, Docker, Podman): More advanced than simple jailing. They
leverage cgroups and namespaces for more isolation.  

- Namespaces: Virtualizes various systm resources, incl the filesystem (mount
  namespace), PIDs (pid namespace), network interfaces (network namespace) user and
  group IDs (user namespace) IPC resources (ipc namespace) and hostname (uts
  namespace). This gives each container its own isolated view of these resources.  

- cgroups (Control Groups): Limit and account for the resource usage (CPU, memory,
  IO) of a group of processes.  


## misc
Put "zero-trust" on your resume.  

* gvisor
* PAW - Privileged Access Workstation

## Let's build it

```bash
Outside system -> Bastion system -> controlplane
                    |
                Jailed user     -> Unjailed user
```

1. Write a bastion.sh script to lock in the user interaction in the jailed
   environment.

What to give them?
    - SSH
    - So they need to resolve network names
    - They need other libs and capabilities for SSH to work.

Create the user/users to jail
Create a line in /etc/ssh/sshd_config for jailed user
Set the user to
Create the jail
- Create the 5 directories that need to exist
    - /usr/bin
    - lib64
    - dev
    - etc
    - home
- copy in the correct executables
    - bash
    - ssh
    - curl
- Copy over the library files for those
    - `<insert cmd>`

* Make the 5 dev devices that are needed
    - /dev/null
    * /dev/tty
    * /dev/zero
    * /dev/random
    * /dev/urandom


