# proofs — round 3 report (2026-10-24, interim: sort3 k=10 still running)

## Done
1. **Builds after the user's OK**: CakePB (`tools/bin/cake_pb_cnf`, Zenodo prebuilt .S), satsuma, dsr-trim (TOOLS.md).
   CakePB checks ONE proof "F0 UNSAT" = VeriPB-certified canon+pcanon prefix + LRAT of F1 (`symcert/full_proof.py`);
   n=3 k=4: VERIFIED; broken witness / removed hint rejected.
2. **No k-sweep needed**: Lean `lower_bound_chain_snap` (padding) turns "UNSAT at exact k" into "no program of length <= k".
3. **First final-model certificate (two verified checkers, one file)**: n=3, k<=9, R=n+k, I1, snapshot outputs (M_out),
   all 13 weak orders, rule I1c (canon+pcanon proved in Lean): lean-lrat's Lean theorem `sort3_I1c_no_le9` and cake_lpr
   both accept the same CNF + LRAT (CNF sha256 a1334fcd…, = fresh `lrat-tool dimacs 3 9 I1c all`). Gives L_AD(3) >= 16.
4. sat2 k=1..9 CNFs: all VERIFIED UNSAT by cake_lpr (cross-check; rules paper-proved only).
5. Answered lean: the final sort3 claim uses no non-symmetry rule (skip G3 for sort3); sort4 needs flags, dead, hcmp.
6. `SORT4_PLAN.md`: n=4 data (lean-lrat I1c k=6/7/8 = 7/26/150 s; sat all rules k=12 = 289 s); k=19 needs
   1300-22000 core-h depending on growth g; asked sat for k=13..15 timings. Certificate structure and rule list there.

## Running (4 cores)
- `peers/lean-lrat/ll_cube_check.py`: waits for lean-lrat's 32 k=10 I1c cube leaves (13/32 done at 20:30), then checks
  glue (leaf = base + cube units), cover (all 32 sign patterns) and every leaf with cake_lpr. This gives the TARGET
  certificate k=10 (L_AD(3) >= 17) with two verified checkers.
- sat2 k=10 CNF -> cake_lpr; sort4 scaling k=9..12 (lean-lrat I1c); two v1 k=10 runs with VeriPB/CakePB SB (cross-check).

## Next
- Post k=10 result (sha256s for critic); CakePB run of full_proof.py at k=10 when its LRAT is complete.
- cc_check on sat's cc/n3_I1_snap_k10_h_perm; sort4 decision when sat's growth data arrive.
