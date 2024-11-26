# ProLUG 101
## Unit 10 Worksheet
## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.


## Discussion Questions:

### Unit 10 Discussion Post 1
Read this document: https://kubernetes.io/docs/concepts/overview/
1. What are the two most compelling reasons you see to implement Kubernetes in
your organization?

The two most compelling reasons I see are the scalability capabilities and the "self-healing" capabilities that Kubernetes provides. 
To be able to easily scale up or down depending on the needs of the application is extremely valuable.  The "self-healing" capabilities, the ability to quickly detect and fix issues, is also a huge benefit.  
Kubernetes is a great tool for any company that runs containerized applications, or wants to.  

2. When the article says Kubernetes is not a PaaS? What do they mean by that? What is a PaaS in comparison?

When they say Kubernetes is not a PaaS, they mean that Kubernetes is not a "Platform as a Service".
I've heard Kuberenetes described as "more of a specification, not a platform". I
think that's a good way to put it. It's a specification that is used to determine how
the orchestration of containerized applications should be done, and it also provides
the tools you need in order to implement that specification.  

In comparison, a PaaS (Platform as a Service) provides a complete platform for
developing, running, and managing applications, and usually hosts everything for you
(e.g., servers, networks, storage, etc.). Kubernetes does not do any of these things,
it only gives you the tools you need in order to do it yourself.  



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

I'd run the same exact `kubctl version` and `kubectl get nodes` commands to verify the output is consisitent with the output I was sent.  
I'd look at the detailed status of `Test_Cluster2` to see if there are any errors to indicate why its status is `NotReady`.  
```bash
kubectl get node Test_Cluster2 -o wide
kubectl describe node Test_Cluster2
```
I'd look for any errors in the logs of the pods on `Test_Cluster2`. Though, I'd
suspect the problem they're facing is due to the inconsistent versions across the
clusters.  
Versions.
They are using k3s, but the k3s version on the client does not match the k3s version on the server.  

---

2. What do you think the problem could be?

The versions that are running on each cluster, except for `Test_Cluster1` are different than both the client and the server's version. This inconsistency is probably the cause of their issue.  

---

3. Do you think someone else has tried anything to fix this problem before you? Why or
why not?

Possibly. It looks like `Test_Cluster1`, which hosts the control plane, was upgraded from an older version to match the server's version, but none of the other worker nodes were upgraded.  

I have questions about their naming convention too...
Is "cluster" the right word for these, or should they be called "nodes"?
They seem to be nodes within a cluster, not clusters themselves.  



### Unit 10 Discussion Post 3
You are the network operations center (NOC) lead.  
 
Your team has recently started supporting the dev, test, and QA environments for your 
company’s K8s cluster.  
 
Write up a basic checkout procedure for your new NOC personnel to verify
operation of the cluster before escalating on critical alerts.
 
1. What information online helped you figure this out? What blogs or tools did you use?
I used ChatGPT to describe what a "checkout procedure" was.
https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
https://kubernetes.io/docs/concepts/services-networking/
https://www.groundcover.com/kubernetes-monitoring/kubernetes-health-check
https://k8s-docs.netlify.app/en/docs/reference/kubectl/cheatsheet/

2. What did you learn in this process of writing this up?

I learned that there are a lot (and I mean a LOT) of `kubectl` commands.  
I also learned that Persistent Volumes are used to dynamically allocate storage to Pods.  
I learned that Deployments are used to manage a set of pods. You can define a 'desired state' for the deployment, and the Deployment Controller will change the actual state of the pods to match the state you defined. ReplicaSets, which are controlled by Deployments, will automatically create pods in the background.  


My (probably not-so-great) checkout procedure:
* Communicate with the rest of your team to make sure you're up to date on all tasks so that you can understand what changes have been made, and any problems that may have been encountered. 

* Check the cluster state. All nodes should be `Ready`. If there's a problem, the node status could be `NotReady` or `Unknown`.  
   ```bash
   kubectl get nodes 
   ```
* Monitor the status of pods running in the cluster. Make sure pods are not continually restarted, stuck on `Pending`, or failing readiness probes.  
   ```bash
   kubectl get pods -n kube-system
   kubectl get pods --all-namespaces
   ```

* Check deployments, ReplicaSets, and services. Make sure everything is running as expected.  
   ```bash
   kubectl get deployments --all-namespaces
   kubectl get rc --all-namespaces
   kubectl get svc --all-namespaces
   ```
    
* Check the logs of the pods you're running to see whether there are any `Error`/`Fatal`/`Panic`/`Fail` messages.  
   ```bash
   kubectl logs 'pod' --all-containers=true
   ```

* Check the resource usage (CPU, memory, network) of the cluster. Make sure that all pods are using no more than the resources they need.  
   ```bash
   kubectl top nodes
   kubectl top pods --all-namespaces
   ```

* If the Kubernetes cluster is supposed to interact with other services (storage, databases, APIs, etc.), make sure those services are up and running.  
    * If you're using Persistent Volumes for storage, check on them to make sure that the dynamic storage provisioning is working as you expect.  
      ```bash
      kubectl get pv
      ```

* Run E2E tests (End to End Tests) regularly to make sure that your cluster is working as expected.  

* Make sure you have a monitoring and logging system in place. For example, Prometheus/Grafana for monitoring, ELK stack (ElasticSearch, Logstash, Kibana) for logging. 

* Make sure to stay updated with the latest Kubernetes versions for bug fixes, security updates, and new features.  

---




## Definitions/Terminology
* Kubernetes/K8s: A container orchestration tool. It's a container management system
that helps deploy and manage containerized applications. 
* K3s: A lightweight version of kubernetes. Available as a single binary.  
    * Supports single node or multi-node clusters.  
* Controller Manager: The component of a Kubernetes control plane that runs controller loops.
    * Controller loops are responsible for managing the state of Kuberenetes resources (e.g., pods, nodes, deployments)
    * Also responsible for managing specific controllers like the Node Controller, Job
      Controller, etc. 
* ETCD: A distributed, highly available key/value store that is used by Kubernetes to store cluster data (including configuration and state info).  
* Kubelet: An agent that runs on each Kubernetes node.  
    * Ensures containers are running in Pods, as instructed by the control plane.  
* Kube-proxy: The network proxy that runs on each node.  
    * Manages network rules to route traffic to the correct Pods, either inside or
      outside the cluster.  
* Controlplane: The set of processes that provide the control plane for a Kubernetes cluster.
    * A Control Plane is made up of the API Server, Scheduler, Controller Manager, and ETCD.
* Node: A machine in a Kubernetes cluster.  
    * Can be either a physical or virtual machine.  
* Static Pod: Defined by a static configuration file on a node.
    * Static Pods are directly managed by the Kubelet.  
    * These pods are NOT managed by the Kubernetes API Server.  
* Scheduler: The component of a Kubernetes control plane that watches newly created Pods and decides which node they should run on. 
* API Server: The component of a Kubernetes control plane that exposes the Kubernetes API.
    * Serves as the central hub for communication between all cluster components. 
    * Exposes the Kubernetes API and handles RESTful requests from users, components,
      and external systems.  

## Notes During Lecture/Class:

### Links:
* [Labels/selectors](https://yuminlee2.medium.com/kubernetes-labels-selectors-and-annotations-2e3e931282a7)
* [Ingress](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#ingress-v1beta1-extensions)
* [Storage in k8s](https://kubernetes.io/docs/concepts/storage/)
    * [Storage Volumes](https://kubernetes.io/docs/concepts/storage/volumes/)
* [Docs on Ephemeral Volumes](https://kubernetes.io/docs/concepts/storage/ephemeral-volumes/)
* [Config Maps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/)
    * [Creating Config Maps](https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-configmap/#create-a-configmap)
    * [Overview/Example](https://kubernetes.io/docs/concepts/storage/volumes/#configmap)

### Terms:
* Storage volumes: Storage volumes are volumes used by kubernetes pods to persist data.  
    * Not always HDD/SSDs (physical disks). 
    * While the pod doesn't necessarily need to be stateful, pods also support volumes
      attached to aid in persistent storage betweeen restarts.  
    * You can provide storage volumes to a pod using a PersistentVolumeClaim.  

* Ephemeral volumes: 
* configMap: A YAML file used to inject configuration data into pods.  


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

---

Installing k3s
```bash
curl -sL https://get.k3s.io | sh -  # Using the -F was failing every time
kubectl get nodes 
```

To add worker nodes, I'd need to get the `k3s` node token from the master node and 
use it in the `k3s` installation on the worker node.  
```bash
# Get the node token and the IP on the master node
cat /var/lib/rancher/k3s/server/node-token
hostname -I | awk '{ print $1 }'

# then, on the worker node
curl -sFL https://get.k3s.io |
    K3S_URL=https://master-node-ip:6443 \
    K3S_TOKEN=node-token \
    sh -

# Verify the cluster
kubectl get nodes
```
I could use Ansible to do this, by reading the token from a file on the master node
and connecting out to all the worker nodes.  
I'd have to write 2 plays in the playbook, one to get the token from the local
machine and save it into a variable, and another to connect to the worker nodes and
set up k3s.  
```yaml
- name: Retrieve k3s token from master and setup worker nodes
  hosts: master
  tasks:
    - name: Get k3s token from master and save as k3s_token
      command:
        cmd: cat /var/lib/rancher/k3s/server/node-token
      register: k3s_token

    - name: Save IP to variable master_node_ip
      ansible.builtin.shell:
        cmd: 'hostname -I | awk "{ print $1 }"'
      register: master_node_ip

    - name: Save IP and Token to facts
      ansible.builtin.set_fact:
        MASTER_NODE_IP: "{{ master_node_ip.stdout | trim }}" # Get rid of whitespace
        K3S_TOKEN: "{{ k3s_token.stdout }}"
      

- name: Install and configure k3s worker nodes
  hosts: workers
  tasks:
    - name: Install k3s on worker nodes with the master's token
      shell: 
        cmd: curl -sFL https://get.k3s.io | K3S_URL=https://{{ hostvars['master']['MASTER_NODE_IP'] }}:6443 K3S_TOKEN={{ hostvars['master']['K3S_TOKEN'] }} sh -
      args:
        executable: /bin/bash
      become: yes
```
I can't (or don't know how) to fully test this playbook in the ProLUG lab environment, 
but I'm going to test it on my homelab once I have it set up.  

---

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

Is manual configuration of TLS required for control planes? Or does k8s provide some sort of API to set up data encryption in transit?

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you
look to put something like this into your resume or portfolio?

I'm not in any role, but I will be applying this knowledge to stuff in my homelab.  
Hopefully I'll be able to roll out some cool k8s stuff that'll give me skills and projects to put on my resume.  


