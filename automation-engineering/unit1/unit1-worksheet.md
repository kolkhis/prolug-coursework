# ProLUG Automation
## Unit 1 Worksheet

## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.

## Discussion Questions:

### Unit 1 Discussion Post 1
The first question of this course is, “What is automation?”

1. If you’ve done the previous courses, how would you define administration? If you
haven’t find a blog (link for us) and explain how they define administration of Linux
systems.

```plaintext
Administration is maintaining running systems, troubleshooting errors on
systems exhibiting problems, and automating tasks.  
I wouldn't say it's necessarily limited to those 3 things, broad as they
are. I think administration can include some systems engineering tasks as
well (e.g., building out new systems and workflows).  
```


2. If you’ve done the previous course, how would you define security? If you haven’t
find a blog (link for us) and explain how they define administration of Linux systems.


```plaintext
Security is a state of mind, but it's also a regular practice. Anyone and
everyone in tech should practice security, regardless of their station. 
Meta aside, security is the practice of analyzing potential threat vectors and 
putting controls in place to curtail the risk of those threats. It may also
involve remediation from a security incident.  
```


3. When you think about automation, how does it tie into things you do on a daily
basis, inside or outside of computer systems?

```plaintext
Automation is the cornerstone of human evolution. Manual tasks are tiresome
and time-consuming. We automate things to make our lives easier and to
boost our productivity. One of the earliest examples of automation was the
invention of the wheel. We automated the process of moving things from
point A to point B (well, not the whole process, but you get what I mean). 

This ties into my everyday life in that I'm always finding ways to automate
tasks. I pretty frequently write bash scripts and Ansible playbooks to automate 
a process once I've done it manually one time (for understanding and to test 
that it works). 

Another (very simple) example of automation in my daily life includes my
coffee maker. It doesn't support time-based brewing but the brewing process
in and of itself is automated. I put in the water and the grinds the night
before, and in the morning I press a button and have coffee within a few
minutes.  
```

### Unit 1 Discussion Post 2

What is meant by a trigger in automation?

1. What is your definition of a trigger?

```markdown
A trigger is a cause which *must* have a consistent, unchanging effect.  

Anything that causes something else to happen in a repeatable way can be 
considered a trigger.  

One of the most well-known examples of this is in firearms. Every firearm has a
trigger that causes it to fire.  
```


2. What are the types of triggers you read or can define?

```markdown
Some common types of triggers used:
- Time-based triggers
    - Chronological triggers: A trigger is pulled every `n` amount of seconds/minutes/hours/days
    - Epochs or Spans: Every `n` amount of hours from the *last time* the
      trigger was pulled.
- Event-based triggers: Run a trigger in response to a specific event that
  occurs.  
    - The event can be something like a code commit. In GitHub Actions, we can
      configure an event-based trigger to run when a branch is merged or a new
      commit is pushed up to a specific branch. This is an event-based trigger.
- Alerts: Sort of another type of an event-based trigger. An alert can be a
  trigger that is run when a system's resource usage meets a certain threshold,
  or if a certain type of log is detected. Basically anything that you can
  monitor on a system can be a trigger.  
```

3. Where would you place these triggers to positively affect your ability to 
   build or administer Linux systems?

```markdown
There are probably a couple of different places to put triggers for building
and administering Linux systems.

One place would be Cron/Anacron. This would be a time-based trigger (chronological).
This is a great place if we need to run something at a fixed time. 

Another place would be in systemd. `/etc/systemd/system/`
Systemd also allows us to schedule tasks in a chronological form with
`systemd.timer`. It also allows us to run things `n` seconds after the last run
(epoch/span), `n` seconds after boot, or after `n` seconds of a service being inactive. 
There are also path triggers that can be run when files change via
`systemd.path` units. 

tl;dr: systemd has a lot of trigger options.

Another (probably the most prominent) place to place triggers for
administration would be in our monitoring stack. In Grafana, we would configure
an alert to go out when our systems are saturated, or if we get important
security logs that the admins must know about.
```

## Definitions/Terminology

- Engineering: The act of builting and configuring systems.  
- Automation: Using technology/software to perform tasks with minimal human
  intervention.  
    - Taking a manual task and abstracting the process away from the user in order to simplify it.  

- Triggers: Procedures that are executed in response to specific events.  

- Scientific Method: An empirical method of acquiring accurate knowledge. It's
  a systematic process used to acquire knowledge through observation,
  experimentation, and anlysis.  
  The six steps to the scientific method are as follows:
    1. Make an Observation
    2. Ask a Question
    3. Form a Hypothesis
    4. Make a Prediction
    5. Test the Prediction
    6. Iterate: Keep spinning through to find out more (e.g., try to find more
       evidence or find counter-evidence that contradicts your hypothesis).  

- Deviation: The difference between an expected value and an actual value.  

- Manual Intervention: The act of manually performing automated tasks. 

- Code Commits: When a commit is made (code is changed) in a version-controlled repository (e.g., using Git, SVN).  

- Event Driven Systems: A sytems architecture where components communitcate by 
  producing and responding to "events." 
    - Events are significant changes in state.

- Alerts: A type of event-driven trigger that is used when a human needs to be
  notified of something.  
    - For instance, an alert may trigger when system resource utilization
      reaches a certain threshold, potentially requiring some sort of manual 
      intervention.  

## Notes During Lecture/Class:
### Links:

- Event Driven Architecture: <https://serverlessland.com/>
- Monitoring: <https://get.influxdata.com/rs/972-GDU-533/images/Customer%20Case%20Study_%20Wayfair.pdf>
- Kafka (event bus) Blogs: <https://aws.amazon.com/blogs/big-data/tag/amazon-msk/>

### Terms:

### Useful tools:


## Lab and Assignment

Unit1_Automation tools installation and execution - To be completed outside of
lecture time.

## Digging Deeper
1. Go to serverless land: https://serverlessland.com/patterns
    1. Can you implement one of the serverless architectures in the cloud via one 
       of the automation tools we have talked about?
    2. Do you see any other automation tools you may use in your career?
2. While we will be going over many concepts in this course, reviewing
   <https://killercoda.com/het-tanis/course/Ansible-Labs> and ensuring 
   you have a strong understanding of Ansible will help absorb this information.

## Reflection Questions
1. What questions do you still have about this week?

What's the difference between automation and orchestration?

Answer: Automation is the practice of automating single tasks. Orchestration is
more the coordination and execution of multiple automated tasks.  

2. How are you going to use what you’ve learned in your current role?

I will apply this knowledge and skillset to my work as a freelancer.
Additionally, I will add these skills to my resume to get a job as a Linux
admin/engineer.

