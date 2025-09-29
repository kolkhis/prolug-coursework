# Unit 2 Discussion Posts

## Unit 2 Discussion Post 1
Review the automation cycle presented in Unit 2 and answer the following questions.

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








<img src="https://cdn.discordapp.com/attachments/1421555551740887151/1421555551967645777/image.png?ex=68db7086&is=68da1f06&hm=9ddfe53d670882342050957a0f05cd90234174155035aacf6e1a674be5e52843&" />
