ProLUG – Unit 4 Operate Running
Systems

## Required Materials
* Rocky or similar server
* Root or sudo permissions

## EXERCISES (Warmup to quickly run through your system and familiarize yourself)

```bash
cd ~
ls
mkdir unit4
mkdir unit4/test/round6     # This fails
mkdir -p unit4/test/round6  # This works, think about why? man (mkdir)
cd unit4
ps # Read 'man ps'
ps –ef # What does this show differently?
ps –ef | grep –i root # What is the PID of the 4th line?
ps –ef | grep –i root | wc –l # What does this show you and why might it be useful?
top # Use 'q' to exit. Inside top, use 'h' to find commands you can use to toggle system info
```

### Pre-LAB – Check to make sure we have a useful tool and where we get it from
1. Real quick check for a package that is useful.
   ```bash
   rpm –qa | grep –i iostat #should find nothing
   ```

2. Let's find what provides iostat by looking in the YUM (we'll explore more in later lab)
   ```bash
   dnf whatprovides iostat
   #should tell you that sysstat provides iostat
   ```

3. Let's check to see if we have it
   ```bash
   rpm –qa | grep –i sysstat
   ```

4. If you don't, lets install it
   ```bash
   dnf install sysstat
   ```

5. Re-check to verify we have it now
   ```bash
   rpm –qa | grep –I sysstat
   rpm –qi sysstat<version>
   iostat #we'll look at this more in a bit
   # Might be good to ensure you have vim on your system now too. This is the same procedure as above.
   rpm –qa | grep –i vim
   # If it's there, good.
   dnf install vim
   # If it's not, install it so you can use vimtutor later (if you need help with vi commands)
   ```

## LAB
1. Gathering system information release and kernel information
   ```bash
   cat /etc/*release
   uname
   uname -a
   uname –r
   # `man uname` to see what those options mean if you don't recognize the values
   rpm -qa | grep -i kernel # What is your kernel number? Highlight it (copy in putty)
   rpm –qi <kernel from earlier> # What does this tell you about your kernel? 
                                   # When was the kernel last updated? 
                                   # What license is your kernel released under?
   ```

2. Check the number of disks
   ```bash
   fdisk -l
   ls /dev/sd*
   ```
   When might this command be useful? What are we assuming about the disks for this to
   work? How many disks are there on this system? How do you know if it's a partition or a
   disk?

---

```bash
pvs # What system are we running if we have physical volumes?
    # What other things can we tell with vgs and lvs?
```
- Use `pvdisply`, `vgdisplay`, and `lvdisplay` to look at your carved up volumes.
  Thinking back to last week's lab, what might be interesting from each of those?
- Try a command like `lvdisplay | egrep "Path|Size"` and see what it shows.
    - Does that output look useful?
    - Try to `egrep` on some other values. Separate with `|` between search items.

- Check some quick disk statistics
  ```bash
  iostat –d
  iostat –d 2 #Wait for a while, then use crtl + c to break. What did this do? Try changing this to a different number.
  iostat –d 2 5 #Don't break this, just wait. What did this do differently? Why might this be useful?
  ```

3. Check the amount of RAM
   ```bash
   a. cat /proc/meminfo
   b. free
   c. free –m
   ```
   What do each of these commands show you? How are they useful?

4. Check the number of processors and processor info
   ```bash
   cat /proc/cpuinfo
   ```
   What type of processors do you have? Google to try to see when they were released.
   Look at the flags. Sometimes when compiling these are important to know. This is how
   you check what execution flags your processor works with.
   ```bash
   cat /proc/cpuinfo | grep proc | wc –l
   ```
    - Does this command accurately count the processors?
    - Check some quick processor statistics
  ```bash
  iostat –c
  iostat –c 2 # Wait for a while, then use crtl + c to break. What did this do? Try changing this to a different number.
  iostat –c 2 5 # Don't break this, just wait. What did this do differently? Why might this be useful?
  ```
  Does this look familiar to what we did earlier with `iostat`?

5. Check the system uptime
   ```bash
   uptime
   man uptime
   ```
   Read the man for uptime and figure out what those 3 numbers represent. Referencing
   this server, do you think it is under high load? Why or why not?

6. Check who has recently logged into the server and who is currently in
   ```bash
   last
   ```
   Last is a command that outputs backwards. (Top is most recent).
   So it is less than useful without using the more command.
   ```bash
   last | more
   ```
    - Were you the last person to log in? Who else has logged in today?
      ```bash
      w
      who
      whoami
      ```
      How many other users are on this system? What does the `pts/0` mean on Google?

7. Check running processes and services
   ```bash
   ps –aux | more
   ps –ef | more
   ps –ef | wc –l
   ```
    - Try to use what you've learned to see all the processes owned by your user.  
    - Try to use what you've learned to count up all of those processes owned by your user.  

8. Looking at system usage (historical)
    - Check processing for last day
      ```bash
      sar | more
      ```
    - Check memory for the last day
      ```bash
      sar –r | more
      ```

Sar is a tool that shows the 10 minute weighted average of the system for the last day.

Sar is tremendously useful for showing long periods of activity and system load.  
It is exactly the opposite in it's usefulness of spikes or high traffic loads.  
In a 20 minute period of 100% usage a system may just show to averages times of 50% and 50%, never
actually giving accurate info.  
Problems typically need to be proactively tracked by other means, or with scripts, as we will see below.  
Sar can also be run interactively. Run the command `yum whatprovides sar` and you will
see that it is the `sysstat` package.  
You may have guessed that sar runs almost exactly like `iostat`.  

* Try the same commands from earlier, but with their interactive information:
  ```bash
  sar 2  # ctrl + c to break
  sar 2 5
  or
  sar –r 2
  sar –r 2 5
  ```
* Check sar logs for previous daily usage
  ```bash
  cd /var/log/sa/
  ls
  # Sar logfiles will look like: sa01 sa02 sa03 sa04 sa05 sar01 sar02 sar03 sar04
  sar –f sa03 | head
  sar –r –f sa03 | head #should output just the beginning of 3 July (whatever month you're in).
  ```
  Most Sar data is kept for just one month but is very configurable.
  Read `man sar` for more info.


- Sar logs are not kept in a readable format, they are binary.
  So if you needed to dump all the sar logs from a server, you'd have to output it to a file that is readable.

You could do something like this:
- Gather information and move to the right location
  ```bash
  cd /var/log/sa
  pwd
  ls
  ```
  We know the files we want are in this directory and all look like this `sa*`

- Build a loop against that list of files 
  ```bash
  for file in `ls /var/log/sa/sa??`; do echo "reading this file $file"; done
  ```

- Execute that loop with the output command of sar instead of just saying the filename
  ```bash
  for file in `ls /var/log/sa/sa?? | sort -n`; do sar -f $file ; done
  ```

- But that is too much scroll, so let's also send it to a file for later viewing
  ```bash
  for file in `ls /var/log/sa/sa?? | sort -n`; do sar -f $file | tee -a /tmp/sar_data_`hostname`; done
  ```

- Let's verify that file is as long as we expect it to be:
  ```bash
  ls –l /tmp/sar_data*
  cat /tmp/sar_data_<yourhostname> | wc –l
  ```

- Is it what you expected? You can also visually check it a number of ways
  ```bash
  cat /tmp/<filename>
  more /tmp/<filename>
  ```

### Exploring Cron
Your system is running the cron daemon. You can check with:
```bash
ps –ef | grep –i cron
systemctl status crond
```

This is a tool that wakes up between the 1st and 5th second of every minute and checks to see if it has
any tasks it needs to run.  
It checks in a few places in the system for these tasks.  
It can either read from a crontab or it can execute tasks from files found in the following locations.

`/var/spool/cron` is one location you can ls to check if there are any crontabs on your system

The other locations are directories found under:
```bash
ls -ld /etc/cron*
```
These should be self-explanatory in their use.
If you want to see if the user you are running has a crontab, use the command `crontab –l`.
If you want to edit (using your default editor, probably `vi`), use `crontab –e `
We'll make a quick crontab entry and I'll point you [here](https://en.wikipedia.org/wiki/Cron) if you're
interested in learning more.
picture
Crontab format looks like this picture so let's do these steps.

<!-- TODO: Add visual representation of crontabs. (sub TODO: Add actual picture) -->
```bash
# .--------------- Minute (0 - 59)
# | .------------- Hour (0 - 23)
# | |  .---------- Day of month (1 - 31)
# | | | .--------- Month (1 - 12) OR jan,feb,mar,apr, etc.
# | | | | .------- Day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat
# | | | | | 
# | | | | |    
  * * * * *  user    command to be executed
```

1. `crontab –e`
2. Add this line (using vi commands – Revisit vimtutor if you need help with them)
```bash
* * * * * echo 'this is my cronjob running at' `date` | wall
```
3. Verify with `crontab –l`.  
4. Wait to see if it runs and echos out to wall.
5. `cat /var/spool/cron/root` to see that it is actually stored where I said it was.
6. This will quickly become very annoying, so I recommend removing that line, or commenting it
   out (`#`) from that file.

I can change all kinds of things about this to execute at different times.
The one above, we executed every minute through all hours, of every day, of every month.
We could also have done some other things:

* Every 2 minutes (divisible by any number you need):
  ```bash
  */2 * * * *
  ```

* The first and 31st minute of each hour:
  ```bash
  1,31 * * * *
  ```

* The first minute of every 4th hour:
  ```bash
  1 */4 * * *
  ```

There's a lot there to explore, I recommend looking into [the Cron wiki](https://en.wikipedia.org/wiki/Cron) or [tldp.org's cron guide](http://www.tldp.org/LDP/lame/LAME/linux-admin-made-easy/using-cron.html) for more information.

---

That's all for this week's lab.
There are a lot of uses for all of these tools above.
Most of what I've shown here, I'd liken to showing you around a tool box.  
Nothing here is terribly useful in itself, the value comes from knowing the tool exists and then being able to properly apply it to the problem at hand.  
I hope you enjoyed this lab.

