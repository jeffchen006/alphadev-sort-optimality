let () =
  let i1 = Sys.argv.(1) = "I1" in
  let k = int_of_string Sys.argv.(2) in
  let t0 = Unix.gettimeofday () in
  let v = Scheck3.scert3 i1 k in
  let t1 = Unix.gettimeofday () in
  let nv = List.length v in
  Printf.printf "set model n=3 %s k=%d certificate size=%d (search %.1fs)\n%!" Sys.argv.(1) k nv (t1 -. t0);
  let cnt = Array.make (k+1) 0 in
  List.iter (fun (_, b) -> cnt.(k - b) <- cnt.(k - b) + 1) v;
  Array.iteri (fun d c -> Printf.printf "g=%d: %d states\n" d c) cnt;
  let ok = Scheck3.sok3 i1 k v in
  let t2 = Unix.gettimeofday () in
  Printf.printf "set model n=3 %s k=%d scertifies=%b (check %.1fs, %.0f states/s)\n%!" Sys.argv.(1) k ok (t2 -. t1) (float nv /. (t2 -. t1))
