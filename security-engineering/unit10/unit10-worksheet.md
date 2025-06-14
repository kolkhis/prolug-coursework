# ProLUG Security Engineering  
## Unit 10 Worksheet  

## Instructions  
Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until  
the end to turn them in as a final submission packet.  

## Discussion Questions:  

### Unit 10 Discussion Post 1  
Capture all the terms and concepts that we talk about in this  
week’s recording.  

1. How many new topics or concepts do you have to go read about now?  
    - So many.
      ```bash  
      ┎ kolkhis@homelab:~/.../security-engineering/unit10 (main)  
      ┖ $ wc -l ./notes.md  
      549 ./notes.md  
      ```

2. What was completely new to you?  
    - Envelope encryption. 
      Envelope encryption is the practice of encrypting plaintext with a data key.  
      The data key is further encrypted under another key. Then you can encrypt the  
      encrypted data key that is encrypted under another key with another key. Then  
      you can encrypt that encryption key under another encryption key. Inception in  
      a nutshell.  
    - Canary. A box that's out of the way whos only purpose is to notify an admin when 
      scanned, used for security.  
    - Software escrow. When you do work for a company and the word you do is built in  
      a software escrow. The software escrow will then stay with the company,
      regardless of whether or not you do.  
    - DNS Sec  
    - A lot of Risk Management terminology and concepts. For instance, risk tolerance  
      and risk appetite. Risk tolerance is how much risk you can carry before taking  
      action (e.g., transferring risk, mititgating risk, etc).  
    - A bunch of other terms that I still need to look up.  

3. What is something you heard before, but need to spend more time with?  
    - TLS  
    - Certificates  
    - Zero-Trust Architecture (ZTA)  
    - Identity and Access Management (IAM)  
    - Simple communication model  
        - Sender  
        - Receiver  
        - Message  
        - Medium  
        - Noise  
    - Deception and Disruption Technology  
        - Honeypots  
        - Honeynets  
        - Honeyfiles  
        - Honeytokens  
    - Networking  
    - Patching systems  


### Unit 10 Discussion Post 2
Proof of Skills from this course.  

1. Think about how the course objectives apply to the things you’ve worked on.  

    * How would you answer if I asked you for a quick rundown of how you would  
      secure a Linux system?  

        > - I would start with access points. SSH being chief among them. I'd start by
        >   locking down SSH to minimum security standards (e.g., no root via SSH,
        >   public key authentication).  

        > - I'd then go over to STIGs. I'd start with the STIGs for the operating
        >   system that the machine is running. Then I'd identify services that are
        >   being hosted on that host and STIG those services as well.  

    * How would you answer if I asked you why you are a good fit as a security  
      engineer in my company?  

        > - I would say that I can objectively analyze the security posture of your
        >  company with fresh eyes, as well as suggest and implement improvements to
        >  the overall security procedures implemented at the company.  

    * Think about what security concepts you think bear the most weight as you 
      put these course objectives onto your resume.  

        > * Which would you include?  
        >     - Build standards and compliance (Implementing STIGs)  
        >     - Bastion Hosts and Air-gapping a network  
        >     - Auditing (Monitoring and Parsing Logs)  
        >     - Alerting  
        >     - Configuration drift and remediation  
        >     - Patching systems  
        >     - Key management (SSH keys)  

        > * Which don’t you feel comfortable including?  
        >     - Certificate management (TLS). I need to spend more time with this.  
        >     - Network security. If it's just STIGs, that's one thing, but if it's
        >       anything beyond that, I still need more practice. In particular, I need
        >       to learn how to use `tcpdump` effectively, as well as Wireshark and
        >       other packet inspection and network troubleshooting tools.  


## Definitions/Terminology  

Capture from this week lesson or recording  

* Security mindset: Constantly thinking about how systems can fail, where leaks could happen, where someone 
  could put pressure on a system, where vulnerabilities exist, and thinking about how to prevent something from  
  being an attack vector. 
    - This is a more defensive and risk-aware perspective.  

* Hacker mindset: Constantly thinking about potential attack vectors -- how you could 
  get into a system, what you could exploit, how you could exfiltrate information from 
  a person or system.  
    - How you can subvert systems, find unintended behaviors, and exploit weaknesses.  
    - A hacker mindset is probably needed with red teaming or penetration testing.  
    - This is a more creative and adversarial perspective.  


- Simple communication model  
    - Sender: The originator of the message  
    - receiver: The intended destination of the message  
    - message: The content being communicated  
    - medium: The channel used (e.g., email, network, radio)  
    - noise: Anything that disrupts or alters the message in transit (interference, packet loss, adversaries).  

- Cypher-based tunnel: A secure, encrypted channel created using cryptographic  
  ciphers.  
    - Common in VPNs, SSH tunnels, and TLS connections.  
    - Ensures confidentiality, integrity, and sometimes authentication.  

- coddywomple: March like you have confidence in where you're going, but you don't know where you're going.  
    - "To travel purposefully toward an as-yet-unknown destination."  


- Non-repudiation: Guarantees that a sender cannot deny having sent a message  
    - Achieved through cryptographic signing and logging.  
    - Often part of legal/compliance controls.  

- Gap analysis: A method of identifying the differences between current state and desired state.  

- Deception and Disruption Technology  
    - Honeypot  
    - honeynet  
    - honeyfile  
    - honeytoken  

- Authentication, Authorization, and Accounting (AAA)  

- Tapper Monitor 

- GWLB: Gateway Load Balancer  

- Segmentation  

- SBOM - Software bill of materials  

- Decommissioning  

- NIST 800-145 (Risk Management)  

* `ngrep`

- 802.1X  
- Extensible authentication  
- Web filters  
    - Agent-based  
    - Centralized proxy  
    - Universal Resource Locator (URL) scanning  
    - Content categorization  
    - Block rules  
    - Reputation  

* An attack surface is a collection of open ports and addresses.  

- DNS SEC  

- Shibboleth (Auth tool)  

- Privileged access management tools  
    - JIT permissions (Just in time)  
    - Password vaulting  
        - Common in root passwords  
    - Ephemeral credentials  

* Endpoint detection and response (EDR)  
* Extended detection and response (XDR)  

- DAST/SAST: Dynamic and statis application statistic checking  
- Simple Network Managment Protocol (SNMP) traps  
- Data loss prevention (DLP)  

- DAST: Dynamic application security testing  

- Canary: A box that's out of the way that will notify when scanned. 
    - e.g., it recieves a ping or something -- any kind of connection -- and notifies the admin.  
    - Can be made to look like different things (windows servers, file servers, etc).  

- IDS/IPS  
    - Signatures  
        - Attack looks like another one that's been happening  
    - Trends  
        - Statistical analysis/heurystical (things a human can't do) analysis  

- Extensible authentication  

- TCP half-open embryonic connections  

- Rolling back kernels is always a reboot  

- RACI chart: Who needs to be in the room.  
    1. Responsible  
    2. Accountable  
    3. Consulted  
    4. Informed  

* Software Escrow: doing some work for a company, they say 'we hope u exist 4evr, but just  
  in case we'll keep the software u build in a software escrow, if u go away we will  
  get that software escraow and it'll be ours forever'  

- Key Escrow  

- Key Stretching  

- Data States  
    - Data at Rest: Must always be encrypted with *at least* AES 256-bit encryption (the minimum cloud standard).  
    - Data in Use: Should be obfuscated  
    - Data in Motion: Should always be moved with TLS  

- Cryptographic Erasure  

- Key Management Systems (KMS)  

- Trusted Platform Module (TPM)  
- Hardware Security Module (HSM)  

- Data obfuscation  
    - Stenography (Hiding data in imgs)  
    - Tokenization (hiding data in a token)  
    - Masking (Hiding in???)  


* Exposure Factor  

- SDLC - Software development lifecycle  
    - Waterfall  
    - Agile  

* SASE: Secure Access Surface Edge  

## Notes During Lecture/Class:  

### Links:  

-  
### Terms:  

Useful tools:  
-  

Lab and Assignment  
No lab for Unit 10, work on your project.  
