type window                   (* The type "window" remains abstract *)
external initscr: unit -> window = "curses_initscr"
external endwin: unit -> unit = "curses_endwin"
external refresh: unit -> unit = "curses_refresh"
external wrefresh : window -> unit = "curses_wrefresh"
external newwin: int -> int -> int -> int -> window = "curses_newwin"
external mvwin: window -> int -> int -> unit = "curses_mvwin"
external addch: char -> unit = "curses_addch"
external mvwaddch: window -> int -> int -> char -> unit = "curses_mvwaddch"
external addstr: string -> unit = "curses_addstr"
external mvwaddstr: window -> int -> int -> string -> unit = "curses_mvwaddstr"

external noecho: unit -> unit = "curses_noecho"
external leaveok: window -> bool -> unit = "curses_leaveok"
external scrollok: window -> bool -> unit = "curses_scrollok"
external mvcur: int -> int -> int -> int -> unit = "curses_mvcur"
external endwin: unit -> unit = "curses_endwin"

external get_lines : unit -> int = "curses_get_lines";;
external get_cols : unit -> int = "curses_get_cols";;
(* lots more omitted *)

external usleep : int -> unit = "curses_usleep";;
