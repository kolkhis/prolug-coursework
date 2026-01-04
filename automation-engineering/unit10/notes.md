# Unit 10 Notes (Harden Linux Systems)




## Chrooted Environments

Why we use them:

- testing and dev
- dependency control
- compatibility
- recovery
- privilege separation

## Importing and customizing images

1. Pull down image into local repo
2. Build with podman for any customizations
3. Push back up to repo
4. Save file locally
5. Inport to warewulf
6. Further customization


<https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-223.ipd.pdf>

## This Week

- Securing images with Ansible Lockdown
    - Ansible lockdown is targeting localhost by default.  

- CIS v STIG
    - STIG is mostly gov't stuff  
    - CIS is a separate standard, used in other industries (e.g., insurance)  



## System build process

System build and config management --  

- engineers build systems according to security and engineering baseline and
  release to operations
    - Artifacts are produced (build and runtime books created)
    - Original build image never needs to change
- Operations admin teams make changes to fix systems
- Operations admin teams make changes for user requests
- Operations admin teams make changes for security fixes
    - Artifacts are produced (build and runtime books created)  
    - These 3 contribute to the golden image.  

Anything you build here is an artifact, whether it's called "golden image" or
"hardened image".  

---

Deployment process: --
- Someone requests a server (api call, vmware manual deployment, terraform
  kickoff, ansible)  
- Server build starts
    - Container is stood up? Golden img is cloned into vm?


## Lab

Harden an image.  

Check Ansible `ansible --version`
Remove Go
```bash
rm -rf /usr/local/go
apt purge golang-go
# Install git
apt -y update && apt -y install make git
# Download later version of go
wget https://go.dev/dl/go1.23.0.linux-amd64.tar.gz
tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
export PATH="$PATH:/usr/local/go/bin"
go version
# Download and install warewulf from source
git clone https://github.com/warewulf/warewulf.git
cd warewulf
make
time make install
```

Import and build image
```bash
time wwctl image import --build docker://ghcr.io/warewulf/warewulf-rockylinux:9 my-rocky-image
wwctl image list
wwctl image build my-rocky-image
```









