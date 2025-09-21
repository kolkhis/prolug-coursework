# Linux Automation Course
## Unit 1 Notes


Syllabus

| Unit |                                                 Topic                                                 |
| :--: | :---------------------------------------------------------------------------------------------------: |
|  1   |   [Automation tools installation and execution]()    |
|  2   |   [Interacting with the Operating system]()   |
|  3   | [Making and using inventories]()  |
|  4   |      [Admin commands and one-offs]()      |
|  5   |  [Environment and Local Variables in systems]()  |
|  6   |     [Automating Docker Builds]()     |
|  7   |       [Automating Docker environments]()       |
|  8   | [Automating K8s environments]() |
|  9   |     [Build and Deploy Linux systems]()     |
|  10  |      [Harden Linux systems]()       |
|  11  |      [Update and patch systems]()       |
|  12  |      [Configure Network Devices]()       |
|  13  |      [Remediating and Reporting on Drift]()       |
|  14  |      [CI/CD Pipelines and Make v. Buy v. Adopt Decisions]()       |
|  15  |      [Troubleshooting/Testing 1]()       |
|  16  |      [Troubleshooting/Testing 2]()       |

---

Course addresses how to automate linux in a corporate environment.  

What *can* we automate?

- Building, security, chekcing/reporting. Anything you can do that takes more
  than a few keystrokes, you can automate.  

What *should* we automate?

- Design, build, deploy, admin, and remediation tasks.  

Focus: Build, Run and End of Life phase, so that CI/CD can occur and
deployments as code are utilized.  

~160 contact hrs.  

---

Project: ProLUG Toolbox

- Start a project on GitHub
- Make our own set of administrative tools
- Some Ansible, Bash, Python
- As a group, we'll make a set of useful tools for us to use

---

This week:

Topic one:

- First question of the course: "What is automation?"

Topic two:

- Find a blog with the topics of triggers and automation.
    - How do triggers affect automation?
    - How does testing guide automation?

Lab:

- Make sure we have access
- Ensure we can execute all of our tools 

Some tools we'll be using:

- Packer
- Docker




---

The lab has 5 nodes, and each node has 2 target nodes specifically for that
node.  

Target nodes:

- Auto1 has `target1-1` and `target2-2`
- Auto2 has `target2-1` and `target2-2`
- Auto3 has `target3-1` and `target3-2`
- Auto4 has `target4-1` and `target4-2`
- Auto5 has `target5-1` and `target5-2`

The user account will be `svc_ansible`, not `root`. Usually `root` access is
more restricted, and a separate privileged account will be provided.  

---

Course objective: Deploy verious automation tools for engineering and
operations activies.  

---

## Unit 1 Overview:

- What is engineering?
- What is automation?
- What is a trigger?
    - What types of triggers are there?
    - What's the difference between an event and an alert trigger?
- What tools do we have for automation?
- What is an automation mindset?
    - Whey do we want to cultivate one?


---

## Definitions/Terminology

* Engineering: We build engines, or systems that cycle
    - An example of an 8 function cycle:
        1. Feeding
        2. chambering
        3. locking
        4. firing
        5. unlocking
        6. extracting
        7. ejecting
        8. cocking
    - We can understand that engines always:
        1. Input
        2. Process
        3. Output

* Automation: An extrnsion of the engineering cycle process where triggers
  cause events to occur or cycles to start instead of manual intervention.  
    - Instead of manually starting the engine, a *trigger* starts it (e.g., a
      keyfob).  
    - It's important to accurately break down each step in a process to be
      abble to properly implement automation
        - This is because automation always starts somewhere (mostly at the beginning 
          of the cycle) and must perform all actions unprompted, uncorrected, or
          realigned.  
        - It needs to finish to completion without being fixed, corrected, etc.
          That's not true idempotency.  

* Triggers: Common triggers for automation:
    - time: 
        - chronological (every hr/day/month)
        - epochs or spans - every so many hrs from the last run
            - An epoch of zero means it continuously restarts without delay
              (back to back to back to back)
    - events: discrete occurrences within a system
        - Event driven system design
        - code commit
    - alerts: generated from thresholds, high watermarks, or other monitoring
      of events

* Scientific Method: Science explains the way the world works
    1. make an observation
    2. ask a question
    3. form a hypothesis
    4. make a prediction
    5. test the prediction
    6. iterate: keep spinning through to find more

* Deviation:
* Manual Intervention:
* Code Commits:
* Event Driven Systems:
* Alerts:

---

What does serverless event-driven architecture look like?

---

Check tools

- Bash
- Python
- Ansible


----

## Automation Mindset

What are the central problems of system engineering?

- Consistency (repeatability)
    - Even starting your own process 30 times, manually typing things in can
      have issues. Nevermind the fac tthat other members of your team or other
      engineering teams may need to follow your steps.  
- Timeliness
    - The time and variance it takes different people to go through, or even
      get to starting, a procedure is unacceptable.  

## DevOps Methodology

DevOps attempt to pull hardware/provisioning of systems in the software
lifecycle methodology.
- Everything produces artifcacts. those are fed into the next step.  
- Acceptance testing becomes automated.  
- Peer review before going into production
- CI/CD

## Quick and Dirty one-off commands
The quick ability to pull info from systems will greatly increase management
and others' perceptions of your ability to maintain systems.  

- Manager needs immediate infofor a meeting he's walking to right now (needs it
  in chat messenger)
- Manager needs immediate info during a meeting
- Manager needs `{...n...}`
- You need to quickly verify something on a set of servers to send in an email.  




