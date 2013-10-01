OCAMLC=$(HOME)/.opam/4.00.1/bin/ocamlc
OCAML_INC_DIR=$(HOME)/.opam/4.00.1/lib/ocaml/caml
# OCAMLC=/opt/godi/bin/ocamlc
# OCAML_INC_DIR=/opt/godi/lib/ocaml/std-lib/caml

all:	sl

curses.cmo:	curses.ml
	$(OCAMLC) -c -g curses.ml

curses.o:	curses.c
	cc -c -I$(OCAML_INC_DIR) curses.c

sl.cmo:		sl.ml
	$(OCAMLC) -c -g -I +unix sl.ml

sl:	curses.o curses.cmo sl.cmo 
	$(OCAMLC) -custom -g -o sl unix.cma sl.cmo curses.o -cclib -lcurses

clean:
	rm -f curses.o curses.cmi curses.cmo sl.cmi sl.cmo sl
