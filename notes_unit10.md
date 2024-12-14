
# ProLUG Unit 10 Notes

## Table of Contents
* [k3s](#k3s) 
* [Containers](#containers) 
    * [What are they?](#what-are-they) 
    * [Why use them?](#why-use-them) 
    * [Why doesn't everyone just start running containers everywhere?](#why-doesnt-everyone-just-start-running-containers-everywhere) 
    * [What's the solution? Kubernetes.](#whats-the-solution-kubernetes) 
    * [Pods vs containers](#pods-vs-containers) 
        * [Exposing a pod deployed to K8s](#exposing-a-pod-deployed-to-k8s) 
    * [Fields](#fields) 
* [Exposing a service with an Ingress](#exposing-a-service-with-an-ingress) 
* [Storage volumes and persistence](#storage-volumes-and-persistence) 
* [Fin.](#fin) 
* [Links](#links) 


Docker/containers
How you'd use docker/containers (and the problems you need to solve) 

Sandboxed environments for containers - 

Rapid development

node_exporter is usually gonna be run on port `9090`.



## k3s
k3s is like Kubernetes Light

To install k3s on a system:
```bash
curl -sFL https://get.k3s.io | sh - 
```
K8s (Kubernetes) is a whole system that has APIs and containers, backend database, 
and all these microserverices running (DNS, handles all the networking), runs kubelet, 
making nodes into control planes or workers (masters/slaves). 


You can turn off all sorts of things on Kubernetes.
k3s is not as robust, it comes as a single executable.  
It still has an API server (p 6443)
Everything that interacts with things is based on certificates
Control plane nodes have static 

```bash
kubectl version
kubectl get nodes
kubectl get pods -A  # Get all pods from all namespaces
kubectl get ns       # Show all the namespaces
```
coredns has been the standard of kubernetes for a long time
With k3s you sacrifice deep granularity and control.  

k8s had an `uwu` version: Kubernetes v1.30: Uwubernetes

```bash
kubectl get pods -n kube-system # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide # scope down to the kube-system namespace
kubectl get pods -n kube-system -o wide --show-labels # scope down to the kube-system namespace
```

Each pod is assigned an IP. If you delete a pod and recreate it, it will get a new IP.
We front-end a service with pods and hit them with their names instead of their IPs.

```bash
kubectl describe service kube-dns -n kube-system  # Show the details of the kube-dns service
```

Services select their backends based on `selectors` or `labels`.  

```bash
kubectl get pod -n kube-system -o wide
kubectl get pod coredns-7b98449c4-dgbcs -n kube-system -o wide
kubectl delete pod coredns-7b98449c4-dgbcs -n kube-system  # Delete a pod
```
So, k8s services are designed to find labels and select pods based on those labels.  

```bash
kubectl get pvc
kubectl get pv
podman images
```

* Deploy nginx by pulling in a "config map", and pull that in as a static page




## Containers
### What are they?
Kubernetes docs define containers as:
A ready-to-run software package containing verything needed to run an application
the code and any runtime it requires, application and system libraries, and default
values for any essential settings

Wht it is, at the core:
a collection of directories and the metadata of how to execute those directories,
bundled up into a "container" that is shippable to any platform that can run them

It's intended that containers should be stateless and immutable.   
Any changes to an image should be done by creating a new image.  

when you build an image, it's stored in layers.

Build an image and version it.

---

### Why use them?


Traditional server architecture:
Linux -> Java -> Application

If the application team maintains the java, they may never want to patch it (possible security risks)
If the Linux team maintains the java, they may upgrade it and break the application.  

---

20 new servers can fit in the same amount of space that 2 servers would.  
So, the amount of compute able to fit in the same physical space has expanded
exponentially over the years.



---

now, with virtualization, you can now pack 10 or 20 applications on each server,
which expands the amount of services that can be run in the same amount of space.  

---

Even with all these new VM servers, there's still a lack of utilization of hardware.  


You kind of need to look at scales of acceptable failures. How can you drive density?
You still need to distribute things evenly across the nodes.  

Enter Kubernetes/Containers


---


Throw in a directory with metadata on how to run it, and call it a container.
and you can then run the 
Now it's a Java container thrown into a node, so all those nodes can run the exact same
application with the same version.  


---


* A container decouples our applications from the underlying host infrastructure .  

* Allows you to drive better compute density into your hardware (get get more bang 
  for your buck in the cloud)

* Each container that you run is the same. If you run an imgage, it should run the 
  same way every single time. 

* Makes your applications cloud agnostic. Whether on-prem, or in the cloud, your 
  application should execute the same way every time, everywhere.  

* Allows you to break down your monolith applications into microserverices that are 
  smaller and more easy to maintain and scale.  


---


If a container doesn't work - just remember
Run things the same every time.
If it breaks, troubleshoot it. It's hard to shoot a moving target. 
Just like you'd commit changes to code. 


### Why doesn't everyone just start running containers everywhere?

Standalone containers really aren't great.  
Running a podman container on top of a regular OS is really only good for dev
environemtns. 

* Redundancy - if the host you run the container on has an outage, there's nothing
  telling the container to start again (unless you run manual startup scripts)

* Scalability - There's nothing to track CPU utilization, or memory utilization, etc.
  There's no magic way to scale a container. There's nothing monitoring on the host
  saying to scale up or down.  

* Accessibility - Exposing a container on a host requires a host port to container port
  mapping. This is easy to do for 1, 10, maybe even 100 pods. But this is problematic
  doing it at scale.

* Security - No security measures implemented at a host level, unless secured by the
  admin that protect the container OR its runtime.  

### What's the solution? Kubernetes.
Kubernetes is a container orchestration tool. There's a reason it's the most popular.

Open-source.
For managing containerized workloads and services.
Facilitates both declarative contiguration and automation. 
Has a large, rapidly growing ecosystem. 
Services, support, and tools are widely available. 

Name originates from Greek, meaning "Helmsman" or "Pilot".  


A clustering technology for managing containers.
* Control plane - has 5 major components to it
    * c-m (controler manager): 
    * api
    * scheduler
    * etcd: Backend database for k8s
    * c-c-m (cloud controller manager): Optional. 

* Look up: 
    * Operators for Kubernetes
        * Passing a Kubernetes definition to an API endpoint, and it will be built for you.  
    * Openshift



---

Node architecture:
* has a Kubelet and a Kubelet Proxy


Everything you do is an API call. Requesting defs, checking status, etc., all are API
calls. They're written to etcd, 

* split brain: Node says one thing, etcd says another



K8s becomes a way for you to take a pol of pcompute nodes and turn the minto a famr
of rsources that supports running yoru applications infrastructure as pods.


* Pod/Pods:



* 4 CPU x 32GB RAM nodes: This ratio is good for appls that are more memory-intensive.  

CPU measurements in k8s are measured in millicores. 1000 millicores = 1 core.

You should always factor into security tools, system tools, etc., as well as the
application that you need to host.  

Not every pod will spike to 100%+ CPU at the same time. 
So, being overcommitted on CPU is not necessarily a bad thing.   

When you instantiate a kubelet, you can put 8 CPUs into a VM. You can go into k8s,
into the kubelet, and say "it's an 8 core VM, but you can only use 6 of them".  
The node kubelet reports to the API "I have 6 cores of schedulable space".
You should try to figure out what to scale *by* when scaling

Add new applications coming in.. "do we have room for it?" - scale worker nodes to
add more compute space.  

How many pods do we want to schedule per worker node? 120 pods per worker node

Having more worker nodes, instead of provisioning larger pods, provides redundancy. 



Requests: ARE YOUR IDLE
    What does your application idle at?
    Most apps, idle low at CPU but might have some memory consumption that requires 2 GB
    of idle memory.  
Limits: YOUR CEILINGS 
    What can the pod burst to? The CPU util might burst to 1000 millicores
     What is the *ceiling*?
     KNOW your ceilings


K6s is a way to load test


### Pods vs containers:
pods - the smallest unit of deployment that can take place to a Kubernetes cluster.

You don't run containers with Kubernetes
You pass a yaml definition (pod definition) to tell kubernetes what it needs to know
about how to run the pod.  
You can run multiple containers within the same pod.  

You can configure what port(s) the pod is exposed on, how much CPI requests/limits to
give it, memory requests/limits, where to pull the image from, proves, etc..
The definition you pass in tells Kubernetes how to execute your application.  

#### Example pod definition (or "kube definition")
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec: 
  containers: 
  - name: nginx
    image: nginx:1.14.2
    ports:
    - containerPort: 80
```

If you push a pod definition, and lost you k8s cluster, you lose your pod
definitions. 
You use replication controllers to manage these things.  

---

#### Exposing a pod deployed to K8s

Kubernetes leverates its own internal networking SDN (software defined network) to
perform the networking magic behind the scenes. 
There are many Networking Plugins out there, most open source, some paid.  

K8s uses the "service" component ot expose network applications.

The k8s documentation defines a Service as:
"Expose an applcation running in your cluster behind a single outward-facing
endpoint, even when the workload is split across multiple backends."

That means that you're able to push a new pod definition behind a service, and as
long as it's been exposed on the same port, the service will send traffic to the new
pods behind it.  

You're able to expose all of your pods in a unified fashion. Just push a labelled pod
to a cluster and the pod knows to expose itself to the service.  


### Fields

The "name" field on a kubelet/pod is not the name of the service.
It's the name of the "Service Object" - a kubernetes object 

The "selector" field is a label selector. It's a way to identify pods, and for pods
to identify each other. This helps the service object know which pods to expose to. 


---

## Exposing a service with an Ingress
[kubernetes docs on ingress
](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#ingress-v1beta1-extensions)  

An ingress lets you route external traffic to a service in your cluster.  
It's a way to map HTTP/S traffic to a service.  

endpoint http(s) routed to one or more *Services*.

OOS:
You can also handle network traffic externally, and expose it all as an nginx service. 



---

## Storage volumes and persistence
Storage volumes are not always HDD/SSDs

Sometimes your application environment requires persistent storage.
While the pod doesn't necessarily need to be stateful, pods also support volumes
attached to aid in persistent storage betweeen restarts.  

k8s offers many ways of providing both long-term and temp storage to your pods.
There are a lot you can choose from to provide long-term and temporary storage to your pods.  

* Ephemeral volumes -  
https://kubernetes.io/docs/concepts/storage/

## Fin.
The list of APIs and resources goes on and on. Everything is covered in the kubernetes documentation.

## Links
https://yuminlee2.medium.com/kubernetes-labels-selectors-and-annotations-2e3e931282a7
https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.31/#ingress-v1beta1-extensions
https://kubernetes.io/docs/concepts/storage/

