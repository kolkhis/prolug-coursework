# ProLUG Automation

## Unit 6 Worksheet

## Instructions

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.


## Discussion Questions:

### Unit 6 Discussion Post 1
Your infrastructure engineering teams have been experiencing
problems re-creating environments. The main problems have been around reliably building
the exact same environment and also making those builds happen in a timely manner.

Read <https://sre.google/sre-book/release-engineering/> and
<https://sre.google/workbook/canarying-releases/> to answer the following questions.

1. What is release engineering?  

    - Release engineering is, broadly speaking, a discipline of software engineering that focuses on automated build deployments and delivery of software.  
      It's a practice with a heavy focus on the automated build and deployment of applications.  

2. What are the release engineering principles?  

    1. Reproducible Builds: The build system should be able to take the inputs and 
       produce **repeatable artifacts** (the product of the build, e.g., the compiled 
       binary of the source code).  

    2. Automated Builds: Once the code is checked in (e.g., with the `checkout` 
       action in GitHub Actions), automation should produce build artifacts to then be 
       uploaded to a storage system.  

    3. Automated Tests: Once the build system produces artifacts, automated tests 
       should be used to ensure they function as intended.  

    4. Automated Deployments: Deployments should be performed by computers, not 
       humans.  

    5. Small Deployments: Build artifacts should contain small, self-contianed 
       changes. This makes it easier to troubleshoot problematic areas of the pipeline.  

3. How do the tools we’ve discussed this week, Apptainer, Packer, Terraform, or even Ansible fit into these topics?  

    - These tools are important in release engineering for several reasons.
      They are essential in some of the release engineering principles. For
      one, Terraform allows us to enforce **reproducible builds**, as well as 
      **automated builds**.
      Apptainer and Packer also help will reproducible and automated builds.  
      All these tools contribute to automated deployments.  

### Unit 6 Discussion Post 2
Your team is trying to decide between the Apptainer and Packer
tools for container deployments. You’ve been tasked with making the decision between the
two packages. Read the following: https://developer.hashicorp.com/packer/docs/intro and
https://apptainer.org/docs/user/latest/introduction.html#why-use-apptainer

1. Can you describe Apptainer and Packer?  

    - Both of these tools are used to manage machine images.  
        - A machine image is a file that contains a pre-configured OS with installed software for use with containerization/virtualization platforms.  
    - Packer: It's considered very lightweight, highly portable, and highly performant.  
        - It stores the metadata associated with the artifacts that we build, but not the artifacts themselves.  
        - It functions around artifact **creators** and artifact **consumers**.  
    - Apptainer: It's a container platform that allows you to create and run containers that package software. Focuses on reproducibility and security by using cryptographic signatures and immutable container image formats, as well as in-memory decryption.  
        - It's primarily used for managing container machine images.  

2. How would you make the decision between the two of these tools? (You may want to make a table)  
    - What do they both do?  
        - Both are used to automate building reproducible environments.  

    - What do only one or the other do?  
        - Apptainer builds and runs containers. Packer only builds.  

    - What are the strengths and weaknesses of each?  
        - Packer:  
            - Builds VM/OS images for cloud or virtual machines.  
            - Ideal for DevOps infrastructure stuff.  
        - Apptainer:  
            - Builds and runs portable and secure containers.  
            - More for application portability and HPC workflows.  
        - See table for more (markdown table rendered on GH cuz Discord does not support tables. I did use AI to help with creating this)  

| Feature / Aspect | **Packer** | **Apptainer**
|------------------|-------------|----------------
| **Purpose** | Builds machine images. | Builds and runs containers.
| **Focus** | Infrastructure / VM templates. | HPC, science, secure app containers.
| **Output** | VM images, cloud images, Docker bases. | `.sif` container files.
| **Runs Containers?** | No. Only builds images. | Yes. Also builds them.
| **Root Required?** | Often yes (depending on builder). | No root needed to run containers.
| **Best Use Case** | Automating OS or VM image creation. | Reproducible apps on shared HPC systems.
| **Strengths** | Multi-platform image building; integrates with Terraform/CI. | Secure, portable, user-space containers; works with SLURM/MPI.
| **Weaknesses** | Not for runtime; platform-specific output. | Limited outside HPC; not a VM-image tool.
| **Portability** | Images tied to specific platforms. | One portable `.sif` works everywhere with Apptainer.
| **Learning Curve** | Moderate (builders, provisioners). | Low (simple definition files).
| **Analogy** | A factory that produces machines. | A sealed box containing an app.

3. Modify or fix the drawing to show how your team will deploy containers.


## Definitions/Terminology

- Docker Images: Machine images that are used for containerization.  
    - These are single-unit files that are bundled with an operating system and other software.

- Docker Processes

- Container/Runtime Environment: Responsible for running containerizaed
  applications.  
    - The CRE manages the lifecycle of containers by pulling container images,
      unpacking them, and running them as isolated processes on the host OS.  

- CI/CD: Continuous Integration / Continuous Delivery
    - The practice of automating the building, testing, and deployments of
      software applications.  

- Release Engineering
    - Releases
    - Code base
    - Code changes
    - Build configuration
        - Building
        - Branching
        - Testing


## Notes During Lecture/Class

### Links

- Apptainer: <https://apptainer.org/docs/user/latest/>
- Packer Tutorial Library: <https://developer.hashicorp.com/tutorials/library?product=packer&edition=open_source>
    - Packer with github actions: <https://developer.hashicorp.com/packer/tutorials/cloud-production/github-actions>
    - Provisioning: <https://developer.hashicorp.com/packer/tutorials/docker-get-started/docker-get-started-provision>
- Terraform
    - With Docker: <https://developer.hashicorp.com/terraform/tutorials/docker-get-started>


### Terms

### Useful tools


## Lab and Assignment

Unit 6 Lab from Lab book

## Digging Deeper

## Reflection Questions
1. What questions do you still have about this week?
2. How are you going to use what you’ve learned in your current role?

