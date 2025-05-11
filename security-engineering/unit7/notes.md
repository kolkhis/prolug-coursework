

# Last week

SALUTE
- S..
- Activity
- L...
- U...
- T..
- E..

---

## This Week
What do we monitor in a system?
- Logs
- Telemetry (Metrics at a Distance)
- Traces (How data is traced from end to end)

How do we decide on what to alert?

The server: It's still a closed engine. Diesel trucks with engines that don't need to be opened
for 200k miles. The system is gonna be engining, but what do we send out?

Alerts are coming out of a system to alert us to events that happen in a system. How
do we decide on what's important to come out or alert?  

Don't be the boy who cries wolf.  


---

If you can make it work once, you can do it again.  
Once you understand how something works, you can replicate its behavior.  

---

what monitor?
- Telemetry
- trace
- logging

How monitor?

What is alerting?
- Sending msgs outside system

How to alert?
- Alert manager -> discord
- Grafana -> discord

On the weekends you should only alert things that are causing customer outages.  

---

Logs: A record of what's happening inside sys/software
metric: Numberic assessments of sys or app performance and resource util.
traces: How data is moving through your system. Also checkpoints of processes as data
moves between nodes.  

---
What we want to report:
When we start having issues, for every resource check:
Sysadmin wants USE (Util, Sat, Err)

Sec Engs want Indicators of compromise:
- sys perf out of normal operating ranges
    - High cpu - btc mining?
        - Usually makes outside connections to unusual places.  
- Connections to outside locations that aren't normally made - compromise?
- User login on muliple areas they don't normally try to log in to - user compromise?

---
What are we monitoring?

- SLOs
 SLAs
 SLIs

Standardize indicators 
- Frequency: every 10 sec
- Data-access latency - time to last byte
- Aggregation intervals: Averaged over 1 minute

In sec eng, time is of the essence.
- For frensics and after action reviews, speed is less important
- For incident and real time solving of compromise, this is critical.  

We use SIEM tools for this

---
How monitor:
Push refers to the end point pushing data into an instance. Not preferred method in
modern monitoring.  

If agent can handle batching, can be useful.  

Pull refers to the endpoint presenting http info and then having the Prometheus
instance scrape the data into its database.  

Advantages of pull:
- easier to tell if instances are down
- manually go to target and inspect health w/ web
- extra instances are easy to add

node_exporter/prometheus is pull, and promtail/loki is push

---

How do we store data we monitor?

TSDB are optimized on one thing, time.  

Writes optimized on timestamp only
Reads focus on blocks of time and measurements only.  

Data types:

* Single-measure records:
    - `Host Metrics Time measure_value`

* Multi-measure records:
    - `Host Metrics Time measure_value1, measure_value2, measure_value3`

---

What is alerting?

The concept of alerting is sending info from a closed system out for others that may
not be in that system.  

Alerts are discreet actions that occur when events happen:
- past event:
    - Log is analyzed and a problem or actionable event is found
- current event:
    - a threshhold is crossed (high or low)
    - a limit of some time is exceeded
    - a service or server stops respoinding (e.g., after 3 scrape attempts, we alert)
- predictive event:
    - logs are analyzed and a future problem is predicated based on indicators

---

High watermarks happen naturally.  
UCLs are things we define within processes (Upper Control Limit).  
Warning and Critical Thresholds (is another thing UCLs will be called)

---

When to alert

- Security breaches
    - unauth access to sys/data
    - suspicious activity (sus login attempts/ large data transfers)
    - malware inf
- system failures
    - server downtime
    - network outage
    - critical app err
- perf issue
    - unusually slow resp time
    - high resource usage (cpu/mem) - unexpected changes in system behavior
    - anomalies - any deviation from normal patterns of system operation that could
      indicate a problem 
        * `irate` changes (instantaneous rate changes) come from a thing called derivatives.  
            - When things change instantly
            - An instant rate of change

---

Fun: Spin up AWS instance, connect to crypto mining system. You'll immediately get alerted.  

You'll see a lot of warnings in k8s. They only have backwards compatibility for 3
versions of k8s.  

---




---

---

## Lab
monitoring jails with fail2ban with logs and telemetry data

from controlplane, turn on fail2ban and jail sshd
ssh over to node01 as root
ssh back as invalid user and get jailed (alert when user is jailed)

go back and manually read logs of jailed activities, verify banned status, unban ip

```bash
ssh node01
exit
apt install -y fail2ban
vi /etc/fail2ban/jail.conf
```

add:
```ini
[sshd]
enabled = true
maxretry = 5
findtime = 10
bantime = 4h
```

Also look for `apache`, it can track and do things for that, also `nginx`  
```bash
systemctl restart fail2ban
systemctl status fail2ban
```

test
```bash
ssh node01
for i in {1..6}; do ssh invaliduser@controlplane; done
# hit enter til it locks out
# try to connect again
ssh invaliduser@controlplane
exit
ssh node01
ssh controlplane # fail

# check logs
tail -f /var/log/fail2ban.log
ip -br addr # check IP

# unban (use the right IP, the one from logs)
fail2ban-client set sshd unbanip 10.244.22.74

# test that unban happened
ssh node01
ssh controlplane # should work
```


Check out:
* fail2ban prometheus exporter





