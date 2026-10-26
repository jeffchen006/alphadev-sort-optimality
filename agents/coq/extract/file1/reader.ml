(* UNTRUSTED reader of the agreed certificate format (agents/lean-reflect/CERT_FORMAT.md).
   It only builds the list V given to the verified test okfile3 (= SetList.set_okb); a reader bug can only make
   the test fail. usage: reader FILE *)
open Fcheck3
let () =
  let file = Sys.argv.(1) in
  let ic = open_in file in
  let hdr = input_line ic in
  let field k = let re = Str.regexp (k ^ "=\\([^ ]*\\)") in
    ignore (Str.search_forward re hdr 0); Str.matched_group 1 hdr in
  let n = int_of_string (field "n") and kk = int_of_string (field "K") and i1 = field "iset" = "I1" in
  if n <> 3 then failwith "this reader instance is for n=3";
  let wl = String.split_on_char ' ' (input_line ic) in
  let fw = Array.of_list (List.tl wl) in               (* file test t -> digit string *)
  let mine = Array.of_list (List.map (fun r -> String.concat "" (List.map string_of_int r)) reps3_out) in
  let m = Array.length mine in
  let tof = Array.map (fun s -> let r = ref (-1) in Array.iteri (fun t f -> if f = s then r := t) fw;
                          if !r < 0 then failwith ("test missing: " ^ s); !r) mine in
  let reorder s = List.init m (fun w -> Char.code s.[tof.(w)] - 48) in
  let cl = String.split_on_char ' ' (input_line ic) in
  let nc = int_of_string (List.nth cl 1) in
  let cols = Array.make nc [] in
  for _ = 1 to nc do
    match String.split_on_char ' ' (input_line ic) with
    | [id; c] -> cols.(int_of_string id) <- reorder c
    | _ -> failwith "bad C line"
  done;
  let sl = String.split_on_char ' ' (input_line ic) in
  let ns = int_of_string (List.nth sl 1) in
  let tbl = Hashtbl.create (2 * ns) in
  for _ = 1 to ns do
    match String.split_on_char ' ' (input_line ic) with
    | g :: fl :: dn :: _gamma :: ids ->
      let g = int_of_string g and dn = int_of_string dn in
      let fl = List.map (function 0 -> Eq | 1 -> Lt | _ -> Gt) (reorder fl) in
      let dl = List.init n (fun j -> (dn lsr j) land 1 = 1) in
      let cs = List.map (fun i -> cols.(int_of_string i)) (List.filter (fun x -> x <> "") ids) in
      let st = mark3 (mkst3 cs fl dl) in
      let b = kk - g in
      (match Hashtbl.find_opt tbl st with
       | Some b0 when b0 >= b -> ()
       | _ -> Hashtbl.replace tbl st b)
    | _ -> failwith "bad S line"
  done;
  close_in ic;
  let v = Hashtbl.fold (fun st b acc -> (st, b) :: acc) tbl [] in
  Printf.printf "read %d state lines, %d distinct canonical states\n%!" ns (List.length v);
  let t0 = Unix.gettimeofday () in
  if Array.length Sys.argv > 2 then begin
    let m = build3 v in
    let nm = List.length (List.filter (fun (st, _) -> not (markedb3 st)) v) in
    Printf.printf "diag: unmarked entries %d; root in table: %b\n%!" nm
      (List.exists (fun (st, b) -> st = root3) v);
    let bad = List.filter (fun e -> not (entry3 i1 m e)) v in
    Printf.printf "diag: failing entries %d\n%!" (List.length bad);
    let pc c = String.concat "" (List.map string_of_int c) in
    let pf f = String.concat "" (List.map (function Eq -> "0" | Lt -> "1" | Gt -> "2") f) in
    let ps st = Printf.sprintf "A={%s} f=%s dn=%s" (String.concat "," (List.map pc st.sA)) (pf st.sf)
        (String.concat "" (List.map (fun x -> if x then "1" else "0") st.sdn)) in
    List.iteri (fun i (st, b) -> if i < 3 then begin
      Printf.printf "  fail: budget %d %s\n" b (ps st);
      List.iter (fun o -> let c = cost3 o in if c <= b then begin
        let raw = step3 st o in let u = canon3 raw in
        let covered = dom3 raw st || (match look3 m u with Some b' -> b - c <= b' | None -> false) || prune3 u (b - c) in
        if not covered then Printf.printf "    uncovered succ (cost %d, b'=%d, in table: %s): %s\n" c (b - c)
          (match look3 m u with Some b' -> string_of_int b' | None -> "no") (ps u) end) (ops3 i1 st) end) bad
  end;
  let ok = okfile3 i1 v kk in
  Printf.printf "file %s: n=3 K=%d set_okb=%b (check %.1fs)\n%!" file kk ok (Unix.gettimeofday () -. t0)
