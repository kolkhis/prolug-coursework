# ProLUG 101

## Unit 11 Worksheet


## Table of Contents
* [Unit 11 Worksheet](#unit-11-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 11 Discussion Post 1](#unit-11-discussion-post-1) 
    * [Unit 11 Discussion Post 2](#unit-11-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
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

2. What is the advantage given for why you might want to implement this type of tooling in your monitoring? Do you agree? Why or why not?

3. They mention "exposing metrics" what does it mean to expose metrics? What happens to metrics that are exposed but never collected?

### Unit 11 Discussion Post 2
Your HPC team is asking for more information about how CPU0 is behaving on a set of servers.  
Your team has node exporter writing data out to Prometheus

(Use this to simulate https://promlabs.com/promql-cheat-sheet/).
1. Can you see the usage of CPU0 and what is the query?  

2. Can you see the usage of CPU0 for just the last 5 minutes and what is the query?

3. You know that CPU0 is excluded from Slurm, can you exclude that and only pull the
   user and system for the remaining CPUs and what is that query?

## Definitions/Terminology
- SLO (Service Level Objective):
- SLA (Service Level Agreement):
- SLI (Service Level Indicator):
- KPI (Key Performance Indicator):
- Span:
- Trace:
- Prometheus:
- Node_Exporter:
- Grafana:
- Dashboard:
- Heads up Display (HUD):


## Notes During Lecture/Class:
### Links:

### Terms:

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


2. Look up the “ProLUG Prometheus Certified Associate Prep 2024” in Resources -> Presentations in our ProLUG Discord.  
Study that for a deep dive into Prometheus.

3. Complete the project section of “Monitoring Deep Dive Project Guide” from the
prolug-projects section of the Discord.  
We have a Youtube video on that project as well.  
https://www.youtube.com/watch?v=54VgGHr99Qg

## Reflection Questions
1. What questions do you still have about this week?

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you look to put something like this into your resume or portfolio?

