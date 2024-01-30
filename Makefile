
BINDIR=${HOME}/bin
TARGETS=    hem2jek hem2md

all: ${TARGETS}

hem2jek: hem2jek.sh
	@sed -e "s|@BINDIR@|${BINDIR}|g" hem2jek.sh > hem2jek

hem2md: hem2md.pl
	@cp hem2md.pl hem2md && chmod +x hem2md

install: all
	@mkdir -p ${BINDIR}
	@install ${TARGETS} ${BINDIR}

clean:
	@rm ${TARGETS}
