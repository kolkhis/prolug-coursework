# ProLUG 101
## Unit 9 Worksheet
## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to send to me at the end of the course.

## Discussion Questions:

### Unit 9 Discussion Post 1
It’s a slow day in the NOC and you have heard that a new system of container deployments are being used by your developers. Do some reading about containers, docker, and podman.
1.	What resources helped you answer this?

https://www.redhat.com/en/topics/containers
https://www.redhat.com/en/topics/containers/what-is-container-orchestration
https://www.veritas.com/blogs/the-10-biggest-challenges-of-deploying-containers
ChatGPT 

2.	What did you learn about that you didn’t know before?

Containers use the same OS kernel, but isolate the application from the rest of the system.
This makes the app portable and easier to deploy in different environments.  

All the tools/container engines used to deploy containers are based on open source technologies:
* Podman
* Skopeo
* Buildah
* CRI-O
* Kubernetes
* Docker

Some terms that I wasn't 100% familiar with:
* Control Plane: Where all task assignments originate. 
    * The control plane is a collection of processes that control k8s nodes. 
    * The control plane is the main component of Kubernetes that runs the API server, scheduler, and controller manager.
        * The API server takes requests from users or other systems and tells the rest of the control plane what to do.
        * The scheduler decides which nodes should run new containers based on the resources available. 
        * The controller manager ensures the system's state matches what you want.
          
* Cluster: A control plane and one or more nodes that run containers.  
* Node: A single machine (physical or virtual) that runs containers and is part of a Kubernetes cluster.  
* Pod: A group of one or more containers that are deployed on a single node.  
    * All containers in a pod share the same network stack (IP address, hostname, etc.) and can all communicate with each other
* Kubelet: The agent that runs on each node and manages the running pods.
    * Kubelet reads the container manifests and keeps the containers running.  
* Volume: A way to store data outside of a container's lifecycle.  
    * Volumes help persist data, even if a container is restarted/redeployed or deleted.  


3.	What seems to be the major benefit of containers?

The major benefit of containers seems to be how easy they are to deploy and manage, and giving all users identical environments in which they can work.
Being able to deploy containers quickly and give users access to the exact environment makes it easier to make sure that the services that are running aren't subject to any issues regarding different runtime environments.  
Another major benefit is the scalability of containers, especially with Kubernetes. Automatically adjusting the number of containers based on the load of the system is a great way to avoid any issues that might arise from having to manually scale the system.  

4.	What seems to be some obstacles to container deployment?

One obstacle to container deployment could be the initial setup of container environments for the users. The images that the users are deploying containers with need to be secure, and pulling them down from the web presents its own security risks. 
Making hardened images that are only pulled from a secure, internal location would be a way around that particular issue.  
Another obstacle could be the fact that users of the containers might change around the configurations and break things.  
Another obstacle could be managing data between containers. Since containers are generally stateless by design, we'd need to use volumes, networked storage, or container storage interfaces (CSI) to manage data between containers. This adds another layer of complexity on top of container deployment.







### Unit 9 Discussion Post 2
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
The container that the engineer is trying to move up to the dev environment is using port `8080` as its port, but that port is already being used by `node_exporter` on the shared server he's trying to push it up to.  

a.	How will you test this?
I'd ask the developer to try changing the configuration of his container to run using a different port, one that is not currently being used on the shared server.
```bash
podman run -dt -p 8089:80/tcp docker.io/library/httpd
```


2.	The developer tells you that he’s pulling a local image, do you find this to be true, or is something else happening in their run command?

The image he's pulling is very clearly a Python image coming from `docker.io/library/python`, which is not local to his system. He's pulling the image from the Docker Hub repository (`docker.io`). 
I'd ask him if he's *supposed* to be pulling a local image, and if so, try finding the image and using that instead



## Definitions/Terminology
* Container: A standard unit of software that packages up code and its dependencies
  so that the application can run quickly and reliably in any environment.  
    * Standard, lightweight, and secure.  
    * Very useful for giving every user the same exact environment to work in.  
    * What used to be called "jailed users" or "jailed environments" are now called containers.  
    * Always grabbing the latest image for a container is usually a bad practice.  
* Docker: Docker is a runtime engine for containers.  
    * Building a container with docker: `Dockerfile -> Docker Image -> Docker Container`
* Podman: A container engine that uses OCI (Open Container Initiative) standards.
    * Used as an alternative to Docker.   
    * `podman --version`  
    * `which podman`  
* CI/CD: Continuous Integration/Continuous Deployment (or Delivery)
    * This is a development practice that requires devs to integrate their code into a shared repository, usually using a CI/CD pipeline. 
* Dev/Prod Environments (Development/Production Environments): Environments in which code is deployed.  
    * Development environments: Where code is developed and tested, where changes can be made
      and things can be broken without suffering downtime in production.  
    * Production environments: This is where code is deployed for actual end-users to use. If things here are broken, the company suffers downtime and loses money. Not for testing stuff.  
* Dockerfile: A configuration file for building a Docker image.  
* Docker/Podman images: Packages of software that include everything needed to run 
  an application in a container.
* Repository: A place where you can store Docker images.  
    * DockerHub: The largest and most popular repository of Docker images. Hosts
      millions of images, from official images to custom user-uploaded images.  
        * This is the go-to for most private users.  
    * RedHat Quay (quay.io): A popular registry with high security and enterprise features.
    * Docker Trusted Registry: A private repo of Docker images.
    * Google Container Registry (GCR): Google Cloud's container registry service.
      Usually used in Google Cloud Platform (GCP) environments.  
    * Amazon Elastic Container Registry (ECR): AWS's container registry service.
      Built for integration with Amazon's cloud services.   
    * Azure Container Registry (ACR): Microsoft's container registry service.
      Optimized for Azure cloud environments.  
    * GitHub Container Registry (GHCR): Allows users to store and manage Docker
      images alongside GitHub repositories.  
    * Harbor: An open-source cloud-native registry that can be self-hosted. Designed
      for enterprise users and orgs that need high security and control.  
    


## Notes During Lecture/Class:
### Links:

### Terms:
* Kubernetes: A container orchestration tool. Used to manage containerized
  applications. Sometimes called "k8s".  
    * Schedules and runs containers
        * Automatically decides which machines (nodes) will run each container to
          optimize resource usage across a cluster of nodes. Then makes sure the
          containers stay up and running as intended.  
    * Solves all the IP addressing and software-defined networking problems.
    * Manages scaling and load balancing  
        * K8s can automatically add or remove containers based on demand.
        * If traffic increases, it can spin up more instances. If traffic decreases, it
          scales down to save resources.  
    * Handles failures and restarts
        * If a container crashes, kubernetes will automatically restart that container, or 
          move it to another machine.  
        * If you killed off a containerized application without using Kubernetes, you'd
          have to manually restart it. 

* k3s: A lightweight, simplified version of Kubernetes.  
    * Designed for easier deployment and lower resource consumption.  
    * Has a smaller footprint, using fewer resources (CPU/Memory) than k8s.  
    * Optimized for edge and dev environments.
    * Fully compatible with Kubernetes. You can use k3s in smaller environments and
      scale up to full Kubernetes later, with minimal adjustments, if you need to.  
* Port conflits: Services on a system cannot share ports. The first service to start on a port will "win".


Why care about containers as System Administrators?
* We're responsible for installing the runtime environment on the servers.
    * Docker, Podman, Cri-o and other container engines 
* We're responsible for troubleshooting the runtime environment
    * What does execution look like when it's working correctly?
    * Ports need to be available on our local machine
* System security ultimately falls on us (ALWAYS)
    * Where are they pulling these random containers from?
        * Out in the world? This is generally unacceptable.  
        * CI/CD Pipelines? 


### Useful tools:
```bash
podman run -dt -p 8080:80/tcp docker.io/library/httpd # Run Apache webserver in a container on port 8080 of the host
podman --version
dnf whatprovides podman
which podman
podman ps
podman images  # Show images available
podman top -l  # Show the running processes inside the latest container
podman logs -l # Show the logs from the latest container
# Start a pod on local port 8080, and port 80 internal to the container
podman ps # Get the funky name of the container
podman inspect -l # Display configuration of the container
podman attach -l  # Attach to the most recently started container
podman exec -it mycontainer bash  # Start a new bash shell inside the container and attach to it
podman stop mycontainer # Stop a container by name or ID
podman build -t mycontainer:tag . # Build a container image from the Dockerfile in the current directory
```

The `-l` (`--latest`) option for a lot of these commands is a shortcut for the last 
container that was made, used in place of a container name or ID.  

---

Images will still be there when you stop containers.
They will stay until you delete it.  

---

* `podman inspect -l`: Displays information about the container.  
    * Container, image, volume, network, and/or configuration
    * The output is JSON.  
    * `-l`: Shows the last created container. Used in place of a container name.  
* `podman top -l`: Display running processes inside of the container.  
    * `-l`: Shows the last created container. Used in place of a container name.  
* `podman exec -it mycontainer bash`: Attach to a container with a bash shell.
    * `-i`: Make it interactive. Enables keyboard input.
    * `-t`: Allocate a pseudo-TTY. Enables terminal output.  
    * `bash`: The process to run.  

* `podman run`
    ```bash
    podman run -d \
        --name coolname \
        --network host -e \
        -e DB_PORT=5432 \
        -p 8080:3000 \
        requarks/wiki
    ```
    * `-d`: Run the container in the background. (detached mode)
    * `--name`: Name the container
    * `-e DB_PORT=5432`: Set an environment variable.  
    * `-p 8080:3000`: Forward port `8080` on the host to port `3000` inside the container.  
    * `requarks/wiki`: The image to run.  

---



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


a.	What worked well?

Pulling the images from `docker.io` worked well. I found that I could specify just
the image name and it let me select the registry it would pull from (red hat access
registries or docker.io).  
I was able to get it running in the end! 

b.	What did you have to troubleshoot?

Environment varaibles and container networking... Mainly container networking.  
When trying to exec into the wikijs container to test database connectivity, it wasn't running.
The wikijs container was not under `podman ps`.  
I used `podman ps -a` and saw that it exited.  
`podman logs wikijs` shows that there's a database connection error.  
I thought it could use podman's default network, but I guess it didn't want to.  
I needed to set up a network for the two containers to connect, so I used 
`podman network create wikinet` to create a network and specified `--network wikinet`
in each of the `podman run` commands for the containers.  

```bash
podman rm -f wikijs postgres-wiki
podman network create wikinet
podman run -d --name postgres-wiki --network wikinet -e POSTGRES_USER=wikijs -e POSTGRES_PASSWORD=wikijsrocks -e POSTGRES_DB=wiki postgres
podman run -d --name wikijs --network wikinet -e DB_TYPE=postgres -e DB_HOST=postgres-wiki -e DB_PORT=5432 -e DB_USER=wikijs -e DB_PASS=wikijsrocks -e DB_NAME=wiki -p 8080:3000 requarks/wiki
```
Making the network `wikinet` solved the networking issue, and all of the `-e` options
set the environment variables that I needed to set.  
Writing them down in a script helped. It's a lot to type.  

After the fact, I realized that I could have written Dockerfiles for each of these,
to build images that have all the environment variables and network set.  


c.	What documentation can you make to be able to do this faster next time?

Well, now I can make a wiki page detailing how to set it up and troubleshoot.  
But you'd need to have it running before being able to access it... 

Kidding, I can note the commands I ran to get it running, and the errors that I ran
into when trying to get it running, as well as how to fix them.  


## Reflection Questions
1.	What questions do you still have about this week?

How often does someone need to manually create a podman network in a professional role?
Are there companies that use container technology but don't rely on k8s or similar tools?



2.	How can you apply this now in your current role in IT? If you’re not in IT, how can you look to put something like this into your resume or portfolio?

I'm definitely going to use this in my homelab. I'm hoping to get some experience deploying out cool services that give skills that I can put into my resume.  

 
