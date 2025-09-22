# Automation Unit 1 Discussion Posts

## Discussion Post 1
If you’ve done the previous courses, how would you define administration? If you haven’t find a blog (link for us) and explain how they define administration of Linux systems.,

```plaintext
Administration is maintaining running systems, troubleshooting errors on
systems exhibiting problems, and automating tasks.  
I wouldn't say it's necessarily limited to those 3 things, broad as they
are. I think administration can include some systems engineering tasks as
well (e.g., building out new systems and workflows).  
```

If you’ve done the previous course, how would you define security? If you haven’t find a blog (link for us) and explain how they define security of Linux systems.,
```plaintext
Security is a state of mind, but it's also a regular practice. Anyone and
everyone in tech should practice security, regardless of their station. 
Meta aside, security is the practice of analyzing potential threat vectors and 
putting controls in place to curtail the risk of those threats. It may also
involve remediation from a security incident.  
```

When you think about automation, how does it tie into things you do on a daily basis, inside or outside of computer systems?

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



## Discussion Post 2

What is your definition of a trigger?
```markdown
A trigger is a cause which *must* have a consistent, unchanging effect.  

Anything that causes something else to happen in a repeatable way can be 
considered a trigger.  

One of the most well-known examples of this is in firearms. Every firearm has a
trigger that causes it to fire.  
```


What are the types of triggers you read or can define?,
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


Where would you place these triggers to positively affect your ability to build or administer Linux systems?

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

