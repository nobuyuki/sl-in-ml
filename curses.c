#include <curses.h>

#include <mlvalues.h>
#include <memory.h>

value curses_initscr(value unit)
{
  CAMLparam1 (unit);
  CAMLreturn ((value) initscr());  /* OK to coerce directly from WINDOW * to
                              value since that's a block created by malloc() */
}

value curses_wrefresh(value win)
{
  CAMLparam1 (win);
  wrefresh((WINDOW *) win);
  CAMLreturn (Val_unit);
}

value curses_newwin(value nlines, value ncols, value x0, value y0)
{
  CAMLparam4 (nlines, ncols, x0, y0);
  CAMLreturn ((value) newwin(Int_val(nlines), Int_val(ncols),
                             Int_val(x0), Int_val(y0)));
}

value curses_addch(value c)
{
  CAMLparam1 (c);
  addch(Int_val(c));            /* Characters are encoded like integers */
  CAMLreturn (Val_unit);
}

value curses_mvwaddch(value win, value y, value x, value c)
{
  CAMLparam4 (win, y, x, c);
  mvwaddch((WINDOW *)win, Int_val(y), Int_val(x), Int_val(c));            /* Characters are encoded like integers */
  CAMLreturn (Val_unit);
}

value curses_addstr(value s)
{
  CAMLparam1 (s);
  addstr(String_val(s));
  CAMLreturn (Val_unit);
}

value curses_get_lines(value unit)
{
  CAMLparam1 (unit);
  CAMLreturn (Val_int(LINES));
}

value curses_get_cols(value unit)
{
  CAMLparam1 (unit);
  CAMLreturn (Val_int(COLS));
}

value curses_noecho(value unit)
{
  CAMLparam1 (unit);
  noecho();
  CAMLreturn (Val_unit);
}

value curses_endwin(value unit)
{
  CAMLparam1 (unit);
  endwin();
  CAMLreturn (Val_unit);
}

value curses_leaveok(value win, value b)
{
  CAMLparam2 (win, b); 
  CAMLreturn (leaveok((WINDOW *)win, Int_val(b)));  
}

value curses_scrollok(value win, value b)
{
  CAMLparam2 (win, b); 
  CAMLreturn (scrollok((WINDOW *)win, Int_val(b)));  
}

value curses_mvcur(value i1, value i2, value i3, value i4)
{
  CAMLparam4 (i1, i2, i3, i4);
  CAMLreturn (mvcur(Int_val(i1), Int_val(i2), Int_val(i3), Int_val(i4)));  
}



value curses_usleep(value i)
{
  CAMLparam1 (i);
  usleep(Int_val(i));
  CAMLreturn (Val_unit);
}
