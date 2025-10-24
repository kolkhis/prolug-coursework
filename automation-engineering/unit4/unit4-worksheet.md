# ProLUG Automation

## Unit 4 Worksheet

## Instructions

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.


## Discussion Questions:

### Unit 4 Discussion Post 1

Your company is on a normal 3 year refresh cycle for hardware.
This means that they purchase ~1/3 of hardware in each year budget. You have 6 months
until the next purchase but have been having storage capacity issues in some of your
servers. Your team sits down and works out a plan to put in place some “Stop gap”
measures to keep the system running until the next deployment.

1. Find an article that discusses what “stop gap” measures are.  

    - This is the one I used: <https://www.arichinfotech.com/understanding-stopgap-measures-definition-and-examples/>  
      Short and sweet.  

2. What is your understanding of the term “stop gap”.  

    - Answer: A stopgap is a solution to an immediate problem that is meant to be temporary. 
      This type of fix is usually only applied when the problem is severe and
      there is no readily available permanent fix to the problem, or the
      permanent fix would take far too long to implement.  
      The permanent fix should still be pursued and implemented, but if the
      problem is "we need this to work **now**," a stopgap solution might be
      the way to go.   

3. What are some things you would be doing to help a system that has no way to add
   capacity before a certain time to continue operations between here and there?  

    - Answer: Perhaps pruning old data. Large log files, uninstall unnecessary packages
      and remove bloat, check for dependencies for packages that were uninstalled, 
      Maybe we can migrate some of the data off of this saturated system's
      storage by connecting an NFS/Samba share and migrating non-mission-critical data off of it.  
      That's in relation to storage capacity, but if we're talking about a different type of
      capacity, we could route users off of this bottleneck server and into a
      more reliable system (if we have one available), or only allow certain
      types of traffic through.  
      These would be stopgap solutions.  

    - What is meant by the term “draconian measures” in this context?

        - Draconian measures typically means an overly strict policy that's
          enacted to address a problem.  
          In this context, it would refer to an extreme or highly restrictive
          action taken to preserve system stability when all other options
          fail, or when resources are severely constrained (e.g., enforcing
          severe rate limits or simply outright blocking certain types of
          traffic).  


### Unit 4 Discussion Post 2

You and your security team have an accurate inventory after last
week’s misunderstanding. You have 110 servers currently in your inventory. What are some
methods you can use to verify those systems are operational?

1. How might you “touch” those servers every day?
    - Maybe a simple ansible playbook that will SSH into the servers and run
      some general commands to verify that the servers are up, and check the
      status of our applications.  

2. How might you plan to keep that inventory updated automatically?

    - That depends entirely on the platform. If we have all those servers
      virtualized on a cloud provider, a hypervisor cluster, or some other such
      centralized platform, we could use the API to dynamically generate an
      inventory for us, thus giving us a full view into all of our servers and
      keeping our inventory up to date and complete.  

    - Alternatively, we could manually maintain the inventory. Whenever a new
      server is added, we put it in the inventory. This method requires far more toil
      and is very prone to human error, and isn't very highly scalable.  

3. How might you monitor those servers? (What tools can you find that would do this?)

    - There are a number of observability tools out there. I'm most familiar
      with the tooling provided by Grafana Labs:
        - Grafana  
        - Prometheus  
            - w/ Node_Exporter  
        - Loki
            - w/ Promtail
        - Alternatively, Alloy to replace Node_Exporter and Promtail.  
    - ELK stack (ElasticSearch, Logstash, Kibana) is also a popular solution
      for observability. This seems to now be called the Elastic Stack.  
    - These ones are nice because they're free. There are also plenty of paid
      solutions. 

4. How might you present a report for these servers (to your team or others?)

    - This could be done with a jinja template via ansible, since ansible
      supports jinja2 templates out of the box. We could use an Ansible
      playbook to check in on servers daily and populate a template with
      relevant information, then either grab and send that manually to the team
      or set up a webhook to integrate with whatever platform is being used
      (e.g., Slack, Discord, etc.).  


## Definitions/Terminology

- One-off: Commands that are not part of an automation, but are run to quickly
  perform an action or retrieve data.  

- Ad-hoc: Commands that are put together on the fly that are not part of a
  larger automated process.  

- Admin Commands: Administrative commands used to set values or get values from
  a system.  

- Stop gap fix: A temporary solution to an immediate problem. A stopgap fix is
  not meant to be a permenent solution to the problem, but should remediate it
  long enough to get a permenent fix out.  

    - How does this relate to a full implementation?
        - A full implementation is the stage where a system design is realized.  
          This relates to stop gap fixes in that the full implementation is
          likely flawed in some way and must be retooled to accommodate the
          **permanent** fix to the problem.  


    - How does this relate to a systemic system problem?
        - A systemic system problem would be an issue with the system
          design/configuration itself. If a stopgap fix is needed, depending on
          the problem, this could indicate a problem in how the system itself was 
          designed, and may require changes to the system configuration/setup
          process.  
          For instance, if the system is provisioned via IaC, maybe with
          Terraform, the permanent fix may need to be implemented within the
          Terraform module itself.  

    - How does this relate to a systemic capacity problem?
        - If the problem is a capacity issue, then the resources we allocate to
          the system may need to be scaled.  
          If we're routing traffic off a server as a stopgap due to being
          unable to handle <N> amount of connections, then maybe we need to
          look into the resources that are provisioned for the system itself
          rather than how the system was built.  

- System load (and utilization ((always as a percentage)) ): The percentage of
  resources that are being utilized by the system.  

    - Averages: The average/mean resource usage of a given type of resource.  

    - High water mark: The highest acceptable load for a specific type of
      resource.  

    - Low water mark: The lowest acceptable load for a specific type of
      resource.  

    - Spiking: A sudden, sharp increase in resource utilization.  

    - Capacity: The total amount of resources the system has access to.  


## Notes During Lecture/Class:
Links:
•
Terms:
Useful tools:


## Lab and Assignment
Unit4 Lab from Lab book
<https://killercoda.com/het-tanis/course/AutomationLabs/Unit4_Admin_Commands>


## Digging Deeper

1. Read this article about Ansible ad-hoc commands
   <https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html>

    1. What did you learn about this that you didn’t know?

    2. How are you going to use this in your current or future automations?

## Reflection Questions

1. What questions do you still have about this week?

2. How are you going to use what you’ve learned in your current role?

