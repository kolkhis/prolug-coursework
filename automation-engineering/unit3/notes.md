# Unit 3 Notes

## Making and Using Inventories


Unstructured data v. Semi-structured data v. Structured data


We need to understand data formatting from a context of "If we're gonna feed 
this into a system, these things need to be there so it can run without manual
intervention."  

It's not really an automation unless it's finishing on its own.  

## Definitions

- "True Up": Reconciliation

- Inventories: Structured, useful lists of items that we can read into our
  automations. 
    - Inventories can be semi structured lists:
        - Flat files
        - CSV
        - JSON
        - YAML
    - Inventories can be input into our automations in many ways:
        - API calls where we must parse downdata that we want to use
            - Typically JSON responses based on queries
        - Environment files that describe the nature of the system and provide
          variables for our automation
    - Inventories must also be maintainable by **us**. You will not like
      maintaining poorly formatted inventories.  


Make sure all your servers are all present in the inventory before triggering
important automation.  

Your inventory should be the ultimate source of truth **for that run**.  

## Inventory Management

- What are our inventory sources?
    - Flat files?
    - API calls?
- What's the importance of having a good inv?
    - What is a "good" inv?
        - Accurate
        - Readable
            - Two ways things are read: 
                1. The system needs to read it (right format)
                2. Human needs to read it
        - Useful

---

Everything about maintaning an IT infra starts from a good inventory.  

You can't interact with things that you don't know exist.  
You can't react to problems to things you're not monitoring or areas you can't see.  
You can't secure that which you do not know about.  

---

## What makes a good inventory?

- Complete. It has all the systems under your purview represented
  inside of it.  

- Accurate. It always targets servers or items by name, IP, or the correct
  identifier (FQDN or the like)

- Properly formatted. The semi-structured nature is readable by your tool of
  choice.  

- Automatically Updated. A mature inventory system will automatically update
  changes to individual items. If you build a new server, the process updates
  the inventory.  

Moving forward without a good inventory is not moving forward.  


## Inventories
Using stright up hostnames in inventories will work as long as they're defined via Hosts or resolvable by DNS.  
```ini
[servers]
controlplane
node01
```
If those two are defined in `/etc/hosts` and mapped to IPs, there's no issue.  


### Variables in Inventoreis
```ini
[servers]
controlplane
node01

[servers:vars]
env=non-prod
ansible_user=dev_svc_ansible
```

Environment file (could be YAML)
```yaml
- nodes:
  - node:
    name: target1-1
    host: 192.168.11.202
  - node:
    name: target1-2
    host: 192.168.11.203
```

## Tool
The `ansible-inventory` tool can be used to parse inventories and reformat them.  


