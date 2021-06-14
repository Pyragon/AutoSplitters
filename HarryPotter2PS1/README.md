# Harry Potter and the Chamber of Secrets

In this directory you will find an autosplitter for Harry Potter and the Chamber of Secrets for PS1.  
You will also find information I have gathered to make this autosplitter, for anyone that is interested.

Any feedback is appreciated.

## Current Issues

The start timer is activated once the 'stage' byte in memory is incremented from 1 to 2.  
This happens about .5s-1s after the 'Yes' button is pressed on the proceed menu. As I understand it, the current speedrun standard is to start the run as soon as you hit 'Yes', and therefor, this autosplitter may cause some delay.

I will try to find an alternative to this, but until then, I would love some feedback on how to proceed.

## Misc

This autosplitter is handled by listening to a 'stage' byte in memory. This stage increments any time you see the 'Loading' screen in-game. This isn't exactly a fool-proof method, but I can't seem to find anything else. Any feedback appreciated.

This screen also appears after every death. This script tries to look for any death, and account for it, (minus the intentional death in DADA). If you ever encounter splits not triggering as they should, please create an issue, and provide any information you can, and I will try to look into it.