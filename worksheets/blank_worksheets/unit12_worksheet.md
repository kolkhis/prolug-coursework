# ProLUG 101  
## Unit 12 Worksheet  

## Table of Contents
* [Unit 12 Worksheet](#unit-12-worksheet) 
* [Instructions](#instructions) 
* [Discussion Questions](#discussion-questions) 
    * [Unit 12 Discussion Post 1](#unit-12-discussion-post-1) 
        * [First answer for Generating a Report](#first-answer-for-generating-a-report) 
        * [Second answer for Generating a Report](#second-answer-for-generating-a-report) 
    * [Unit 12 Discussion Post 2](#unit-12-discussion-post-2) 
    * [Unit 12 Discussion Post 3](#unit-12-discussion-post-3) 
* [Definitions/Terminology](#definitionsterminology) 
* [Notes During Lecture/Class](#notes-during-lectureclass) 
    * [Links](#links) 
    * [Terms](#terms) 
    * [Useful tools](#useful-tools) 
* [Lab and Assignment](#lab-and-assignment) 
* [Digging Deeper (optional)](#digging-deeper-optional) 
* [Reflection Questions](#reflection-questions) 


## Instructions  
Fill out this sheet as you progress through the lab and discussions. Hold onto all of your work to  
send to me at the end of the course.  

## Discussion Questions:  

### Unit 12 Discussion Post 1  
Your manager has come to you with another emergency.  
He has a meeting next week to discuss capacity planning and usage of the system with IT upper management.  
He doesn’t want to lose his budget, but he has to prove that the system utilization warrants spending more.  

1. What information can you show your manager from your systems?  

2. What type of data would prove system utilization? (Remember the big 4: compute,
   memory, disk, networking)  

3. What would your report look like to your manager?  


### Unit 12 Discussion Post 2
You are in a capacity planning meeting with a few of the architects.  
They have decided to add 2 more agents to your Linus sytems, Bacula Agent and an Avamar Agent.  
They expect these agents to run their work starting at 0400 every morning.  
7 day view  
24 hour view  

1. What do these agents do? (May have to look them up)  

2. Do you think there is a good reason not to use these agents at this timeframe?  

3. Is there anything else you might want to point out to these architects about these  
agents they are installing?  


### Unit 12 Discussion Post 3
Your team has recently tested at proof of concept of a new  
storage system. The vendor has published the blazing fast speeds that are capable of being  
run through this storage system. You have a set of systems connected to both the old  
storage system and the new storage system.  

1. Write up a test procedure of how you may test these two systems.  

2. How are you assuring these test are objective?  
    - What is meant by the term Ceteris Paribus, in this context?  



## Definitions/Terminology  

- Baseline:
- Benchmark:
- High watermark:
- Scope:
- Methodology:
- Testing:
- Control:
- Experiment:
- Analytics:


## Notes During Lecture/Class:  
### Links:  

### Terms:  

### Useful tools:  


## Lab and Assignment  
Unit 12 Lab Baselining and Benchmarking  
Continue working on your project from the Project Guide  
Topics:  
1. System Stability  
2. System Performance  
3. System Security  
4. System monitoring  *
5. Kubernetes  
6. Programming/Automation  *
You will research, design, deploy, and document a system that improves your  
administration of Linux systems in some way.  

## Digging Deeper (optional)  
1. Analyzing data may open up a new field of interest to you. Go through some of the  
free lessons on Kaggle, here: https://www.kaggle.com/learn  
    - What did you learn?  
    - How will you apply these lessons to data and monitoring you have already  
       collected as a system administrator?  

2. Find a blog or article that discusses the 4 types of data analytics.  
    - What did you learn about past operations?  
    - What did you learn about predictive operations?  
3. Download Spyder IDE (Open source)  
    - Find a blog post or otherwise try to evaluate some data.  
    - Perform some Linear regression. My block of code (but this requires some  
      additional libraries to be added. I can help with that if you need it.)  

```python  
import matplotlib.pyplot as plt  
from sklearn.linear_model import LinearRegression  
size = [[5.0], [5.5], [5.9], [6.3], [6.9], [7.5]]  
price =[[165], [200], [223], [250], [278], [315]]  
plt.title('Pizza Price plotted against the size')  
plt.xlabel('Pizza Size in inches')  
plt.ylabel('Pizza Price in cents')  
plt.plot(size, price, 'k.')  
plt.axis([5.0, 9.0, 99, 355])  
plt.grid(True)  
model = LinearRegression()  
model.fit(X = size, y = price)  
#plot the regression line  
plt.plot(size, model.predict(size), color='r')  
```


## Reflection Questions  
1. What questions do you still have about this week?  

2. How can you apply this now in your current role in IT? If you’re not in IT, how can you  
look to put something like this into your resume or portfolio?  

