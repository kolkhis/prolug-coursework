# Unit 9 Lab - Certificate and Key Madness


## Lab 🧪

These labs focus on pulling metric information and then visualizing that data quickly on dashboards for real time analysis.

<!-- #### Downloads -->

<!-- The lab has been provided below. The document(s) can be transposed to -->
<!-- the desired format so long as the content is preserved. For example, the `.txt` -->
<!-- could be transposed to a `.md` file. -->

<!-- - <a href="./assets/downloads/u9/u9_lab.txt" target="_blank" download>📥 u9_lab(`.txt`)</a> -->
<!-- - <a href="./assets/downloads/u9/u9_lab.pdf" target="_blank" download>📥 u9_lab(`.pdf`)</a> -->

### Setting up Rsyslog with TLS

1. Complete the lab: <https://killercoda.com/het-tanis/course/Linux-Labs/211-setting-up-rsyslog-with-tls>

### Review Solving the Bottom Turtle

1. Review pages 41-48 of <https://spiffe.io/pdf/Solving-the-bottom-turtle-SPIFFE-SPIRE-Book.pdf>
    - Does the diagram on page 44 make sense to you for what you did with a certificate authority in this lab?
        > - Not really. We only had 1 CA (controlnode), and one service that was
        >   authenticated through the CA. We did not have any intermediate CAs.  

### SSH – Public and Private key pairs

Complete the lab: <https://killercoda.com/het-tanis/course/Linux-Labs/212-public-private-keys-with-ssh>

- What is the significance of the permission settings that you saw on the generated
 public and private key pairs?

    > - Public key had 644 permissions, the private key had 600 perms. 
    >   The significane of this is that only the owner can view and modify the
    >   private key, whereas anyone can view the public key (but only the owner
    >   can modify it) -- This is important in keeping eyes off of the private key.  
        ```plaintext
        -rw-------  1 root root  411 May 30 23:42 ProLUG
        -rw-r--r--  1 root root   99 May 30 23:47 ProLUG.pub
        ```

<!-- TODO: PR to fix `cat authorized_key`, add exit when necessary -->



## Digging Deeper challenge (not required for finishing lab)

1. Complete the following labs and see if they reinforce any of your understanding of certificates with
   the use of Kubernetes.

    - <https://killercoda.com/killer-shell-cks/scenario/certificate-signing-requests-sign-manually>

    - <https://killercoda.com/killer-shell-cks/scenario/certificate-signing-requests-sign-k8s>

2. Read the rest of <https://spiffe.io/pdf/Solving-the-bottom-turtle-SPIFFE-SPIRE-Book.pdf>

    - How does that align with your understanding of zero-trust? if you haven't read about zero-trust, start here.  
        - <https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf>


