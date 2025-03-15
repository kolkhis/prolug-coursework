# ProLUG 101
## Unit 6 Worksheet

## Table of Contents
* [Unit 6 Worksheet](#unit-6-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 5 Discussion Post 1](#unit-5-discussion-post-1) 
    * [Unit 5 Discussion Post 2](#unit-5-discussion-post-2) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.


## Discussion Questions:

### Unit 5 Discussion Post 1
A ticket has come in from an application team.  
Some of the servers your team built for them last week have not been reporting up to enterprise monitoring and they need it to be able to troubleshoot a current issue, but they have no data.  
You jump on the new servers and find that your engineer built everything correctly and the agents for node_exporter, ceph_exporter and logstash exporter that your teams use.  
But, they also have adhered to the new company standard of firewalld must be running.  
No one has documented the ports that need to be open, so you’re stuck between the new standards and fixing this problem on live systems.

1. As you’re looking this up, what terms and concepts are new to you?

`firewalld` - specifically the `firewall-cmd` command and the concept of a "zone".  
I'm not particularly well-versed in anything related to firewalls.
I've configured some port forwarding in the past but I've never manually configured a firewall for a system, and I've never manually opened ports.  
So, quite a lot of this is new to me.  


2. What are the ports that you need to expose? How did you find the answer?
The ports I need to expose are the ones used for the services running on the machine.
Specifically, the agents for `node_exporter`, `ceph_exporter`, and `logstash exporter`.  
* The port for `node_exporter` is HTTP port `9100` by default.
    * Source: https://github.com/prometheus/node_exporter
* The default port for `ceph_exporter` is `9128`.  
    * Source: https://github.com/digitalocean/ceph_exporter
* Find out what version of Logstash Exporter is being used. Both versions seem to be
  using the same ports for the exporter.  
    * The default ports for `logstash-exporter` are `9600` (for the logstash API) and `9198` (for the exporter itself). I'd want to see if any other services use port `9600`, because if it's in use when the Logstash service starts, it'll try to use `9601`, or if that's in use, `9602`, and so on.  
        * Source: https://github.com/kuskoman/logstash-exporter
    * The ports for `logstash_exporter` (with an underscore) are the same, `9600` for the Logstash API, and `9198` for the exporter.  
        * Source: https://github.com/BonnierNews/logstash_exporter


3. What are you going to do to fix this on your firewall?
First, I'd check the `firewalld` status on the system to make sure it's up and running.  
```bash
systemctl status firewalld
```
I'd check the current ports that are exposed and listening on the machine.  
```bash
ss -tuln
```


Then I'd go into `firewalld` and check the current ports and services that are exposed on the machine
```bash
firewall-cmd --list-all-zones  # lists all the zones, and if they have anything assigned to them
firewall-cmd --list-all        # lists the services and ports that are exposed, and what zone they're in
firewall-cmd --list-ports      # lists the ports that are exposed
firewall-cmd --list-services   # lists the services that are exposed
```

Then I'd then expose the ports that need to be exposed for the services that need to communicate externally, using `--permanent` to make the change persist through reboots.
Since `public` is the zone that is usually used for public-facing services, I'd probably add the ports to that zone, assuming it's active.  
```bash
firewall-cmd --permanent --zone=public --add-port=9600/tcp
firewall-cmd --permanent --zone=public --add-port=9198/tcp
```
Without `--permanent` option, a change will only be a part of the *current* runtime configuration, meaning it won't persist across reboots.  


I may also wanna check that the zone these ports are enabled on is actually attached to the correct network interface for outgoing traffic.  
```bash
firewall-cmd --get-active-zones  # shows active zones and what network interface they're attached to
```

The changes aren't applied immediately. 
I'd need to restart or reload firewalld first (or reboot the system) before the changes take effect.  
```bash
firewall-cmd --reload
```

Finally, I could check the configuration file for the `public` zone to make sure the changes were added.  
```bash
vi $(firewall-cmd --permanent --path-zone=public)
# /usr/lib/firewalld/zones/public.xml
```








### Unit 5 Discussion Post 2
A manager heard you were the one that saved the new application by fixing the firewall. They get your manager to approach you with a request to review some documentation from a vendor that is pushing them hard to run a WAF in front of their web application. You are “the firewall” guy now, and they’re asking you to give them a review of the differences between the firewalls you set up (which they think should be enough to protect them) and what a WAF is doing.

1.	What do you know about the differences now?

Network firewalls:
A network firewall targets **all** internal and external network traffic (not just HTTP), and 
acts as an intermediary between the internet and the internal network. These are
mainly used to prevent unauthorized access to private networks by separating a secure 
zone and a less secure zone, and control the communications between these two zones.   

Web Application Firewalls:
A WAF is used to target only HTTP (Hypertext Transfer Protocol) and HTTPS (HTTP 
Secure) traffic, or "application traffic".  
Application-level firewalls are used in the public-facing zones of the network, to 
detect things like SQL injections, cross-site scripting (XSS), DDoS attacks; attacks 
that can be carried out over HTTP.

The main technical difference between network firewalls and WAFs is the network layer that these
two types of firewalls operate on (as defined by the OSI network model).

WAFs protect against attacks that are made on the application layer, layer 7.
This protects against:
* Attacks on web applications (like Ajax, ActiveX, JavaScript)
* Cookie manipulation
* SQL injection
* DDoS
* URL attacks

Network firewalls protect against attacks that are made on the network layer (layer 3), and on the transport layer (layer 4).  
This protects data transfer and network traffic.  
This protects against:
* Man-in-the-Middle Attacks
* Unauthorized access
* DNS Attacks
* FTP Attacks
* SMTP Attacks
* SSH Attacks
* Telnet Attacks


2.	What are you going to do to figure out more?

I'll figure out more by reading the documentation for the WAF that they're
trying to implement. I'll read up on other differences and implementations in blog 
posts or articles. 


3.	Prepare a report for them comparing it to the firewall you did in the first discussion.

Since the company thinks that the network firewall is enough to protect against attacks, I'll set up an outline explaining the differences between the firewalls, and why a WAF is important.   

I understand that you may think that the network firewall I configured is enough to protect against attacks. It will protect against attacks made on the network from bad actors trying to gain unauthorized access to our systems, but there are some crucial things that the network firewall does not protect against.

A network firewall is designed to protect against attacks made on the network our systems are on, but not necessarily the applications that our systems host.  The network firewall we've set up can protect our servers from attacks on crucial protocols and areas of the network, like FTP, DNS, SMTP, and SSH. However, it is not designed to detect or prevent the types of attacks made on web applications.  

That's where the Web Application Firewall (WAF) comes in.
The WAF is designed to protect against malicious attacks made on the applications
that are hosted on our servers; attacks carried out over HTTP and HTTPS (Hypertext Transfer Protocol/Secure). These attacks include things like DDoS (Distributed Denial of Service) attacks, SQL injections, cross-site scripting, cookie manipulation, and other HTTP-centric attacks.  

Technical difference: The network firewall is a type of firewall that operates on the network layer (layer 3) and the transport layer (layer 4), based on the OSI (Open Systems Interconnection) network model, inspecting traffic made to the systems hosting our application. The WAF operates on the application layer (layer 7), inspecting traffic made to the application itself.

Conclusion: 
Both the network firewall and the WAF are important tools in our network's security infrastructure. Both should be implemented to mitigate the risk of attacks on any part of our systems.  





## Definitions/Terminology
* Firewall: A network security tool that monitors and controls inbound and outbound network traffic based on predefined security rules.  
* Zone: A logical grouping of network interfaces in a firewall configuration. Zones are levels of security or strictness in `firewalld`. With `firewalld`, one zone can be attached to a network interface at a time.  
* Service: In the context of firewalls, a service is an application or protocol (like HTTP, SSH, DNS, etc) that requires network access
* DMZ (Demilitarized Zone): The part of the internal network that is used to separate internal and external networks. The DMZ allows access to your system, but limits its access to the internal network.  
* Proxy: A server that acts as an intermediary between a client and a server.  
* Stateful packet filtering: Firewall keeps track of communications, relies on a trusted interface
* Stateless packet filtering: Firewall doesn't keep track of communications
* WAF (Web Application Firewall): Applied by cloud providers in front of different web applications
* NGFW (Next Generation Firewall): Application level firewalls that are waware of what the application is doing. Can adapt to various applications, users, and devices.



## Notes During Lecture/Class:

Types of firewalls
Firewalls on a *device* are for sure operating on the first 4 layers, someimtes all 7
* Network firewalls - Operates on network layers 3 and 4 (network layer and transport latyer)
* WAFs - Operate on application layer 7.  
* NGFW (next-gen firewall) 
Layer 4 - Checks TCP hand shakes that are half-open. Prevents SynAck attacks

---

A WAF and a standard firewall are both firewalls, but they function in different ways.  
A standard firewall acts like a gatekeeper.  
Standard firewalls are designed to permit or deny access to networks.  
On the other hand, a WAF generally focuses on threats aimed at HTTP/HTTPS and other areas of the application, as you mentioned in your post.  
Additionally, WAFs run on different algorithms such as anomaly detection, signature-based, and heuristic algorithms.  
Therefore, it is best to place a standard firewall as the first layer of security and then place a WAF in front of the application servers in the DMZ zone.

---



### Links:
https://owasp.org/www-project-top-ten/
https://www.fortinet.com/resources/cyberglossary/waf-vs-firewall

### Terms:
* Access Control Lists (ACLs)
* `nohup`: No hangup. Both a command and a signal (`SIGHUP`).  
    * `nohup` is used to run a command that won't be stopped when the parent process is terminated.  
* Nohup Environment: normally all child processes are killed when a shell session
  is terminated. A nohup environment is used to keep processes running across
  multiple sessions. 
    * `tmux` and `screen` are both nohup environments.  
```bash
nohup sleep 600
ps -ef | grep -i sleep
# sleep is there
# Restart the shell
ps -ef | grep -i sleep 
# sleep is still there
```
* Defense in depth: Multiple layers of protection so that when one layer fails, another layer still covers the gap
* `/usr/lib/firewalld/`: The location of the firewalld configuration files.

`screen` and `tmux` are both nohup'd environments.  
```bash
screen -x <number>  # Join a screen session even if another user is connected to that session
```

Jumpbox
Firewalld/UFW



### Useful tools:
```bash
man 7 signal
screen -x <number>  # Join a screen session even if another user is connected to that session
seq 1 10
systemctl enable/status firewalld
firewall-cmd
firewall-cmd --get-zones
firewall-cmd --list-all --zone=public
```

## Lab and Assignment
Unit 6 Firewalls - To be completed outside of lecture time
-	(Alternate assignment to lab, if you have no Rocky) https://killercoda.com/het-tanis/course/Linux-Labs/205-setting-up-uncomplicated-firewall-UFW
Begin working on your project from the Project Guide
		Topics:
1.	System Stability
2.	System Performance
3.	System Security
4.	System monitoring
5.	Kubernetes
6.	Programming/Automation

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.

## Digging Deeper
1.	Read https://docs.rockylinux.org/zh/guides/security/firewalld-beginners/
What new things did you learn that you didn’t learn in the lab?
What functionality of firewalld are you likely to use in your professional work?

I learned that you can use `firewalld` to only allow specific IPs or places access to a server.  
The functionality of `firewalld` that I'm likely to use in my professional work (if I ever get any) is enabling services to communicate through their necessary ports, opening ports to specific IPs, and to allow specific IPs access to a server to communicate with services.

## Reflection Questions
1.	What questions do you still have about this week?

When using tmux to connect to servers, is it usually preferred to use tmux on your
local terminal session and connect to the server using SSH, or is a tmux session usually started
on the remote server, after SSHing into the remote server?

2.	How does security as a system administrator differ from what you expected?

Security as a systems administrator is about what I expected (so far). Managing
access from within the network and outside the network is a key concept of any
system's security.  


