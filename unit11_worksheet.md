# ProLUG 101
## Unit 11 Worksheet

## Table of Contents
* [Unit 11 Worksheet](#unit-11-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 11 Discussion Post 1](#unit-11-discussion-post-1) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper (optional)](#digging-deeper-optional) 
* [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.

## Discussion Questions:
### Unit 11 Discussion Post 1
You’ve heard the term "loose coupling" thrown around the
office about a new monitoring solution coming down the pike.  
You find a good resource and read the section on "Prefer Loose Coupling" https://sre.google/workbook/monitoring/

1. What does “loose coupling” mean, if you had to summarize to your junior team members?

Loose coupling is essentially making your setup "modular", meaning you can switch out one thing without breaking the other. 
In a loosely coupled setup, each component of the system is in charge of its own thing.
Essentially, if you want to change one component for a different component that does the same thing, the other components won't be affected.

For instance, using `node_exporter` with `Prometheus`.
`node_exporter` gathers the data, and `Prometheus` stores it.
In a loosely coupled setup, you could change out `node_exporter` for another tool that collects the same metrics, and exposes them in the same way, without affecting `Prometheus`. 


2. What is the advantage given for why you might want to implement this type of tooling in your monitoring? Do you agree? Why or why not?

Loosely coupled tooling allows for modularity/flexibility. If a better alternative comes along for a part of the monitoring process (e.g., a better visualization tool), you'll be able to switch over to that.  

I imagine it would make troubleshooting easier as well. Narrowing a problem down to a single component can make it much easier to fix than if you only have one tool for the entire process.  


3. They mention "exposing metrics" what does it mean to expose metrics? What happens to metrics that are exposed but never collected?

"Exposing metrics" is making them available to other services. They're either made available through an endpoint (like an HTTP endpoint at `http://localhost:9090/metrics` for Prometheus) or logged to a specific location on the filesystem.  
The exposed metrics are exposed so that the monitoring service that collects the data can store it in a database.
Metrics that are exposed but never collected are lost, resulting in wasted resources and gaps in your monitoring. 




### Unit 11 Discussion Post 2
Your HPC team is asking for more information about how CPU0 is behaving on a set of servers.  
Your team has node exporter writing data out to Prometheus

(Use this to simulate https://promlabs.com/promql-cheat-sheet/).
1. Can you see the usage of CPU0 and what is the query?  
The usage of CPU0 is very low, it has spent most of its time in the `idle` state.  
```c
node_cpu_seconds_total{cpu="0"}
```

2. Can you see the usage of CPU0 for just the last 5 minutes and what is the query?

Query:
```c
node_cpu_seconds_total{cpu="0"}[5m]
```
This shows the counts of the number of seconds that the CPU has been in each state, and each count is timestamped in UNIX Epoch time.  

3. You know that CPU0 is excluded from Slurm, can you exclude that and only pull the
user and system for the remaining CPUs and what is that query?

Query:
```c
node_cpu_seconds_total{cpu!="0",mode=~"user|system"}
```
* `cpu!="0"` excludes CPU0
* `mode=~"user|system"` is a regex match for either `user` or `system`.  
This shows that CPUs 1, 2, and 3 are active with the `user` and `system` modes using the instance `node-exporter:9100`. 


## Definitions/Terminology
* SLO (Service Level Objective): This is an achievable target value that is set for a Service Level Indicator (SLI).
    * An SLO represents the goals that a service should meet in terms of performance,
      availability, and other SLIs. 

* SLA (Service Level Agreement): An agreement made between a service provider and a client.  
    * These agreements typically include Service Level Objectives (SLOs) that should
      be met, and any penalties for SLOs that are unmet, and other conditions for
      service.  
* SLI (Service Level Indicator): A specific metric that is used to measure
  performance or availability for a system or service.  

* KPI (Key Performance Indicator): Measurable values that demonstrate how effectively
  a system or service is performing in terms of availability, performance, and
  reliability.  
    * KPIs for sysadmins could be ticket queue times (how long a trouble ticket sits in queue) and ticket turnover times (how quickly trouble tickets are resolved).  
    * A KPI could also be something like uptime, response times, or error rates. 

* Span: A period of time over which metrics are collected, like "traces" 

* Trace: Data collected on how data moves through a system.  

* Prometheus: An open source monitoring tool that collects metrics and stores them in a time series database (TSDB).  
    * Listens for metrics on `http://localhost:9090/metrics` by default.  
* Node_Exporter: A tool that collects metrics from the host system and exports them
  for other tools (like Prometheus) to collect.  
    * The `node_exporter` listens on HTTP port `9100` by default.  
* Grafana: An open source tool that allows you to visualize data from a TSDB.  
* Dashboard: A centralized location at which you can visualize data from multiple sources.  
    * If you have to scroll on a dashboard for important information, it's no longer useful to the NOC.
    * Keep dashboards relevant and readable. Information Fatigue is a thing, and there is such a thing as TMI (too much information).  
* Heads up Display (HUD): An interface that shows the most relevant information on system health.  
    * A HUD should be easy to grok (read and understand) at a glance.  


## Notes During Lecture/Class:
### Links:
* [Linux Tracing Systems ](https://jvns.ca/blog/2017/07/05/linux-tracing-systems/)
* [Crowdsec](https://www.crowdsec.net/)
    * [Crowdsec Github](https://github.com/crowdsecurity/crowdsec)
* [Setting up ClamAV](https://killercoda.com/het-tanis/course/Linux-Labs/105-install-antivirus)
* [Promlens Demo for Practicing Queries](https://demo.promlens.com/)
* [Dockprom "Monitoring solution"](https://github.com/stefanprodan/dockprom)
* [Node exporter setup](https://prometheus.io/docs/guides/node-exporter/)

### Terms:

* Coupling: Interweaving two things that rely on each other, to the point one cannot function without the other.  
* Loose coupling: Making things more modular so you're able to switch out tools.
    * Each component of the system is in charge of its own thing.
    * e.g., Separate components should be in charge of collecting, storing, and visualizing data.  
        * If you want to switch out the tool that's "collecting" data, it won't break the tool that's "storing" data.  
        * If you want to switch out the tool that's "visualizing" data, it won't break the tool that's "storing" data. 
    * If you want to change one component for a different alternative, the other won't be affected.
    * For instance, using `node_exporter` with `Prometheus`. You could change out
      `node_exporter` for another tool that collects the same metrics. 

* What to monitor:
    * Logs: A record of what's happening within your system or software
        * Usually stamped with UTC time
    * Metrics: Numerical assessments of system or application performance and resource utilization
    * Traces: How data is moving through your system.
        * Also checkpoints of processes as data moves between nodes.  
        * Deals with numerical 
        * Represents the whole journey of a request or action as it moves through all
          nodes in a ddistrubted system
    * Spans: The time it takes to complete a request
        * An operation or work taking place on a service.
        * E.g., Web server responding to an individual request or function.  

* Time Series Database (TSDB): A database that stores "time series" data.  
    * Time Series data is data that has a timestamp associated with it.  
    * Time series datasets are measurements or events that are tracked, monitored, downsampled, 
      and aggregated over time.  
        * Downsampling is the process of aggregating data over a shorter period of time.
        * This decreases the amount of data samples in a dataset. 
    * Examples of TSDBs: InfluxDB, Prometheus, Kdb+, TimescaleDB, Graphite, DolphinDB. 

* The USE Method: This is a method of analyzing system performance via Utilization, Saturation, and Errors.
    * Utilization: The amount of time a resource is busy servicing work.  
        * Typically measured as a percentage, signifies how much a resource is used.  
    * Saturation: The additional work that is deferred when a resource is busy (fully utilized).  
        * The degree to which a system's demand exceeds its supply.  
        * This is when the "line" starts to form and jobs start to queue.  
    * Errors: The amount of errors encountered while either servicing requests or performing work.  
        * Generally measured in the number of error messages generated per "time unit" (e.g., per hour).  
        * Errors come out as immutable logs.  


Prometheus gathers data from a tool like `Node_Exporter` and puts it into a Time Series Database (TSDB).  
`Node_Exporter` is a tool that collects metrics (port 9090).
If prometheus is turned off, and doesn't scrape this data, it will be lost.   

---

* ClamAV: Antivirus for Linux
* ARP: Address Resolution Protocol

### Useful tools:


## Lab and Assignment
Unit 11 Lab Monitoring
Continue working on your project from the Project Guide
Topics:
1. System Stability
2. System Performance
3. System Security
4. System monitoring
5. Kubernetes
6. Programming/Automation
You will research, design, deploy, and document a system that improves your
administration of Linux systems in some way.

## Digging Deeper (optional)
1. Read the rest of the chapter https://sre.google/workbook/monitoring/ and note
anything else of interest when it comes to monitoring and dashboarding.

* You should be able to have a long-term view of your data for analysis.  


2. Look up the “ProLUG Prometheus Certified Associate Prep 2024” in Resources -> Presentations in our ProLUG Discord.  
Study that for a deep dive into Prometheus.

3. Complete the project section of “Monitoring Deep Dive Project Guide” from the
prolug-projects section of the Discord.  
We have a Youtube video on that project as well.  
https://www.youtube.com/watch?v=54VgGHr99Qg

## Reflection Questions
1. What questions do you still have about this week?

I've heard a lot about ELK stack for monitoring (elasticsearch, logstash, kibana).  
When would a setup like this be preferred over the setups shown in the Killerkoda labs?

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you look to put something like this into your resume or portfolio?

I'm not in any role. I will be setting up monitoring in my proxmox homelab for all
VMs/containers using prometheus, grafana, loki, node_exporter, and promtail.  
Hopefully this will look good on my (currently nonexistent) resume.  

