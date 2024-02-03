
# Hemingway Editor to MD

Ming Vase license - if it breaks you get to keep the pieces. No awards will be won for this work.

Yes I know, the [Hemingway Editor](https://hemingwayapp.com) will output to markdown, but you have to do it
every time. And if you are like me, you might want to use the output in a different
system (e.g. [Leanpub](https://leanpub.com)). This convertor will parse a Hemingway Editor file
and attempt to output Markdown (compatible with Leanpub).

If you use the git editing method for Leanpub, you can have your Hemingway files
in a directory called hemingway and use the example Makefile supplied here.

## hem2md

To use, install the perl JSON module. The following converts an Hemingway file into markdown. Unfortunately it does not work very well with non-Latin character sets (which is annoying if you are writing books on... non-Latin character sets, like me). I may look at reimplementing this in Go which makes such things a lot easier.

```
hem2md 20240130-February.hemingway >> myoutput.md
```

At the top of the file, there will be an HTML comment to warn that the file is automatically generated. This can be useful if you are working on a document set and are using a Makefile to process lots of Hemingway files (like me). If you supply -n it will remove the comment as sometimes it can confuse other processors.

## hem2jek

To use the Jekyll script, you need jekyll and ansi2txt from [colorized-logs](https://github.com/kilobyte/colorized-logs). Run the script in your jekyll site directory. For example, the following will parse the Hemingway file, take the title formatted with # and use that to create a jekyll post in _posts. If you supply -d you'll get a draft instead of a post.

```
hem2jek ~/Documents/Writing/Diet\ Blog/20240130-FebruaryRules.hemingway
```



Caveats:

- This filter will use * for italics, not _. (Hemingway extracts use _).
- We've only filtered scenarios we have seen coming from Hemingway files. There may be scenarios not covered
