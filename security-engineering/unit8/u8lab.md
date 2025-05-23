# Unit 8 Lab - Configuration Drift and Remediation

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

- <a href="./assets/downloads/u8/u8_lab.txt" target="_blank" download>📥 u8_lab(`.txt`)</a>
- <a href="./assets/downloads/u8/u8_lab.pdf" target="_blank" download>📥 u8_lab(`.pdf`)</a>

## Lab 🧪

These labs focus on configuration drift tracking and remediation.

### Operational Activities

![Image 1](./assets/images/u8/image1.jpeg)

1. Check your stig viewer and go to RHEL 9 stigs.

2. Set a filter for “change management”.

   - How many STIGs do you see?
        - I see 9 STIGs that contain "change managment" in the RHEL 9 STIGs.  

3. Review the wording, what is meant by a robust change management process?
   ```txt
   If RHEL 9 allowed any user to make changes to software libraries, then those changes 
   might be implemented without undergoing the appropriate testing and approvals that 
   are part of a robust change management process.
   ```
   > - I think "robust change management process" here means that the process for
   > implementing changes should be part of a larger process -- with version
   > control, peer review, 

   - Do you think this can be applied in just one STIG? Why or why not?
        > - Probably not. Implementing a robust change management process isn't just
        >   turning on a service or modifying kernel runtime parameters. It's an
        >   organization-level task that requires everyone to be on the same page
        >   about how configuration and change is implemented, modified, and
        >   deployed.    
   - What type of control is being implemented with change management in these STIGS?
        > - These are, I believe, technical preventative controls. They all deal with
        >   ensuring files have the correct permissions. Most of them deal with
        >   making critical system files root-owned.  
     - Is it different across the STIGs or all the same?
        > - The type of control seems to be the same across all change management
        >   STIGs.  

### Monitoring configuration drift with Aide

1. Go into the sandbox lab: <https://killercoda.com/playgrounds/scenario/ubuntu>

2. Install aide and watch the installation happen.

   ```bash
   apt -y install aide
   ```
   - What is being put in the path `/etc/aide/aide.conf.d/`?  
        > - Configuration files for AIDE for different services.  
        > - These configuration files contain patterns. The patterns specify paths for
        >   files that should be hashed and stored in the AIDE database. These file
        >   hashes will be checked for changes when AIDE runs an integrity check.  
        > - The AIDE configuration also has some special syntax in the configuration
        >   files that allows for conditional logic.  
     - How many files are in there?
        > - 213 files.  

3. Check your version of aide

   ```bash
   aide -v
   ```
   > AIDE 0.18.6  

4. Read the man page (first page).

   - What does aide try to do, and how does it do it?

        > - Stands for Advanced Intrusion Detection Environment.
        > - It attempts to verify file integrity.
        >   It does this by using a database to store file hashes for files specified
        >   in its config files. Then, when running a check, AIDE is checking the current hashes 
        >   of the file against the hashes stored in its database. If changes are
        >   detected, they will be reported to the user when running the check.  


5. What is the configuration of cron found in `/etc/cron.daily/dailyaidecheck`?

   - What does this attempt to do?
        > - It makes sure the script `/usr/share/aide/bin/dailyaidecheck` exists and is
            executable, and then runs that script via `capsh` if `capsh` is available. If `capsh` 
            is not available, it's run with just regular `bash`.  

   - What checks are there before execution?
        > - It checks if the `/run/systemd/system` directory exists. It also checks if `capsh` is available.  
        > - The script is run using `capsh` if it's there, and uses bash if `capsh`
          isn't available.  
        - The check:
          ```bash
          if command -v capsh > /dev/null; then
              capsh --caps="cap_dac_read_search,cap_audit_write+eip cap_setpcap,cap_setuid,cap_setgid+ep" \
                  --keep=1 --user=_aide \
                  --addamb=cap_dac_read_search,cap_audit_write -- \
                  -c "${SCRIPT} --crondaily"
          else
            "${SCRIPT}" --crondaily # execute the script directly without capsh
          ```

   - Read the man for `capsh`, what is it used for?
        > - `capsh`: Capability Shell wrapper. It's used for testing capability and
        >   environment creation. It's a more fine-grained alternative to the
        >   "all-or-nothing" root permissions model.    
        > 
        >   Capabilities allow programs to perform privileged operations without
        >   becoming full root.  
        >   You can use `capsh` to drop root privileges, set capabilities, or run as
        >   another user with just the necessary permissions to do what you need to
        >   do.  
        >   
        >   In this instance, it's running the `dailyaidecheck` script with just enough 
        >   permissions for the `_aide` user to perform the actions it needs to perform.  


6. Set up aide according to the default configuration

   ```bash
   time aide -i -c /etc/aide/aide.conf
   ```
   - How long did that take?
        > - 4 minutes and 14 seconds
        ```bash
        real    4m14.839s
        user    3m30.362s
        sys     0m8.712s
        ```
     - How much time was wall clock v. system/user time?  
        > - User time was 44 seconds less than wall clock time. System time was only 8 seconds.  

     - Why might you want to know this on your systems?  
        > - If we're installing AIDE on more than one system, or if we're doing it
        >   more than once, it is definitely a good thing to know. How long it will
        >   take to set up, and the amount of resources it uses. If we know what to
        >   expect with that, we can plan accordingly. This could also be a cloud
        >   consideration. How much compute time will be used if we're installing
        >   this on an EC2 instance, for instance? 

     - What do you notice about the output?  
        > - The output contains the new database written to
        >   `/var/lib/aide/aide.db.new`, which prevents potentially overwriting a
        >   pre-existing aide database.  
        > - The output also contains multiple hashes for the new database file.  
        >     - It contains MD5, SHA{1,256,512}, RMD160, TIGER, CRC32[B],
        >       HAVAL, WHIRLPOON, and GOST hashes. 
        >     - We can store these hashes to store the state of the new database.
        >       Then we can use those hashes to detect any changes made to the
        >       database. Sort of like snapshots, except we can't roll back with just
        >       hashes.  

       1. What do you need to go read about?  
            > - RMD160, TIGER, CRC32, CRC32B, HAVAL, WHIRLPOOL, and GOST hashes. I've
            >   never heard of these ones before.  

![Image 2](./assets/images/u8/image2.jpeg)

(Mine took 5 minutes 8 seconds to run on the lab system)

7. Set the database up properly  

   ```bash
   cp /var/lib/aide/aide.db.new /var/lib/aide/aide.db
   ```

8. Test aide by making files in a tracked directory  

   ```bash
   mkdir /root/prolug
   touch /root/prolug/test1
   touch /root/prolug/test2
   time aide -c /etc/aide/aide.conf --check
   ```
     - Did you see your new files created?
        > - Yes, under the "Added entries" section.  
     - How long did this take to run?
        > - 6 minutes and 38 seconds
        ```bash
        End timestamp: 2025-05-18 01:06:19 +0000 (run time: 6m 39s)

        real    6m38.765s
        user    5m54.272s
        sys     0m8.283s
        ```

       1. What type of usage do you see against user/system space?
            > - Again, the user time was about 45 seconds less than wall time.
            >   The system time was also 8 seconds (like the last timed cmd).  

![Image 3](./assets/images/u8/image3.png)

### Using Ansible to fix drift

1. Complete the lab here: 
   <https://killercoda.com/het-tanis/course/Ansible-Labs/16-Ansible-Web-Server-Env-Deploy>
    ```
    controlplane:~$ cat /answers/*.conf
    <VirtualHost *:8080>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html_dev

        ErrorLog ${APACHE_LOG_DIR}/dev_error.log
        CustomLog ${APACHE_LOG_DIR}/dev_access.log combined

    </VirtualHost><VirtualHost *:8082>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html_qa

        ErrorLog ${APACHE_LOG_DIR}/qa_error.log
        CustomLog ${APACHE_LOG_DIR}/qa_access.log combined

    </VirtualHost><VirtualHost *:8081>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html_test

        ErrorLog ${APACHE_LOG_DIR}/test_error.log
        CustomLog ${APACHE_LOG_DIR}/test_access.log combined

    </VirtualHost>
    ```
    - Second variant needs the vars `deploy` (`present` or `absent`), `env` (`dev`, `test`, `qa`),
      and `port` (`8080`, `8081`, `8082`)

2. When you finish ensure that you see broken output for 8081, as required.

   ```bash
   curl node01:8080
   ```
    - Output:
      ```plaintext
      controlplane:~$ curl node01:8081
      curl: (7) Failed to connect to node01 port 8081 after 2 ms: Couldn't connect to server
      ```

3. One of the dev teams figured out they could modify the test and qa environments because a
   previous engineer left them in the sudoers file. You can address that separately with 
   the security team, but for now you need to get those environments back to working. 
   Run your original deployment command to see if it sets the environment back properly.

   ```bash
   ansible-playbook -i /root/hosts /root/web_environment.yaml
   ```

![Image 4](./assets/images/u8/image4.png)

- Did this force the system back into a working configuration?
    > - yes, it did force the system back to a working config.  

  - If it worked, would it always work, or would they (the systems) need to be
    manually intervened?
    > - It *should* always work (the original playbook) without manual intervention.  
    >   Since we're installing and configuring Apache from scratch every time, it
    >   should not need any manual intervention unless the network is misconfigured
    >   (e.g., firewall rules are blocking connections). 

  - What is your test? (hint: `curl` 8080 8081 and 8082 from previous commands)
    ```bash
    curl node01:808{0,1,2}
    ```
- Could this cause potential problems in the environment?
    > - If the environment is just being used for this singular purpose (serving the
    >   web application), and is being bootstrapped for a first-time deployment, no.  
    > - If the environment is further configured after the initial deployment, then
    >   this could potentially overwrite some of the configurations that were made,
    >   which could definitely cause problems. Another example of how configuration
    >   drift can cause problems.  

  - If so, is that problem based on technology or operational practices? Why?
    > - Operational practices. This would be other people messing with the
    >   configuration of an environment whos deployment and configuration is automated.  
    >   Without letting everyone know of changes before making them, other teams
    >   could potentially make breaking changes. So this would be an operational
    >   problem.  

### Digging Deeper challenge (not required for finishing lab)

1. Complete this lab: <https://killercoda.com/het-tanis/course/Ansible-Labs/19-Ansible-csv-report>
   - Can you think about how you’d use this to verify that a system was stamped
     according to your build process?
     - You may have to tie it in with something like this lab and add some variables
       to your custom facts files, maybe the date of deployment:
       <https://killercoda.com/het-tanis/course/Ansible-Labs/12-Ansible-System-Facts-Grouping>

> Be sure to `reboot` the lab machine from the command line when you are done.
