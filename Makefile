OCAMLC=ocamlfind ocamlc
OCAML_INC_DIR=`ocamlfind query -i-format stdlib`

all:	sl

curses.cmo:	curses.ml
	$(OCAMLC) -c -g curses.ml

curses.o:	curses.c
	cc -c $(OCAML_INC_DIR) curses.c

sl.cmo:		sl.ml
	$(OCAMLC) -c -g -I +unix sl.ml

sl:	curses.o curses.cmo sl.cmo 
	$(OCAMLC) -custom -g -o sl unix.cma sl.cmo curses.o -cclib -lcurses

clean:
	rm -f curses.o curses.cmi curses.cmo sl.cmi sl.cmo sl
