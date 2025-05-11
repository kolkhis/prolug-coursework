# Unit 6 Notes

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

Kafka doesn't have its own visualization. But it can feed right into kibana or loki. 

---

## Notes from Lab

Enable rsyslog for recieving, then enable sending on other nodes.  
```bash
TODO: put stuff
```

---
`vi /etc/rsyslog.d/30-remote.conf`

Weird rsyslog rule syntax:
```plaintext
$template RemoteLogs,"/var/log/%HOSTNAME%/messages.log"
if ($fromhost-ip != "127.0.0.1") then ?RemoteLogs
& stop
```


Set up a directory for each node in `/var/log/${HOSTNAME}/messages.log`


---




## rsyslog 
`/etc/rsyslog.d/90-remote.conf`
```???
# template(name="PerHostPerApp" type="string"
         string="/var/log/remote/%HOSTNAME%/%PROGRAMNAME%.log")
# catch-all rule: every message, any priority/facility
.    ?PerHostPerApp        # the “?” routes to a named template
```

| Piece                  | Meaning                                                                                                           |
| ---------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `template(name="...")` | Defines a reusable format or file path.                                                                           |
| `type="string"`        | Says the template is just a literal string (not JSON, etc.).                                                      |
| `%HOSTNAME%`           | Built-in property replacer → value of the sending host.                                                           |
| `%PROGRAMNAME%`        | Same for the process/app that emitted the log line.                                                               |
| `?PerHostPerApp`       | Action: *write* the message using that template path. (`?` means write to file; `@@` would be TCP forward, etc.). |










* Message queues:
    1. Drop msg in a queue 
    2. Containers (or other services) can pick those messages up from that message queue  
    * So instead of sending straight to destination host, a queue can be used.  

Kafka is a message broker that works with a message queue (or event bus).  
* The message broker is not limited to just logs -- it can queue any sort of information.  

<https://kafka.apache.org/uses>



`kafkacat` is a separate tool that writes out to kafka (invoked as `kcat`).  



Five Why's in Analysis:
* Ask why 5 times.
* By the time you get to the 5th "why", you're probably at the root cause.  

Kafka is not typically run in a kubernetes cluster.  
Kafka is usually run on dedicated hardware or VM.  

## TODO:
<https://killercoda.com/het-tanis/course/Kubernetes-Labs/Kafka-deployment-in-kubernetes>

