# Unit 5 Lab - Repos and Patching

<!-- > If you are unable to finish the lab in the ProLUG lab environment we ask you `reboot` -->
<!-- > the machine from the command line so that other students will have the intended environment. -->

<!-- ### Required Materials -->

<!-- Putty or other connection tool Lab Server -->

<!-- Root or sudo command access -->

<!-- STIG Viewer 2.18 (download from <https://public.cyber.mil/stigs/downloads/> ) -->

<!-- #### Downloads -->

<!-- The lab has been provided below. The document(s) can be transposed to -->
<!-- the desired format so long as the content is preserved. For example, the `.txt` -->
<!-- could be transposed to a `.md` file. -->

<!-- - <a href="./assets/downloads/u5/u5_lab.txt" target="_blank" download>📥 u5_lab(`.txt`)</a> -->
<!-- - <a href="./assets/downloads/u5/u5_lab.pdf" target="_blank" download>📥 u5_lab(`.pdf`)</a> -->
<!-- - <a href="./assets/downloads/u5/u5_lab.docx" target="_blank" download>📥 u5_lab(`.docx`)</a> -->

<!-- > Be sure to `reboot` the lab machine from the command line when you are done. -->

## PreLAB

Download the STIG Viewer 2.18 from - <https://public.cyber.mil/stigs/downloads/>

<!-- <img src="./assets/images/download_stig_viewer.png" /> -->

Download the STIG for Apache 2.4 and the import it into your STIG viewer

<!-- <img src="./assets/images/download_apache2_stig.png" /> -->

Create a checklist from the opened STIG for Apache 2.4

<!-- <img src="./assets/images/create_apache2_stig_checklist.png" /> -->

Review the software download process for Mellanox drivers:  
[Linux InfiniBand Drivers](https://network.nvidia.com/products/infiniband-drivers/linux/mlnx_ofed/)

<!-- <img src="./assets/images/u5/linux_infiniband_drivers_mlnx_u5lab.png" /> -->

Look through the available downloads and see if you can find the currently available
LTS for Rocky 9.5 x86_64.  
After that find a distribution of your choice and play with their tool.

<!-- <div class="warning"> -->
<!-- You do not have to download or move this into our environment, I have already provided them in our lab. -->
<!-- </div> -->

## LAB

This lab is designed to have the engineer practice deploying patches in a Linux environment. The
engineer will create repos and then deploy patches through an automated enterprise level Ansible
playbook. But first, the engineer will review some of the Apache 2.4 STIG requirements if they want to
run their own repo on their network.

### Apache STIGs Review

---

1. Look at the 4 STIGs for "tls"

   - What file is fixed for all of them to be remediated?
      - `httpd.conf`

2. Install httpd on your Hammer server

   ```bash
   systemctl stop wwclient
   dnf install -y httpd
   systemctl start httpd
   ```

3. Check STIG V-214234

   - What is the problem?
        - The apache webserver needs to alert the ISSO if a processing failure
          occurs.  

   - What is the fix?
        - To work with an admin to determine if there are alerts configured for when
          log data is not being received as expected. If there are none, set them up.  

   - What type of control is being implemented?
        - This is a technical detective control.  

   - Is it set properly on your system?
        - No. We have no alerts set up, since it's a clean install of httpd.  

4. Check STIG V-214248

   - What is the problem?
        - The webserver files (directories, libraries, and config files) should only
          be accessible by privileged users.  
          This STIG enforces the rule of least privilege.  

   - What is the fix?
        - Make sure no non-admins have access to the directory tree (files), have shell
          access, or have access to any other OS functions/utilities.  

   - What type of control is being implemented?
        - This is a technical preventative control.   
          It helps to prevent any unauthorized actions on the webserver.

   - Is it set properly on your system?
        - When looking in `/etc/passwd`, there are user accounts with shell
          access who are not administrators, so this is a finding.  
          ```bash
          grep -i 'bash' /etc/passwd
          getent passwd | grep -i 'bash'
          ```
        - The directories have the correct ownership (owned by root).
          ```bash
          [root@hammer6 ~]# ls -alh /var/www
          # total 0
          # drwxr-xr-x.  4 root root  80 Apr 30 08:30 .
          [root@hammer6 ~]# ls -alh /etc/httpd/
          # total 0
          # drwxr-xr-x.  5 root root  180 Apr 30 08:30 .
          ```
          But the permissions still allow for `r` and `x` on these directories, so
          it's not set up properly on the system.  


   - How do you think SELINUX will help implement this control in an enforcing state? Or
     will it not affect it?
        - SELinux compliments file permissions, which can help implement this
          control. It uses a MAC (mandatory access control) list to determine who has
          access to what on the system, so a properly set SELinux context for the
          relevant files can help implement this STIG. 
        - However, the fact that the STIG requires no shell access for non-admin
          accounts, SELinux won't enforce this STIG without a major system overhaul.  

### Building repos

1. Start out by removing all your active repos

   ```bash
   cd /etc/yum.repos.d
   mkdir old_archive
   mv *.repo old_archive
   dnf repolist
   ```

2. Mount the local repository and make a local repo

   ```bash
   mount -o loop /lab_work/repos_and_patching/Rocky-9.5-x86_64-dvd.iso /mnt
   df -h  # Should see the mount point
   ls -l /mnt
   touch /etc/yum.repos.d/rocky9.repo
   vi /etc/yum.repos.d/rocky9.repo
   ```

   Add the repo configuration:

   ```ini
   [BaseOS]
   name=BaseOS Packages Rocky Linux 9
   metadata_expire=-1
   gpgcheck=1
   enabled=1
   baseurl=file:///mnt/BaseOS/
   gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

   [AppStream]
   name=AppStream Packages Rocky Linux 9
   metadata_expire=-1
   gpgcheck=1
   enabled=1
   baseurl=file:///mnt/AppStream/
   gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
   ```

   Save with `esc :wq` or "shift + ZZ"

   - Do the paths you're using here make sense to you based off what you saw
     when using the `ls -l`? Why or why not?
        - Yes, the paths make sense. The ISO was mounted in `/mnt`, and the `baseurl`
          is pointing at each directory in there (`AppStream` and `BaseOS`).  

   ```bash
   chmod 644 /etc/yum.repos.d/rocky9.repo
   dnf clean all
   ```
   <!-- [root@hammer6 yum.repos.d]# dnf clean all -->
   <!-- 43 files removed -->


3. Test the local repository.

   ```bash
   dnf repolist
   dnf --disablerepo="*" --enablerepo="AppStream" list available
   ```
    <!-- [root@hammer6 yum.repos.d]# dnf repolist -->
    <!-- repo id                                  repo name -->
    <!-- AppStream                                AppStream Packages Rocky Linux 9 -->
    <!-- BaseOS                                   BaseOS Packages Rocky Linux 9 -->

   - Approximately how many are available?
        - A lot. 5591 packages.  
          ```bash
          [root@hammer6 yum.repos.d]# dnf --disablerepo="*" --enablerepo="AppStream" list available | wc -l
          5591
          ```

   ```bash
   dnf --disablerepo="*" --enablerepo="AppStream" list available | nl
   dnf --disablerepo="*" --enablerepo="AppStream" list available | nl | head
   ```

   Now use BaseOS.

   ```bash
   dnf --disablerepo="*" --enablerepo="BaseOS" list available
   ```

   - Approximately how many are available?
        - Much less than AppStream. Only 1002 packages.  
          ```bash
          [root@hammer6 yum.repos.d]# dnf --disablerepo="*" --enablerepo="BaseOS" list available | wc -l
          1002
          ```

   ```bash
   dnf --disablerepo="*" --enablerepo="BaseOS" list available | nl
   dnf --disablerepo="*" --enablerepo="BaseOS" list available | nl | head
   ```

   - Try to install something

     ```bash
     dnf --disablerepo="*" --enablerepo="BaseOS AppStream" install gimp
     # hit "n"
     ```

     1. How many packages does it want to install?
        - It wants to install 173 packages.  

     2. How can you tell they're from different repos?
        - It shows the repository when listing the packages it wants to install.
          
4. Share out the local repository for your internal systems (tested on just this one system)

   ```bash
   rpm -qa | grep -i httpd
   systemctl status httpd
   ss -ntulp | grep 80
   lsof -i :80
   cd /etc/httpd/conf.d
   vi repos.conf
   ```

   Edit the file:

   ```xml
   <Directory "/mnt">
       Options Indexes FollowSymLinks
       AllowOverride None
       Require all granted
   </Directory>
   Alias /repo /mnt
   <Location /repo>
       Options Indexes FollowSymLinks
       AllowOverride None
       Require all granted
   </Location>
   ```

   Restart the service.

   ```bash
   systemctl restart httpd
   vi /etc/yum.repos.d/rocky9.repo
   ```

   Edit the file with your lab's name in the `baseurl`:

   ```ini
   ###USE YOUR HAMMER MACHINE IN BASEURL###
   [BaseOS]
   name=BaseOS Packages Rocky Linux 9
   metadata_expire=-1
   gpgcheck=1
   enabled=1
   #baseurl=file:///mnt/BaseOS/
   baseurl=http://hammer25/repo/BaseOS/
   gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

   [AppStream]
   name=AppStream Packages Rocky Linux 9
   metadata_expire=-1
   gpgcheck=1
   enabled=1
   #baseurl=file:///mnt/AppStream/
   baseurl=http://hammer25/repo/AppStream/
   gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
   ```

   - Do the paths you've modified at `baseurl` make sense to you? If not, what do you need to better understand?
        - Yes. Since we've added an xml config file to alias the `/mnt` directory to
          `/repo`, we're pointing the baseurl to `http://<host>/repo`, which is being
          hosted by the apache webserver (hence the `http` protocol).  
          I don't understand everything the XML is doing, but that much I can gather.  

   ```bash
   dnf clean all
   dnf repolist
   # Try to install something
   dnf --disablerepo="*" --enablerepo="BaseOS AppStream" install gimp
   ```

### Enterprise patching

---

1. Complete the killercoda lab found here: <https://killercoda.com/het-tanis/course/Ansible-Labs/102-Enterprise-Ansible-Patching>

   - Look at the roles, in the order the are run in the playbook.
     - Does it make sense how the custom facts are used? What other custom
       facts might you use?
        - The facts here:
          `db_patching.fact`
          ```json
          {
              "patch_group": "group2",
              "rebooting":   "false",
              "appserver":   "true",
              "database":    "true",
              "webserver":   "false"
          }
          ```
          And `web_patching.fact`
          ```json
          {
              "patch_group": "group1",
              "rebooting":   "false",
              "appserver":   "app",
              "database":    "false",
              "webserver":   "true"
          }
          ```
          These contain facts that can be used to easily determine where we're at
          inside playbooks, so we don't need to do any sort of gymnastics to figure
          out if the machine's purpose is webserver or database.  
          These are very useful. Some other ones I might include would be maybe a
          `dependencies` entry to quickly install all the deps for the type of host
          we're on.  

       
     1. What are the prechecks doing? What other ones might you add?
        - The prechecks seem to be grouping the hosts based on their OS and
          major version. Like creating a group for "Rocky 9" boxes (`Rocky9`).  
        - They're also checking the local `fact` files for the `rebooting` key. If
          it's there, it will also group by this flag, and the host is added to a
          `rebooting` group.
        - One other precheck I might add could be to check available disk space
          before patching. This way it doesn't fill up the disk unintentionally.  
        - Another precheck could be checking if there's a package manager lock. Like
          `versionlock` on DNF.  

     2. What does the reboot task do, and how does it check for reboot to be needed?
        - It checks if a reboot is needed by using `needrestart -b` (Debian-based)
          and `needs-restarting -r` (RedHat-based) and registers the output to a
          variable. Then a fact is set, `reboot_required`, to either `true` or `false`
          depending on the output.  
          If `reboot_required` and `rebooting` are both set to `true`, it will reboot.  

## Digging Deeper challenge (not required for finishing lab)

1. You've set up a local repository and you've shared that repo out to other systems that might
   want to connect.
   Why might you need this if you're going to fully air-gap systems?  
   Is it still necessary even if your enterprise patching solution is well designed? Why or why not?

2. Can you add the Mellanox ISO that is included in the `/lab_work/repos_and_patching` section to
   be a repository that your systems can access?
   If you have trouble, troubleshoot and ask the group for help.

3. Make a pull request to improve the enterprise patching tool that you just used. Write up, for the
   group, why you need that change and how it improves the efficacy of the patching.

