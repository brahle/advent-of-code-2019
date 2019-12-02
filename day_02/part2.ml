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
    for noun = 0 to 99 do
      for verb = 0 to 99 do
        try
          let res = (evaluate (replace (replace values 1 noun) 2 verb) 0) in
          if res = 19690720 then printf "%d,%d -> %d\n" noun verb res;
        with e ->
          if 0 = 1 then printf "%d,%d -> exception\n" noun verb;
      done
    done;

    flush stdout;
    close_in ic
  with e ->
    close_in_noerr ic;
    raise e
