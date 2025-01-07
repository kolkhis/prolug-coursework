# ProLUG 101
## Unit 1 Worksheet

## Table of Contents
* [Unit 1 Worksheet](#unit-1-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 1 Discussion Post 1](#unit-1-discussion-post-1) 
    * [Unit 1 Discussion Post 2](#unit-1-discussion-post-2) 
* [Definitions/Terminology (with notes)](#definitionsterminology-with-notes) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
* [Lab and Assignment](#lab-and-assignment) 
    * [Digging Deeper](#digging-deeper) 
    * [Reflection Questions](#reflection-questions) 


## Instructions
Fill out this sheet as you progress through the lab and discussions.  
 
Turn in the sheet to scott.champine@simple2serious.com for grading and feedback.

## Discussion Questions:

### Unit 1 Discussion Post 1
* Using a 0-10 system, rate yourself on how well you think 
  you know each topic in the image. (You do not have to post this rating).  

* Answer these questions (here): 

1.	What do you hope to learn in this course?

```plaintext
I hope to learn more about fundamental Linux tools, and managing Linux systems; system hardening, core utils, user management, and managing resources for running services. I'm also very interested in learning about kubernetes, even though I have zero containerization experience.
I want to become familiar enough with Linux systems to be able to confidently speak on any aspect of systems with accuracy. 
```

2.	What type of career path are you shooting for?

```plaintext
This is a tough one for me. I've done some research and I think I'd like to shoot for an SRE
role. I'm also interested in DevOps, as I started my journey into tech with software
development and I do enjoy it, though once I jumped down the Linux rabbit hole I realized that I also really love doing Linux stuff. A role in which I could mainly do systems administration but also write code would be something I'd want to pursue. 
As someone who has been disabled for about a decade now, I'd love to get a well-paid job that allows me to work in a way that I am able to, doing something that I enjoy. In whatever form that may take. 
```

### Unit 1 Discussion Post 2
1.	Post a job that you are interested in from a local job website. (link or image)
    * https://www.indeed.com/viewjob?jk=da76e7061efe123b
2.	What do you know how to do in the posting?
    * Shell Scripting
    * _Some_ automation
    * _Some_ Linux security practices
    * _Some_ familiarity with cloud services and infrastructure
3.	What don't you know how to do in the posting?
    * Pretty much everything else
4.	What are you doing to close the gap? What can you do to remedy the difference?
    * I've been studying on my own time to try and close the gap between where I am and where I want to be. I've been trying to surround myself with people who have the same interests and goals, so that I might make some connections. I know if I keep doing these things, in addition to this course that Scoot put together for us (THANK YOU AGAIN), I'll end up where I want to be.

## Definitions/Terminology (with notes)

* Kernel - A thing that has access to the hardware. It runs everything - it's a
  collection of programs that are either native or loaded later that deal with
  everything.
    * `uname -r`
* OS Version - The version of the OS of the machine that you're on
    * `cat /etc/*release`
* Kernel Args - Kernel arguments to the system
    * `dmesg | head`
* Modules - Modules are programs that are loaded into the kernel. 
            These are usually loaded by the kernel itself, but can also be loaded
            by the user.  
    * `lsmod` lists loaded modules
    * `lspci` lists PCI devices (in a PCI/PCIe slot)
* Mount Points - Mount points are where the system will look for files to load into memory
    * All block devices are not necessarily disks, but all disks are block devices. HDDs, SSD, etc are all block
      devices.
    * Block devices and disks are mounted as `/dev/sda*` (or `sr*` for CD ROMs)
Text Editor - 

- Volatile: Means it's lost when the system is restarted.  
    

## Notes During Lecture/Class:
Links:

Terms:

Useful tools:

---

## Lab and Assignment
`Unit1_ProLUG_LabEssentials` - To be completed outside of lecture time

Start thinking about your project ideas (more to come in future weeks):

Topics:
1.	System Stability  
2.	System Performance  *
3.	System Security  *
4.	System monitoring  *
5.	Kubernetes  *
6.	Programming/Automation  *

You will research, design, deploy, and document a system that improves your 
administration of Linux systems in some way.

### Digging Deeper
1.	Use `vimtutor` and see how far you get. What did you learn that you did not know about vi/vim?
    * Nothing, I did vimtutor about 10 times before I started using it regularly.

2.	Go to https://vim-adventures.com/ and see how far you get.  
    What did you learn that you did not already know about vi/vim?
    * Nothing, I'm already pretty proficient with vim.

3.	Go to https://www.youtube.com/watch?v=d8XtNXutVto and see how far you get with vim.  
    What did you learn that you did not already know about vi/vim?
    * I learned about the `:earlier` and `:later` Ex commands.  
    * I learned that using `Alt-<norm-command>` in insert mode will execute the
      normal mode command and put you back into normal mode. E.g., `<Alt-k>` in
      insert mode will move you up one line and put you back into normal mode.  


### Reflection Questions
1.	What questions do you still have about this week?

All block devices are not necessarily disks, but are all disks block devices?


2.	How are you going to use what you’ve learned in your current role?

I'm not in a role, but I will try to close the gap between where I am and where I
want to be as a systems administrator.


