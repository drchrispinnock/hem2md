
BINDIR=~/bin

all: hem2md.pl
	@cp hem2md.pl hem2md && chmod +x hem2md

install:
	@mkdir -p ${BINDIR}
	@install hem2md ${BINDIR}
