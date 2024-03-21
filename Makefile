
BINDIR=${HOME}/bin
TARGETS=    hem2jek hem2md hem2md_go
#TARGETS=    hem2jek hem2md

all: ${TARGETS}

hem2jek: hem2jek.sh
	@echo "===> hem2jek"
	@sed -e "s|@BINDIR@|${BINDIR}|g" hem2jek.sh > hem2jek

hem2md: hem2md.pl
	@echo "===> hem2md"
	@cp hem2md.pl hem2md && chmod +x hem2md

hem2md_go: hem2md_go.go
	@echo "===> Go version of hem2md"
	@go build hem2md_go.go

install: all
	@echo "===> Installing in ${BINDIR}"
	@mkdir -p ${BINDIR}
	@install ${TARGETS} ${BINDIR}

clean:
	@rm ${TARGETS}
