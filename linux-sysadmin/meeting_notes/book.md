
Make a book of the course
- Comeraderie as a study group



Pull requests, meeting timelines, check-ins
`mdbook` deploy with `github actions` at `github.io/adminbook`
Develop 16 units/chapters
- 16 Units
    - Worksheets
    - Labs
    - Discussion posts
    - Bonus sections (digging deeper)


Book with 16 units
Repo with commit history
Build deployment system for future updates


## QUESTIONS:
* How does `mdbook` handle links in markdown? 
 

## IDEAS:
* Build locally first - maybe use ProLUG lab environment?
* Labs:
    * Add markdown link to a "digging deeper" for each command - explain and break down what
      is happening at each step.  


## FLOW
- Comment rough draft first, get thumbs up
- Fork
- Branch
- PR


## Syllabus
```
Unit 1 Get Linux Lab Access – CLI Primer – vi/vim/nano basic
Unit 2 Essential Tools – Files, Redirects, and Permissions
Unit 3 Storage – Logical Volume Management and RAID
Unit 4 Operating Running Systems
Unit 5 Security - Manage users and groups
Unit 6 Security – Firewalld/UFW
Unit 7 Security – Patching the system/ Package Management – yum, dnf, rpm
Unit 8 Scripting – System checks
Unit 9 Docker - K3s Setup and basics
Unit 10 K3s advanced w/ microservices
Unit 11 Monitoring systems
Unit 12 Engineering – System baselining/benchmarking and testing
Unit 13 System Hardening
Unit 14 Ansible Automation
Unit 15 Engineering Troubleshooting
Unit 16 Incident Response – Actual incident callout and information gathering
```


## Syncing your Fork with the Original 
You'll need to keep your local fork of the repository up to date with the original repository.  
You can do this from the GitHub web UI easily with the `Sync Fork` button.  
If you want to do this from the terminal, you can add a new `git remote` called `upstream`.  
```bash
git remote add upstream https://github.com/ProfessionalLinuxUsersGroup/lac.git
```
Then, to sync your local fork with the original repo, do a `git pull` from the `upstream` remote.  
```bash
git pull upstream main
```


## Reviewing

Things to review:
- Verify the title section follows CSS style, per Chris' post
- Verify there are links to discussion posts
- Verify there's the unit's video embedded
- Verify the headers are the correct levels (following style guide)


