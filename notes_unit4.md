
# ProLUG 101 Unit 4 Notes



## Definitions/Terminology
* Detection: 
* Response: 
* Mitigation: 
* Reporting: 
* Recovery: 
* Remediation: 
* Lessons Learned: 
* After action review: 
* Operations Bridge: 


## Notes During Lecture/Class:

Topics:
* Operating running systems
* Handling incidents
    * Do we have an incident bridge?
    * Tracking events and timelines?
    * what info do we track?
        - time we were alerted
        - what we checked
        - what actions we took
        - did we change anything?
        - were we instructed to change anything?
TIMESTAMP EVERYTHING


logs
open ports
processes



Incident response lifecycle
* Response capability (Policy, procedure, a team)
    * This is handled before an incident happens.  
    * A team needs to be defined beforehand
* Invident response and handling (triage, investigation, containment, and analysis 
  & tracking)
* Recovery (recovery / repair)
* Debriefing


MTTD: Primary KPI of being on a security team
* Mean Time To Detect

MTBF 
* Mean Time Between Failures
* Infant Mortality Rate: If a piece of hardware is going to fail before MTBF, it'll
  be in the first few weeks of use. 

---
Always keep logs of your issues
* If you're claiming that you can't ping out to google.com, log that output to a
  file.  


Test your assumptions about your system. 

You get alerted - Note when you're alerted
Check test assumptions
Document anomalies

---

Full system checkout
Verify what you know and don't know about a system
Understand Cron and Crontab entries


### Links:
https://github.com/dokksterr/linux-hardening-checklist
https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/
https://www.sans.org/information-security-policy/

### Terms:
* Redlining: Take someone who's never seen a project before and run them through it.  
    * Smoothing docs to make sure no one can mess it up.  

### Useful tools:
```bash
cat /etc/*release
```
* iowait
* ionotify



## Project:
* Select *some topic* around linux systems. 
Apply tripwire to an org?
Make your own tripwire?:
* iowait
* ionotify

