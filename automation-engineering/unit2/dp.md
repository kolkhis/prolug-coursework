# Unit 2 Discussion Posts

## Unit 2 Discussion Post 1
Review the automation cycle presented in Unit 2 and answer the following questions.

<img src="https://cdn.discordapp.com/attachments/1421555551740887151/1421555551967645777/image.png?ex=68db7086&is=68da1f06&hm=9ddfe53d670882342050957a0f05cd90234174155035aacf6e1a674be5e52843&" />

1. What would you add or take away from this drawing?

I think the drawing is a pretty comprehensive overview of the elements of a 
good piece of automation should contain.  
If I had to add something, it might be to add some sort of secondary function.
It already does say "do not fail, generate variables and continue", but we may
also want to perform some other fallback function if the primary function
fails. Obviously this would be a case-by-case basis and it would be an optional
step in this process.  

2. When might you want something to fail during an automation?

We may want something to fail if the automation is the first step in a series
of events that rely on each other's success to continue. Like if we had a piece
of automation that first checked for dependencies that are required, and if
they do not exist on the system, install them. If the install fails, we may not
want to continue attempting to set up the "thing" the requires those
dependencies.  

Or, potentially if a system is just completely offline. 

That is to say, we would also want to report these things, assuming we're not
manually kicking off the automated process and won't catch the errors in
realtime.  

So if we're talking about "fail without reporting," I'd have to say... never.  
If anyone can think of a scenario in which you'd want to fail without reporting, please let me know.  

3. When might you not want an automation to fail?

If things are working correctly. We definitely wouldn't want it to fail in the case.

But really, maybe we're in a situation in which we're generating an automated
report. Reports can be time-sensitive, so we'd want to get it as soon as
possible. If we failed because a system was unreachable (or some other problem), 
then we would not get the report we needed until we went in and fixed the issue 
with that system. We would not want an automation to fail in that scenario.



## Unit 2 Discussion Post 2
Read about the pareto rule or the rule of 80/20.

1. What is the general stated rule, as you understand it?

The rule, as I understand it, is:
"80% of your errors come from 20% of your input"
It's not strictly about computer science either. It can also be applied to
business: 80% of sales come from 20% of clients. 

The Pareto rule doesn't require the numbers to be 80/20. They can be 70/30, or 90/10. 
They're also not even required to add up to 100. The main idea is that 
**a minority of causes/inputs are responsible for the majority of results/outputs**.  

2. Do you agree with the rule? Has this been your experience?

For the most part, yes. Within all of my projects, 80/20 seems like a
reasonable ratio. 

In writing software, 90% of my problems/bugs come from 10% of the code.  
In addition to that, 90% of my sales on Fiverr came from a single client. 

3. What examples can you find where this has proven true?

- Apple apparently found that 20% of their products generated 80% of their revenue.   
- Microsoft stated that 80% of software bugs originated from 20% of the code.  
- GM (General Moters) said that 20% of their factories produced 80% of their vehicles.    
- 20% of Starbucks store locations generated 80% of their sales.  
- The list goes on: <https://smartway.es/en/pareto-the-most-absurd-examples-confirming-the-80-20-rule/>  

4. What examples can you find where this has not proven true?

Maybe at a consumer grocery store. Everyone needs groceries, so assuming that
80% of sales come from 20% of clients may be a bit of a reach.  


