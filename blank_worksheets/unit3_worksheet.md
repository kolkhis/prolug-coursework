# ProLUG 101  
## Unit 3 Worksheet  

## Table of Contents
* [Unit 3 Worksheet](#unit-3-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 3 Discussion Post 1](#unit-3-discussion-post-1) 
    * [Unit 3 Discussion Post 2](#unit-3-discussion-post-2) 
* [Definitions and Terminology](#definitions-and-terminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Logical Volume Management](#logical-volume-management) 
    * [LVM Step by Step](#lvm-step-by-step) 
        * [LVM Tools](#lvm-tools) 
    * [Implementing RAID on Logical Volumes with mdadm](#implementing-raid-on-logical-volumes-with-mdadm) 
    * [Resizing Logical Volumes](#resizing-logical-volumes) 
    * [LVM Snapshots](#lvm-snapshots) 
    * [Creating a Logical Volume from Raw Disks](#creating-a-logical-volume-from-raw-disks) 
* [Lab and Assignment](#lab-and-assignment) 
    * [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 


## Instructions  

Fill out this sheet as you progress through the lab and discussions. Turn in the sheet to scott.champine@simple2serious.com for grading and feedback.  

## Discussion Questions:  

### Unit 3 Discussion Post 1
What does the term triage mean to you? Have you ever had to triage something?  
To triage is to sort by order of importance. I've only ever triaged in troubleshooting code. This was just a way to figure out what I should work on first - e.g., fixing problematic API calls is more important than making the output look good. 
1. Scan the chapter [here](https://google.github.io/building-secure-and-reliable-systems/raw/ch17.html) for keywords and pull out what you think will help you to better understand how to triage an incident.  

2. Read the section called "Operation Security" in this same chapter: 
    [here](https://google.github.io/building-secure-and-reliable-systems/raw/ch17.html)  
   what important concepts do you learn about how we behave during an operational response to an incident?  

### Unit 3 Discussion Post 2
Ask google, find a blog, or ask an AI about high availability. (Here’s one if you need it: https://docs.aws.amazon.com/pdfs/whitepapers/latest/real-time-communication-on-aws/real-time-communication-on-aws.pdf#high-availability-and-scalability-on-aws)  

1.  What are some important terms you read about?  

2.  Why do you think understanding HA will help you better in the context of triaging incidents?  


## Definitions and Terminology  

- Five 9’s: 
- Single point of failure (SPOF): 
- Key Performance Indicators (KPI): 
- SLI (Service level indicator): 
- SLO (Service Level Objective): 
- SLA (Service Level Agreement): 
- Active-Standby: 
- Active-Active: 
- MTTD: 
- MTTR: 
- MTBF: 






## Notes During Lecture/Class:  
 
### Links  

### Terms  

### Useful tools  


## Lab and Assignment  
Unit3_ProLUG_LVM_and_RAID - To be completed outside of lecture time  

---

Start thinking about your project ideas (more to come in future weeks):  
        Topics:  
1.  System Stability  
2.  System Performance  
3.  System Security  
4.  System monitoring  
5.  Kubernetes  
6.  Programming/Automation  

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.  
### Digging Deeper  
1.  If uptime is so important to us, why is it so important to us to also understand how our systems can fail? Why would we focus on the thing that does not drive uptime?  

2.  Start reading about SLOs: https://sre.google/workbook/implementing-slos/  
How does this help you operationally? Does it make sense that keeping systems within defined parameters will help keep them operating longer?  

## Reflection Questions  
1.  What questions do you still have about this week?  

2.  How are you going to use what you’ve learned in your current role?  

