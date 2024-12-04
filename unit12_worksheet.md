# ProLUG 101  

## Unit 12 Worksheet  

## Instructions  
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to  
send to me at the end of the course.  

## Discussion Questions:  

### Unit 12 Discussion Post 1  
Your manager has come to you with another emergency.  
He has a meeting next week to discuss capacity planning and usage of the system with IT upper management.  
He doesn’t want to lose his budget, but he has to prove that the system utilization warrants spending more.  

1. What information can you show your manager from your systems?  

I can show metrics gathered by a tool like `node_exporter` visualized with Grafana, with a dashboard that shows resource utilization over the amount of time since his last meeting with upper management.  
I can also show data gathered with other tools from the command line.  


2. What type of data would prove system utilization? (Remember the big 4: compute,
memory, disk, networking)  

The type of data that would prove system utilization would be CPU usage, memory  
usage, storage space, disk read/write speeds, and network throughput.  

Using automated monitoring tools to gather the data would be ideal, but I could  
establish a current baseline that would show resource utilization as of right now:  
```bash  
iperf3 -s # Use to show network throughput  
pidstat 1 5 # Show what processes are consuming the most CPU  
iostat -xz 1 5  # Show CPU and Disk usage  
vmstat 1 5  # Show virtual memory usage 
mpstat 1 5  # Show overall CPU usage  
sar -h -u 1 5  # CPU usage over time
sar -h -r 1 5  # Memeory usage over time
sar -W  # Show swap used, indicating when the system runs out of memory
```


3. What would your report look like to your manager?  

The report made to my manager would include visualizations of resource utilization as  
shown in Grafana, and the output of commands used to monitor the resources on the  
system. I'll use my local ubuntu box and the rocky boxes for dummy data.  


#### First answer for Generating a Report

Average CPU utilization under normal operations is well below saturation.  
As you can see, this (relatively small) dataset shows that we're sitting at roughly ~95% idle CPU time.  
```bash  
#sar -u -p 1 5  
11:00:52        CPU     %user     %nice   %system   %iowait    %steal     %idle  
11:00:53        all      1.51      0.00      2.51      0.00      0.00     95.98  
11:00:54        all      1.00      0.00      3.49      0.00      0.00     95.51  
11:00:55        all      1.76      0.00      3.02      0.00      0.00     95.21  
11:00:56        all      2.25      0.00      2.00      0.00      0.00     95.75  
11:00:57        all      1.99      0.00      2.74      0.00      0.00     95.27  
Average:        all      1.70      0.00      2.75      0.00      0.00     95.55  
```
While there are some spikes in CPU consumption by both the system and user, they are relatively low and do not warrant extra CPU power.  

From the log data collected, we can see system utilization on the first day of this month.  
I've stripped out everything but the averages:  
```bash
# sar -u -f /var/log/sa/sa01
#CPU  
23:20:51        CPU     %user     %nice   %system   %iowait    %steal     %idle  
Average:        all      0.0%      0.0%      0.4%      0.0%      0.2%     99.4%  

# sar -rh -f /var/log/sa/sa01
#Memory  
23:20:51    kbmemfree   kbavail kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty  
Average:         1.6G      1.5G    191.1M      4.9%      0.0k      1.9G      2.3G     61.7%      2.0G     44.0k      0.0k  
```
`%commit` is the amount of memory needed for the current workload, showing that there's 38.3% available for applications. Of that 38.3%, 4.9% is being used by applications.  

As you can see, CPU under normal operations is mostly idle at 99.4% idle.  
Memory under normal operations stands at roughtly 4.9% utilization, leaving 95.1% free. 

The higest spikes in user CPU utilization show that the usage spikes to an
**average** of 4.74%. This could be worth investigating.  
```bash
# sar -u -p | awk '{ print $3 }' | sort -n | tail -n 5
0.11
0.21
0.71
0.86
4.74

# sar -u -p | awk '{ print "System: " $5 ", User: " $3 " Time: " $1 }' | sort -n | tail -n 5
System: 0.99, User: 0.21 Time: 16:30:27
System: 1.71, User: 0.86 Time: 16:40:51
System: 2.19, User: 0.71 Time: 17:40:51
System: 5.38, User: 4.74 Time: 17:10:51

# The timeline in question:
17:10:51        all      4.74      0.00      5.38      0.00      0.33     89.55
```
Between `17:00` and `17:10`, the CPU usage spiked to 10.45%.  



```bash  
# free -h  
               total        used        free      shared  buff/cache   available  
Mem:           3.8Gi       2.3Gi       1.6Gi       1.8Gi       1.9Gi       1.5Gi  
Swap:             0B          0B          0B  
```
On this particular box, we can see there's about 66% memory usage under normal operations, so  
this machine could potentially run out of memory when under a load. 

```bash  
for f in /var/log/sa/sa*; do sar -W -f $f; done  
```
`sar -W` shows all zeroes, meaning the box is not switching to SWAP due to running out of memory.  


* Disks
  ```bash
  iostat -xz | awk '{print $23}'
  %util
  0.00
  0.00
  0.00
  0.00
  ```
  This shows that the disks are far from saturation, they're not receiving more
  requests than they can process.  
  


On to disk speeds and network throughput.  
We'll perform read/write tests on several disks.  
```bash  
# Write  
time dd if='/dev/zero' of='/speedtest/xvdatest' bs=100M count=10  
10+0 records in  
10+0 records out  
1048576000 bytes (1.0 GB, 1000 MiB) copied, 1.48242 s, 707 MB/s  

real    0m1.628s  
user    0m0.002s  
sys     0m1.573s  

# Read  
time dd if='/speedtest/xvdatest' of='/dev/null'  
2048000+0 records in  
2048000+0 records out  
1048576000 bytes (1.0 GB, 1000 MiB) copied, 4.84648 s, 216 MB/s  

real    0m4.850s  
user    0m1.919s  
sys     0m2.827s  
```
We've got the read speed of the disk sitting at 216 MB/s.  
The write speeds are sitting at 707 MB/s.  

* Network:  
    * Check the network speeds:  
```bash  
iperf3 -c 192.168.200.101 -n 1G -P 128  # using 128 parallel streams on tcp  
[SUM]   0.00-1.75   sec  1.01 GBytes  4.99 Gbits/sec  203             sender  
[SUM]   0.00-1.75   sec  1.01 GBytes  4.98 Gbits/sec                  receiver  

# Increasing the bitrate/bandwidth for UDP, which is inherently limited with iperf3
iperf3 -c 192.168.200.101 -u -b 4G -n 1G -P 128  # using 128 parallel streams on udp  
[SUM]   0.00-12.99  sec  1.00 GBytes   662 Mbits/sec  0.000 ms  0/741632 (0%)  sender  
[SUM]   0.00-12.99  sec  1.00 GBytes   662 Mbits/sec  0.548 ms  0/741632 (0%)  receiver  
```

SIDEBAR: Increasing the bitrate with `-b` (default 1 Mbit/sec for UDP, unlimited for TCP/SCTP) better reflects network speeds with UDP.  

The network speeds are 4.99 Gbit/s via TCP, and 662 Mbit/s via UDP. 
Increasing the bitrate beyond `4G` doesn't make any difference, it produces the same speeds.  

Overall, our CPU utilization is low. Storage is averaged at 0%
However, memory is severely lacking in **some** of our service nodes, sitting at roughly 66% utilization under normal operations.  

FIN.
I don't know if a manager wants technical details like this or not... I'd probably use screenshots of monitoring dashboards instead of this format to write the report (everyone loves a graph)...  

---

#### Second answer for Generating a Report

I wrote bash script to format the data gathered from `sar` into CSV so it can be
opened in excel.  
```bash
sar -r -h 1 5 | 
    awk 'BEGIN {
        print "Timestamp,Free Memory,Available Memory,Used Memory,%Used Memory,Buffered Memory,Cached Memory, %Commited to System/Applications"
    } 
    NR>3 && /^[0-9A]/ {
        print $1, "," $2  "," $3 "," $4 "," $5 "," $6 "," $7 "," $9
    }' > memory_usage_report.csv
if [[ ! -f memory_usage_report.csv ]]; then
    printf "Error generating memory usage report.\n"
fi
```
I'd so the same for `sar -u` for CPU usage.
I'd use `iperf3` for network checking, an `iostat -xz`/`dd` for checking the disks.  

Afterthought, since the manager is looking to increase the budget:
I'd also use `smartctl` to determine how long the physical storage disks have been active, and compare that to any known MTBF for that particular disk.  

### Unit 12 Discussion Post 2
You are in a capacity planning meeting with a few of the architects.  
They have decided to add 2 more agents to your Linus sytems, Bacula Agent and an Avamar Agent.  
They expect these agents to run their work starting at 0400 every morning.  
7 day view  
24 hour view  

1. What do these agents do? (May have to look them up)  

The Bacula agent is part of an open-source, cross-platform system backup software kit, which allows backup, restoration, and data verification over the network.  

The Avamar agent is also a part of a backup and recovery solution, this one from Dell.  Avamar performs deduplication at the source of the data to minimize the amount of resources used.  


2. Do you think there is a good reason not to use these agents at this timeframe?  

Using both of them at the same time could be a bad idea, no matter the time. Both of these agents could use a significant amount of resources, which could cause system saturation and failures.  
In addition to that, the metrics shown on the dashboard already show a significant spike in memory and CPU usage on and around 04:00, so this timeframe is one of the worst they could choose from.  

3. Is there anything else you might want to point out to these architects about these  
agents they are installing?  

Yeah... These two agents serve the same basic function. Backup and recovery. Duplicating functionality like that is an extreme waste of resources.  
You'd not only be impacting the system by running the agents themselves, but the amount of storage that would be consumed could increase cost by an order of magnitude. 
I'd recommend considering if these backup solutions are better than the one we currently have in place, and if that turns out to be the case, choosing just one of these agents, rather than putting them both on the system.  


### Unit 12 Discussion Post 3
Your team has recently tested at proof of concept of a new  
storage system. The vendor has published the blazing fast speeds that are capable of being  
run through this storage system. You have a set of systems connected to both the old  
storage system and the new storage system.  

1. Write up a test procedure of how you may test these two systems.  

Establish a baseline for both of the systems.  
* Test disk read speeds and disk write speeds
  ```bash
  for i in {1..10}; do
      time dd if='/dev/zero' of='/old/system/mountpoint/file' bs=1024K count=100 2>&1 | tee -a /tmp/old_disk_write
      time dd if='/old/system/mountpoint/file' of='/dev/null' 2>&1 | tee -a /tmp/old_disk_read
  done
  # Same for the new storage system
  for i in {1..10}; do
      time dd if='/dev/zero' of='/new/system/mountpoint/file' bs=1024K count=100 2>&1 | tee -a /tmp/new_disk_write
      time dd if='/new/system/mountpoint/file' of='/dev/null' 2>&1 | tee -a /tmp/new_disk_read
  done
  # 2>&1 since `time` apparently writes to stderr by default
  ```
* Compare the two.
  ```bash
  cat /tmp/new_disk_read
  cat /tmp/old_disk_read
  cat /tmp/new_disk_write
  cat /tmp/old_disk_write
  ```
Gather data over time using metric-gathering tools and visualizations (node_exporter/prometheus/grafana).  
Create a dashboard with metrics of each of the two systems side by side to see how the they perform against each other.  


2. How are you assuring these test are objective?  

* Using only the output of reliable tools for judgements rather than how the system "feels".  
* Using the same tools (`dd` here) to test each of the storage systems.  
* Making sure that both systems are using the same hardware and software across the board.  
* Making sure that the two systems are being tested in the exact same environment with the exact same workload.  


a. What is meant by the term Ceteris Paribus, in this context?  

"Holding all others equal" - Examining the two disks in the exact same way, in the exact same environment. Basically, ensuring that the only variable that is being tested is the storage systems themselves.  


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

* Capacity planning: Forecasting and allocation the required system resources (CPU,
  memory disk, network) to meet the current a future workload demands.  
* Stopgap Procedures: Temporary solutions or workarounds to address an immediate
  issue or gap in functionality until a permanent fix can be applied.  



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

* The precision of the tool and your ability to use and interpret the tool are the most  
  important factors to making good assessments and predicting proper outcomes.  

* Garbage in, garbage out. If you put garbage into the system, you'll only get garbage  
  out of the system.  


### Useful tools:  
- Spyder ide  
* Linpack: Benchmark and stress testing tool. Best used to test system stability,
  especially of overclocked PCs.  
* `fio`: A benchmarking tool. It simulates real workloads, which will give more
  accurate statistics of how a disk will behave in an actual dev/prod environment.  
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
4. System monitoring  *
5. Kubernetes  
6. Programming/Automation  *
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

I've noticed that the output from `sar` and `free -h` don't really compliment each other...
In terms of memory usage, `sar` shows a 4.4% utilization on memory, but using
`free -h` shows that there's almost 66% of the total memory being used, with only 33%
available. Am I misinterpreting the output of `sar`?
* The answer I found: `sar` excludes cache and buffers from its memory utilization
  calculations for `free` memory, and focuses on the "real" usage by actual applications.  

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you  
look to put something like this into your resume or portfolio?  

I'm not in any role. 
When I get good at this, I can start a project that will establish baselines of
systems and generate reports, that can be put on a resume/portfolio as a project.  



