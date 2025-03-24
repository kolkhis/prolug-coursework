# ProLUG 101
## Unit 10 Worksheet


## Table of Contents
* [Unit 10 Worksheet](#unit-10-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 10 Discussion Post 1](#unit-10-discussion-post-1) 
    * [Unit 10 Discussion Post 2](#unit-10-discussion-post-2) 
    * [Unit 10 Discussion Post 3](#unit-10-discussion-post-3) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
    * [Unit 10 Lab k3s](#unit-10-lab-k3s) 
* [Digging Deeper](#digging-deeper) 
* [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.


## Discussion Questions:

### Unit 10 Discussion Post 1
Read this document: https://kubernetes.io/docs/concepts/overview/
1. What are the two most compelling reasons you see to implement Kubernetes in
your organization?

2. When the article says Kubernetes is not a PaaS? What do they mean by that? What is a PaaS in comparison?

### Unit 10 Discussion Post 2
You get a ticket about your new test cluster.  
The team is unable to deploy some of their applications.  
They suspect there is a problem and send you over this output:

```bash
[root@Test_Cluster1 ~]# kubectl version
Client Version: v1.31.6+k3s3
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
Server Version: v1.30.6+k3s1
[root@rocky15 ~]# kubectl get nodes
NAME STATUS ROLES AGE VERSION
Test_Cluster1 Ready control-plane,master 17h v1.30.6+k3s1
Test_Cluster2 NotReady worker 33m v1.29.6+k3s1
Test_Cluster3 Ready worker 17h v1.28.6+k3s1
```


1. What are you checking on the cluster to validate you see their error?

2. What do you think the problem could be?

3. Do you think someone else has tried anything to fix this problem before you? Why or
why not?

### Unit 10 Discussion Post 3
You are the network operations center (NOC) lead.  
 
Your team has recently started supporting the dev, test, and QA environments for your 
company’s K8s cluster.  
 
Write up a basic checkout procedure for your new NOC personnel to verify
operation of the cluster before escalating on critical alerts.
 
1. What information online helped you figure this out? What blogs or tools did you use?

2. What did you learn in this process of writing this up?


## Definitions/Terminology
- Kubernetes/K8s:
- K3s:
- Controller Manager:
- ETCD:
- Kubelet:
- Kube-proxy:
- Controlplane:
- Node:
- Static Pod:
- Scheduler:
- API Server:

## Notes During Lecture/Class:

### Links:

### Terms:

### Useful tools:


## Lab and Assignment
### Unit 10 Lab k3s
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

## Digging Deeper
1. Work more in the lab to build a container of your choice and then find out how to
deploy that into your cluster in a secure, scalable way.

2. Read this about securing containers: https://docs.docker.com/build/building/best-practices/

a. Do this to practice securing those containers. 
https://killercoda.com/killer-shell-cks/scenario/static-manual-analysis-docker

3. Read these about securing Kubernetes Deployments:
https://kubernetes.io/docs/concepts/security/ and
https://kubernetes.io/docs/concepts/security/pod-security-standards/

a. Do this lab to practice securing Kubernetes: 
https://killercoda.com/killer-shell-cks/scenario/static-manual-analysis-k8s


## Reflection Questions
1. What questions do you still have about this week?

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you
look to put something like this into your resume or portfolio?


