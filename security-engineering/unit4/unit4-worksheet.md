# Unit 4 Worksheet - Bastions and Jailing Users

## Instructions

---

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

### Resources / Important Links

- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>
- <https://aws.amazon.com/search/?searchQuery=air+gapped#facet_type=blogs&page=1>
- <https://aws.amazon.com/blogs/security/tag/bastion-host/>

#### Downloads

The worksheet has been provided below. The document(s) can be transposed to
the desired format so long as the content is preserved. For example, the `.txt`
could be transposed to a `.md` file.

- <a href="./assets/downloads/u4/u4_worksheet.pdf" target="_blank" download>📥 u4_worksheet(`.pdf`)</a>
- <a href="./assets/downloads/u4/u4_worksheet.txt" target="_blank" download>📥 u4_worksheet(`.txt`)</a>

<!-- - <a href="./assets/downloads/u3/u3_worksheet.docx" target="_blank" download>📥 u3_worksheet(`.docx`)</a> -->

<!-- ### Unit 4 Recording -->

<!-- <img src="./assets/images/under-construction.jpg" style="border-radius:2%"></img> -->

<!-- <iframe -->
<!--     style="width: 100%; height: 100%; border: none; -->
<!--     aspect-ratio: 16/9; border-radius: 1rem; background:black" -->
<!--     src="" -->
<!--     title="" -->
<!--     frameborder="0" -->
<!--     allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" -->
<!--     referrerpolicy="strict-origin-when-cross-origin" -->
<!--     allowfullscreen> -->
<!-- </iframe> -->

#### Discussion Post #1

Review some of the blogs here:

- <https://aws.amazon.com/search/?searchQuery=air+gapped#facet_type=blogs&page=1>
- <https://aws.amazon.com/blogs/security/tag/bastion-host/>

Or find some on your own about air-gapped systems.

1. What seems to be the theme of air-gapped systems?
    - The overarching theme of air-gapped systems is enhanced security by limiting
      the amount of network access it has.  

2. What seems to be their purpose?
    - The purpose of air-gapped systems is to limit access. By air-gapping your
      system, you're requiring a user to go through a set of steps that you
      explicitly define, which will only allow them to perform actions that are 
      sanctioned (ideally).  
    - This is particularly useful when using legacy software that is known to have
      vulnerabilities.  


3. If you use google, or an AI, what are some of the common themes that come up when
   asked about air-gapped or bastion systems?
    - Critical infrastructure that does not need to be on a network to function.  
    - Air-gapped systems are used when using old systems that are vulnerable to attacks (e.g., Windows XP).  
    - Stuxnet is mentioned a lot. 
        - This was a virus that utilized removable media (particularly USB drives) to
          deliver a malicious payload, which naturally bypasses the air-gapped
          network security measure.  



#### Discussion Post #2

Do a Google or AI search of topics around jailing a user or processes in Linux.

1. Can you enumerate the methods of jailing users?
    - Chroot jails
        - Changing the root directory for a user/process so that the user can't see
          or access files outside the jail.  
    - cgroups (control groups)
        - Restricts CPU/memory/IO usage for users or process. Usually combined with
          jails for more granular control.  
    - Container jails
        - Provides strong user/process isolation when used along with namespaces and
          cgroups. Considered "modern" and very common.  
    - Linux namespaces
        - Isolates resources (network, users, processes, and filesystems). Underpins
          containers and other jail tools. 
        - Containers, jails, and sandboxing tools are built on top of namespaces.  
    - rbash (restricted bash)
        - A limited shell where users can't change directories, run certain
          commands, or modify environment variables. It also doesn't allow the user
          to run any commands with slashes (e.g., `/usr/bin/id`).  
        - Set a user's shell to `rbash` in `/etc/passwd` or with `chsh`:
          ```bash
          chsh -s /bin/rbash username # change a user's shell to rbash
          ```
        - Then create a safe directory of allowed commands.
          ```bash
          mkdir /home/username/bin
          ln -s /bin/ls /home/username/bin/
          ln -s /bin/cat /home/username/bin/
          ```
        - You can then restrict the `PATH` and lock them in.  
          ```bash
          printf 'PATH=$HOME/bin' >> /home/username/.bash_profile
          chmod 755 /home/username
          chown username:username /home/username/.bash_profile
          ```
          Then the user is jailed to their home dir and is only able to run the
          commands in `$HOME/bin`.  
    - AppArmor/SELinux
        - Implements a MAC (mandatory access control) model that defines strict rules on what 
          a process or user can access (even as root).  
    - scp/sftp-only shells
        - Limits users to file transfer access without giving them access to a shell.  
          Used for shared hosting or backup users.  

2. Can you think of when you’ve been jailed as a Linux user?  
   If not, can you think of the useful ways to use a jail?
    - I'm pretty sure I have been jailed every time I logged into the ProLUG lab,
      being forwarded through the bastion host to the destination host.  
    - Useful ways to use a jail are represented in the lab -- controlling the ingress
      process.

<div class="warning">
Submit your input by following the link below.

The discussion posts are done in Discord threads. Click the 'Threads' icon on the top right and search for the discussion post.

</div>

- [Link to Discussion Posts](https://discord.com/channels/611027490848374811/1098309490681598072)

## Definitions

---

- Air-gapped: A system that is almost completely isolated from the network (no
  network interfaces connected to the internet).  
    - Truly full isolation is not possible since we still need ingress and egress.  

- Bastion: A DMZ (demilitarized zone) in which the user is jailed, and only given the
  necessary tools needed to get to where they need to go.  

- Jailed process: A process that is isolated from the rest of the machine.  
    - Usually can not interact with the base system as it is.  
    - A jailed process thinks it is the only process on the system.  

- Isolation: Keeping things separated from the rest of the environment.  

- Ingress: Entry points.
    - E.g., Allowing inbound SSH connections.  

- Egress: Exit points.
    - E.g., Allowing outbound SSH connections.  

- Exfiltration: The act of extracting data from a machine.  

- Cgroups: Control groups.

- Namespaces: 
    - Mount: 
    - PID: 
    - IPC: 
    - UTS: 

## Digging Deeper

---

1. While this isn’t, strictly speaking, an automation course there is some value in
   looking at automation of the bastion deployments. Check out this ansible code:  
   <https://github.com/het-tanis/stream_setup/blob/master/roles/bastion_deploy/tasks/main.yml>

   - Does the setup make sense to you with our deployment?
   - What can improve and make this better?

2. Find a blog or github where someone else deploys a bastion. Compare it to our
   process.

3. Knowing what you now know about bastions, jails, and air-gapped systems. Reflect
   on the first 3 weeks, all the STIGs you’ve reviewed and touched. Do any of them
   seem moot, or less necessary if applied in an air-gapped environment?

   - Does your answer change if you read about Zero Trust and know how much of a hot
     topic that is in the security world now?
     1. Why or why not?

4. Think of a Linux system where you would like to deploy a bastion (If you cannot think
   of one, use ProLUG Lab). Draw out how you think the system works in
   excalidraw.com.

## Reflection Questions

---

1. Does it matter if the user knows that they are jailed? Why or why not?

2. What questions do you still have about this week?

3. How are you going to use what you’ve learned in your current role?
