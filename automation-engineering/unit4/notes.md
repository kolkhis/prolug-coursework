# Unit 4 Notes


## Last Week
We talked about "what is an inventory."  

We use semi-structured lists for inventories. Flat files, CSV, json, yaml.  

---

Everything about maintaining an IT infra starts from a good inventory.  

Good inventories are:

- complete
- accurate / FQDN
- properly formatted

---


## Overview

Admin and one-off cmds

- what are they?
- what triggers them?
- one-off cmds in automation tools

### Admin Commands

There are 2 things you do at the command line. You set things and you check things.  

Admin cmds change running systems. They tend to fall into these categories:

- Observe - check system is as we expect it to be.  
- Benchmark - load test and spin the system up in some way. sometimes kicking
  off scripts or services
- Tune - change the system or config in some way (then restart services)

These all modify the system **in some way**. When you log in the a server, you
generate logs. That's modifying the server in a "purist" sense.

---

What triggers admin cmds to need to be run in a system?

- System event occurs
    - server stops responding
        - service unavailable
        - no ping
        - no console/power access
    - log event / alert trigger
    - event driven env activities (kafka, SQS, splunk)

- User request
    - give access/permission
    - fix/configure environment

- security event
    - security findings - trigger patching
    - security incident - triggers incident response

If anyone ever types `useradd` -- that needs to be reported. Any user accounts
that need to be there should be there from the beginning or come through AD.  

This would log and create a security incident, esp in a prod system.  




## 



## Terms

- PPDIOO
    - prepare
    - plan
    - design
    - implement
    - operate
    - optimize

Admin is the two O's (sysadmins start here).  
Engineering is PPDI.  



- Draconian: Overly secure / violently secure  

- systemic system problem: 
    - you're just doing stuff wrong
- systemic capacity problem: being overwhelmed by lack of capacity (e.g., can't
  support enough connections, running out of resources, etc.)
    - you're doing stuff right, but you've got a lack of resources


- perfmon

- iostat / vmstat





serverlessland


System hitting storage capacity issue, team is putting in a stop-gap measure to
keep it runnning.  

110 servers in inventory.  

