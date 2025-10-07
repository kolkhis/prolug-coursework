# Unit 2 Lab – Interacting with the Operating System

## Required Materials

- Putty or other connection tool
- Lab Server 
    - Killercoda recommended: <https://killercoda.com/het-tanis/course/AutomationLabs/Unit2_Interacting_with_OS> 
- Root or sudo command access


## LAB
This lab is designed to have the engineer verify and execute their automation 
tools to interact with the OS in a controlled fashion.

If you do the Killercoda Lab 2, just answer these questions. If you are doing 
the lab in the ProLUG environment, find the scripts in `/labs/automation/unit2`.


### Lab Setup (ProLUG Lab Only)
```bash linenums="1"
cp -r /labs/automation/unit2/* /root
chmod 755 *.sh
chmod 755 *.py
```


### Bash Execution

1. Run the u2_script1.sh and look at what it shows you.
   ```bash
   /root/u2_script1.sh
   ```
   What are you shown?
    - Answer: /etc/passwd entries. The first 10 and the bottom 10 it seems.  

2. Inspect the file and see if you can modify it to show the first 15 lines.
   ```bash
   cat /root/u2_script1.sh
   ```
   Note: Modify with `vi` or `vim`. You may have to RTFM to continue.
    - Answer: Changed `head -n 10` to `head -n 15`

3. Run the u2_script2.sh and look at what it shows you.
   ```bash
   /root/u2_script2.sh
   ```
   What happened in the script? Did it work correctly?
    - Answer: It created a logfile that contains the full date, the filename contains the date in `YYYY-MM-DD` format
   ```bash
   ls -l /root
   ```

4. Inspect the file and see if you can make it use a different date format. You 
   may have to read the man pages for `date` command.
   ```bash
   cat /root/u2_script2.sh
   ```
    - Answer: Change this line:
      ```bash
      date >> ~/log.`date +%F`.txt
      ```
      To:
      ```bash
      date "+%F %T" >> ~/log.`date +%F`.txt
      ```
      To change the format. It will use the full date (just like the filename)
      as well as the time in `HH:MM:SS` format.

As you’re interacting with the OS, are there any observations you have about how the scripts are set up,
their structure and their output.

Is there anything you would add for your scripts?

```answer
- Maybe a bit more output describing what is happening. Maybe also timestamping 
  the messages, as well as some error handling to account for failed commands.  
```

If you would add something, how does it improve the code?

```answer
- More output enables us to tell what state the script is in, and where it's at
  in execution.  
- Timestamps help us determine when things are happening (more
  useful for a script that's actually logging out to a file somewhere, though).
- Error handling is super handy, allowing us to have some backup
  solution/command, potentially exit if the command is required to run for the
  rest of the script to run, or even just tell us that the command failed.  
```

### Python execution

1. Run the u2_script1.py and look at what it shows you.
   ```bash
   /root/u2_script1.py
   ```
   What are you shown?
    - Answer: This output seems to also be `/etc/passwd` entries.  

2. Inspect the file and see if you can modify it to show the first and last 15 lines.
   ```bash
   cat /root/u2_script1.py
   ```
   Note: Modify with `vi` or `vim`. You may have to RTFM to continue.
    - Answer: Change these lines:
      ```python
      print("".join(lines[:10]))
      print("...")
      print("".join(lines[-10:]))
      ```
      to:
      ```python
      print("".join(lines[:15]))
      print("".join(lines[-15:]))
      ```

3. Run the u2_script2.py and look at what it shows you.
   ```bash
   /root/u2_script2.py
   ```
   What are you shown?
    - Answer: I see `root` and `node_exporter`. These are the two
      user accounts that have access to bash as their shell.  

4. Inspect the file and see if you can make it use a different user shell, maybe one you've seen from
   other output in this lab.
   ```bash
   cat /root/u2_script2.py
   ```
   Note: Modify with `vi` or `vim`. You may have to RTFM to continue.
    - Answer: Change this line:
      ```python
      if line.strip().endswith("/bin/bash"):
      # Change to:
      if line.strip().endswith("/sbin/nologin"):
      ```

As you’re interacting with the OS, are there any observations you have about how the scripts are set up,
their structure and their output. Is there anything you would add for your scripts?

- Maybe we could add some command-line options. Instead of manually needing to
  go in and set the shell to a different one, we could allow the user to pass
  in an argument and search for that.  
  Something like: 
  ```python
  /root/u2_script2.py "/sbin/nologin"
  ```
  If no argument is passed, we can use a default value of `/bin/bash`.

If you would add something, how does it improve the code?

- That adds flexibility. It turns it into more of a command-line tool rather
  than just a script. Parsing user-inputted arguments can make the script
  extremely flexible, and allow us to achieve different behavior with the same
  script.  

### Ansible execution
1. Run the `u2_script1.yml` and look at what it shows you.
    ```bash
    ansible-playbook /root/u2_script1.yml
    ```
    What are you shown?

2. Inspect the file and see if you can modify it to show the first and last 15 lines.
    ```bash
    cat /root/u2_script1.yml
    ```
    Note: Modify with `vi` or `vim`. You may have to RTFM to continue.

3. Run the u2_script2.yml and look at what it shows you.
   ```bash
   ansible-playbook /root/u2_script2.yml
   ```
   What are you shown?

4. Inspect the file and see if you can make it name the file differently or populate different content.
   ```bash
   cat /root/u2_script2.yml
   ```
   Note: Modify with `vi` or `vim`. You may have to RTFM to continue.

5. Do one final `ls -l` against the `/root` directory.
    - What is a difference between the `.sh`, `.py`, and `.yml` files?
      ```bash
      ls -l
      ```

As you’re interacting with the OS, are there any observations you have about how the scripts are set up,
their structure and their output. Is there anything you would add for your scripts? If you would add
something, how does it improve the code?
