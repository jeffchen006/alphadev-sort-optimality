# spec — round 4 report (2026-10-25): reproducibility artifact

## Done
- `artifact/` (README with claims table, `lib.sh`, `snapshot.sh`, `run_all.sh`, 22 scripts in `claims/`, frozen sources
  `src/` + `SHA256SUMS`, 1419 files / 16 MB). One script per claim: rebuilds the tool from `src/`, re-runs, compares with the
  expected string, prints `RESULT name: PASS|FAIL|SKIPPED`. Logs: `build/<script>/run.log`, `build/SUMMARY.txt`.
- Every owner confirmed command + expected string (sat, sat2, bounds, lean, lean-reflect, lean-lrat, upper); coq, critic, enum, x86, proofs
  were checked by running. Layout fixes made from owners' answers (Lean files need `agents/<x>` + `programs/` layout, 1 core via taskset).

## Results of the re-run on this machine (1 core each)
- PASS (19): s3_00 programs, s3_01 Lemma 4.1, s3_10 enum, s3_11 critic (21 min), s3_12 bounds, **s3_20 sat + cake_lpr (I1, I0)**,
  **s3_21 sat2 10 CNFs + CEGIS**, **s3_22 sat no-cut (2 h 10 min)**, s3_30 Lean programs, **s3_31 lean-reflect (incl. sort3_mm_lb)**,
  **s3_32 lean-lrat k<=9**, **s3_33 Coq**, **s3_34 Coq set model**, s4_bounds_cmov10, s4_bounds_case9, s5_fj5_7cmp, upper_00_search,
  mm_00_memplus, x86_00 harness, x86_01 ACL2 (48 programs, 24000 vectors, 0 mismatches).
- **s3_35 lean-lrat k<=10: cake_lpr part VERIFIED UNSAT** (cadical 626 s); the Lean theorem step printed nothing (needs ~11 GB, only
  ~4 GB RAM was free: probably killed by OOM). Script now guards RAM and logs the exit code. Re-run when RAM is free.
- **s3_23 CakePB chain: SKIPPED (RAM)**: needs ~30 GB free (k=7); machine has ~4 GB free (shared). First try failed for another reason
  (my script used the wrong lean-lrat version): fixed, frozen v1 binary `proofs/vendor/lrat-tool` in the snapshot.

## sort3 claim as reproduced
L5 map (s3_01) + k_out(3) >= 11 certified by cake_lpr (s3_20, s3_21, s3_22), Lean (s3_31 incl. sort3_mm_lb), Rocq (s3_33, s3_34),
+ 4 uncertified searches (enum, critic, bounds, sat2 CEGIS) + upper bound k = 11 (s3_00): **L_MM(3) = 17**.

## Open
- Re-run s3_35 and s3_23 when >= 30 GB RAM is free: `bash artifact/run_all.sh s3_35`, `bash artifact/run_all.sh s3_23`.
- sort4/sort5 scripts: only the supporting bounds exist; add them when certificates arrive (sort4 k<=19 is the team priority).
- Optional: sat's `r8` CNFs are in s3_22; lean-lrat's cube version (k<=10, 4 h) and lean-reflect's set-model proof `sort3_rs_lb_G` have no script.
