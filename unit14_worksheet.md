# ProLUG 101
## Unit 14 Worksheet
## Instructions
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to
send to me at the end of the course.


## Discussion Questions:

### Unit 14 Discussion Post 1
Refer to your Unit 5 scan of the systems.
You know that Ansible is a tool that you want to maintain in the environment.

Review this online documentation:
https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html

1. Make an inventory of the servers, grouped any way you like.

```ini
[rocky_boxes]
192.168.200.[50:69]

[]

```

2. What format did you choose to use for your inventory?

3. What other things might you include later in your inventory to make it more useful?


### Unit 14 Discussion Post 2
You have been noticing drift on your server configurations, so you want a way to 
generate a report on them every day to validate the configurations are the same.

Use any lab in here to find ideas: 
https://killercoda.com/het-tanis/course/Ansible-Labs 

Use this webhook to send your relevant data out to our sandbox.
https://discord.com/api/webhooks/1317659221604433951/uyKpuq8fNNNSEyCra4n33PakIBk-XtTn1WrwTpHs9BcgkIu7URPV_Gd5HJCRX0_EJVUT


### Unit 14 Discussion Post 3
Using ansible module for git, pull down this repo:
https://github.com/het-tanis/HPC_Deploy.git
1. How is the repo setup?
2. What is in the roles directory?
3. How are these playbooks called, and how do roles differ from tasks?

## Definitions/Terminology
- Automation: The act of taking a repetitive task and writing instructions to repeat it automatically, to reduce the need for manual intervention.

- Consistency: The ability to perform the same task or set of instructions across multiple systems without any variation. 

- Dev/Ops: Development/Operations. The point between software development and
  operations teams, streamlining software development, deployment, and maintenance.  
    * It's a methodology which integrates and automates the work of software development.
    * Specifically, on the operations side where environments are set up, configured, and deployed.  

- Timelines: A period of time that you have to complete a task.  
    * Performing tasks or updates quickly and reliably, to ensure systems remain
      current and secure.

- Git: A version control tool, the most popular one.
    * It's used to track changes in files and directories, stores all changes and
      previous versions of the files so that you can roll back if you need to.  

- Repository: A centralized storage location where you store a version-controlled project.  
    * Repositories can be local or remote.  
    * Remote repositories are hosted on cloud platforms (e.g., GitHub, GitLab).  

- Ad-hoc: One-liners executed directly, without running a whole playbook.  
    * Used for quick, one time tasks like checking uptime or restarting services.  

- Playbook: A `yaml` file that contains a set of instructions for Ansible.  
    * Made up of a series of tasks, and optionally roles.  

- Task: A single set of instructions within a playbook. Uses an ansible module with arguments to achieve a specific outcome.  

- Role: A reusable/modular way to organize playbooks, tasks, variables, and templates in Ansible.  
    * A role can be included in any playbook, and that playbook will inherit
      everything inside of the role.  
    * A role has a directory structure to separate all of its components.  
    * E.g., Create a role with `ansible-galaxy init my_role` and it will
      generate a new directory with these subdirectories:
        * `tasks/`: Where you define the main tasks for the role.  
        * `handlers/`: Define handlers that are triggered with `notify` in `tasks`.  
        * `templates/`: Store `Jinja2` templates for dynamically generating files.  
        * `files/`: Store static files that can be copied to remote hosts.  
        * `vars/`: Define variables that are specific to the role.  
        * `defaults/`: Define default values for variables (these have the lowest precedence).  
        * `meta/`: Include metadata about the role, like depenencies.  

- SSH (Secure SHell): A protocol used to securely log in with a shell to a remote system.   
    * Ansible relies on SSH to connect to Linux/Unix systems. 

- WinRM (Windows Remote Management): A protocol used to manage and communicate with Windows systems remotely.  
    * Ansible uses WinRM for accessing Windows machines.  




## Notes During Lecture/Class:
### Links:
* https://maas.io/
* https://ubuntu.com/hpc
* https://www.jetify.com/devbox
* https://github.com/michaelpesa/homelab-automation/tree/main
* https://github.com/lablabs/ansible-role-rke2
* https://github.com/michaelpesa/homelab-automation
* https://lttng.org/
* Ansible Runner: https://ansible.readthedocs.io/projects/runner/en/stable/index.html
* Ansible Execution Environments: https://docs.ansible.com/automation-controller/latest/html/userguide/execution_environments.html

### Terms:

* OpenTelemetry
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

### Useful tools:

- Spyder ide


* Ansible Runner
    * Tool for consistently executing Ansible in an isolated and controlled environment
    * Decouples exeuction of ansible from AAP UI and backend logic
    * Easier to integrate Ansible Runner into tools other than AAP
    * Standardizes how a playbook is run. 

* Ansible Execution Environments
    * Container images that package ansible tasks and deps (ansible version, collection, python libs)
    * Removes the need for python virutal environments or installing packages onto AAP hosts
    * Easier to scale and distribute workloads
    * Bundle everything you need. OS, Python modules, etc
    * Can spawn as many instances of the container as you want.  

* ArgoCD for GitOps (continuous deployment)
* kargo - Multi-stage continuous promotion with GitOps. https://kargo.io/

---

* `dnsmasq`: PXE boot files 
* `matchbox`: Talos node configs 
* `HAProxy` (can be used as load balancer)
* `iSCSI` for talos storage
* NAS media storage
* `TimeMachine` backups

## Lab and Assignment
Unit 14 Lab Automation
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


## Digging Deeper (optional)
1. I have a large amount of labs to get you started on your Ansible Journey (all free):
https://killercoda.com/het-tanis/course/Ansible-Labs

2. Find projects from our channel Ansible-Code, in Discord and find something that is interesting to you.

3. Use Ansible to access secrets from Hashicorp Vault: https://killercoda.com/het-tanis/course/Hashicorp-Labs/004-vault-read-secrets-ansible

## Reflection Questions
1. What questions do you still have about this week?

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you look to put something like this into your resume or portfolio?


