
HEM2MD=perl ../hem2md.pl
SOURCES=$(wildcard *.hemingway)
OBJECTS=$(patsubst %.hemingway, %.md, $(SOURCES))

%.md:	%.hemingway
	@echo "Building $@"
	@${HEM2MD} $< > $@

all: $(OBJECTS)

clean:
	rm -f $(OBJECTS)

test: all
	@echo "Comparing with expected result"
	@diff -u ExpectedTest.md Test.md && echo "OK"
	@diff -u ExpectedBroken.md Broken.md && echo "OK"
	
	
