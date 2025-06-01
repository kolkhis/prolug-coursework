# Notes for Unit 10


Terms and concepts that are new
* Security mindset - constantly think about where leaks could happen, where someone
    could push on a system
* Hacker mindset - constantly think about potential attack vectors -- how you could get into a system

---

How do we manage keys?

* One post and one response 
    - key management and topics
    - TLS encryption and operation

---
Journaling of all these topics

Goal: Never to align to any one security standard.  
Rather balance theory vs application in a Linux enterprise environment.  
Topics covered are in Security+.  
Also Look at: ISC2 Certs

---

Do these things and understand WHY you're doing them.  

---

No default password should exist on a system.  

---


CIA
STIGs
Controls - Technical Controls

EEngineers are engineers regardless of the tools used or the outcomes sought.  
---


Risk analysis:
Probability should be represented between 0.00 and 1.00
Can also be percentages.  

---


- Rolling back kernels is always a reboot


---

If you don't have a goood inventory, you don't have anything. 

- Simple Network Managment Protocol (SNMP) traps (not used very much any more)
- you will never use SNMP v1, v2. maybe v2C and v3

---

- Sometimes you need to fix the system, sometimes you need to fix the user.  

* 3 weeks planning
* 3 weeks running pentest
* 3 weeks reporting

---

What is identity?
Digital representation of person/device/app allows authorized access to a
system/network/etc.  

  CAC Cards
  Yubikeys

  Retina
  Fingerprint
  Iris

  Passwords
  Pins 
  Historical facts (challenge questions)

---

## envelope encryption
The practice of encrypting plaintext with a data key. Encrypt the data key under
another key. Even encrypt the data encryption key under another encryption key, and
encrypt that encryption key under another encryption key.  

`KMS key --encrypts-> Data key --encrypts-> Data`
- Cryptographic Erasure

---


* Security mindset - constantly think about where leaks could happen, where someone
    could push on a system
* Hacker mindset - constantly think about potential attack vectors -- how you could get into a system


- Simple communication model
    - Sender
    - receiver
    - message
    - medium
    - noise

- Cypher-based tunnel

- coddywomple: March like you have confidence in where you're going, but you don't know where you're going.  

- Non-repudiation

- Gap analysis

- Deception and Disruption Technology
    - Honeypot
    - honeynet
    - honeyfile
    - honeytoken

- Zero trust

- Authentication, Authorization, and Accounting (AAA)

- Segmentation

- SBOM - Software bill of materials

- Rule of Least Privilege

- Configuration Enforcement
    - Can't have until CIs 

- Decommissioning

- Data protection
    - Data types
        - Regulated
        - trade secr4et
        * Intellecual property
        * Legal info
        * Financial info
    - Data classifications
        - Sensitive
        * Confidential
        * Public
        * Restiricted
        * Private
        * Critial
    - General data considerations
        - Data state
            - data at rest : Always be AES256 (Minimum cloud standard)
            - data in transit : Always be moved with TLS
            - data in use : Shold be obfuscated
        - Data sovereignty: Huge.
        - Geolocation: Performance and security
    - Methods to secure data
        - Geographic restrictions
        - Encryption
        - Hashing
        - Masking (hide some of the bits)
        - Tokenization (Tokenize smth, all users from one database have a certain token)
        - Obfuscation: 
            Any number of fields of the data should not be able to be mapped to each other
        - Segmentation
        - Permission restrictions

* Security Governance
    - Guidelines: High level
    - Policies: High level -- goes down into procedures
        - High level wrappers around behavior
    - Procedures: Interactive step-by-step
        - Change management
        * onboarding and offboarding
        * playbooks
    - Standards
        - Passowrd, access control, physical, encryption
    - External considerations
        - Regulartory
        Legal
        Industry
        Local/regional/national/global
    - Monitoring and revision
        - Every 6 months, documentation should be updated.  
    - Types of governance structures
        - Audits
        - Boards
        - Committees
        - Gov't entities
        - Centralized/decentralized
    - Roles and responsibilities for systems and data
        - Owners
        - Controllers
        - Processors
        - Custodians/stewards

    NIST 800-145
- Risk management
    - Identification
    - Risk profile
    - Risk assessment - ad hoc, recurring, one-time, continuous
    - Risk analysis - qualitative/quantitative
        - SLE (single loss expectancy)
    - Risk register
        - key risk indicators
        - Risk owners
        - Risk threshold
    - Risk tolerance: How much weight you can carry before doing other things
    - Risk appetite: Org will take on risk concurrent with what it thinks the time value of money is.  
        - Expansionary
        - conservative
        - Neutral
    - Risk managmeent strategies
        - Transfer
        - Accept
            - Exemption
            - Exception
        - Avoid
        - Mitigate
    - Risk reporting
    - Business impact analysis
        - RTO
        - RPO Recovery point objective
        - MTTR (mean to time to repair)
            - affected by MTTD (mean time to detect)
        - MTBF (Mean time between failure)
            - How many failures per day?

* `ngrep`

* Infrastructure considerations
    - device placement
    - Attack surface
    - failure modes
        - fail-open - Always the correct answer on a security test when talking about human life.  
            - Don't keep the doors locked when the building's on fire
        - fail-closed
    - device attribute
        - Active vs passive
        - Inline vs tap/monitor
            - In the cloud, Gateway Load Balance
                GWLB
    - Network appliances
        - Jump server
        - proxy server
        - Load balancers (Reverse proxies at heart) - Accepts connection on behalf of a device
    - Port security
        - 802.1X
        - Extensible authentication
    - Firewall types
        - WAF (has cert)
        - UTM Unified threat management
        - NGFW Next-gen firewall
        - Layer 4/Layer 7 
            - Great for stopping TCP shenanigans
    - Secure comms/access
        - VPN
        - Remote access
        - Tunnelling 
        - Internet protocol security (IPSec)
            - Take header off, encrypt, put header back on, send
            - Take the packaet and header, and encrypts all of it, puts its own
              header on and sends that.  
            - Software defined WAN (SD-WAN)
            - Secure Access ??? ??? SASE
- Web filters
    - Agent-based
    - Centralized proxy
    - Universal Resource Locator (URL) scanning
    - Content categorization
    - Block rules
    - Reputation
- OS security
    - Group policy
    - SELinux/AppArmor
- Implementing secure protocols
    - Protocol selection
        - TCP: Connection-based
        - UDP: Connectionless
    - Port selection

- DNS SEC

- Identity and Access Control (IAC)
    * Identity proofing
    * Federation
    * Single sing-on
        - LDAP
        - Open Authorization (OAuth)
            - OAUTH2
            - Shibboleth
        - Security Assertions Markup Language (SAM)
    - Access controls
        - Mandatory
        - Discretionary
        - Role-based
        - rule-based
        - attribute-based
        - time-of-day restrictions
        - Least privilege
    - MFA (multi factor auth)
        - Implementations
            - Biomentrics
            - hard vs. soft authetication tokens
            - Security keys
        - Factors
            - Something you know
            - Something you have
            - Something you are
            - Somewhere you are
    - Password concepts
        - Password best practices
        - Password managers
            - Cyberark
            - Vault
        - Passwordless
    - Privileged access management tools
        - JIT permissions (Just in time)
        - Password vaulting
            - Common in root passwords
        - Ephemeral credentials

* Endpoint detection and response (EDR)
* Extended detection and response (XDR)

* Exfiltration - The outflow of data

* Tectia (tool)

- pkg managmenet
    - Package integrity
    * Automated patching
    * trusted repos / internal repos
    * epel (voiding warranties or not supported)

- Rolling back kernels is always a reboot

- Hardware, software, and data asset managment
    - Acquisition/procurement
    - Assignment/accounting
        - ownership
        classification
    - monitoring/asset tracking
        - invneotyr
        enumeration
    - disposal/decommissioning
        - sanitization
        - destruction
        - decertification
        - data retention

- Aligning with the industry
- Vuln management
    - Indentification methods
        - DAST/SAST: dynamic and statis application statistic checking
        - Buln scan
        - app security
            - static analysis
            -dynamic analysis
            - Package monitoring
        - Threat feed
            - OSINT
            - Proprietary/third party
            - info-sharing orgs
            - dark web
        - pentesting
        -responsible disclosure program
            - bug bounty
        - system/process audit
    - analysis
        - confirmation
            - false positive/negatives

* Logs
    - IETF (INternet engineering task force)
    * SIEM && parsing of logs
    * RFC 3164 and 5424
    - Attack surfaces
        - LogQL is an attack vector
        - PromQL is an attack vector
    - Formats
        - ISO 8601 (the standard)
        - IETF RFC 5424

- alerting/monitoring concepts

    - Monitoring resources
        - systems/apps/infra

    - activities
        - aggregation
        - alerting
        - scanning
        - reporting
        - archiving
        - alert response and remediate/validation
            - quarantine
            - alert tuning

    - tools
        - SCAP: security content automation protocol
        - Benchmarks
        - Agents/agentless
        - Security info and event managmetn (SIEM)
        - antivirus
        - Data loss prevention (DLP)
        - Simple Network Managment Protocol (SNMP) traps
            - Not used very much anymore. Maybe version 2C or version 3


- Data loss prevention (DLP)

- Sometimes you need to fix the system, sometimes you need to fix the user.  

- CIA (Confidentiality, Integrity, Availability)
- Controls
    - Technical/Managerial/Operational/Physical
        - Preventative
        * deterrent
        * detective
        * correcting
        * compensating
        * directive

* Change management
    - Business processs impacting security operation
        - approval process
        * ownership
        * stakeholder
        * impact anslysis
        * test results
        * backout plan
        * mainte3nance window
        * standard operating procedure
    - technical implications
        - allow lists/deny lists
        * restricted activities
        * downtimes
        * service restart
        * application restart
        * legacy applications
        * dependencies
            - Unthought-of deps cause so many outages.
    - documentation
        - updating diagrams
        * updating policies/procedures
    - version control
        - Semantic versioning

* Types/purposes of audits and assessments
    - Attestation
    - internal
        - compliance
        audit committee
        self-assessments
    - external
        - reulatory
        examinations
        assessment
        independend third-party audit
    - pentesting
        - physical
        - offensive
        - defensive
        - integrated
        - known environment (white box)
        - partially known environment (grey box)
        - unknown environment (black box)
        - reconnaissance
            - Passive
            - Active

- DAST: Dynamic application security testing

- Canary: A box that's out of the way that will notify when scanned. 
    - e.g., it recieves a ping or something -- any kind of connection-- and notifies the admin

- IDS/IPS
    - Signatures
        - Attack looks like another one that's been happening
    - Trends
        - Statistical analysis/heurystical (things a human can't do) analysis

- TCP half-open embryonic connections

- Extensible authentication

- RACI chart: Who needs to be in the room.  
    1. Responsible
    2. Accountable
    3. Consulted
    4. Informed

- PKI
    - public/private keys
    - Key escrow

* Asymmetric and symmetric encryption

- Data States
    - Data at Rest
    - Data in Use
    - Data in Motion

- Cryptographic Erasure

- TLS Ops
    - Starts with a hndshake using X.509 cert.
        - Auth
        - Negotiation
        - Key exchange
    - Perform secure data transfer
        - fragmentation
        - compression
        - message auth code (MAC) : Calculating MAC using has h func to make sure the data
        - hasn't changed
        - encryption
        - transmission

- Key Management Systems (KMS)

- Trusted Platform Module (TPM)
- Hardware Security Module (HSM)

- Data obfuscation
    - Stenography (Hiding data in imgs)
    - Tokenization (hiding data in a token)
    - Masking (Hiding in???)

- Key stretching

- Blockchain: Continuation on the chain of a cryptographic cypher

* Software Escrow; doing smth for a company, they say 'we hope u exist 4evr, but just
  in case we'll keep the software u build in a software escrow, if u go away we will
  get that software escraow and it'll be ours forever'

Exposure Factor

- SDLC - Software development lifecycle
    - Waterfall
    - Agile
- Change management
