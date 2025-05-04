# ProLUG Security Engineering 
## Unit 6 Worksheet 
 
## Instructions 
Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until 
the end to turn them in as a final submission packet. 

## Discussion Questions:

### Unit 6 Discussion Post 1
Review chapter 15 of the SRE book: 
<https://google.github.io/building-secure-and-reliable-systems/raw/ch15.html#collect_appropriate_and_useful_logs>. 
There are 14 references at the end of the chapter. Follow them for more information. One of them: 
<https://jvns.ca/blog/2019/06/23/a-few-debugging-resources/> should be reviewed for 
question "c". 
	1. What are some concepts that are new to you? 
	1. There are 5 conclusions drawn, do you agree with them? Would you add or 
	   remove anything from the list? 
	1. In Julia Evan’s debugging blog, which shows that debugging is just another 
	   form of troubleshooting, what useful things do you learn about the 
	   relationship between these topics? Are there any techniques you already do 
	   that this helps solidify for you? 

### Unit 6 Discussion Post 2
Read https://sre.google/sre-book/monitoring-distributed-systems/  

1. What interesting or new things do you learn in this reading? What may you 
   want to know more about? 
1. What are the “4 golden signals”? 
1. After reading these, why is immutability so important to logging? What do you 
   think the other required items are for logging to be effective? 

## Definitions/Terminology 

- Types of logs 
	- Host 
	- Application 
	- Network 
	- DB
 
- Immutable
 
- Structure of Logs 
	- RFC 3164 BSD Syslog 
	- RFC 5424 IETF Syslog 
	- Systemd Journal 

- Log rotation
 
- Rsyslog
 
- Log aggregation 
	- ELK
	- Splunk 
	- Graylog 	
	- Loki 

- SIEM 

## Notes During Lecture/Class: 

Logging and log parsing.

1. Storing logs
2. Parsing logs

:w

---

What is a log?
- Immutable record of an action that occured (or tried to occur)
    - The logs are NOT changed. We write them in stone.
    - It comes in as readonly.  
    - We can take notes **over** the log, but the original log is not modified.  

How do we use logs?
What are common log elements?
- What is the structure of a log?

Where do we store logs?
- Centralized locations?
    - Rotation for space and compression?
- Get them off servers in real time?
    - This is the NUMBER ONE enterprise rule of logs.
    - MOST IMPORTANT>
    - Cuz then we can go look at stuff in real time as an incident occurs.  

How do we parse and look at specific information from logs?
- Parsing logs with CLI tools
    - Good for looking into individual things 
- Querying logs with specific tools 
    - Good for looking over an aggregate (overviews)

---

Log usage
- review
    - troubleshooting (when things go wrong, and why)
    - security auditing (track user activity, login attempts, system changes,
      potential breaches)
        - `sudo` attempts - very important

- check pointing (built into an app - )
    - performance monitoring (insights into system performance/system utilization)
    - debugging applications (devs rely on app-specific logs to understand their
      software and identify bugs)


---

On Cisco, running the command `debug all` will ruin your life.

---


Logs often follow RFC format
- RFC 3164 BSD syslog
- RFC 5424 IETF syslog

Logs must be timestamped
- Commonly ISO 8601
    - Should be a standardized time format (timezone? use UTC time).  

Logs must be categorized by severity
- Allows proper routing (where the logs go)
- Common in linux systems: debug, info, notice, warning, err, crit, alert, emerg

---

The old BSD syslog:
- `PRI`: priority
- `TIMESTAMP`
- `HOSTNAME`
- `TAG`
- `message`

---

The new IETF syslog:
* `PRI`
* `VERSION`
* `TIMESTAMP`
* `HOSTNAME`
* `APP-NAME`
* `PROCID`
* `MSGID`
* `STRUCTURED-DATA`
* `MSG`

---

Systemd journal: use `journalctl` to look at it -- they're stored in binary format.  
* `__CURSOR`
* `__REALTIME_TIMESTAMP`
* `__MONOTONIC_TIMESTAMP`
* `_BOOT_ID`
* `_MACHINE_ID`
* `_HOSTNAME`
* `_SYSTEMD_UNIT`
* `_PID`
* `_COMM`
* `_EXE`
* `PRIORITY`
* `MESSAGE`

---

Log storage and rotation.

Log ratation is an **ESSENTIAL AUTOMATED PROCESS** on a local system.  
But... Can't let the storage side be an afterthought when aggregating.  

The logrotate utility, configured through `/etc/logratate.conf` and files in
`/etc/logrotate.d`, handles this by periodically rotating, compressing, and deleting
old log files based on the rules that are defined.  

- `/etc/logrotate.conf`: The generic values that will happen unless you override in `/etc/logrotate.d`
- `/etc/logrotate.d`: Can see and set the log rotation in `/etc/logrotate.conf`.  
    - How many copies
    - Logging frequency
    - Minimum size

Don't let it fill up.  

---

Four ways to send logs off the server (prob more)

1. Rsyslog forwarding and collection
2. Log aggregation with agents and a centralized platform (ELK stack, Splunk, Graylog, Loki)
3. Using message queues (Kafka, RabbitMQ) -- Event busses. Modern way to do it.  
4. Cloud-native logging services. 

Common architectures that will almost certainly be in any professional environment.  

---

Factors to consider to choose the right architecture:
- Scale
- Reliability requirements
- Realtime analysis needs
- Budget
- Expertise
- Compliance requirements
- Existing infrastructure

---

Parsing logs
- Understand log format
- Start simple
- Use regex with grep/sed
- Iterate and refine
- Save useful commands


```bash
grep -i failed /var/log/secure
```

---

Special tools for parsing logs
- Splunk
- LogQL <https://grafana.com/docs/loki/latest/query/analyzer/>
    ```logql
    |~ `(F|f)ailed`
    ```

- ELK
- Graylog

Libraries in programming languages
 - python libs (re for regex)
 - Go libraries ( regexp, encoding/json)

---
When to use:
* Large log volume
* Complex log format
* Need for realtim analysis/alert
* Requirement for vizualization
* Security analysis
* Compliance requirements

---

You can write out custom logs in kafka and set up a job to get it picked up by promtail


## Links: 
- https://grafana.com/docs/loki/latest/query/analyzer/  
- https://www.sans.org/information-security-policy/ 
- https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/ 
- https://public.cyber.mil/stigs/downloads/ 

* <https://landscape.cncf.io/guide#observability-and-analysis--observability>
## Terms:  
 
## Useful tools: 
- STIG Viewer 2.18 
- SCC Tool (version varies by type of scan) 
- OpenScap 
 
## Lab and Assignment 
Unit6_Logs_and_Parsing - To be completed outside of lecture time. 

## Digging Deeper
 
1. Find a cloud service and see what their logging best practices are for security 
incident response. Here is AWS: https://aws.amazon.com/blogs/security/logging-
strategies-for-security-incident-response/ 
	a. What are the high level concepts mentioned? 
	b. What are the tools available and what actions do they take? 
	c. What are the manual and automated query capabilities provided, and how 
	   do they help you rapidly get to a correct assessment of the logged events? 

2. Open up that STIG Viewer and filter by “logging” for any of the previous STIGs we’ve 
worked on. (Mariadb has some really good ones.) 

a. What seems to be a common theme? 

b. What types of activities MUST be logged in various applications and 
operating systems? 
	i. Does it make sense why all logins are tracked? 
	ii. Does it make sense why all admin actions, even just attempted admin 
	    actions, are logged? 

## Reflection Questions 

1. What architectures have you used in your career?  
	a. If you haven’t yet worked with any of these, what do you think you would 
	   architect in the ProLUG lab (~60 virtual machines, 4 physical machines, 1 
	   NFS share, and 2 Windows laptops?) 
 
2. What questions do you still have about this week? 
 
3. How are you going to use what you’ve learned in your current role? 
 
 
 
