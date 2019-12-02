open Printf
open Str

let file = "input.txt";;

let parse line =
  let parts = Str.split (Str.regexp_string ",") line in
  List.map int_of_string parts;;

let replace l pos a = List.mapi (fun i x -> if i = pos then a else x) l;;

exception Invalid;;

let resolve values x =
  (List.nth values (List.nth values x));;

let rec evaluate values idx =
  (printf
    "Command %d -> %d,%d,%d,%d\n"
    idx
    (List.nth values idx)
    (resolve values (idx+1))
    (resolve values (idx+2))
    (resolve values (idx+3)));
  List.iter (printf "%d ") values;
  printf "\n";
  let op = List.nth values idx in
  match op with
  | 99 -> List.nth values 0
  | 1 -> evaluate
      (replace
        values
        (List.nth values (idx+3))
        ((resolve values (idx+1)) + (resolve values (idx+2))))
      (idx+4)
  | 2 -> evaluate
      (replace
        values
        (List.nth values (idx+3))
        ((resolve values (idx+1)) * (resolve values (idx+2))))
      (idx+4)
  | _ -> raise Invalid;;

let () =
  let ic = open_in file in
  try
    let line = input_line ic in
    let values = parse line in
    let start = 0 in
    printf "%d\n" (evaluate (replace (replace values 1 12) 2 2) start);

    (* in
    let values = parse line in
    List.iter (fun s -> printf "%d\n" s) values; *)

    flush stdout;                (* write on the underlying device now *)
    close_in ic                  (* close the input channel *)
  with e ->                      (* some unexpected exception occurs *)
    close_in_noerr ic;           (* emergency closing *)
    raise e                      (* exit with error: files are closed but
                                    channels are not flushed *)

  (* normal exit: all channels are flushed and closed *)