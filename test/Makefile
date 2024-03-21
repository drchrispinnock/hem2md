
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
	@echo "Test.md" && diff -u ExpectedTest.md Test.md && echo "OK"
	@echo "Broken.md" && diff -u ExpectedBroken.md Broken.md && echo "OK"
	@echo "Utf.md" && diff -u ExpectedUtf.md Utf.md && echo "OK"
	
	
