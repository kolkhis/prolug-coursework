# ProLUG Security Engineering

## Unit 9 Worksheet

## Instructions

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.


## Discussion Questions:

### Unit 9 Discussion Post 1
Read the Security Services section, pages 22-23 of
<https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf> and
answer the following questions.

1. How do these topics align with what you already know about system security?
    - This outlines a variation of the CIA security triad.  
        - Confidentiality
        - Integrity
        - Authentication 
    - The "A" is only different in our previous discussions of the CIA security triad
      in that it uses the word Authentication instead of Availability.  
    - Aside from that, the Security Services section outlines a set of concepts that
      should be applied to data and the accessing of data.  
        - Data should be confidential, only readable by those with the correct permissions. Using cryptography, making data untillegiable by anyone without the correct private key is the way to make the data confidential.  
        - Data should not undergo unauthorized modification. This is detectable using cryptography.  
        - Any access to the data should be properly authenticated using a public/private key pair.  
2. Were any of the terms or concepts new to you?
    - there are three types of authentication services that cryptography can provide.  
        1. Identity authentication services: Authenticates the entity (person or service) interacting the system.  
        2. Integrity authentication services: Ensures that no unauthorized modifications are made to data.  
        3. Source authentication services: Verifies the source of the incoming information (e.g., verifies the entity the sent the info).  
    - Cryptography can be used to detect unauthorized modifications to data.  



### Unit 9 Discussion Post 2
Review the TLS Overview section, pages 4-7 of
<https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf> and answer
the following questions

1. What are the three subprotocols of TLS?
    - Handshake protocol: Negotiates the session parameters. 
        - Supports optional authentication using X.509 public-key certificates.  
        - Used in TLS 1.0, 1.1, and 1.2, but removed in TLS 1.3 (which handles the handshake itself).  
    - Change cipher spec protocol: Used to change the cryptographic parameters of a session.  
    - Alert protocol: Notifies the other party of an error condition (when an error occurs).  
        - Ensures both sides are aware of any failures that may occur (e.g., invalid certs).  
    - Also see RFC 5246 and RFC 8446.  

2. How does TLS apply
    - Confidentiality: Ensures that all data being sent over the wire is encrypted.  
    - Integrity: Data being sent is not modified in transit due to cryptographic signing.  
    - Authentication: Validates that the user accessing the data is who they say they are. Done in the handshake subprotol of TLS.  
    - Anti-replay: TLS includes sequence numbers and session identifiers to detect and prevent message replay attacks. Sessions use nonces and timestamps to make sure a message can't just be captured and resent to trigger unwanted actions.    

## Definitions/Terminology

- TLS: Transport Layer Security. As the name suggests, it's used in the Transport layer (layer 4 of the OSI network model).  
    - Replaced SSL. Current best practice is TLS 1.3.  
- Symmetric Keys: An encryption method that uses a single key to both encrypt and decrypt.  
    - This is fast and efficient (like 10x faster than asymmetric encryption), but
      requires secure key exchange.  
    - An example of this would be AES.  
- Asymmetric Keys: Public/private key pairs. A private key is used to encrypt
  information, and a public key is used to decrypt the encrypted information.  
    - Data encrypted with the public key can *only* be decrypted with the private key, and visa versa.   
    - Common asymmetric encryption algorithms are RSA and ed25519. Also ECC.  
    - This makes secure key exchange and authentication easy.  
    - Slower than symmetric key encryption.  

- Non-Repudiation: Beyond repute. Ensuresw that a sender cannot deny having sent a message.  
    - Can be achieved through digital signatures and public key cryptography.  
    - Can also be achieved through immutable logs.  
- Anti-Replay: Prevents an attacker from re-sending captured messages to trick a
  system into repeating actions.  
    - TLS defends against replay attack using sequence numbers, session identifiers,
      timestamps, and ephemeral keying.  
- Plaintext: Raw text data. The data in its original, readable form, before encryption.  
- Cyphertext: Data that has been encrypted using an algorithm and a key.  
- Fingerprints: A short and unique hash generated from a cryptographic key.  
    - Fingerprints can be generated from SSH keys, GPG keys, and TLS certs.
- Passphrase (in key generation): A human readable password used to encrypt and
  protect a private key on a disk.  


## Notes During Lecture/Class:

[notes.md](./notes.md)

### Links:
- <https://www.sans.org/information-security-policy/>
- <https://www.sans.org/blog/the-ultimate-list-of-sans-cheat-sheets/>
- <https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-57pt1r5.pdf>
- <https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-52r2.pdf>

### Terms:

### Useful tools:

- STIG Viewer 2.18
- Ansible
- Killercoda


## Lab and Assignment

Unit9-Certificates and keys - To be completed outside of lecture time.

## Digging Deeper

1. Finish reading about TLS in the publication and think about where you might apply it.

## Reflection Questions

1. What were newer topics to you, or alternatively what was a new application of
   something you already had heard about?

2. What questions do you still have about this week?

3. How are you going to use what you’ve learned in your current role?


