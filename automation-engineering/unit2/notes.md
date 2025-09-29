# Unit 2 notes

## Last Week Review

Automation is an extension of the engineering cycle process where triggers
cause events to occur or cycles to start instead of manual intervention.

Important to accurately break down each step into a process to implement
automation properly. 
Automation always starts somewhere (usually at the beginnning of the cycle) and
must 

Events happen within a system -- alerts happen ouside of a system.  

Automation mindset:
- Consistecy (repeatability)
    - even starting your own process 30 times, manually typing things in can
      have issues. 

Devops Methodology

- Everything produces artifacts. Artifacts are fed into the next step.  
- Acceptance testing becomes automated.
- Peer review before going into prod
- Continuous Integration/Continuous Deployment (CI/CD)


## Unit 2 Overview

- Automation cycle
    - How does automation cycle function in an enterprise?
    - How do we build for all the eventualities of differences in so many systems?

- System Checking
    - What do we check on a system?
    - What do we need to know to differentiate systems?

Perfection is not the goal -- just get as close as possible.

"You don't go when you're ready, you go when you're ready enough."

---

## Automation Cycle

1. Trigger
2. Input validation
3. System checking
    - Do not fail, generate variables for report.
    - Separate systems out into their categories, based on variables
4. Execution of primary function
    - Do not fail, generate variables for report.
5. System validation
    - Do not fail, generate variables for report.
6. Reporting
    - Sent to email, slack, discord, logs

---

yaml is considered "semi-structured"

The two most common types of semi-structured data:

- yaml
- json


CSV is also semi-structured.  

---


- Trigger 
    - time/events/alerts
- Input validation 
    - handled by builtin checks (do not fail, generate vars for report)
- system checking 
    - handled by evaluating variables you create and things that you plan for. we 
      paint with a wide brush here.
    - separate systems into groups
- Primary function 
    - patch/deploy/fix (do not fail, gen vars)
- System validation 
    - check system is back in working order (dont' fail, gen vars)
- Report out 
    - Based on Jinja or some other technology (templates are useful)

## System Checking
System checking is validating that the system is in a good state to proceed.

We may check:
- The os and versions are as expected
- Software pkgs are installed and at expected versions
- Services are running and/or ports are responding
- For patching, we might validate that repos are configured and can be reached for metadata pulling
    - If we didn't do a check on the repos against 1k servers, and 20 were
      broken, you could find out in two ways: 1. Have a check for it, 2. Have broken servers
- For systems with an RPMDB, we can validate that the RPMDB is responding and 
  ready for changes (RHEL and SLES specific, but very common)
    - `rpmdb --repair`
- May check that no connections are being made to the systems, in the case of being behind a drained connection.  

---

system checking is also grouping servers according to expected versiuons of the
OS.  
Yo ucan group by server function, variables, software pkgs, and really anything
else you want.  

Assume you had a group of servers, and you know they'd be RHEL 8,9,10, Ubuntu
24.04, or <unknown>. 
You can handle these accordingly. YOu can plinko them down into the actions
that they should take.  

This is necessaary because you do not always control what is going to be input
into your automations. You don't know what servers the orginzation will release
or allow, or slide in at the last minute for this patching, release, or
deployment.  

You don't always know all the time all the servers that will be in the patching
cycle -- People may try to run your automation against **any** type of
server/OS/system.  

## How much variance do you prepare for?
It's not feasible that you can predict every one of the possible inputs and
outputs of all systems you may interact with.  
The principle of "painting with a wide brush" loosely follows along with the
Pareto principle.  

The Pareto principle: "80% of your outcomes come from 20% of your sources".  

E.g., 80% of your headaches come from 20% of your systems.  


