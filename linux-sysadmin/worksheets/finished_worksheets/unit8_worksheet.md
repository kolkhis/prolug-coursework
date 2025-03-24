# ProLUG 101
## Unit 8 Worksheet

## Table of Contents
* [Unit 8 Worksheet](#unit-8-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 8 Discussion Post 1](#unit-8-discussion-post-1) 
    * [Unit 8 Discussion Post 2](#unit-8-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.

## Discussion Questions:
### Unit 8 Discussion Post 1
It’s a 2 week holiday in your country and most of the engineers and architects who designed the system are out of town.  
You’ve noticed a pattern of logs filling up on a set of web servers from increased traffic.  
Your research shows, and then you verify, that the logs are being sent off real time to Splunk.  
Your team has just been deleting the logs every few days, but one of the 3rd shift engineers didn’t read the notes and your team suffered downtime.  
How might you implement a simple fix to stop gap the problem before all the engineering resources come back next week?


1.	What resources helped you answer this?

Posts on https://community.splunk.com/
`man logrotate`  
`man logger`
`man rsyslog`
Knowledge on how normal logs are handled.  
I really got stuck on this one so I used ChatGPT for some general questions and ideas.  

2.	Why can’t you just make a design fix and add space in /var/log on all these systems?

I'd assume the system was designed as it is because disk space is required elsewhere.
I wouldn't want to go around reallocating disk space without knowing for certain that 
it was necessary. There may be some disk space constraints on the system, so this is
not a very practical stopgap.   

3.	Why can’t you just make a design change and logrotate more often so this doesn’t happen?

Running `logrotate` more frequently could possibly cause recent logs on the disk to
be overwritten or lost if there are high traffic logging spikes. This would be bad, because if an issue arises and there are no logs pointing to what caused the issue, it would be much more difficult to troubleshoot.
There's also the consideration of the Splunk configuration. 
Since the logs are being sent to Splunk, rotated log files are automatically considered ([source](https://docs.splunk.com/Documentation/Splunk/latest/Data/Howlogfilerotationishandled)) and not read a 2nd time.  



4.	For 2,3 if you are ok with that, explain your answer. (This isn’t a trick, maybe there is a valid reason.)

Depending on how often `logrotate` is being run, changing the log rotation configuration may be a viable temporary workaround to the problem. The logs being sent to Splunk are not being read a 2nd time, so they could, in theory, be rotated more frequently (at low traffic hours) without disrupting the flow of logs into Splunk... Maybe rotating every day instead of every week. 

Temporary fix:
Since the situation has already caused downtime, a temporary redirection to
`/dev/null` may be a viable stopgap until the rest of the team gets back and a more
permanent solution can be put into place, but I also don't want to throw away all the logs. 
I would want to make sure that the logs are being sent to Splunk before being redirected to `/dev/null`

I'd check the splunk forwarder to confirm it's running and forwarding logs
```bash
systemctl status splunkforwarder
```
I'd confirm logs are reaching the splunk server by checking the web interface for logs from the server I'm using.
Then I'd want to run a test to see if Splunk is receiving the logs before their
redirection. I'd do this by checking where Splunk is listening for logs, then temporarily adding a rule to forward the output of a log file to `/dev/null`. 
If the `splunkforwarder` is running, it probably listens for all logs in `/var/log`, so a test using `rsyslog` should work.... I think.  
I'll make a test log file and add a rule to forward it to `/dev/null`, then generate
a log message to see if Splunk picks it up.  
```bash
echo "local1.* /dev/null" >> /etc/rsyslog.d/99-devnull.conf
systemctl restart rsyslog
logger -p local1.info "Test message for splunkforwarder"
```
Then I'd go into the Splunk web interface and search for the log message.  
If it's not there, then Splunk isn't picking it up and I need to think of something else.  

Something else: Make a cron job to delete the logs (as they've already been doing) daily instead of every few days.  



### Unit 8 Discussion Post 2
You are the only Linux Administrator at a small healthcare company.  
The engineer/admin before you left you a lot of scripts to untangle.  
This is one of our many tasks as administrators, so you set out to accomplish it.  
You start to notice that he only ever uses nested if statements in bash.  
You also notice that every loop is a conditional `while true` and then he breaks the loop after a decision test each loop.  
You know his stuff works, but you think it could be more easily written for supportability, for you and future admins.  
You decide to write up some notes by reading some google, AI, and talking to your peers.

1.	Compare the use of nested if versus case statement in bash.

Nested `if` statements can be used to test for multiple conditions of multiple variables at once. These can also cause the code to be harder to read and understand. 
A `case` statement can also be used to test for multiple conditions, but is usually only used for checking the value of one variable. 
If we're just checking the condition of one variable, I'd prefer using a `case` statement. 
If we have multiple variables to check, or we need to do error handling, nested `if` statements are a good choice.    
You can also use `if` statements inside `case` statements if you need to, and visa versa.  

```bash
#!/bin/bash

# Using nested if statements
MY_VARIABLE="Hello, world."
if [[ -n "$MY_VARIABLE" ]]; then
    if [[ "$MY_VARIABLE" == "Hello, world." ]]; then
        printf "%s\n" "$MY_VARIABLE"
        # Error handling
        if ! cat "response.txt" 2> /dev/null; then
            printf "Error reading the file response.txt, it doesn't exist!\n";
        fi
    else
        printf "Goodbye, world.\n"
    fi
fi

# Using a case statement
case "$MY_VARIABLE" in
    Hello*)
        printf "%s\n" "$MY_VARIABLE";
        # Error handling inside case statements
        if ! cat response.txt 2> /dev/null; then
            printf "No response.txt!\n"
        fi
        ;;
    Goodbye*)
        printf "%s\n" "$MY_VARIABLE";
        ;;
    *)
        printf "Goodbye, world.\n";
        ;;
esac
```

2.	Compare the use of conditional and counting loops. Under what circumstances would you use one or the other?

Conditional loops are useful when you're waiting for a certain condition to be
triggered before breaking out of the loop.
E.g., If we're waiting for a file to be created, we can use a conditional loop to
continuously check for the file until it exists. 
A counting loop is useful if we need to perform a specific task a certain number of times, or iterate over multiple items (like numbered files or an array).  
```bash
# Using a conditional loop to wait for a file to exist
while ! cat "response.txt" 2> /dev/null; do
    printf "Waiting for response.txt to be created...\n"
    sleep 1
done

# Using a counting loop to create files
for i in {1..10}; do
    printf "Creating file%s.txt\n" "$i"
    touch file$i.txt
done

# Looping over an array
FRUIT_ARR=("Apples" "Oranges" "Bananas")
for fruit in "${FRUIT_ARR[@]}"; do
    printf "Fruit: %s\n" "$fruit"
done
```


## Definitions/Terminology
* Variables: Names within a program that refer to values. Used to store information. 
    * Variables are defined by a name, a type, and a value.  
    * In bash:
      ```bash
      MY_VARIABLE="Hello, world."
      # to make it available to the rest of the environment:
      export MY_VARIABLE
      # to do both in one line:
      export MY_VARIABLE="Hello, world."
      ```
* Interpreted program: A program that can be executed line-by-line by an interpreter.
    * E.g., Python, Perl, Ruby, Bash
* Compiled program: A program that is compiled into a binary (machine code) before it
  can be executed.
    * E.g., C, C++, Go, Java
* Truth table: A table showing the result of every possible combination of inputs.  
* And/or logic: Logical operators that test for multiple conditions, and evalues to
  either True or False.  
* Single/Dual/Multiple alternative logic: Conditional logic used to control the flow
  of a program based on a single condition, two conditions, or a combination of 
  multiple conditions.  
    * Single alternative logic: Execute specific code if one condition is met. Otherwise 
      do nothing.
        * E.g., Using an `if` statement
    * Dual alternative logic: Offer 2 possible code blocks to be executed depending on 
      which one of two conditions are met. Otherwise do nothing.
        * E.g., Using `if`/`else` statements
    * Multiple alternative logic: Offer multiple code blocks to be executed depending
      on which condition is met out of several. Otherwise do nothing.
        * E.g., Using `if`/`elif`/`else` statements.  




## Notes During Lecture/Class:


### Links:


### Terms:

* Flow of a program: The order in which the statements in a program are executed.  
* Scripting: Writing a program that runs top to bottom, sequentially (procedurally),
  line by line. Usually written in a scripting language.  
* Loops: Counts/iterates over items, numbers, or test conditions.  
* Functions: Blocks of code that are only executed when explicitly called.  
* Decisions/flow of logic: Alters the course of the program, or selects different paths, based on conditions that we set.
* Variables: Names within a program that refer to values. Used to store information.  
* Interpreted programs: Programs that are executed line by line by an interpreter.  
* Compiled programs: Programs that need to be compiled before they can be run.  


### Useful tools:
* `gcc`: The Gnu C Compiler. Used to compile C programs into machine code (binaries).  
    * `gcc -o hello hello.c`
        * `-o`: Specifies the name of the ouput file.  
        * `hello.c`: The name of the C file you're compiling.  


## Lab and Assignment
Unit 8 Scripting and system checks
Begin working on your project from the Project Guide
		Topics:
1.	System Stability
2.	System Performance
3.	System Security
4.	System monitoring
5.	Kubernetes
6.	Programming/Automation

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.

## Digging Deeper
1.	Read https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_02.html
https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_03.html
What did you learn about capabilities of bash that can help you in your scripting?

I learned that terminating a subshell with `exit` does not pass that subshell's
variables to the parent shell. 
So, if you need to maintain variables while processing one or more commands, you can 
use braces `{ }` instead of parentheses `( )` to group commands without spawning a subshell.  


2.	If you want to dig more into truth tables and logic, this is a good start: https://en.wikipedia.org/wiki/Truth_table

Truth tables

|  and  | T | F  
|   -   | - | -
| **T** | T | F
| **F** | F | F

|  or   | T | F
|   -   | - | -
| **T** | T | T
| **F** | T | F

|  xor  | T | F
|   -   | - | -
| **T** | F | T
| **F** | T | F


## Reflection Questions
1.	What questions do you still have about this week?

How often would one use C as a Linux sysadmin, and for what tasks? Is it ever preferred over Bash for administrative tasks?


2.	Just knowing a lot about scripting doesn’t help much against actually doing it in a practical sense. What things are you doing currently at work or in a lab that you can apply some of this logic to?

I regularly write shell scripts for fun (and practice). I like to write my own install scripts to pull down and install software (e.g., the latest version of Go).  
I'm also working on my own bash script for dotfile management, so that I don't have to rely on GNU Stow (which is what I'm currently using for dotfile management).  




