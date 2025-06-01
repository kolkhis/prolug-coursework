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

2. What was completely new to you?

3. What is something you heard before, but need to spend more time with?
    - TLS
    - Certificates
    - ZTA (Zero-Trust Architecture)


### Unit 10 Discussion Post 2
Proof of Skills from this course.

1. Think about how the course objectives apply to the things you’ve worked on.

    * How would you answer if I asked you for a quick rundown of how you would
      secure a Linux system?
        - Where to start? CIA, STIGs, Technical Controls

    * How would you answer if I asked you why you are a good fit as a security
      engineer in my company?

    * Think about what security concepts you think bear the most weight as you
      put these course objectives onto your resume.

        * Which would you include?

        * Which don’t you feel comfortable including?


## Definitions/Terminology

- Capture from this week lesson or recording

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

- DNS SEC
- Shibboleth

- Privileged access management tools
    - JIT permissions (Just in time)
    - Password vaulting
        - Common in root passwords
    - Ephemeral credentials

* Endpoint detection and response (EDR)
* Extended detection and response (XDR)

- DAST/SAST: dynamic and statis application statistic checking
- Simple Network Managment Protocol (SNMP) traps
- Data loss prevention (DLP)

- DAST: Dynamic application security testing

- Canary: A box that's out of the way that will notify when scanned. 
    - e.g., it recieves a ping or something -- any kind of connection-- and notifies the admin

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

- PKI
    - public/private keys
    - Key escrow

* Asymmetric and symmetric encryption

- Data States
    - Data at Rest: Always be AES256 (Minimum cloud standard)
    - Data in Use: Shold be obfuscated
    - Data in Motion: Always be moved with TLS

- Cryptographic Erasure

- Key Management Systems (KMS)

- Trusted Platform Module (TPM)
- Hardware Security Module (HSM)

- Data obfuscation
    - Stenography (Hiding data in imgs)
    - Tokenization (hiding data in a token)
    - Masking (Hiding in???)

- Key Stretching

* Software Escrow; doing smth for a company, they say 'we hope u exist 4evr, but just
  in case we'll keep the software u build in a software escrow, if u go away we will
  get that software escraow and it'll be ours forever'

* Exposure Factor

- SDLC - Software development lifecycle
    - Waterfall
    - Agile


## Notes During Lecture/Class:

### Links:

-
### Terms:

Useful tools:
-

Lab and Assignment
No lab for Unit 10, work on your project.
