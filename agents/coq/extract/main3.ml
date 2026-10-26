(* driver: untrusted search (cert3), then the verified checker (okb3 = Inst.all_okb) on its output *)
let () =
  let i1 = Sys.argv.(1) = "I1" in
  let k = int_of_string Sys.argv.(2) in
  let t0 = Unix.gettimeofday () in
  let v = Check3.cert3 i1 k in
  let t1 = Unix.gettimeofday () in
  Printf.printf "n=3 %s k=%d R=%d certificate size=%d (search %.1fs)\n%!" Sys.argv.(1) k (3+k) (List.length v) (t1 -. t0);
  let ok = Check3.okb3 i1 k v in
  let t2 = Unix.gettimeofday () in
  Printf.printf "n=3 %s k=%d all_okb=%b (check %.1fs)\n%!" Sys.argv.(1) k ok (t2 -. t1)
