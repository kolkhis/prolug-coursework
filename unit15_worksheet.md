# ProLUG 101

## Unit 15 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions.  
Hold onto all of your work to send to me at the end of the course.  

## Discussion Questions:
### Unit 15 Discussion Post 1
Your management is all fired up about implementing some Six
Sigma processes around the company. You decide to familiarize yourself and get some
basic understanding to pass along to your team: https://www.sixsigmacouncil.org/wp-content/uploads/2018/08/Six-Sigma-A-Complete-Step-by-Step-Guide.pdf

1. Page 56 – What about the “5S” methodology might help us as a team of system administrators? (Think of your virtual or software workspaces)

The 5S methodology makes a lot of sense for systems. A filesystem can get cluttered very quickly, which can make it hard to find the things we need when we need them.  
Following the 5S methodology, we'd have a filesystem in which everything is there only if it needs to be, all files are clearly named with names that make sense, and directories are structured in a way that makes sense.
If we need to access a file, we'd know where to look for any given machine if the entire environment is standardized using the 5S methodology.  

2. Page 94 - What are the four layers of process definition? How would you explain them to your junior engineers?

The four layers or process definition are essentially components that break down how a process is structured.
The layers help people on a team understand, standardize, and improve processes by examining each layer of detail.  

The four layers are:
* Inputs: Refers to anything that is entered into a process to eventually produce an output
* Outputs: The service that is used by the end-user
* Tasks: The heart of a process. The tasks use the inputs and turn them into outputs.  
* Events: Specific actions that cause a process to start.  

Explain to a junior:
I'd hope that any junior engineer knows what inputs and outputs are. But, I'd use a webserver analogy to explan in this context.  
Inputs are the things you need to get started. If you're deploying a webserver, your inputs might be the IP address, application package, and config files. 
Outputs are the end goals of the work. After deploying a web server, the output is a running server accessible by end-users via its IP address.  
Events answer the question "What starts the process?" An event might be a user request to deploy a server.  
Tasks are the building blocks of a process, how you turn the inputs into outputs. Deploying a webserver might include tasks like provisioning resources, configuring the application, and then verifying that the server is running.  




### Unit 15 Discussion Post 2
Your team looks at a lot of visual data. You decide to write up an
explanation for them to explain what they look at.

1. What is a high water mark? Why might it be good to know in utilization of systems?
A high watermark represents the peak usage of resources.
It's the maximum value of resource usage that a system reaches during a given persiod.


This is good thing to know in terms of system utilization because we always need a point of reference.
We need to know when we're going to reach a level of utilization that a system cannot handle, resulting in saturation.  
It helps to identify whether the current infrastructure meets the needs of the applications.  
This can also be helpful in spotting bottlenecks in the system, pinpointing which areas of the system are mnost stressed and under what conditions.


2. What is an upper and lower control limit in a system output? While this isn’t exactly what we’re looking at, why might it be good to explain to your junior engineers?

These both refer to acceptable levels of resource utilization.
* Upper control limit (UCL): The highest acceptable value for a system before it's considered out of control or problematic.
* Lower control limit (LCL): The lowest acceptable value for a system before it's considered problematic.  
This would be a good thing to explain to junior engineers so that they can recognize
when the system is reaching either the UCL or LCL, so they can take the appropriate
actions, whether that be notifying a senior or some other procedure in place at the
organization.  


## Definitions/Terminology

- Incident: An unexpected event that disrupts normal operations.
    * Usually requires immediate attention and resolution.  

- Problem: The underlying cause of one or more incidents.
    * Problems may not always result in immediate incidents, but indicate an issue in the system.  

- FMEA: Failure mode and effects analysis
    * Identify: List all possible failure modes for each part of a systesm
    * Assess: Evaluate severeity, and detection of each failure mode
    * Prioritize. Rank failures (with RPN) according to risk priority to focus on the most critical issues first.

- Six Sigma: A data-driven methodology for improving processes by reducing variation and defects. 
    * 6S uses DMAIC to try to achieve near-perfect quality.  
        * Define
        * Measure
        * Analyze
        * Improve
        * Control

- TQM (Total Quality Management): Continuous improvement philosophy, with a focus on customer satisfaction, process improvement, and quality control at every level of the organization.  

- Post Mortem: Analyzing a problem after it has been resolved.  

- Scientific Method
    * Made up of 5 steps:
        * Observe: Notice smth that doesn't work as expected
        * Hypothesis: formulate possible reasonss for the problem
        * Experiment: Test hypotheses by changing variables or conditions
        * Conclusion: Analyze results to confirm or refute the hypothesis
        * Iterate: If the problem isn't solved, refine the hypothesis or experiment
    * This is important in chaos engineering.  

- Iterative: The process of refining and improving solutions incrementally until achieving the desired outcome.  

- Discrete data: Comes in 3 types
    * Ordinal: Numeric and ordered in some way (has a hierarchy)
    * Nominal: Simply numeric 
    * Binary - attribute

- Continuous data measured in units
    * Time of day is measured in hours
    * Temperature is measured in degrees

- Risk Priority Number (RPN): A score based on the severity, portability, and detection of a problem.  
    * RPN will be between 1 and 1000
    * Score: `Risk Priority Number (RPN) = Severity * Portability * Detection` (1-10 each)
        * 1 = lowest risk
        * 1000 = highest risk

- 5 Whys: Ask "why" five times, or until the problem is identified.  

- Fishbone Diagram (Ishikawa): Vizualize potentical causes of a problem grouped into categories like methods, machines, materials, mapntower, measurement, and environment

- Fault Tree Analysis (FTA): Top-down deductive failure analysis which an undesired state of a system is determined using boolean logic

- PDCA: Plan, Do, Check, Act 
    * Plan: Identify a problem and plan for change
    * Do: Implement the change on a small scale
    * Check: Measure the result to see if the change led to improvement
    * Act: If successful, ikmplement on a larger scale. If not, reasses and start the cycle again

- SIPOC: A diagram that is used to track problems and troubleshoot.  
    * Suppliers
    * Inputs
    * Processes
    * Output
    * Customers



## Notes During Lecture/Class:

### Links:
https://www.gremlin.com/certification


### Terms:
* Blooms taxonomy

* Muda: "non-value-added" tasks. 
    * Considered "waste" that fails to add value to a product or process that the customer or end-user defines.  
    * Type 1 muda are processes that may actually be essential or required by certain circumstances.  
    * Type 2 muda are processes that are not essential and can be immediately removed from a process.  

* 5s Methodology: A Japanese Lean approach to organizing a workspace.  
    * Making a process more effective and efficient, it'll become easier to identify and expunge Muda.  
    * Consists of five components:
        * Sort (Seiri)
            * Everything in the workspace is reviewed, removing unneeded items and
              only keeping things that are necessary.  
        * Straighten (Seiton)
            * After sorting, every tool/item/material is given a home to streamline using them.  
            * Things are labeled and accessible.  
        * Shine (Seiso)
            * Keep the workspace clean and neat.  
            * Naming files in a way that makes sense and makes them easy to locate.  
            * Keeping directory structure intact.  
            * Delete or archive files that aren't necessary.  
        * Standardize (Seiketsu)
            * Maintain the progress made in the previous phases.  
            * Continue best practices established from the other phases.  
        * Sustain (Shitsuke)
            * Commit to the process. Everyone follows these rules.  

* Layers of process definition
* Upper/lower control limit

Engineering troubleshooting:
* FMEA (before)
* Six Sigma or TQM (during)
* Port Mortem (after, typically projects)

PracticalTroubleshooting Tips:
* Documentation: Keep detailed records of all observations, tests, and outcomes.  
* Teamwork: Involve people with different perspectives and experience.  
* Tools: Employ software or diagrams for better visualization and analysis.  
* Iterative Approach: Be prepared to revisit steps or hypotheses as new information emerges.  


* Kepner-Trego Problem Solving
    * Situation analysis: Define the problem clearly
    * Problem analysis: Use questions like "what, when, where, how" to undestand the problem's nature
    * Decision analysis: Evaluate and choose the best solution
    * Potential problem analysis: Predict future issues and plan preventive measures

* 8 dimension problem solving
    * D1 Establish a team
    * D2 Describe the problem: scope problem appropriately
    * D3 Develop interim containment actions
    * D4 Define and verify root cause
    * D5 Verify permanent corrective actions: Fixing the problem
    * D6 Implement permanent corrective actions: Making sure it doesn't happen again
    * D7 Prvent recurrence
    * D8 Congratulate your team

Collecting data: Accuracy. Test and trust your collection tools and methods


Admins know that the thing they're fixing was working before. Engineers don't, so their scope can be different.  

* FMEA: Failure mode and effects analysis
    * Identify: List all possible failure modes for each part of a systesm
    * Assess: Evaluate severeity, and detection of each failure mode
    * Prioritize (RPN) will be between 1 and 1000.  Rank failures according to risk priority to focus on the most critical issues first
        RPN score:
        Severity * portability * detection (1-10 each) = Risk Priority Number (RPN)
        1 = lowest risk
        1000 = highest risk
    * What could go wrong?
    * What impact could it have?
    * What is the likelihood of it occurring?
    * Can we detect and react to it?


* Daily build process.

When troubleshooting a system: Basic information FIRST - uptime, last, etc. Then logs.

Every 6 months, your organization should update its documentation. Always update procedures.   

* Classic fault tree example calculation analysis
    * AND gate
    * OR gate
    * Fault event
    * Basic event
    * Undeveloped event
    * Normal event

* Plan Do Check Act (PDCA)
    * Plan: Identify a problem and plan for change
    * Do: Implement the change on a small scale
    * Check: Measure the result to see if the change led to improvement
    * Act: If successful, ikmplement on a larger scale. If not, reasses and start the cycle again

* SIPOC Diagram
    * Suppliers
    * Inputs
    * Processes
    * Output
    * Customers

### Useful tools:
https://ip-api.com/csv/$ip
* vRO (vRealize Orchestrator): A workflow automation and orchestration tool
  designed to streamline IT processes.  
* vRA (VMware vRealize Automation): A platform for automating the delivery of IT
  services, including infrastructure, applications, and custom IT processes.  


## Lab and Assignment
Unit 15 – No Lab – Christmas Miracle
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
1. Spend more time in https://www.sixsigmacouncil.org/wp-content/uploads/2018/08/Six-Sigma-A-Complete-Step-by-Step-Guide.pdf
a. Page 243 – Starts looking at visual data analysis.
2. Get your White belt (Free) Six Sigma Certification.

## Reflection Questions
1. What questions do you still have about this week?
2. How can you apply this now in your current role in IT? If you’re not in IT, how can you
look to put something like this into your resume or portfolio?
