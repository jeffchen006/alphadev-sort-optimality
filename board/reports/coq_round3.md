# coq — round 3 report (2026-10-25 00:45)

## Done
1. **H3' proved in Rocq** (`agents/coq/src/SetModel.v`, no Admitted, assumptions = PrimInt63 only).
   Statement as proved: for an undone output j and m with "no m columns of A cover t_j on the strict perms"
   (decided by enumerating subsets of size ≤ m, with a completeness proof), every successful operation list has
   #non-cmp ops ≥ m + (#undone − 1). Proof: a cmov whose new column never takes value j on a strict perm keeps "no
   m-cover"; any other cmov lowers the cover bound by ≤ 1 (replace M by its two operands); such a "j-useful" cmov creates
   no other target (t_k(p) = k ≠ j); creating steps of different targets are different steps.
   Prune test (with H1, H2): prune iff for all x ≤ b: 2^x < class or b < x + max(und, x, und + m − 1).
   The Coq set checker now has enum's full rule set except NG: Lemma S, W, P, G, D, H1, und, H2, E3, H3'.
2. **Exact agreement with enum.** My own (untrusted) BFS with these rules gives exactly enum_out's counts
   (SYM=1, WEAK=0, I1): n = 3: K ≤ 9 135, K ≤ 10 2,219; n = 4: K ≤ 12 17, K ≤ 13 247, K ≤ 14 5,896. All checks true
   (K ≤ 14: no sort4 program with k ≤ 14, i.e. k_out(4) ≥ 15, claim posted). Strong evidence that the rule texts agree.
3. **Two checkers, one file.** lean-reflect's certificate `sort3_I1_k10.cert` (agreed format v1, 56,816 states) is
   accepted by the Coq checker (`set_okb = true`, 147 s; untrusted OCaml reader). Open question to lean-reflect: with my
   older rule set (no H2/H3') 26 entries failed, so their h may be stronger than hc + und — asked for the exact formula.
4. **Closed Rocq theorem, no extraction:** `sort3_lb10` (register model, R = 13) by native_compute: 7,459 s (2:06 h),
   1.5 GB, 1 core; TCB = Rocq kernel + native compiler. The vm_compute run of the same premise is still running
   (> 4 h CPU at report time).
5. **Format:** agreed (lean-reflect `CERT_FORMAT.md` v1); my reader reads it; enum has not exported yet.
6. **Speed for n = 4** (list columns): 6 → 14 states/s (precomputed relabelling list, canon tries only the
   relabellings with minimal flag key, transposed rows for keys/dead test, capped cover search, all with equality proofs).

## Numbers
| run | states | time | rate |
|---|---|---|---|
| sort3 set checker, K ≤ 10 (all rules) | 2,219 | 14 s + 10 s | ~220 states/s |
| lean-reflect file sort3 K ≤ 10 | 56,816 | 147 s check | ~390 states/s |
| sort4 set checker, K ≤ 13 | 247 | 20 s + 18 s | 14 states/s |
| sort4 set checker, K ≤ 14 | 5,896 | 1,119 s + 1,075 s, true | ~5 states/s (older binary) |
| enum sort4 K ≤ 18 | 55.8 M | 698 s, 16 threads | — |

## Assessment for sort4
At 14 states/s the K ≤ 18 certificate (55.8 M states) would take ~46 days on one core: not feasible. The cost per
successor is dominated by list columns of length 24 (O(W²) access) and by canonicalization over 24 relabellings.
Needed: packed columns (3-bit lanes in two int63, needs bit-level proofs), relabelling of packed columns by table,
incremental canonical form (only the new column changes), and parallel chunks (already proved). Realistic target:
~1,000× → K ≤ 18 in hours on 8–16 cores. This is a multi-round engineering task.

## Next
- Packed column instance (abstract interface `dec` is ready; prove lane-level specs of blend/cmp/permute).
- Ask enum for a K ≤ 15/16 export (format v1) as the first sort4 file to check with both checkers.
- Report the vm_compute time when it ends.
