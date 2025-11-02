# Unit 3 Lab

This lab is designed as part of a larger set of instruction that is free from 
the Professional Linux Users Group (ProLUG). The lab book for this course can 
be found here: <https://professionallinuxusersgroup.github.io/course-books/pcae/unitindex>

You have found yourself in a bash shell. You are trying to better understand 
inventories so you can run your automations by inputting values given to you 
from other parts of your organization.

Run the .sh script and attempt to understand what it is doing.

---

Your organization has an API to hit to pull the names of servers. To simulate this, we are using earthquakes from the USGS in an API that should always be available.

Execute the api call and see if you can read the data.

```bash
/root/u3_script.sh
```

- What are the data showing?
    - it's showing earthquake magnitude, location, and the time it happened, in epoch
      format it seems.

- What does the script look like in bash?
  ```bash
  cat /root/u3_script.sh
  ```

- What tools or techniques were used to gather this data? Could you modify the api to call something else?
    - **Answer:**
        - Uses a `curl` to save response into a .json file, then parsed with `jq` to
          format the output.  
            - **side note:** I don't think this is an API endpoint: <https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson>, it seems to be a static file they make available daily.  
        - Could modify the URL with the given format for the API: 
          `https://earthquake.usgs.gov/fdsnws/event/1/[METHOD[?PARAMETERS]]`
          So we could maybe specify a timeframe.

Could you pipe this output to call only the fields between the "-", specifically the second field?

Read the provided users.csv file. This represents some data sent over to you by 
a project manager or other non-technical resource in your organization. They 
used a format they got the data in, and now you're going to have to use it.

```bash
cat /root/users.csv
```

- What do you notice about this data format? Can you parse this for just the first and third fields?
    - **Answer:** It's comma-delimited (CSV), so we could use `read`, `cut`, or `awk` to easily
      parse this

```bash
cat /root/users.csv | awk -F , '{print $1,$3}'
```

- Does this look correct to you? How might you use this data?
    - **Answer:** This looks correct. This can be used to glean insight into statstics like average ages
      and how many males vs. how many females.  

- How might you strip the header off as you use the data?
    - **Answer:** Use a condition for awk:
      ```bash
      awk -F, 'NR > 1 {print $1, $3}' /root/users.csv
      ```

If you need to regenerate the data use this script.
```bash
/root/u3_script_user_generator.sh
```

- Does it repopulate the data?
    - **Answer:** Yes, it generates new data

```bash
cat /root/users.csv
```

- Can you modify this script and generate other data? (use this as reference: <https://documenter.getpostman.com/view/19878710/2s93Jrwk3R>)
    - We could add another parameter to the API call to only generate female data
      ```bash
      curl -s "https://randomuser.me/api?inc=gender,dob,nat&results=10&gender=female&format=csv" > /root/users.csv
      ```
      (added `&gender=female` to this)

---

## Page 2
You have decided to verify the functionality of Python on your system to pull in and parse user information.

Run the scripts and modify them to fit your needs.



- Run the u3_script.py and look at what it shows you.
  ```bash
  /root/u3_script.py
  ```

- What are you shown?
    - **Answer:** It looks like earthquake information, showing magnitute, location, and
      time

- Inspect the file and see if you can figure out what it was doing.
  ```bash
  cat /root/u3_script.py
  ```

- Note: Modify with vi or vim. Can you make this show the lowest 10 items, ordered by magnitude?
    - **Answer:** Can change the sort functionality to not sort in reverse in order to
      print lowest magnitudes
      ```python
      earthquakes.sort(reverse=False, key=lambda x: x[0])
      ```

- Can you generate a python script that parses the /root/users.csv file? (What resources might you use to do this?)
    - **Answer:** A very simple script I wrote to simply print the data in a structured
      format:
      ```python
      #!/usr/bin/python3

      import csv;
  
      with open('./users.csv', 'r') as fh:
          data = fh.readlines()
  
      for ln in csv.reader(data):
          print(f"Line num: {ln}")
      ```

---

## Page 3
You have decided to interact with Ansible inventories.

Execute some playbooks to see their functionality.

Use the tool `ansible-inventory` to parse and understand your inventories.

---

Run the u3_script.yml and look at what it shows you.
```bash
ansible-playbook /root/u3_script.yml
```

- What are you shown?
    - **Answer:** It seems to be the full output of the file pulled from our endpoint, `all_day.geojson`

- Can you modify this output so show other interesting parts of the API calls?

- If you had to pull a specific field, could you do it?
    - Again, you don't know how data might come to you in your organization, so 
      this is an exercise in parsing things different ways.

Inspect your current inventory files.
```bash
cat /root/hosts
cat /root/hosts_example2
cat /root/hosts_example3
```


- What file type are these? (<https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html>)?
    - **Answer:** These are INI formatted ansible inventories.  

- What other file types might you use for inventories?
    - **Answer:** INI, YAML, JSON

- Do you have a preference on how the data are formatted, or where the variables are located on these?
    - **Answer:** I do. I prefer INI-style inventories for readability. The YAML variants
      of ansible inventories look like a game of jenga with one piece left at
      the bottom.
      The inventories should be applied to groups (if applicable), I think
      single-host inline variables are hard to maintain and don't work well if
      we need to scale.  

- Do you think some of this looks better formatted or do you prefer it as yaml?
    - **Answer:** I like the `hosts_example3` inventory most. This uses `:children` to make
      sub-groups containing other groups, and applies variables to entire
      groups rather than single-host variables -- though there are some for the
      two nodes, this would be my pick for an inventory to scale.  

Check the yaml versions of these files.
```bash
ansible-inventory -i /root/hosts --list -y
ansible-inventory -i /root/hosts_example2 --list -y
ansible-inventory -i /root/hosts_example3 --list -y
```


This is a very high level review of the many `ansible-inventory` commands.  
It is recommended that you parse and play with these files more, as the 
concepts will continue to be built on in later labs.




