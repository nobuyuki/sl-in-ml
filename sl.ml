(* sl.ml --- Ocaml implementation of Toyoda's sl(1). *)

open Curses;;

(* Options *)
let accident = ref false;;		(* -a *)
let logo = ref false;;			(* -l *)
let fly = ref false;;			(* -F *)

let specs = [
  ("-a", Arg.Set accident, "Accident");
  ("-F", Arg.Set fly, "Fly!");
  ("-l", Arg.Set logo, "long");
];;

let usage_msg = "sl [-aFl]";;


(*  *)
let my_mvwaddstr w y x s =
  let lines = get_lines () in
    if 0 <= y && y < lines then
      let cols = get_cols () in 
      let len = String.length s in
      let sx = x in
      let ex = x + len in
	for x' = sx to ex - 1 do
	  if 0 <= x' && x' < cols then
	    mvwaddch w y x' s.[x' - sx];
	done
;;


(* Smoke handling. *)
module Smoke = struct

  let smokeptns = 16;;
  let sum = ref 0;;
  let smoke = [|
    [|
      "(   )"; "(    )"; "(    )"; "(   )"; "(  )";
      "(  )" ; "( )"   ; "( )"   ; "()"   ; "()"  ;
      "O"    ; "O"     ; "O"     ; "O"    ; "O"   ;
      " "                                          
    |];
    [|
      "(@@@)"; "(@@@@)"; "(@@@@)"; "(@@@)"; "(@@)";
      "(@@)" ; "(@)"   ; "(@)"   ; "@@"   ; "@@"  ;
      "@"    ; "@"     ; "@"     ; "@"    ; "@"   ;
      " "                                          
    |];
  |];;

  let eraser = [|
    "     "; "      "; "      "; "     "; "    ";
    "    " ; "   "   ; "   "   ; "  "   ; "  "  ;
    " "    ; " "     ; " "     ; " "    ; " "   ;
    " "                                          
  |];;

  type smokes = {
    y: int;
    x: int;
    ptrn: int;
    kind: int;
  };;

  let s = Array.make 1000 { y = 0; x = 0; ptrn = 0; kind = 0};;

  let add_smoke w y x =
    let dy = [|  2;  1; 1; 1; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0; 0 |] in
    let dx = [| -2; -1; 0; 1; 1; 1; 1; 1; 2; 2; 2; 2; 2; 3; 3; 3 |] in
      if x mod 4 = 0 then begin
	for i = 0 to !sum - 1 do
	  my_mvwaddstr w s.(i).y s.(i).x eraser.(s.(i).ptrn);
	  s.(i) <- {
	    y = s.(i).y - dy.(s.(i).ptrn);
	    x = s.(i).x + dx.(s.(i).ptrn);
	    ptrn = s.(i).ptrn + (if s.(i).ptrn < smokeptns - 1 then 1 else 0);
	    kind = s.(i).kind;
	  };
	  my_mvwaddstr w s.(i).y s.(i).x smoke.(s.(i).kind).(s.(i).ptrn);
	done;
	my_mvwaddstr w y x smoke.(!sum mod 2).(0);
	s.(!sum) <- {
	  y = y;
	  x = x;
	  ptrn = 0;
	  kind = !sum mod 2;
	};
	incr sum
      end
  ;;
end;;

(* Man handling *)
let add_man len w y x =
  let man = [| [|""; "(O)"|]; [|"Help!"; "\\O/"|] |] in
    for i = 0 to 1 do
      my_mvwaddstr w (y + i) x man.((len + x) / 12 mod 2).(i);
    done
;;

(* SL handling *)
module Sl = struct
  let logolength = 84;;
  let logoheight = 6;;
  let logofunnel = 4;;
  let logopatterns = 6;;

  let add_man = add_man logolength;;

  let add_sl w x =
    let logo = [|
      "     ++      +------ ";
      "     ||      |+-+ |  ";
      "   /---------|| | |  ";
      "  + ========  +-+ |  ";
    |] in
    let lwhl = [|
      [| " _|--O========O~\\-+  ";
	 "//// \\_/      \\_/    ";|];
      
      [| " _|--/O========O\\-+  ";
	 "//// \\_/      \\_/    ";|];
      
      [| " _|--/~O========O-+  ";
	 "//// \\_/      \\_/    ";|];
      
      [| " _|--/~\\------/~\\-+  ";
	 "//// \\_O========O    ";|];
      
      [| " _|--/~\\------/~\\-+  ";
	 "//// \\O========O/    ";|];
      
      [| " _|--/~\\------/~\\-+  ";
	 "//// O========O_/    ";|];
    |] in
      
    let delln =  [|"                     "|] in
      
    let sl = Array.map
	       (fun x -> Array.concat [logo; lwhl.(x); delln] )
	       [|0;1;2;3;4;5|] in
      
    let coal = [|
      "____                 ";
      "|   \\@@@@@@@@@@@     ";
      "|    \\@@@@@@@@@@@@@_ ";
      "|                  | ";
      "|__________________| ";
      "   (O)       (O)     ";
      "                     ";
    |] in
    let car  = [|
      "____________________ ";
      "|  ___ ___ ___ ___ | ";
      "|  |_| |_| |_| |_| | ";
      "|__________________| ";
      "|__________________| ";
      "   (O)        (O)    ";
      "                     ";
    |] in
    let add_sl' w y py1 py2 py3 =
      for i = 0 to logoheight do
	my_mvwaddstr w (y + i) x sl.((logolength + x) / 3 mod logopatterns).(i); 
	my_mvwaddstr w (y + i + py1) (x + 21) coal.(i);
	my_mvwaddstr w (y + i + py2) (x + 42) car.(i);
	my_mvwaddstr w (y + i + py3) (x + 63) car.(i);
      done;
      if !accident then begin
	add_man w (y + 1) (x + 14);
	add_man w (y + 1 + py2) (x + 45);  add_man w (y + 1 + py2) (x + 53);
	add_man w (y + 1 + py3) (x + 66);  add_man w (y + 1 + py3) (x + 74);
      end;
      Smoke.add_smoke w (y - 1) (x + logofunnel)
    in
      if x < (- logolength) then raise Exit;
      if !fly then
	add_sl' w ((x / 6) + (get_lines ()) - ((get_cols ()) / 6) - logoheight) 2 4 6
      else
	add_sl' w ((get_lines ()) / 2 - 3) 0 0 0;
  ;;
end;;

(* D51 handling *)
module D51 = struct
  let d51length = 83;;

  let add_man = add_man d51length;;

  let add_d51 w x =
    let d51hight = 10 in
    let d51funnel = 7 in
    let d51patterns = 6 in
    let d51str = [|
      "      ====        ________                ___________ " ;
      "  _D _|  |_______/        \\__I_I_____===__|_________| " ;
      "   |(_)---  |   H\\________/ |   |        =|___ ___|   " ;
      "   /     |  |   H  |  |     |   |         ||_| |_||   " ;
      "  |      |  |   H  |__--------------------| [___] |   " ;
      "  | ________|___H__/__|_____/[][]~\\_______|       |   " ;
      "  |/ |   |-----------I_____I [][] []  D   |=======|__ "
    |] in
      
    let d51whl = [|
      [|
	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ";
	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ";
	"  \\_/      \\O=====O=====O=====O_/      \\_/            "
      |];
      [|
	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ";
	" |/-=|___|=O=====O=====O=====O   |_____/~\\___/        ";
	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            "
      |];
      [|
	"__/ =| o |=-O=====O=====O=====O \\ ____Y___________|__ ";
	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ";
	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            ";
      |];
      [|
	"__/ =| o |=-~O=====O=====O=====O\\ ____Y___________|__ ";
	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ";
	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            "
      |];
      [|
	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ";
	" |/-=|___|=   O=====O=====O=====O|_____/~\\___/        ";
	"  \\_/      \\__/  \\__/  \\__/  \\__/      \\_/            "
      |];
      [|
	"__/ =| o |=-~~\\  /~~\\  /~~\\  /~~\\ ____Y___________|__ ";
	" |/-=|___|=    ||    ||    ||    |_____/~\\___/        ";
	"  \\_/      \\_O=====O=====O=====O/      \\_/            ";
      |];
    |] in
      
    let d51del = [|"                                                      "|] in
      
    let coal = [|
      "                              ";
      "                              ";
      "    _________________         ";
      "   _|                \\_____A  ";
      " =|                        |  ";
      " -|                        |  ";
      "__|________________________|_ ";
      "|__________________________|_ ";
      "   |_D__D__D_|  |_D__D__D_|   ";
      "    \\_/   \\_/    \\_/   \\_/    ";
    |] in

    let coaldel = [|"                              "|] in

    let d51 = Array.map
	       (fun x -> Array.concat [d51str; d51whl.(x); d51del] )
	       [|0;1;2;3;4;5|] in

    let coal = Array.append coal coaldel in

      if x < - d51length then raise Exit;
      let dy = ref 0 in
      let y = ref ((get_lines ()) / 2 - 5) in
	if !fly then begin
	  y := (x / 7) + (get_lines ()) - ((get_cols ()) / 7) - d51hight;
	  dy := 1;
	end;
	for i = 0 to d51hight do
	  my_mvwaddstr w (!y + i)  x d51.((d51length + x) mod d51patterns).(i);
	  my_mvwaddstr w (!y + i + !dy) (x + 53) coal.(i);
	done;
	
	if !accident then begin
	  add_man w (!y + 2) (x + 43);
	  add_man w (!y + 2) (x + 47)
	end;
	Smoke.add_smoke w (!y - 1) (x + d51funnel)
  ;;
end;;


let main () =
  Arg.parse specs (fun _ -> ()) usage_msg;
  let stdscr = initscr() in
    ignore(Sys.signal Sys.sigint Sys.Signal_ignore);
    noecho();
    leaveok stdscr true;
    scrollok stdscr false;

    (try 
       let add = if not !logo then D51.add_d51   else Sl.add_sl in
       let len = if not !logo then D51.d51length else Sl.logolength in
	 for x = (get_cols ()) - 1 downto - len do
	   add stdscr x;
	   wrefresh stdscr;
	   usleep 20000;
	 done
     with Exit -> ());
    mvcur 0 ((get_cols ()) - 1) ((get_lines ()) - 1) 0;
    endwin ();
;;

(* starup *)
let _ = main ();;
