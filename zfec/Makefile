# This is not part of the main build but is included for reference only. 
# It is used to generate tables.c, but that's been done and the result committed to source control.

tables.h:	write.c fec.c fec.h Makefile
	touch tables.h
	gcc -o write write.c && ./write > tables.h
