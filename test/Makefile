
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
	@for o in $(OBJECTS); do \
		printf "$$o: "; diff -u Expected$$o $$o >/dev/null; \
		 	if [ "$$?" = "0" ]; then echo "OK"; else \
				echo "FAIL"; fi; done

