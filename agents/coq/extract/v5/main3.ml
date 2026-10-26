(* driver (trusted, small): untrusted search, then pre3 (hypotheses + root) and N chunk checks in N forked
   processes. Inst.lower_bound_par: pre3 = true and chunk3 ... i = true for all i < N give the lower bound.
   Note: chunk3 is called on the table (build V) computed once before fork; Inst.chunk_okb computes the same
   table (build V) inside, so this is the same value. *)
let () =
  let i1 = Sys.argv.(1) = "I1" in
  let k = int_of_string Sys.argv.(2) in
  let nproc = int_of_string Sys.argv.(3) in
  let t0 = Unix.gettimeofday () in
  let v = Check3.cert3 i1 k in
  let t1 = Unix.gettimeofday () in
  let nv = List.length v in
  Printf.printf "n=3 %s k=%d R=%d certificate size=%d (search %.1fs)\n%!" Sys.argv.(1) k (3+k) nv (t1 -. t0);
  let pre = Check3.pre3 i1 k v in
  let m = Check3.table3 v in
  let t2 = Unix.gettimeofday () in
  Printf.printf "pre3=%b (hypotheses + root, table build %.1fs)\n%!" pre (t2 -. t1);
  let pids = List.init nproc (fun i ->
    match Unix.fork () with
    | 0 -> exit (if Check3.chunk3 i1 k m v nproc i then 0 else 1)
    | pid -> pid) in
  let ok = List.fold_left (fun acc pid ->
    match Unix.waitpid [] pid with
    | (_, Unix.WEXITED 0) -> acc
    | _ -> false) true pids in
  let t3 = Unix.gettimeofday () in
  Printf.printf "n=3 %s k=%d chunks=%d all chunks ok=%b  RESULT=%b (check %.1fs, %.0f states/s)\n%!"
    Sys.argv.(1) k nproc ok (pre && ok) (t3 -. t2) (float nv /. (t3 -. t2))
