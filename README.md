
# Hemingway Editor to MD

Yes I know, the [Hemingway Editor](https://hemingwayapp.com) will output to MD, but you have to do it
everytime. And if you are like me you want to use the output in a different
system (e.g. leanpub). This convertor will parse a Hemingway Editor file
and attempt to output Markdown (compatible with Leanpub).

If you use the git format for leanpub, you can have your hemingway files
in a directory called hemingway and use the example Makefile.

To use, install the perl JSON module. No awards will be won for this script.

Ming Vase license - if it breaks you get to keep the pieces.

Caveats:

- This filter will use * for italics, not _. (Hemingway extracts use _).
- Text in both bold and italics will not currently convert (Bug)
- We've only filtered scenarios we have seen coming from Hemingway files. There may be scenarios not covered

