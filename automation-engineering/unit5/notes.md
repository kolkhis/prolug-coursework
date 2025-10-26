# Unit 5 Notes



## Last week review

Talked about admin commands and one-offs

- with admin cmds, we observe, benchmark, and tune
- what triggers them?
    - system events, log/alerts, etc.
    - KTLO (keeping the lights on)


## This Week

- Variable precedence and use
- Templating and default values of variables
- Map env vars to systems and utilize them in automations
- deploy and configure a linux system with automated tools




when working in enterprise environments, we sometimes get variables from **people**.  
e.g., DB name, what server it's on, etc.  
we'll get those variables and feed into an environment file.  

- Very common variables that come from other people:
    - connect string (username/password), hostname, cluster name, namespace, etc.

---

If a var doesn't exist in a play, it only exists once "Registered" in the play, and is
specific to that host.  


## Unit 5 Overview

Vars in automation:

- General idea and workflow 
- How do we load vars into our tool (ansible)?
- Where can we populate them from?
- How do we place these vars on systems?
- What is precedence?
- What happens when a var doesn't exist (isn't populated)? 
- How do we generate vars during our automations?
- How do we report these vars out?


### General workflow
- Before execute: Inventories and custom vars in each server
- During execute: Environment files, extra vars (CLI overrides)
    - registered vars, populated at runtime 
        - completion of scripts
        - api calls
        - global or scoped to individual machines

Variables passed as CLI args will always take precedence.  

- Completion: Write out to logs, jinja2 template to slack or email, teams,
  discord, etc.

Variables always have a scope. Ansible:
- Global: Set by config, env vars, and the cli
- Play: Eac h play and contained structure, vars entries (`vars:`, `vars_files:`, `vars_prompt:`)
- Host: Vars directly associated to a host, like included in the inventory, 
  with `include_vars:`, or in `facts`, or registered task outputs

Environment files can be in yaml format that has vars that are associated with
hosts, maybe even an inventory.  


API loaded vars:
- env values stored in vault
    - connect strings for mysql
    - connect usernames
    - connect passwords
- Basically just pulling in values that another team set in a Vault.  

Set mostly in `vars_files`


## Vault Lab (API-loaded vars)

Use `root token`:
```bash
vault server -dev & # background process
export VAULT_ADDR='http://127.0.01:8200'
export VAULT_TOKEN='<root token from server output>'
vault status # verify
lsof -i :8200
ss -ntulp | grep 8200
# verify secrets engine v2 is running
vault secrets list --detailed
# Create a vault secret of the username/password for app
vault kv put secrets/app1/values username=secretuser password=supersecure

# verify that they were set
vault kv get secret/app1/values

# allow vault to user usernames/password
vault auth enable userpass

# create the user for vault
vault write auth/userpass/users/ansible password=ansible
```

Create a policy to allow reads of `secret/app1/values` 
```bash
cat > /root/ansible-policy.hcl <<- EOF
# Write and manage secrets in key-value secrets engine
path "secret*" {
  capabilities = [ "create", "read", "update", "delete", "list", "patch" ]
}
EOF
```

Write the vault policy into vault itself
```bash
vault policy write ansible_policy /root/ansible-policy.hcl
```

Then **map the policy to the user `ansible`**.  

```bash
vault write /auth/userpass/users/ansible policies=ansible_policy
# Verify the mapping
vault read auth/userpass/users/ansible
```


You can also have a **vault password file** and make it 600 so only root can
read it.  

But then the vault creds could be grabbed with an Ansible task:  
```yaml
  - name: test my connection to vault for credentials
    uri:
      url: "http://127.0.0.1:8200/v1/auth/userpass/login/{{username}}"
      return_content: yes
      method: POST
      body_format: json
      body: { password : "{{ password }}" }
    register: user_connect
```

## Default values
We may want to use the `default` jinja filter
```yaml
- name: touch files w/ optional mode
  ansible.builtin.file:
    dest: "{{item.path}}"
    mode: "{{ item.mode | default(omit) }}"
  loop:
    - path: /tmp/foo
    - path: /tmp/bar
    - path: /tmp/baz
      mode: '0444'
```
The `omit` will just leave it empty

Defaults are **only used** when the variable isn't defined anywhere.  

## special vars
- hosts, and their state of active/inactive in a play.  
    - ansible_play_hosts : the ones that finish -- failed ones are omitted
    - ansible_play_hosts_all : all of the hosts
- executtion values like forks, check mode, and config files
- loop states
- where you are in a play -- tasks, roles, tags that are active
- inventories and inventory files. includes host groups and vars
- ansible_local: values that get brought to the play via servers
- 

## Generating vars

```yaml
- name: run installer
  shell: /opt/myapp/deploy/deployer.sh
  register: installer_output

- name: Debug and show output
  debug:
    var: installer_output
```

## stamping vars out w/ jinja2
- stamp values to servers to record when things happened on them
- report everything back centrally to capture how everything ran on the systems.  

```yaml
- name: copy template over to all hosts
  template:
    src: /template.j2
    dest: /root/report.txt
```

`delegate_to` will only run on a specific host.  

```yaml
- name: copy template over to all hosts
  template:
    src: /template.j2
    dest: /root/report.txt
  delegate_to: localhost
```

Example: Jinja template to determine if any servers failed.  
```jinja2
{% for host in ansible_play_hosts_all %}
{% if host not in ansible_play_hosts %}
Unreachable host: {{ host }}
{% endif %}
{% endfor %}


{% for host in ansible_play_hosts_all %}
{% if hostvars[host].uptime is defined %}
{% if 'day' in hostvars[host].uptime.stdout %}
{{ hostvars[host].ansible_hostname }} has not rebooted
{% endif %}
{% endif %}
{% endfor %}
```


