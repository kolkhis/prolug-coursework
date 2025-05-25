
# Encryption Techniques

Encryptions are based on cyphers. Pass plaintext through a cypher and you get
**cyphertext**. Pass the cyphertext through the correct cypher again, using the
correct method, and get plaintext.  

Two major ways to encrypt things:
1. Symmetric key encryption
    - Same key is used to encrypt and decrypt
    - "Low cost" encryption.  
2. Assymetric key encryption
    - Public/private key pairs are used to encrypt and decrypt data.
    - This is what SSH and TLS uses.  

        - For SSH: You have the private key and the server stores the public key
          (more analogous to a lock) in the authorized_keys file.  
        - For TLS: The server holds the private key, and you (the client)
          download the public key from a Certificate Authority (CA) that you
          trust.  

    - Assym keys are "algorithmically linked".  

    - Takes 10x more processing power than Symmetric key encryption.  


## PKI - Commonly known as SSL/TLS

Secure Sockets Layer (SSL) and Transport layer security (TLS)
- It's like a third-party introduction.  



---

SSH keygen -- will generate a fingerprint
- will probably be lost in the sands of time.
- You can see the fingerprint whenever you want:
  ```bash
  ssh-keygen -l -f key
  ssh-keygen -l -f key.pub
  ```
    - You can use this to tell if two keys are cryptographically similar.  
      This will help you identify if they are actually key/pairs.  


- If you lose the public key, you can generate the public key from the private key!
  ```bash
  ssh-keygen -y -e -f key
  ```

- Private keys will not be read unless they're `600` (permissions)

- You can always regenerate the public key from the private key.  

---

When an admin leaves, `root` user's password is rotated. The key *should* also be
rotated.  

## Key Rotation
It's important to set up a plan for key rotation.  
<https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf>

---

## Zero Trust
Zero-trust (ZT) architecture
<https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-207.pdf>

ZT talks with certificates, they're the same asymmetric key encryption concept just
using a CA (certificate authority). 

ZT is such a prevalent concept that it will likely be in most jobs related to security.  

SPIFFEE deals with zero trust.  
<https://spiffe.io/pdf/Solving-the-bottom-turtle-SPIFFE-SPIRE-Book.pdf>



```bash
# Gen private key as CA (we'll be our own CA)
certtool --generate-privkey --outfile ca-key.pem


# Generate self-signed cert
certtool --generate-self-signed --load-privkey ca-key.pem --outfile ca.pem
# select defaults
# org name : proLUG
# Expirtaion: 90 days
# Select 'y' for "Is the above info ok?"

# Gen new private key
certtool --generate-privkey --outfile key.pem

# Gen a certificate request
certtool --generate-request --load-privkey key.pem --outfile request.pem

# Sign the cert reques
certtoll --generate-certificate --load-request request.pem --outfile cert.pem \
    --load-ca-certificate ca.pem --load-ca-privkey ca-key.pem
# Select defaults
# Expiration: 60 days

# Validate info by checking the cert
certtool --certificate-info --infile cert.pem

# push correct ca.pem to remote host (node01)
scp /usr/local/share/ca-certificate/ca.pem node01:/usr/local/share/ca-certificates


```

The CA determines the expiration time accepted. If we set it to 90 days, then try to
genereate a new certificate with an expiration of 120 days, it won't work.  

Then configure the TLS in rsyslog
/etc/rsyslog.conf

```bash
# Custom TLS server

global(
DefaultNetstreamDriver="gtls"
DefaultNetstream
DefaultNetstream
DefaultNetstream
DefaultNetstream
)
```


---

DC (Domain Component) is going to be important later.  

---

`vi -x` to [en|de]crypt a file, or `:X` (uppercase)

