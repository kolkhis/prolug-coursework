# Digital Analytics

## Tag Management Platform
Tag Management Platforms (or Tag Management Sytems/TMS) are configurable JS libraries
that capture metadata -- Where the user came from (google, url in search bar, etc.),
and other behavioral data that comes from the user.  


Ex, someone clicks "add to cart" -- This data is of interest to Facebook, Twitter,
or anywhere else that the company advertises. 
Each consumer of the behavioral data will require a different schema for this data,
and will perhaps request different data points.  

## Tools and Tech

Focus: Data capture.  

- Google Analytics && Google Tag Manager
- JavaScript
- Python
- SQL (e.g., for sanity checking aggregate data)


GTM -- Google Tag Manager: #1 by market share, low barrier to entry. Free.  

Universal analytics (Gone now) -> Google Analytics 4 


## How user data is collected

User -> Types in website. Browser request webpage. User gets html/css/etc. In the
initial request it will include the JS for the tag management system. JS executes. 
cookies will also be sent. They will be used to recognize repeat users.  

JS sends a request to the tracking server, and finally generates reports.  



## Consider this

- Easy to break into the field (low barrier to entry)
- Lots of demand
- Contant talent shortae
- Pays well
- NOT BUSINESS CRITICAL
    - No on-call schedule
    - No weekend patching
    - etc

## How to start?
- Learn Google Analytics - what it can do, how it works, etc.  
- Learn the fundamentals of Google Tag Manager
- Complete a basic implementation of google analytics via google tag manager (on a
  personal site, friend's site, etc)
- Keep learning

## Resources
- Measure Slack
Analytics academy - Google Analytics Analysis Invividual Qualification Exam
Simo Ahava's Blog: Great blog for industry
Analytics Mania: Great blog for industry
Measure School: Has free content. Also has a paid offering for courses etc.  



Google Analytics Demo Account (or a real account on googleanalytics.com)
Learning JS


Questions:

Do the bots introduce any noise to the data ?

- Absolutely. The bot data is noise. You want real data from real users.  
    - Up to 40% of data could be bot data.
    - Curtail this with vendors that deal with bot detection and scoring at the
      firewall.  
    - Bots can be adjusted to get around heuristics for detection.  

Does it buffer user interaction with UI elements ? Because sending a request on every action can be slow



 What did you do to get into the industry? Where should they study/spend their time?



 ---

 # Turtles all the way down -- Designing the Design Docs
 Presented by Will Frye

Why write design docs? why is it important?
- skill development (writing)
- Flywheel (virtuous cycle)
- Problem/domain identification
- Forcing function
- COE/After action reports

We really need to understand the problem space when we're trying to solve something.  



---

What is a design doc?

> "I think, to most people, scripting is a lot like obscenity. I can't define it, but
> I'll know it when I see it" - Larry Wall (creator or Perl)

It's a way for us to identify the problem, scope the problem, understand the
constraints, the solution, and the lifecycle of the problem.  

Side effect: Way to avoid minimize getting paged into an event in the middle of the
night because of prior "questionable" decision.  

---

Design: Engineering at Scale

Systems Engineering: You're tying to build something that will be effective at
scaling.  

---

Classification (Doc Familiaes)

- One-pager: The go-to. The file that you reference when building or troubleshooting.  
- Six-pager: Longer design doc that is not quite a PRFAQ
- Decision doc: Making a decision
- Technical Design doc: Can be very long with multiple appendices
- PRFAQ: Explaining problem, your solution to problem, etc
    - Public Release / Frequently Asked Questions
- ... and many more

Each has a cost.  

---

Anatomy of a (good) Design doc

"Loose" list:

- Problem / Background (problem you're trying to solve -- explain why you're making v2)
    - Why didn't we just start with this in the first place? Give Background
- Proposed solution: Hash out in a sentence or two what you're doing and why.  
- Alternatives considered: Is there already a tool that does this? 
    - What already exists? What already does this? Is there a problem with these tools?
- Costs
    - Tangible
        - Infra (EC2, S3)
    - Unseen
        - **Maintining the code you write**
        - Nothing is for free. Is there repercussions for launching this thing?
        - E.g., launch a service, you can open yourself up to legal liabaility.  

- Testing and Validation
- Data Design / Access Patterns: Common things that users are gonna do.  
    - Web app that shows users tickets and allows them to manage them.  
    - When we make a change to an API, what will it affect? How will it affect the
      user experience?

- Architecture Diagrams: The CLI tool that might have a primary function with some 
- Lifecycle 
    - Launch / Maintenance / Sunset


---

> Create a small design doc for a script that bulk adds users to a system from a CSV

# Script -- `append_users`

## Overview
Manually adding users to our internal database with the required information manually
is a tedious process and is an easily automated task.  

The solution to appending all new users manually to our database is a bash script to
read a list of users from a CSV file and takes care of appending.  

This is a utility script that appends users to the database by reading in data in CSV format.  

Why use this script instead of, say, a JS library? The answer is simple. It is lightweight, and uses a native Linux REPL -- Bash. It's easily maintained if our user database schema changes, it only requires parsing an extra field.  

---

The input file should be a `.csv` file that contains user(s) in the following example format:
```csv
username,nickname,prilvelege,
sending_grounds,will,admin,
het_tanis, scoot, admin,
kolkhis,kolkhis,admin,
```

This is the format in which the data will be appended to the database.  

The first line is only there for clarity and portability and always must contain the names of the fields that the data will be going into in the database.  

---

Usage:
```bash
./append_users /path/to/input_file.csv
```

You can validate the script works by getting a user count before and after running the script with new users.  

Duplicates are skipped by default. So, if you have duplicate entries in your CSV
file, or have entries in your CSV file that already exist within the database, they
will be skipped.  


---















An alternative input format can be 

The 



(pretend it has some options)





---



