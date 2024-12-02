# ProLUG 101

## Unit 12 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.

## Discussion Questions:

### Unit 12 Discussion Post 1: Your manager has come to you with another emergency. He
has a meeting next week to discuss capacity planning and usage of the system with IT
upper management. He doesn’t want to lose his budget, but he has to prove that the
system utilization warrants spending more.
1. What information can you show your manager from your systems?
2. What type of data would prove system utilization? (Remember the big 4: compute,
memory, disk, networking)
3. What would your report look like to your manager?

### Unit 12 Discussion Post 2: You are in a capacity planning meeting with a few of the architects.
They have decided to add 2 more agents to your Linus sytems, Bacula Agent and an Avamar Agent .
They expect these agents to run their work starting at 0400 every morning.
7 day view
24 hour view
1. What do these agents do? (May have to look them up)
2. Do you think there is a good reason not to use these agents at this timeframe?
3. Is there anything else you might want to point out to these architects about these
agents they are installing?

### Unit 12 Discussion Post 3: Your team has recently tested at proof of concept of a new
storage system. The vendor has published the blazing fast speeds that are capable of being
run through this storage system. You have a set of systems connected to both the old
storage system and the new storage system.
1. Write up a test procedure of how you may test these two systems.
2. How are you assuring these test are objective?
a. What is meant by the term Ceteris Paribus, in this context?

## Definitions/Terminology

* Baseline: Getting information about how a system is performing under normal operations. 
    * Establish a baseline of the system under normal operations to measure how changes affect a system.  
    * Do the same thing when the system is under load to see how the system is affected.  
    * This can be thought of as a "low watermark" of the system.  
    * Should be captured with telemetry and observability systems so that variations
      from the norm can be observed.  

* Benchmark: A standard point of reference used to measure and compare system performance and capabilities.  
    * Used for performance testing under specific conditions, e.g., measuring disk IO and CPU speeds. 
    * Allow comparisons across different systems or configurations.  
    * Validating the way the system is. Making a change. Then measuring what changed.  

* High watermark: The peak resource usage or performance level oberserved over a given time period.  
    * Useful for capacity planning; knowing the most RAM, CPU, or bandwidth your
      system has used.  
    * Can help identify potential bottlenecks during peak loads.  

* Scope: The boundaries/extent of what is being analyzed or managed in a system.
    * The scope defines what the analysis, testing, or project will cover and what
      will be excluded.  
    * E.g., The scope of a performance test could include CPU and RAM usage, but exclude network traffic

* Methodology: The structured approach or process used to achieve a specific goal.  
    * Should include a step-by-step approach, tools to use, and best practices to follow.  

* Testing: Validating a system's behavior under specific conditions.  
    * Unit testing: Testing individual components (e.g., does a service start correctly?)
    * Integration testing: Ensuring multiple services or systems work together.  
    * Performance testing/Stress testing: Evaluating how well the system handles load or stress.  
    * Regression testing: Confirming that changes haven't introduced any new issues.  

* Control: A baseline or unaltered state used for comparison in tests/experiements.  
    * In system testing, the control is the system under normal operation with no changes.  

* Experiment: The process of introducing a change to the system to observe its effects.  
    * Experiments can be modifying configurations, applying updates, or adjusting workloads.  
    * Always compare the results of an experiement to a control or baseline.  

* Analytics: Insights gained from analyzing data that has been gathered.
    - Descriptive: Deals with what happened in the past
        * How many? When and where?
    - Diagnostic: Deals with why did it happen in the past
        * where should we look? Why did it happen?
    - Predictive: Deals with what will happen in the future
        * What will happen next? what is the pattern?
        * If you watch your storage go from 50%, to 60%, to 70% over the past weeks,
          you can predict what will happen based on this data.  
        * HUDs, dashboards, 
    - Prescriptive: "How can we make it happen?"
        * What is the best action? What if we try this? *random testing*


## Notes During Lecture/Class:
### Links:
* https://kaggle.com/learn
* [NOAA Data Open Data Dessemination](https://www.noaa.gov/information-technology/open-data-dissemination)
    * Know the license that the data is under. Creative Commons is "public domain"
* https://catalog.data.gov/dataset - Legally allowed to use this for stuff

### Terms:

* Capacity planning:
* Stopgap Procedures:

* Find ways to describe system utilization to a manager
    * "Except for this one period of time, we sit at X% memory usage, X% CPU usage" etc.

The precision of the tool and your ability to use and interpret the tool are the most
inportant factors to making good assessments and predicting proper outcomes.  

Garbage in, garbage out. If you put garbage into the system, you'll only get garbage
out of the system.  


* The "Big 4" to consider when showing system utilization (in this order, based on cost):
    * Compute
        * GPU and CPU would both be compute
    * Memory
    * Disk
    * Networking

* Ceteris paribus: "All others being held equal" Holding all things equal. Usually an economic term.
    * We try to limit any non-dependent variables from being important in our evaluations.
    * Non-dependent variables are variables that get pushed by other variables.  

* Adding a bunch of agents could be unnecessary utilization; e.g., 5% per agent with 6 agents

* Benchmarking phase iteration:
    * Plan phase
        * Goals identification
        * Tools and metrics identification
        * Planning and resource allocation
    * Experiment phase
        * Experiment definition
        * Experiment execution
        * Result analysis
    * Improve phase
        * Benchmark report
        * Improvement planning
        * Improvement monitoring

* Qualitative and Quantitative assessments:
    * Qualitative assessments: Non-numerical evaluations that focus on descriptions,
      observations, and subject insights about the system.
        * Often involves human judgement or interpretation rather than data.
        * Helps identify issues that may not be easily measurable (like user
          experience, system design flaws, etc). 
        * E.g., observing that a UI is "slow to respond" without measuring response
          times.  
    * Quantitative assessments: Numerical and data-driven evaluations that use
      metrics and measurements to assess the system's performance or health.  
        * Focuses on specific, objective, and measurable criteria.  
        * E.g., Measuring CPU usage, memory consumption, or disk I/O

### Useful tools:
- Spyder ide
- Linpak (sp?)
* `iperf3`: Runs in either server mode or client mode.  
* `sar`: Good for utilization metrics in the past.
    * Only good for long-term system metrics. Won't accurately represent events that happen for less than 10 minutes
    * Logs from `sar` are stored in `/var/log/sa/`
* `stress`: Generic workload increase tool. 
* `Grafana K6s`: 

A loop to test 
```bash
time $(i=0; while (( i < 99999999 )); do (( i++ )); done)
```

## Lab and Assignment
Unit 12 Lab Baselining and Benchmarking
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
1. Analyzing data may open up a new field of interest to you. Go through some of the
free lessons on Kaggle, here: https://www.kaggle.com/learn
a. What did you learn?
b. How will you apply these lessons to data and monitoring you have already
collected as a system administrator?
2. Find a blog or article that discusses the 4 types of data analytics.
a. What did you learn about past operations?
b. What did you learn about predictive operations?
3. Download Spyder IDE (Open source)

a. Find a blog post or otherwise try to evaluate some data.

b. Perform some Linear regression. My block of code (but this requires some
additional libraries to be added. I can help with that if you need it.)

```python
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
size = [[5.0], [5.5], [5.9], [6.3], [6.9], [7.5]]
price =[[165], [200], [223], [250], [278], [315]]
plt.title('Pizza Price plotted against the size')
plt.xlabel('Pizza Size in inches')
plt.ylabel('Pizza Price in cents')
plt.plot(size, price, 'k.')
plt.axis([5.0, 9.0, 99, 355])
plt.grid(True)
model = LinearRegression()
model.fit(X = size, y = price)
#plot the regression line
plt.plot(size, model.predict(size), color='r')
```


## Reflection Questions
1. What questions do you still have about this week?
2. How can you apply this now in your current role in IT? If you’re not in IT, how can you
look to put something like this into your resume or portfolio?
