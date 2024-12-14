# ProLUG 101 Unit 14 - Ansible Automation


CSAA 
Ansible uses:
patching servers
setting up servers
remediating vulnerabilities
handling audit failures

Automate scanning of systems and generate reports.  

* Provisioning
    * Creating RKE2 clusters
        * RKE2 is a distribution of k8s
    * Configuring and hardening hypervisors
    

* Operations
    * Remediating CVEs
    * Distributing/removing SSH keys
    * Database and etcd backups (e.g., in S3)
        * the etcd database is a critical part of a system



Ansible is similar to infrastructure as code.  

Not often used in K8s clusters, but it is great for initial setup of clusters.  

Provisioning data centers/servers: Ansible is very useful.  
Great for day 0 or day 1 operations.  


It brings you to your desired state.  
Good for hardening, applying security settings, on bare metal servers.


Workflow
Operator -> initiate server provisioning -> Canonical MAAS -> Provisioned server (PVE
BOOT SERVER, fetch OS image and metadta, install OS and configure network) -> Ansible
automation platform (Callback to initiate ansible job, execute ansible playbook,
report job status)

---

PXE boot files (dnsmasq)
Talos node configs (matchbox)
HAProxy (can be used as load balancer)
iSCSI for talos storage
NAS media storage
TimeMachine backups

---

Ansible Runner
* Tool for consistently executing Ansible in an isolated and controlled environment
* Decouples exeuction of ansible from AAP UI and backend logic
* Easier to integrate Ansible Runner into tools other than AAP
* Standardizes how a playbook is run. 

Execution Environments
* Container images that package ansible tasks and deps (ansible version, collection, python libs)
* Removes the need for python virutal environments or installing packages onto AAP hosts
* Easier to scale and distribute workloads
* Bundle everything you need. OS, Python modules, etc
* Can spawn as many instances of the container as you want.  

---

CIS Benchmark playbooks

---
Tag tasks



## TERMS
* Ansible Execution Environments
* Ansible Runner
* Ansible Tower
* Kubernetes from Scratch
* RKE2
* MAAS - Canonical, Metal as a Service
    Treat your data servers as cloud
* PXE booting (Pixie-boot) - Preboot eXecution Environment booting
* Make (makefile) - used for compiling things, can also run arbitrary commands
* Just (justfile) - Made for running arbitrary commands.
* argo
* kubevirt
* synology-csi
* kube-prometheus-stack


https://maas.io/
https://ubuntu.com/hpc

https://www.jetify.com/devbox
https://github.com/michaelpesa/homelab-automation/tree/main
https://github.com/lablabs/ansible-role-rke2
https://github.com/michaelpesa/homelab-automation

* Ansible Runner: https://ansible.readthedocs.io/projects/runner/en/stable/index.html
* Ansible Execution Environments: https://docs.ansible.com/automation-controller/latest/html/userguide/execution_environments.html
* Stephane Maarek on Udemy (AWS certs)

OpenTelemetry
https://lttng.org/



* ArgoCD for GitOps (continuous deployment)
* kargo - Multi-stage continuous promotion with GitOps. https://kargo.io/


