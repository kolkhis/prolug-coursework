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
    - Log anonymization.
    - Log encryption. 

2. There are 5 conclusions drawn, do you agree with them? Would you add or 
   remove anything from the list? 
    - The conclusions I'm seeing are as follows:  
        1. Depth of logging: Logs should be as "complete" as possible. Standardized
           with as much relevant information as possible.    
            - I agree with this.  
        2. Log retention: The length of time you keep your logs needs to be
           considered, since it can be expensive to keep logs for longer periods of
           time. On average, it takes about 200 days to discover a system compromise
           (according to this SRE book), so logs should probably kept for at least
           that long.  
            - I agree with this.  
        3. Access and audit controls: Log viewing should follow the rule of least
           privilege.   
            - I agree with this.  
            - <https://google.github.io/building-secure-and-reliable-systems/raw/ch05.html#design_for_least_privilege>  
        4. Data anonymization/pseudonymization: Sensitive data should be anonymized.  
            * I've never heard that logs should be anonymized to
              protect user information. Though, I suppose when we're talking about
              application logs that run on users' personal workstations then that's an
              acceptable thing. That said, I don't think server logs themselves should be
              anonymized. That just makes things difficult.  
        5. Encryption: Using rotating key pairs to encrypt logs in order to prevent attackers from gaining access to your logs in aggregate.    
            - I hadn't considered this one. It's a very fair point, so I do agree as
              long as the rotation of public/private key pairs can be automated and
              doesn't lock any authorized personnel out of the logfiles should they
              need access.  

3. In Julia Evan’s debugging blog, which shows that debugging is just another 
   form of troubleshooting, what useful things do you learn about the 
   relationship between these topics? Are there any techniques you already do 
   that this helps solidify for you? 

    - "accept that it's probably your code's fault" - this is a technique that I
      employ often and in abundance. If you feel like you're digging too deep, you
      probably are.  

    - Understanding how to reproduce a bug (or whatever the error is) is a useful
      skill. This should be employed in all forms of troubleshooting. If you can
      reproduce it, you can understand how it came to be and how to prevent it.  

    - "Error messages are better than silently failing." Too true. I, by default,
      write defensive error handling in all of my bash scripts now for this exact
      reason. Good logs are essential.  

    - Checking assumptions is a BIG one.  

    - I've always seen troubleshooting and debugging as the same thing, and I think
      *all* of the points listed in Julia's blog post serve to solidify that point.  

      Debugging code is one of the best ways to gain experience in troubleshooting imo.  
      It's all dealing with inputs and outputs at the end of the day.  

### Unit 6 Discussion Post 2
Read https://sre.google/sre-book/monitoring-distributed-systems/  

1. What interesting or new things do you learn in this reading? What may you 
   want to know more about? 
    - Things I learned:
    - White-box monitoring is the term for monitoring based on metrics that come from the internal system itself.
    - Black-box monitoring is simply testing from an outside perspective with no access.
    - Black-box and White-box monitoring are both helpful. The difference is that
      black-box monitoring is more capable of monitoring symptoms, whereas white-box
      monitoring is more geared towards root cause analysis.  
    - Monitoring systems are usually better off as simple rather than complex, with
      better tools for ad-hoc analysis so that the system is not as fragile.  
    - Certain alerts can be more complex in their conditions. One example given is
      that if a data center is "drained," then it won't alert on latency.  
1. What are the “4 golden signals”? 
    - Latency: The time it takes to service a request.  
    - Traffic: How much demand is being placed on the system.  
        - E.g., HTTP requests per second  
    - Errors: The rate of errors.  
    - Saturation: How "full" the system/service is. A measure of resource utilization.  
    - This is kind of like the USE (Utilization, Saturation, and Errors) method of
      troubleshooting that was presented in the admin course.  
1. After reading these, why is immutability so important to logging? What do you 
   think the other required items are for logging to be effective? 
    - Immutability is important to logging so that we can set up proper alerts and
      have a clear, untampered audit trail for troubleshooting system errors or
      security incidents.  
    - Another required item for logging to be effective would probably be
      expertise with log audit tools (like `journalctl` or other such tools),
      basically a clear and consistent way to access and parse logs.  Also, having
      logs that are concise and to-the-point is another item for effective logging.  

## Definitions/Terminology 

- Types of logs:
	- Host: Logs generated either by the operating system or system-level services
      (`/var/log/messages`, `/var/log/auth.log`, `journalctl`).  
	- Application: Logs generated by specific applications (like `access.log` from Apache), which can vary from application to application.  
	- Network: Logs generated by network services or devices, like firewalls, VPNs, 
  	  routers, or other tools (`iptables`, `nftables`, `tcpdump`)
	- D: Device logs? Audit logs from USB hardware or disk-level events.
 
- Immutable: The inability to be mutated (changed) after creation.  
    - You can use the `chattr` command to add the `i` (immutable) attribute:
      ```bash
      chattr +i /var/log/secure
      ```
      
 
- Structure of Logs:
	- RFC 3164 BSD Syslog: A log format that's considered legacy, used by `syslogd`.  
        - Timestamp + Hostaname + Tag + Message
	- RFC 5424 IETF Syslog: The more modern standardized log format.  
        - More structured, includes Timestamps, hostnames, app names, PIDs, Message
          IDs, and structured data.  
	- Systemd Journal:

- Log rotation:
 
- Rsyslog:
 
- Log aggregation :
	- ELK:
	- Splunk:
	- Graylog:
	- Loki:

- SIEM:

## Notes During Lecture/Class: 

[notes.md](./notes.md)

## Links: 
- <https://grafana.com/docs/loki/latest/query/analyzer/>  
- <https://www.sans.org/information-security-policy/> 
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/> 
- <https://public.cyber.mil/stigs/downloads/> 

* <https://landscape.cncf.io/guide#observability-and-analysis--observability>

## Terms:  

Event bus (Kafka)

Splunk - costs a lot of money.
LogQL - How we parse logs -- works with loki (free)
ELK (ElasticSearch, Logstash, Kibana) was wildly popular for a long time 20-teens. Need beats agents.  
- Metricbeat
- Filebeat
- Requires Expertise to maintain

Graylog - free.

Kafka doesn't have its own visualization. But it can feed right into kibana or loki. 

 
## Useful tools: 
- STIG Viewer 2.18 
- SCC Tool (version varies by type of scan) 
- OpenScap 

## Lab and Assignment 
Unit6_Logs_and_Parsing - To be completed outside of lecture time. 

## Digging Deeper
1. Find a cloud service and see what their logging best practices are for security 
   incident response. Here is AWS:
   <https://aws.amazon.com/blogs/security/logging-strategies-for-security-incident-response/> 
    - What are the high level concepts mentioned? 
    - What are the tools available and what actions do they take? 
    - What are the manual and automated query capabilities provided, and how 
	   do they help you rapidly get to a correct assessment of the logged events? 

2. Open up that STIG Viewer and filter by “logging” for any of the previous STIGs we’ve 
   worked on. (Mariadb has some really good ones.) 
    - What seems to be a common theme? 
    - What types of activities MUST be logged in various applications and 
      operating systems? 
        1. Does it make sense why all logins are tracked? 
        2. Does it make sense why all admin actions, even just attempted admin actions, are 
           logged? 

## Reflection Questions 
 
1. What architectures have you used in your career?  
	- If you haven’t yet worked with any of these, what do you think you would 
	  architect in the ProLUG lab (~60 virtual machines, 4 physical machines, 1 
	  NFS share, and 2 Windows laptops?) 

2. What questions do you still have about this week? 

3. How are you going to use what you’ve learned in your current role? 

 
 
