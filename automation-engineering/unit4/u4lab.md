# Unit 4 Lab 
## Admin commands and one-offs

## Required Materials
- Putty or other connection tool
- Lab Server 
    - Killercoda recommended: <https://killercoda.com/het-tanis/course/Automation-Labs/Unit4_Admin_Commands> 
- Root or sudo command access

## LAB
This lab is designed to have the engineer verify and execute their automation tools to interact with the
OS in a controlled fashion.

If you do the killercoda Lab 4, just answer these questions. If you are doing the lab in the ProLUG
environment, find the scripts in /labs/automation/unit4.

## Lab Setup (ProLUG Lab Only)
```bash
cd /root
cp -r /labs/automation/unit4/* /root
```

- Alternatively, for your own lab environment:
  ```bash
  cd /root
  git clone https://github.com/het-tanis/prolug-labs.git
  cp prolug-labs/AutomationLabs/Unit4_Admin_Commands/assets/* /root
  ```

Finally, make everything executable:
```bash
chmod 755 /root/*.sh
chmod 755 /root/*.py
```

---

In the ProLUG lab, you must edit `/root/hosts` to point at your correct 
environment based on which `auto<x>` server you have connected to.

| Server | Hostgroup    | Target Nodes
|------- | ------------ | --------------
| auto1  | [webservers] | target1-1,target1-2
| auto2  | [webservers] | target2-1,target2-2
| auto3  | [webservers] | target3-1,target3-2
| auto4  | [webservers] | target4-1,target4-2
| auto5  | [webservers] | target5-1,target5-2

!!! warning "Killercoda Recommended"

    This lab is designed to be run in the Killercoda environment and will take 
    significant user tooling to change over to their own environment. This is not 
    supported in this run of the course but the learner is welcome to work with it 
    and tool it over for that purpose as time permits.  

## Lab Notes / Answers

### Page 1

The expected state of web server:

dev - port 8080

test - port 8081

qa - port 8082

- What environment is deployed? What problems do you see compared to what you expected to see?
    - Answer: The QA environment is deployed on port 8087, not 8082.  
      ```plaintext
      changed: [node01] => (item=Listen 8080)
      changed: [node01] => (item=Listen 8081)
      changed: [node01] => (item=Listen 8087)
      ```

- How might you find what broken in the deployment? We saw it run from start to finish, why didn't the deployer fail?
    - We can look at the output of the Ansible playbook to see what changed, 

- Did the wrong port get set somehow? How might you find that incorrect port?
    - The wront port did get set, yes. That shows when we try to `curl` on port
      8082, as well as in the playbook output.  
      It also shows port 8087 when trying to run an `nmap` on node01.  

- Can you fix that with some one-off commands to get the environment correct?

- Can you fix that with some one-off commands to get the environment correct?
  ```bash
  ansible webservers -i /root/hosts -m lineinfile -a "path=/etc/apache2/ports.conf regexp='Listen 8087' line='Listen 8082'" 
  ```

- If you check the system, did that fix it? Why or why not?
    - It did not fix it, `nmap` still shows port 8087. I think this is because
      the apache webserver has not been restarted for the changes to take
      effect.  

- ansible webservers -i /root/hosts -m service -a "name=apache2 state=restarted"

- If you check the system, did that fix it? Why or why not?
    - It did fix it, restarting the service reloads the config so the changed
      port will be picked up.  

### Page 2

New file to push to the web servers:

```bash
ansible webservers -i /root/hosts -m copy -a "src=/answers/fixed_qa_index.html dest=/var/www/html_qa/index.html"
```

- But wait, did this require a restart of the apache web service? Why or why not? What is different here?
    - It didn't. I think this is because the `index.html` is not part of the
      actual service configuration, and it's serving whatever files are there, so 
      it'll be dynamically updated.   


### Page 3

A user named svc_ansible set up on webservers with a home directory in 
/var/chroot/svc_ansible instead of the normal location.
The user must be added to the admin or wheel group and have the uid of 10001.  


Create directory
```bash
ansible webservers -i /root/hosts -m user -a "name=svc_ansible home=/var/chroot/svc_ansible uid=10001 groups=admin"
```

Create the svc_ansible user and give them the correct settings in the environments needed.
```bash
ansible webservers -i /root/hosts -m user -a "name=svc_ansible
```

- What warnings do you see here? Might you need to fix these? How would you do the fix, if you needed one?
    - The only warning message I see is:
      ```plaintext
      "useradd: warning: the home directory /var/chroot/svc_ansible already exists.\nuseradd: Not copying any file from skel directory into it.\n"
      ```
    - Probably won't need to fix this. This just says the the home dir already
      exists. The `svc_ansible` user doesn't need the default user files.  
    - We could just do a `copy` of all files in /etc/skel to the
      /var/chroot/svc_ansible directory.  
      ```bash
      ansible webservers -m shell -a "cp /etc/skel/* /var/chroot/svc_ansible"
      ```


