# Unit 1 Worksheet - Linux Fundamentals and Systems Editing Tools

Welcome to Unit 1 of the Professional Linux Users Group (ProLUG) Systems Administration Course.
With this worksheet students will explore the foundations of Linux and its many constituent parts.

Specifically, this unit and worksheet aim to cover concepts such as the command line interface (CLI),
commands and syntax, command line tools, Vim (visual editor improved), the Linux Kernel, and much more.

Students are strongly encouraged to learn from these units and apply what they learn. Applying what you
learn offers no better teacher. Again welcome, and good luck in your studies.

### Resources / Important Links

- [https://public.cyber.mil/stigs/downloads](https://public.cyber.mil/stigs/downloads/)
- [https://excalidraw.com](https://excalidraw.com/)
- [https://www.open-scap.org](https://www.open-scap.org/)
- [https://www.sans.org/information-security-policy](https://www.sans.org/information-security-policy/)
- [https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets](https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/)

### Unit 1 Recording

- TODO -> Add Recording

## Instructions

---

A major aspect of this course is to intake, comprehend, and discuss the assigned
topics. Take the time to fully absorb each topic and contribute to the discussion
thread by sharing your thoughts. Interaction with peers is also expected; the goal is
to compare and contrast ideas to build a solid foundation of knowledge.

Fill out this worksheet as you watch the unit video.
Discussion posts can be completed afterwards, answers to be posted in Discord.
You must both answer the discussion questions and respond to another student's
answers. This is only required if you want the certification.

#### Discussion Post #1

The first question of this course is, "What is Security?"

A: Security, in relation to computers, is the process of maintaining controlled access to both a system and the data on that system.

1. Describe the CIA Triad.

Confidentiality, Integrity, and Availability. These are three things that define the
backbone of data security.
- Confidentiality: Making sure that only authorized users have access to data.
- Integrity: Making sure that the data remains in the state it must be in - it should be intact and untouched.
- Availability: Making sure that the data is accessible when it's needed.

Prioritizing one of these over the others can lead to complications. For instance,
making data *too* avilable could potentially compromise the confidentiality of the
data.
The CIA security triad is a concept that requires balance.

2. What is the relationship between Authority, Will, and Force as they relate to security?


**Authority** can impose rules, like "do not connect to this machine." But if a user has
the **will** to connect to that machine, unless there is a **force** (some sort of 
technical control) stopping them, then they will be able to connect, despite the rules imposed by the Authority. Will can overrule authority in the absence of force. Force is what enforces rules.  


3. What are the types of controls and how do they relate to the above question?

Controls can be categorized into types, the types define the type of action taken.
* Categories:
    * Technical: Controls implemented via hardware or software (e.g., firewalls).
    * Managerial: Rules or policies set by authority figures.
    * Operational: Day to day processes and practices that support security (training, incident response, audits, etc.).
    * Physical: Controls that protect physical access to systems.
* Controls:
    * Preventative: Controls that prevent incidents from occurring.
    * Deterrent: Controls that discourage/deter an attacker.
    * Detective: Controls that identify/detect when something goes wrong.
    * Corrective: Controls that fix/restore systems after an incident occurs.
    * Compensating: Alternate/fallback controls that are used when the primary
      control doesn't work.
    * Directive: Controls that provide guidelines/instructions.

These types of controls relate to the previous question in that many of these can
related to Authority, Will, and Force directly. 
For instance, a managerial directive control can set forth policies that prevent an
incident from happening, but if they're not also enforced by another type of control
(physical or technical), then those controls will not work 100% of the time.



#### Discussion Post #2

Find a STIG or compliance requirement that you do not agree is necessary for a server or service build.

1. What is the STIG or compliance requirement trying to do?

Apache 2.4 STIG `SV-33028r2_rule`: A web site must not contain a `robots.txt` file.

This is trying to stop a website from having a `robots.txt` file, which contains
instructions on what type of behavior is and is not allowed on that website by bots
(typically web scraping).  

This rule is in place due to the possibility of an attacker using the file to
determine the directory/file index for a site -- i.e., accidentally disclosing
potentially sensitive URLs or directories.

2. What category and type of control is it?

This is a technical/preventative control.

3. Defend why you think it is not necessary. (What type of defenses do you think you could present?)

This is definitely not necessary. This rule is overly cautious, ESPECIALLY for
public-facing websites. The `robots.txt` file isn't a security mechanism, it's a
voluntary protocol designed for SEO and crawler etiquette, not access control. It's a
communication tool, not a defense system. Malicious actors are already going to
ignore these instructions, so the file offers the attacker no real leverage against 
the website that they wouldn't be able to get through other means.

This rule also hurts legitimate use cases, when a site owner does not want his/her
data to be mined indiscriminately. Well behaved bots written by non-malicious devs
will honor the instructions set forth in this file.

<div class="warning">
Submit your input by following the link below.

The discussion posts are done in Discord threads. Click the 'Threads' icon on the top right and search for the discussion post.

</div>

- [Link to Discussion Posts](https://discord.com/channels/611027490848374811/1098309490681598072)

## Definitions

---

* CIA Triad: Confidentiality, Integrity, Availability
    - Confidentiality
    - Integrity: More than just protection from attackers
    - Availability: Is the system there when I need it to be?

* Regulatory Compliance: 

* HIPAA: Health Insurance Portability and Accountability Act.
    - A security standard -- set of security rules designed to protect sensitive
      patient health info (ensure the privacy and security of that info).  
    - Has different types of safeguards that define security practices:
        - Administrative safeguards
        - Physical safeguards
        - Technical safeguards

* Industry Standards: 
 
* PCI/DSS: 
 
* Security Frameworks: 
 
* CIS: 
 
* STIG: 

## Digging Deeper

---

1. Research a risk management framework. https://csrc.nist.gov/projects/risk-management/about-rmf

   - What are the areas of concern for risk management?

2. Research the difference between quantitative and qualitative risks.

   - Why might you use one or the other?

3. Research ALE, SLE, and ARO.
   - What are these terms in relation to?
   - How do these help in the risk discussion?

## Reflection Questions

---

1. What questions do you still have about this week?

2. How are you going to use what you’ve learned in your current role?


Resources:
- https://www.hhs.gov/hipaa/for-professionals/security/laws-regulations/index.html

Fix text:

```sql
GRANT USAGE ON *.* TO 'mariadb.sys'@'localhost' WITH MAX_USER_CONNECTIONS 1;
```

- CONTROLS
    * Categories
        * Technical
        * Managerial
        * Operational
        * Physical
    * Controls:
        * Preventative
        * Deterrent
        * Detective
        * Corrective
        * Compensating
        * Directive
        
