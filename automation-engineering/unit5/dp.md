# Unit 5 Discussion Posts

## Unit 5 Discussion Post 1
You know about variable precedence and have decided to study it for your Ansible playbooks.  
Read <https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html> and 
answer the following questions:

1. What is variable precedence and why should it matter?

    - Variable precedence is the order in which variables are evaluated.  
      This matters because those variable assignments evaluated last will be the ones 
      that take effect inside the play.  
      Setting default values for variables is handy, but you need to know which
      variable assignments (and where they happen) will take priority.  

2. What does it mean to register a variable, and how is that variable used in the playbook?

    - Registering a variable will typically save the output of a task into the
      variable itself.  
      The variable can be used in the play however you want, but we need to be
      aware that when we access the variable, it's in a JSON-type format, so we
      use dot notation to scope into the specific value that we need.  

3. How might variables be useful at the end of an automation, in relation to reporting out what happened in the playbook?

    - Variables can be extremely useful at the end of automation to generate
      reports (e.g., using jinja templates that use variables to populate the
      report body).  


## Unit 5 Discussion Post 2

You've stumbled on a playbook and you're trying to figure out what the following line means:

You have reviewed filters 
<https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html#providing-default-values>
and think you have a good handle on what is happening.

1. What is the variable name being called?

2. What is the default value if that variable does not exist or is not populated?

3. What is the reason this might be nice in your executions if you want them always to complete?

4. Is there a danger to always setting default values?

5. Or another way to ask that, is there a tradeoff between always finishing and 
   sometimes having incorrectly set values?

6. Where will you use these in your automations?



