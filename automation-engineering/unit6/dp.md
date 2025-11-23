# Unit 6 Discussion Posts

### Unit 6 Discussion Post 1

Your infrastructure engineering teams have been experiencing problems re-creating environments.  

The main problems have been around reliably building the exact same environment 
and also making those builds happen in a timely manner.  

Read to answer the following questions: 
- <https://sre.google/sre-book/release-engineering/>
- <https://sre.google/workbook/canarying-releases/> 


1. What is release engineering?  

    - Release engineering is, broadly speaking, a discipline of software engineering that focuses on automated build deployments and delivery of software.  

2. What are the release engineering principles?  

    1. Reproducible Builds: The build system should be able to take the inputs and produce **repeatable artifacts** (the product of the build, e.g., the compiled binary of the source code).  
    2. Automated Builds: Once the code is checked in (e.g., with the `checkout` action in GitHub Actions), automation should produce build artifacts to then be uploaded to a storage system.  
    3. Automated Tests: Once the build system produces artifacts, automated tests should be used to ensure they function as intended.  
    4. Automated Deployments: Deployments should be performed by computers, not humans.  
    5. Small Deployments: Build artifacts should contain small, self-contianed changes. This makes it easier to troubleshoot problematic areas of the pipeline.  

3. How do the tools we’ve discussed this week, Apptainer, Packer, Terraform, or even Ansible fit into these topics?  

    - These tools are important in release engineering for several reasons.
      They are essential in some of the release engineering principles. For
      one, Terraform allows us to enforce **reproducible builds**, as well as **automated builds**.
      Apptainer and Packer also help will reproducible and automated builds.  
      All these tools contribute to automated deployments.  



### Unit 6 Discussion Post 2
Your team is trying to decide between the Apptainer and Packer tools for container deployments. You’ve been tasked with making the decision between the two packages. Read the following:

- <https://developer.hashicorp.com/packer/docs/intro> 
- <https://apptainer.org/docs/user/latest/introduction.html#why-use-apptainer> 

1. Can you describe apptainer and packer?  

2. How would you make the decision between the two of these tools? (You may want to make a table)  

    - What do they both do?  

    - What do only one or the other do?  

    - What are the strengths and weaknesses of each?  

3. Modify or fix the drawing to show how your team will deploy containers.  


<img src="https://media.discordapp.net/attachments/1434694216599994519/1434694216847720468/image.png?ex=690f315c&is=690ddfdc&hm=4f699f109b4c82a04cde74e671cb56d6f17941894faaff26907af846adab8dd1&=&format=webp&quality=lossless" />
