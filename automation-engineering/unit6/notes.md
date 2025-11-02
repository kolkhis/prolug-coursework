# Unit 6 Notes

Focus this week: Docker/container images, building images

## Last week

- Variable precedence
- variable scope (global, play, host)
- default values (`default(omit)`)
- variables from APIs
- inventories
- grouping hosts
- host group variables
- local facts/custom facts in `/etc/ansible/facts.d`
- registering variables
- Stamping variables out and reporting with jinja2


## This week

Container image workflow example

- What can trigger a build?
    - GH actions
    - Manually
    - Event driven (Kafka, event bridge, opensearch, splunk)

Docker images

- Tools to maintain images
    - Packer
    - AppTainer
    - etc


GitHub actions can trigger off to packer.  

## Container img workflow
Some external repo out of our control, we pull down to local repo.  

We modify image by adding layers:

- dockerfiles
- packer
- apptainer

Images are "artifacts" and versioned acc ording to semantc versioning.  

Auomations can triger from artifacts, then we can test artifacts for
functionality or security.  

## Docker Images

Useful for the following reasons (non-exhaustive):

- Snappiness
- Bring your own environment (BYOE)
- Reproducible science
    - libraries
    - scripts in place
- Static environments
- Legacy code
    - Can emulate older OS environments
- Custom/specific software environments
    - only have to set stuff up one time  

Setting up docker images:

- Tools exist to make this easier
    - Packer
    - Terraform
    - Apptainer

## Lab: Use terraform to deploy containers

First, check that containerd is running and exposed
```bash
systemctl status containerd
ss -ntulp | grep -i containerd
```
check if tf is installed
```bash
terraform --version
```
make a dir for the project
```bash
mkdir docker && cd docker
docker ps
docker images
```

---

Terraform doesn't ship with any providers

`version = "~> 2.13.0"`

`terraform fmt` will 
`terraform validate` will check if everything's kosher. you need to run
`terraform init` to download all the required providers first.
Deploy the resource with `terraform apply --auto-approve`

See the terraform state in `terraform.tfstate`. This file **should not be
edited by hand**.  

Destroy the deployed resources with `terraform destroy`.  

---

Adding apptainer:
```bash
add-apt-repository -y ppa:apptainer/ppa
apt update
apt install -y apptainer
apt install -y apptainer-suid
apptainer --version

vi my_image.def

Bootstrap: docker
From: ubuntu:22.04

%post
    apt-get update
    apt-get install -y cowsay
    echo "Hello from inside the container!" > /message.txt

%runscript
    cat /message.txt
    # cowsay "Apptainer is awesome!"
    /usr/games/cowsay "Apptainer is awesome!"

apptainer build my_image.sif my_image.def
apptainer run my_image.sif
```

You can loop in Terraform resources.  
```hcl
resource "" "" {
    count = 10
    name = "${count.index}"
}
```
This can be used to dynamically generate numbered instances.  
Can also set the `count.default` to `1` to start from 1 instead of 0.  

## Links
- <https://apptainer.org/docs/user/latest/>
- <https://developer.hashicorp.com/tutorials/library?product=packer>

