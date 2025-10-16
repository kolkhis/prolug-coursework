# ProLUG Automation - Unit 3 Worksheet


## Instructions

Fill out this sheet as you progress through the lab and discussions. Hold your worksheets until
the end to turn them in as a final submission packet.


## Discussion Questions

### Unit 3 Discussion Post 1

Find a blog post or open source tool that focuses on IT inventory
management.  


1. What is meant by the term “inventory” in an IT context?  
   ```markdown
   An inventory in IT context is a complete list of all technological resources   
   that an organization owns.    
   ```


2. What are some of the issues with inventories in a company?    
   ```markdown
   Unclear inventories, where it's not apparent what is what, maybe it's not clear   
   what servers are prod/dev/test environments.    
   Maybe an inventory just not existing, or incomplete inventories. Misconfigured   
   inventories. Not grouping servers together. Grouping incorrectly.  
   Leaving out variables containing essential information about the servers.  
   Changing the inventory without notice. If someone decides to refactor, say   
   labels (variables) for servers and all the playbooks are relying on that  
   label to determine which tasks to run, that could be a huge issue.    
  
   Poorly maintaining or simply failing to create an inventory is a huge issue.    
   ```

  
    - How have people attempted to overcome these issues?    

      ```markdown
      Aside from rebuilding a bad inventory from scratch...  
      Regular inventory maintenance. Either update the inventory manually on a  
      set schedule or have some sort of dynamic inventory generation set up.    
      Also setting up a standard or guidelines for how an inventory should be  
      formatted would be a great way to ensure the inventory remains static.    
      ```


3. What different formats of inventories can you find for IT management?    

   ```markdown
   `.ini`, `.yaml`, `.csv`, `.json`, `.xml` to name a few of the popular ones that are used for  
   machine-readable inventories. Some could use spreadsheets in Excel or Google  
   Sheets (`.xls`/`.xlsx`) for organizing data in a tabular format.    
   There are also database exports, SQLite or SQL dumps, that are supported by  
   managed inventory software solutions.    
   ```

  
    - Why would formatting matter?  

      ```markdown
      Formatting is important. If it needs to be machine-readable *only*, then  
      using something like CSV, where everything is a hot mess to looks at, is   
      probably fine since the human-readable element is not there.  
  
      But, if the inventory needs to be both machine-readable *and*  
      human-readable, then a more structured format like `.ini`, `.yaml`, or `.json`   
      is a better approach. These are easily parsed by code and humans.    
      ```


Source used: <https://invgate.com/itsm/it-asset-management/it-asset-inventory>

### Unit 3 Discussion Post 2

You are a system administrator for a small company with ~100 total Linux systems.  
The security engineer approaches you and shows you vulnerabilities in your 110 total Linux systems.  
He then asserts, “without a good inventory, you cannot have security in the system.”

1. Do you agree with him, why or why not?  
   ```answer  
   I do agree. Without a decent inventory, you will not be able to tell what  
   machines are in the environment, their characteristics (e.g., their OS, the  
   applications they're running, their roles, etc.), which can prevent you from  
   being able to apply the correct security patches to the systems.    
   You also won't be able to troubleshoot a security incident easily if you  
   can't identify affected servers easily.    
   If the vulnerabilities are really severe, without an inventory we won't be  
   able to quickly take them offline for a maintenance.    
   ```  
  
    1. How do you plan to start to “true up” your inventories?  
       ```answer  
       Make the inventories clear.  
       Separate the hosts into groups depending on their roles and tasks  
       they're meant to perform.    
       Add appropriate variables for either specific machines (if needed), or  
       variables for entire groups, which can then be used in playbooks to  
       determine which tasks need to be done on which hosts.    
  
       If the 100 Linux systems are all running the same operating system,  
       great. If not, start by grouping them by OS. Then at least we can apply  
       the appropriate patch for the OS type.  
  
       If the vulnerabilities are to do with a specific application, then just  
       having an inventory that is **complete** may be enough to apply the  
       security patch.  
       ```  
  
    2. How can you prevent this type of problem (if you think it is one) in the future?  
       ```answer  
       Just by having a complete, properly formatted inventory should be enough  
       to apply patches in a timely manner.  
       ```  
  
2. We often say in engineering, “Or you can do nothing”. This speaks to the possibility  
   of just accepting the situation and allowing a system to keep running.  
  
    1. Can you do that in this situation, or must this be corrected? Why or why not?  
       ```answer  
       No, we can't just "do nothing." This needs to be corrected. A  
       vulnerability in production systems is a security incident and needs to  
       be remediated ASAP. Now, if we have an acceptable amount of downtime  
       we'd probably patch these in cycles, a few at a time to keep downtime to  
       a minimum. But yeah, we can't do nothing if there are vulnerabilities  
       found within *all* systems.  
       ```  
  

## Definitions/Terminology

- IT Inventory: A complete list of all technological resources that an
  organization owns.  

- File formats (be able to identify and parse them with your tools): 

    - `.csv`: Comma-separated values.
    - `.ini`: Configuration file that uses key/value pairs structured in sections.  
        - Ansible supports this format for inventories.  
        - Often used in Windows/MS environments for system and application configuration.  
        - Originally derived from the word "initialization."  
    - `.yaml`: A structured data format that's often used for configuration.  
        - Used for writing Ansible playbooks and roles.  
        - Stands for "Yet Another Markup Lanugage"
        - ...or "Yaml Ain't Markup Language"

- Grouping: Identifying similar machines/components and organizing them together.  

- Variables (in relation to inventories): Key/value pairs that can be set to 
  describe properties or settings for inventory items. 

- Ranges (and their usefulness): Ranges allow you to specify a range of numbers
  within brackets, and will expand to the range listed. 
    - `[01:50]`: Specify `01` to `50` including the leading zero(es).  
    - `[01:50:2]`: Specify `01` to `50` including the leading zero(es) by **steps of two**. 
    - Useful for specifying ranges of IPs:
      ```yaml
      [servers]
      192.168.1.[01:50]
      ```
      Specifies a range of servers in the `192.168.1.01-50` range
    - We can also specify ranges of letters with the same notation.
        - `control-node-[a-z]`


## Notes During Lecture/Class:

### Links:

<https://stackoverflow.com/questions/3790454/how-do-i-break-a-string-in-yaml-over-multiple-lines>

<https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html>

### Terms:

### Useful tools:


## Lab and Assignment
Unit3 Lab from Lab book
<https://killercoda.com/het-tanis/course/Automation-Labs/Unit3_Inventories>


## Digging Deeper

1. Build some inventories like the ones here:
<https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html>
    1. Parse these down using ansible-inventory to see if you understand the syntax
       and formatting.
2. Run through this lab for understanding: <https://killercoda.com/hettanis/course/Ansible-Labs/02-Ansible-Host-File>


## Reflection Questions
1. What questions do you still have about this week?
2. How are you going to use what you’ve learned in your current role?
