# ProLUG 101
## Unit 9 Worksheet

## Table of Contents
* [Unit 9 Worksheet](#unit-9-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 9 Discussion Post 1](#unit-9-discussion-post-1) 
    * [Unit 9 Discussion Post 2](#unit-9-discussion-post-2) 
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

#### Unit 9 Discussion Post 1
It’s a slow day in the NOC and you have heard that a new system of container deployments are being used by your developers. Do some reading about containers, docker, and podman.
1.	What resources helped you answer this?

2.	What did you learn about that you didn’t know before?

3.	What seems to be the major benefit of containers?

4.	What seems to be some obstacles to container deployment?


#### Unit 9 Discussion Post 2
You get your first ticket about a problem with containers. One of the engineers is trying to move his container up to the Dev environment shared server. He sends you over this information about the command he’s trying to run.

```plaintext
[developer1@devserver read]$ podman ps
CONTAINER ID  IMAGE       COMMAND     CREATED     STATUS      PORTS       NAMES
[developer1@devserver read]$ podman images
REPOSITORY                TAG                IMAGE ID      CREATED      SIZE
localhost/read_docker     latest             2c0728a1f483  5 days ago   68.2 MB
docker.io/library/python  3.13.0-alpine3.19  9edd75ff93ac  3 weeks ago  47.5 MB
[developer1@devserver read]$ podman run -dt -p 8080:80/tcp docker.io/library/httpd
```

You decide to check out the server 
```plaintext
[developer1@devserver read] ss -ntulp
Netid   State    Recv-Q   Send-Q      Local Address:Port        Peer Address:Port         Process
udp     UNCONN   0        0           127.0.0.53%lo:53               0.0.0.0:*             users:(("systemd-resolve",pid=166693,fd=13))
tcp     LISTEN   0        80              127.0.0.1:3306             0.0.0.0:*             users:(("mariadbd",pid=234918,fd=20))
tcp     LISTEN   0        128               0.0.0.0:22               0.0.0.0:*             users:(("sshd",pid=166657,fd=3))
tcp     LISTEN   0        4096        127.0.0.53%lo:53               0.0.0.0:*             users:(("systemd-resolve",pid=166693,fd=14))
tcp     LISTEN   0        4096                    *:8080                   *:*             users:(("node_exporter",pid=662,fd=3))
```

1.	What do you think the problem might be?
    - How will you test this?

2.	The developer tells you that he’s pulling a local image, do you find this to be true, or is something else happening in their run command?


## Definitions/Terminology
- Container:
- Docker:
- Podman:
- CI/CD:
- Dev/Prod Environments (Development/Production Environments):
- Dockerfile:
- Docker/Podman images:
- Repository:


## Notes During Lecture/Class:

### Links:

### Terms:

### Useful tools:


## Lab and Assignment
Unit 9 containers and k3s
```http
# Run scenario and play with K3s
https://killercoda.com/k3s/scenario/intro
```

Continue working on your project from the Project Guide
		Topics:
1.	System Stability
2.	System Performance
3.	System Security
4.	System monitoring
5.	Kubernetes
6.	Programming/Automation

You will research, design, deploy, and document a system that improves your administration of Linux systems in some way.

## Digging Deeper
1.	Find a blog on deployment of some service or application in a container that interests you. See if you can get the deployment working in the lab.
    - What worked well?
    - What did you have to troubleshoot?
    - What documentation can you make to be able to do this faster next time?

## Reflection Questions
1.	What questions do you still have about this week?

2.	How can you apply this now in your current role in IT? If you’re not in IT, how can you look to put something like this into your resume or portfolio?
 
