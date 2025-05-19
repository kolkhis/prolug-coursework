
# ProLUG Security Engineering

## Unit 8 Worksheet

## Instructions

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.


## Discussion Questions:

### Unit 8 Discussion Post 1:
Read about configuration management here:
<https://en.wikipedia.org/wiki/Configuration_management>

* What overlap of terms and concepts do you see from this week’s meeting?
    - CM (configuration management) itself. Tracking, auditing, and controlling
      systme configuration throughout its lifecycle.  
    - System lifecycles: The article emphasizes that CM is applied from planning
      through disposal (decommissioning), which mirrors the lifecycle model we
      discussed in the meeting.  
    - Integrity: Stresses the importance of ensuring systems remain in their intended
      state, and to detect when drift has occurred.  
    - Baselines: The article talks about defining approved configurations (baselines)
      and ensuring future changes are managed against those baselines. This directly
      aligns with out focus on drift detection and remediation.  

* What are some of the standards and guidelines organizations involved with
  configuration management?  
    - ISO: International Organization for Standardization.    
        - ISO/IEC 20000 (security CM requirements)  
        - ISO 27001 (IT service management)  
    - ANSI: American National Standards Institute  
    - ANSI/EIA-649: A dedicated standard for Configuration Management principles.  
        * This one is widely referenced in enterprise and defense environments.  
    - IEEE: Institute of Electrical and Electronics Engineers  
        - IEEE 828: Standard for software configuration management plans.    

    1. Do you recognize them from other IT activities?
        - Yes. Many of these show up across tech in general.  
        - ANSI is one that stands out to me right away. ANSI escape sequences are
          supported in all terminals across the board (that I know of, anyway).  
        - ISO 27001 is a common one I've seen in documents I've found related to the security engineering course.  
            - This one is described as an "industry agnostic" standard, and is
              designed to apply to businesses of all types.  

### Unit 8 Discussion Post 2:
Review the SRE guide to treating configurations as code. Read as
much as you like, but focus down on the “Practical Advice” section:
<https://google.github.io/building-secure-and-reliable-systems/raw/ch14.html#treat_configuration_as_code>


- What are the best practices that you can use in your configuration management adherence?  
    > - Some of the best practices are:  
    >     - Version control. Have your configuration stored under version control (Git)
    >       in a repository.  
    >     - Peer review (if applicable). If your config is going to be used in a
    >       production environment, place some importance on reviewing changes made to
    >       your configuration.  
    >     - Provide actionable error messages in your CaC.  
    >     - Make sure you know where everything is coming from (provenance).  
    >         - Avoid duplicating functionality by assigning specific things to specific tasks.  
    >     - Don't check in (store) your secrets in your configuration.  
    >         - Never put the secrets into version control or embed secrets into the source code itself.  
    >         - Use a centralized secret management system instead.  
    >             - Or, use encryption in conjuction with a key management system (e.g., Cloud KMS).  
    >         - Limit access to secrets. Rule of least privilege. Only give services
    >           access if they need it to function.  
    >             - Never grant **humans** access to the secrets. If a human needs access, create dedicated credentials for them to use instead.  
    >     - Create clear, unambiguous policies that apply to particular
    >       builds/deployments.  


- What are the security threats and how can you mitigate them?
    > - An old version of code is deployed with known vulnerabilities. Mitigate by
    >   setting the deployment policy to require the code to have undergone a
    >   vulnerbility scan within a set number of days.  

    > - The Continuous Integration (CI) system is misconfigured to allow requests to build from any
    >   source repository (untrusted/misconfigured/malicious). Mitigate by having
    >   the CI generate binary provenance (the source of truth for its repository)
    >   and repository verification before deployment.  

    > - An attacker uploads a malicious build script to the Continuous Integration (CI) 
    >   system that allows them to exfiltrate the signing key, allowing them to
    >   hijack the pipeline.  Mitigate by using signed configs. Tightly control
    >   access to CI systems and validate script integrity at runtime (e.g., with
    >   checksums).  

    - Why might it be good to know this as you design a CMDB or CI/CD pipeline?
    
        > - Understanding these threats and best practices is important when building
        >   systems in general. 
        > - If you treat config as a first-class asset (just as important as the
        >   code), tracking it in the CMDB (as a configuration item, yet another CI
        >   acronym) will give you traceability and accountability for changess.  
        > - In CI/CD pipelines, config becomes code, so all the rules of secure
        >   software engineering apply to the config as well.  
        > - If your CMDB tracks baselines and state, and your CI/CD system can
        >   enforce and remediate drift, then you have a closed-loop system for
        >   managing infrstructure safely *and* predictably.  
        >       - Closed-loop meaning it can self-correct or self-enforce its
        >         intended state based on realtime observations.  

## Definitions/Terminology

- System Lifecycle: The full journey of a system from its initial build, through
  operation and maintenance, to decommissioning.  
  Lifecycle phases:  
    1. Planning
    2. Provisioning/building
    3. Configuration and hardening
    4. Monitoring and patching
    5. Decommissioning
  Knowing where we are in the system lifecycle can help us track which changes are
  authorized changes, and which changes classify as drift.  

- Configuration Drift: When a system's actual state diverges from its intended or
  documented state over time.  
    - Drift happens for a number of reasons. 
        - Teams make changes to fix systems
            - e.g., version changes for compatibility  
        - Teams make changes for user requests
            - e.g., environment customization  
        - Teams make changes for security patches
            - e.g., fixing CVEs or STIG'ing  
    - Drift can lead to security vulnerabilities, compliance issues, and
      unpredictable behavior.  

    - Configuration drift means that we may be falling out of security 
      compliance, may not be able to work on the system as effectively, may turn on/off a 
      service across the environment but may not work because a different version was 
      installed on the system.  


- Change management activities: Used to track, approve, and document changes to
  infrastructure.  
    - CMDB: Configuration Management Database. Stores information about IT assets,
      their configurations ,and their relationships.
        - Used to track what exists, where it is, and how it's configured.
    - CI: Configuration Item. An entry in the CMDB.  
        - Hardware software, docs, or other componenet that needs to be managed.
        - Can be a server, service, application, network device, etc.  
        - Each CI has its own metadata (name, owner, version, deps, etc).  
    - Baseline: A set of CIs that have been formally agreed upon and serve as a basis
      for future changes.  
        - These are the approved, expected configurations of a system at a point in time.  
        - Used as a reference to detect drift or unauthorized changes.  


- Build book: A document or script (or other piece of automation) that defines how to
  build a system from scratch.  
    - Includes OS install steps, package lists, initial config, user accounts, etc.  
    - Build books are updated whenever operation admin teams make changes.  

- Run book: Run books (or runtime books) are a set of standard operating procedures
  (SOPs) for handling known tasks or incidents.  
    - E.g., "how to restart the web server" or "steps to recover from a failed patch".  
    - Often used by on-call responders or junior engineers.  


- Hashing: Calculating a hash based on the contents of a file. Used to verify file integrity.  
  Used for making sure a file has the correct contents without having to manually
  inspect the file itself.  
    - `md5sum`: Prints a 128-bit hash.  
        - This is fast, but no longer considered secure to to collision
          vulnerabilities.  
    - `sha<x>sum`: Print out SHA-family hashes using different numbers of bits (varying lengths).  
        - There are a number of different choices to use here.  
            - `sha1sum`: Print 160-bit checksums.  
                - Deprecated.  
            - `sha224sum`: Print 224-bit checksums
            - `sha256sum`: Print 256-bit checksums
                - This one is common. It's a secure default.  
            - `sha384sum`: Print 384-bit checksums
                - Higher bit version, more secure.  
            - `sha512sum`: Print 512-bit checksums
                - Highest bit version, stronger integrity.  

- IaC: Infrastrucure as Code. The practice of defining infrastructure (servers,
  services, networks) in code rather than manual steps.  
    - Enables version control, repeatability, and automated builds.  
    - IaC can be done with dedicated tools like Terraform, Ansible, and CloudFormation.  

- Orchestration: The coordination of multiple systems or services to achieve a goal. 
    - Goes beyond automation by managin dependencies, timing, and multi-host
      operations.  
    - E.g., Using Kubernetes, a container orchestration tool, to manage multiple systems.  

- Automation: The use of tools (scripts, playbooks, etc) to replace manual tasks.  
    - Can be used for provisioning, patching, configuration, or enforcement.  
    - Often powered by tools like Ansible, Bash, Puppet, Chef, Terraform, etc.  

- AIDE: Advanced Intrusion Detection Environment.  
    - It checks the integrity of the files by hashing all of the files, and then keeping 
      a database of all the hashes for those files.  
    - By default, AIDE runs daily at 03:14 on Linux systems (since the run script is
      in `/etc/cron.daily`).  
    - It comes with 213 config files by default for different programs and their
      configuration files. More can be added as needed.  
    - AIDE initially generates a new database (needs to be renamed) that contains all
      the hashes of the files it is tracking on the system. Then, on its daily run,
      it verifies that the current hashes of those files are the same as the ones it
      its databse. If there's any change (added files, modified files, deleted
      files), AIDE will catch that.  


## Notes During Lecture/Class:

### Links:
<https://google.github.io/building-secure-and-reliable-systems/raw/ch14.html#practical_advice>
- https://google.github.io/building-secure-and-reliable-systems/raw/ch14.html#treat_configuration_as_code
- https://en.wikipedia.org/wiki/Configuration_management
- https://www.sans.org/information-security-policy/
- https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/

### Terms:

### Useful tools:
- STIG Viewer 2.18
- Ansible
- Killercoda

### Lab and Assignment
Unit8-Configuration-drift-remediation - To be completed outside of lecture time.

## Digging Deeper

1. Review more of the SRE books from Google: <https://sre.google/books/> to try to find 
   more useful change management practices and policies.


## Reflection Questions

1. How does the idea of control play into configuration management? Why is it so
important?

2. What questions do you still have about this week?

3. How are you going to use what you’ve learned in your current role?

