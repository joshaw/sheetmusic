# Created:  Mon 14 Nov 2016
# Modified: Mon 14 Nov 2016
# Author:   Josh Wainwright
# Filename: makefile

SHEETS := $(wildcard sheetmusic/*)

all: index.html

index.html: index.lua makefile $(SHEETS)
	lua index.lua > index.html
	cp $$WIKIDIR/res/css.css .
