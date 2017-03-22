# Created:  Mon 14 Nov 2016
# Modified: Wed 22 Mar 2017
# Author:   Josh Wainwright
# Filename: makefile

SHEETS := $(wildcard sheetmusic/*)

all: index.html

index.html: index.lua makefile $(SHEETS)
	lua index.lua > index.html
	cp $$WIKIDIR/res/css.css .

commit:
	git add -A
	git commit -m "$$(date)"
