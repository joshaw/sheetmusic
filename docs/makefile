# Created:  Mon 14 Nov 2016
# Modified: Fri 13 Apr 2018
# Author:   Josh Wainwright
# Filename: makefile

SHEETS := $(wildcard sheetmusic/*)

all: index.html

index.html: index.lua makefile $(SHEETS)
	lua index.lua > index.html
	#cp $$WIKIDIR/res/css.css .

commit:
	git add -A
	git commit -m "$$(date)"
