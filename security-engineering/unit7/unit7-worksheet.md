# ProLUG Security Engineering

## Unit 7 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

## Discussion Questions:

### Unit 7 Discussion Post 1:
Read about telemetry, logs, and traces. Ther are many good
sources, even from Microsoft: <https://microsoft.github.io/code-with-engineering-playbook/observability/log-vs-metric-vs-trace/>

- How does the usage guidance of that blog (at bottom) align with your
  understanding of these three items?  
    - The usage guidance summarizes that:  
        - Metrics are used to track occurences of events
          and counting items, as well as quantify the time taken to perform actions or
          report values of resources like CPU usage.  
        - Logs are used to track detailed information about events (which should also
          be monitored by metrics), in particular warnings, errors, and other
          important events.  
        - Traces provide visibility into how requests pass through multiple services
          when used within a microservice environment, and specifies that traces
          should have unique identifiers (like UUIDs).  
    - This aligns with my understanding in that metrics should be used to monitor
      system resources to identify the behavior of the system around incidents, as
      well as provide alerts when thresholds are met, and logs should contain more
      detailed information around those incidents and describe why those thresholds may 
      have been met. I have not used traces directly yet, but I understand the
      concept -- when troubleshooting an incident, traces can be a more detailed type
      of log that tell us how data is processed through each step from its origin to its 
      endpoint, and having UUIDs for them could help to tie them to specific events
      or logs.  

- What other useful blogs or AI write-ups were you able to find?  
    - <https://grafana.com/blog/2020/03/31/how-to-successfully-correlate-metrics-logs-and-traces-in-grafana/>
    - Reading this, it describes how you can configure grafana to be a full
      observability platform. Tagging your data when configuring your monitoring
      stack is super important in being able to correlate metrics with logs and
      traces, and visa versa.  

- What is the usefulness of this in securing your system?  
    - The usefulness here is that when you have tools that give you a deeper
      understanding of how your system is behaving, you can tell when it is behaving
      in a strange way.  
      This will give you an advantage in both preventing and remediating incidents.
      Good historical data will help you troubleshoot when something is going wrong.  

### Unit 7 Discussion Post 2:
When we think of our systems, sometimes an airgapped system
is simple to think about because everything is closed in. The idea of alerting or reporting is
the opposite. We are trying to get the correct, timely, and important information out of the
system when and where it is needed.

Read the summary at the top of:
<https://docs.google.com/document/d/199PqyG3UsyXlwieHaqbGiWVa8eMWi8zzAn0YfcApr8Q/edit?tab=t.0>

- What is the litmus test for a page? (Sending something out of the system?)
    - The page should be urgent, important, actionable, and real.  
    - The question would be "would the person receiving this page be able to take action to fix the
      issue?" (e.g., actionable by *that* particular person)  
        - If the answer is no, the alert is just noise.  
    - If alerts ren't actionable, they create "alert fatigue," which desensitizes
      teams and delays responses when real issues occur.  
        - Just like the boy who cried wolf.  

- What is over-monitoring v. under-monitoring. Do you agree with the
  assessment of the paper? Why or why not, in your experience?
    - Over-monitoring is when you get too many alerts, too many metrics, and too much
      noise.  
        - This is described as a harder problem to solve than under-monitoring in the
          linked document.  
    - Under-monitoring is when you don't get alerted enough. If a system is
      failing in some way that needs to be corrected, or if there is behavior that is
      indicative of a system acting unusual, you should be alerted. If you're not
      getting alerts on crucial things like this, then you're under-monitoring.  

- What is cause-based v. symptom-based and where do they belong? Do you agree?
    - Symptom-based alerts are alerts that happen when things are acting up.  
      For instance:  
        - Database server is returning 500s.
        - Latency is higher than it should be.  
        - A database is not being updated when it's supposed to be, and is not returning up-to-date data.  
        - User data is unavilable for whatever reason.  
    - Cause-based alerts are alerts that go out saying something like "Database
      servers are unreachable," instead of the symptom-based alert of "Database
      server is returning a 500 to a user."  
        - The write-up says that you should implement a symptom-based alert rather
          than implementing a cause-based alert, since you'll need to catch the
          symptom anyway. In your troubleshooting, the first thing you'd do is
          probably go and try to do the query, and then you'll receive the 500. This
          saves you that step. It additionally states that using a cause-based alert
          along with a symptom, you'll have reduntant alerts. 
        - Do I agree? Kind of. I think symptom-based alerts are good, but cause-based
          alerts should probably be paired with them (in the same alert). If the idea is to 
          save you time and reduce alert fatigue, then maybe having rules in place to
          run tests when certain alerts are about to go out is probably a good idea.  
          I'm not sure if monitoring systems support this, but I'm sure we could set
          up a system to run tests before certain alerts are sent out. This requires
          further investigation.



## Definitions/Terminology

- Telemetry: The automatic collection and transmission of metrics, logs, and traces
  from a system to a centralized location.  
    - Information gathered via telemetry is used for monitoring and analysis.    

- Tracing: Tracking a request or event as it moves through multiple components of a distributed system. Basically seeing how data is traced from its origin point to its end point.  
    - Span: A single unit of work in a trace.  
    - Label: Also called "tag", it's key/value metadata attached to spans or metrics
      to categorize or filter data.  

- Time Series Database (TSDB): A database that's optimized for storing and querying
  data points over time (logs, CPU usage, memory, etc).  
    - E.g., Prometheus, Loki

- Queue: A system for temporarily storing and ordering data or events before they're
  processed.  
    - Used in log shipping, task execution, or decoupling services.
    - Called a Message Queue or Event Bus.  
    - Used by Kafka, RabbitMQ, SQS.  

- Upper control limit / Lower control limit (UCL/LCL)
    - Upper and Lower Control Limits are the high end and low end limits that we define within a process.  
        - Will also be called "Warning and Critical Thresholds."  
    - They're manually defined thresholds that define acceptable operating ranges for specific metrics.  
    - These are distict from high and low watermarks. Watermarks happen naturally,
      whereas control limits are things we set in order to alert us when things are
      in a state that requires attention.  


- Aggregation: Pulling information from multiple locations and combining them into one data stream.  
    - Also combining multiple data points into a single value (an average, max, sum)
      over a time window.  

- SLO, SLA, SLI: 
    - Service Level Objectives: Target performance or reliability goal.  
    - Service Level Agreements: A legal or business agreement based on SLOs.  
    - Service Level Indicators: Measurable units used to track performance (e.g.,
      latency, resource usage).  

- Push v. Pull of data: 
    - Push refers the the end point pushing data into a server.   
        - Client sends data to the server proactively.  
        - This is how Promtail works with Loki. Promtail pushes logs up to Loki.  
    - Pull refers to the monitoring system fetching data from clients on a schedule.  
        - Client exposes data and server pulls it up (scrapes it).  
        - Node_Exporter exposes metrics, and then Prometheus pulls them up into its database.  
        - Using pull, it's easier to tell if instances are down.  

- Alerting rules: Rules that we define that determine when we are alerted, and under
  what conditions.  
    - This can be defined to alert when certain metric conditions are met, or when
      certain events are logged.  

- Alertmanager: A Prometheus component that handles alerts.  
  It handles deduplicating, routing, grouping, silencing, and notification delivery.  
    - Alert template: Templates used by Alertmanager to determine how
      notifications/alerts are formatted.
        - Alertmanager's templating system is based on the Go templating system. Some fields 
          are evaluated as text and others as HTML, which offers a lot of flexibility in how 
          your alerts are displayed.    
    - Routing: Defines which receiver should be notified based on alert labels or the
      severity of the alert.  
        - Receivers can be Slack, PageDuty, email, or a custom integration using
          Alertmanager's generic webhook interface.  
    - Throttling: Used to prevent notifications from flooding your receivers. This is 
      listed as "inhibition" in the Prometheus documenation (Grouping is also relevant here). 
        - It prevents notifications for certain alerts if other alerts are already firing, 
          which can be useful during a major outage.  

  <https://prometheus.io/docs/alerting/latest/alertmanager/>
  <https://prometheus.io/docs/alerting/latest/notifications/>

- Monitoring for defensive operations: 
    - SIEM: Security Information and Event Management. A centralized system for
      collecting, normalizing, correlating, and analyzing security logs. 
        - Splunk, Elastic SIEM, Wazuh, Graylog
    - Intrusion Detection Systems - IDS: A system that detects when suspicious
      activity occurs.  
        - It monitors traffic or system activity and detects, logs, and alerts on suspicious behavior.  
        - Snort, Suricata, OSSEC
    - Intrusion Prevention Systems - IPS: Like an IDS, but also actively blocks or
      drops malicious traffic.  
        - This is often deployed inline on the network.  
        - Suricata (in IPS mode), Cisco IPS  


## Notes During Lecture/Class:
[notes](./notes.md)

## Links:
- <https://promlabs.com/promql-cheat-sheet/>
- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>

## Terms:

## Useful tools:
- STIG Viewer 2.18
- SCC Tool (version varies by type of scan)
- OpenScap


## Lab and Assignment
Unit7_Monitoring_and_Alerting - To be completed outside of lecture time.


## Digging Deeper

1. Look into Wazuh: [Security Information and Event Management (SIEM). Real Time Monitoring | Wazuh:](https://wazuh.com/platform/siem/)

    - What are their major capabilities and features? (what they advertise)
    - What are they doing with logs that increases visibility and usefulness in the security space? 
      [Log data analysis - Use cases · Wazuh documentation](https://documentation.wazuh.com/current/getting-started/use-cases/log-analysis.html)

## Reflection Questions

1. What do I mean when I say that security is an art and not an engineering practice?
    - There are many ways to achieve things. If the end result is a system in which
      you have a keen insight as to what's going on, you can do that in a variety of
      ways. In that sense, the type of brush you pick to paint those strokes is up to
      you.  

2. What questions do you still have about this week?


3. How are you going to use what you’ve learned in your current role?
    - I'll be putting these skills to good use in my homelab, and then putting that
      on the resume.  

