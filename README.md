
# Hemingway Editor to MD

Yes I know, the Hemingway Editor will output to MD, but you have to do it
everytime. And if you are like me you want to use the output in a different
system (e.g. leanpub). This convertor will parse a Hemingway Editor file
and attempt to output Markdown (compatible with Leanpub).

If you use the git format for leanpub, you can have your hemingway files
in a directory called hemingway and use this Makefile:

HEM2MD=/usr/bin/hem2md
TARGETDIR=../manuscript
SOURCES=$(wildcard *.hemingway)

%.md:	%.hemingway
	${HEM2MD} $< $@

all: $(OBJECTS)

clean:
        rm -f $(OBJECTS)

install: all
	@for i in *.md; do \
                echo "Installing $$i";          \
                cp $$i ${TARGETDIR}; done

