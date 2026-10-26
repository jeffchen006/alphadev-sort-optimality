# proofs — round 4 report (2026-10-24, updated 23:35)

## 1. sort3 final model (n=3, I1, snapshot outputs M_out, R=n+k, all 13 weak orders)
- k<=9: DONE, two verified checkers on ONE file (lean-lrat Lean theorem `sort3_I1c_no_le9` + cake_lpr).
  CNF sha256 a1334fcdea11590bc017fc292187251798a7846160ede7f5436a66faf8a25360 (= fresh `lrat-tool dimacs 3 9 I1c all`),
  LRAT sha256 prefix 981061b39f256ea0, cake_lpr 60 s. Gives L_AD(3) >= 16.
- **k=10 (target, L_AD(3) >= 17): DONE (cake_lpr side).** Base CNF = fresh `lrat-tool dimacs 3 10 I1c all`,
  sha256 43fc08042ce3928393e2ebfa1c50359d3802c1d41cf43cd026795259eacb324c. lean-lrat split it into 32 cubes (all sign
  patterns of DIMACS vars 2,8,14,20,26 = "op t 1", t=0..4). My independent re-check `peers/lean-lrat/ll_cube_check.py`:
  cover = all 32 patterns; every leaf CNF = base + its cube units (multiset); every leaf LRAT `s VERIFIED UNSAT` by
  cake_lpr -> `LL_CUBE_CHECK PASS`. Full sha256 of the 32 leaf CNFs + LRATs (12 GB): `peers/lean-lrat/SHA256SUMS_k10_leaves.txt`.
  The Lean theorem for k=10 (Results/S3_I1c_K10, unsat_split) is lean-lrat's part (status: their STATUS.md).
- sat2 k=1..10 CNFs: all VERIFIED UNSAT by cake_lpr (cross-check; rules paper-proved). k=10: cadical 2782 s, LRAT 5.2 GB (sha256 1e98e135…), cake_lpr 343 s.

## 2. CakePB full chain (symmetry steps + solver proof, ONE verified check)
- `symcert/full_proof.py`: VeriPB dom/red/rup prefix (canon+pcanon) + cadical LRAT of F1 as kernel `rup` with hints;
  checked by `cake_pb_cnf F0.cnf full.pbp`, F0 = lean-lrat v1 rule-free enc.
- n=3, I1, snap, 13 types: k=4, 7, 8 all `s VERIFIED UNSAT`. k=7: 48 s / 26 GB; k=8: 208 s / 67 GB (LRAT 265 MB);
  cake_lpr on the same LRAT 9 s / 37 s. Negative tests (broken witness, removed hint) rejected.
- k=10: one monolithic proof is too big for CakePB, so `symcert/cube_chain.py` splits it into 512 cubes on the cmp
  variables op t 1 (t = 0..8; register swaps fix them, so each leaf F0 + cube is still symmetric). F0 = lean-lrat's
  CURRENT v2 rule-free enc (I1), swap witnesses built from its name map (`symcert/regcanon2.py`). Per leaf: dom proof
  -> cadical LRAT -> kernel proof -> cake_pb_cnf; glue (leaf F0 = fresh base + cube units) and cover checked.
  RUNNING: 80/512 leaves CakePB VERIFIED at 00:05 (~15 s per easy leaf), log `symcert/cc_k10/log.txt`.

## 3. cc_check on sat's cube runs
- `cc/n3_I1_snap_k10_r8_perm`: stopped by sat. `cc/n3_I1_snap_k10_h_perm`: stopped at leaf 8087/17457 (19:53), no summary.
- Partial check: 100 random logged leaves rebuilt byte-exact from F.cnf + cubes.json: 100/100 sha256 equal to sat's
  log, 100/100 cake_lpr VERIFIED (`peers/sat/cc_check_h_perm_sample100.out`). Glue/summary: cannot be checked until
  sat finishes the run. (`cc_check.py --done-only` added.)

## 3b. Other re-checks (cake_lpr, independent cadical re-solve)
- sat direct k=10 certificates (6 perms, NOP mode, r8 + hcmp): I1 h_perm VERIFIED (772 s + 207 s), I0 h_perm VERIFIED
  (450 s + 165 s). I0 r8: solved (2114 s, 4.3 GB LRAT), cake_lpr OOM-killed twice (machine shared with the user's other
  jobs, ~430 GB used); retry every 10 min in background. I1 r8: not started.
- latency: all 11 CNFs VERIFIED UNSAT.

## 4. sort4 plan (`agents/proofs/SORT4_PLAN.md` v2)
- Measured: lean-lrat I1c k=6..9 = 7/26/150/854 s; sat k=12 (all rules + hcmp) = 289 s; sat2 k=11/12/13 = 31/454/>3600 s.
- k=19 from k=12: g=4 per k -> 1.3e3 core-h solve (+ similar for cake_lpr); g=6 -> 2.2e4 core-h; g=15 -> impossible.
- LRAT 2-7 MB per solver second -> 10-30 TB; free disk 2.3 TB => keep-all NOT feasible; check-and-delete per leaf with
  logged hashes IS feasible (peak = jobs x largest leaf). cake_lpr on all cubes is feasible iff solving is feasible.
- sat's new data: k=13 > 2 h (g > 25 from k=12); Knuth estimate for k=19 cubes ~3e10 core-h.
  VERDICT: sort4 k<=19 is not reachable with the current encodings (direct or syntactic cubes); cake_lpr on all cubes is
  then not feasible either (same cost as solving). Disk (2.2 TB) is not the limit. A new search-reducing method is needed
  first (sat: semantic cubes); its glue must be proved, not only solved.

## Next
- CakePB k=10 cube chain result; I0 r8 retry; I1 r8 and sat2 nop K10 checks; artifact scripts (spec).
