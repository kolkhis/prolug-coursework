<div class="flex-container">
        <img src="https://github.com/ProfessionalLinuxUsersGroup/img/blob/main/Assets/Logos/ProLUG_Round_Transparent_LOGO.png?raw=true" width="64" height="64"></img>
    <p>
        <h1>Unit 4 Lab - Bastions</h1>
    </p>
</div>

> If you are unable to finish the lab in the ProLUG lab environment we ask you `reboot`
> the machine from the command line so that other students will have the intended environment.

### Required Materials

Putty or other connection tool Lab Server

Root or sudo command access

STIG Viewer 2.18 (download from <https://public.cyber.mil/stigs/downloads/> )

#### Downloads

The lab has been provided below. The document(s) can be transposed to
the desired format so long as the content is preserved. For example, the `.txt`
could be transposed to a `.md` file.

<!-- - <a href="./assets/downloads/u4/u4_lab.txt" target="_blank" download>📥 u4_lab(`.txt`)</a> -->
- <a href="./assets/downloads/u4/u4_lab.pdf" target="_blank" download>📥 u4_lab(`.pdf`)</a>


## PreLAB

Review lab diagram for the Bastion design.

<img src="./assets/images/u4/u4_lab_bastion_diagram.png" />

## LAB

This lab is designed to have the engineer practice securing a Linux environment by the use of bastion
hosts and jailing users as they enter an air-gapped environment.

### Jailing a User

1. Follow the lab here answering the questions below as you progress:
   <https://killercoda.com/het-tanis/course/Linux-Labs/204-building-a-chroot-jail>

2. If you were to write out the high level steps of building a chroot jail, what would they be?

3. Think about what you did in the lab and what extra (or less) you might give a user/process.
   - What directories are needed?
        - `/var/chroot` (or another directory to use as chroot)
        - Root subdirectories to help pretend that `/var/chroot` is root:
            - `/bin`
            - `/lib64`
            - `/dev`
            - `/etc/`
            - `/home`
            - `/usr/bin`
            - `/lib/x86_64-linux-gnu`
   - What executables might you give the jailed user/process?
        - `bash` so that it can run whatever commands and scripts needed.  
        - `ssh` if using as a jumpbox.  
        - `bastion.sh` if used as a bastion.  

   - If you give an executable, why is it important to give the link libraries that it uses?
        - If the link libraries are not given, the executable won't work.  
          The executable expects its dependencies to be present.  

   - What are the special files that you made with mknod and why must they be there?
     (try removing them or redoing the lab without them. How does it break?)
        - `mknod` makes special files. That is, files that are not regular files or
          directories.  
          It can make block device files, character special files, or pipes (FIFOs... though, I'm
          not sure why you'd use this over `mkfifo`).


### Building a Bastion

1. Follow the lab here: <https://killercoda.com/het-tanis/course/Linux-Labs/210-building-a-bastion-host>

2. If you were to write out the high level steps of building a bastion host, what would they be?

    - Create a chrooted environment
    - Copy binaries and their dependencies
    - Copy necessary system files
    - Create bash script to use as user's custom shell
    - Create jailed user account, set shell to script with `chsh` or in `/etc/passwd`
    - Set the user's root directory in `/etc/ssh/sshd_config`
      ```bash
      Match User jaileduser
      ChrootDirectory /var/chroot
      ```
    - Restart the ssh daemon and try to connect via ssh to that user account


3. When you jump into the bastion host, do you have any options other than the one you have given yourself?

    - Not that I'm aware of. The script is very strict in what is allowed and what is
      not. There is no obvious way to execute arbitrary commands as the jailed user.

4. How did you test that you couldn’t leave the jailed environment?
    - I tried entering other input, which was invalid and discarded. I tried hitting
      `^C` to interrupt the script, but since it's the user's shell it just kicked me
      out of the jail back to the original box.  

- How effective do you think this is as a technical preventative control against user
  breakout in the jail, having a 20 second timeout?
    - I think this is very effective. Having the timeout prevents the user from
      exploring and trying new things at their leisure. Without a timeout, this is
      still pretty effective as there are few options, but the fact that they need to
      reconnect every time to try new things is also good.

## Digging Deeper challenge (not required for finishing lab)

1. Fix the drawing from the lab with excalidraw and properly replace it here:
   <https://github.com/het-tanis/prolug-labs/tree/main/Linux-Labs/210-building-a-bastion-host>

2. Do a pull request and get some github street cred or something.

> Be sure to `reboot` the lab machine from the command line when you are done.
