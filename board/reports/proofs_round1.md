# proofs — round 1 report (2026-10-24)

## Done
1. **Tools** (`agents/proofs/TOOLS.md`, versions + hashes): cake_lpr (CakeML-verified, prebuilt `.S`, repo a36874a),
   drat-trim + lrat-check (2e3b2dc), VeriPB 3.0.2 (f41ce91, Rust build). Trust-base table: cake_lpr vs lean-lrat vs coq.
   Note: cake_lpr's `basis_ffi.c` does not match the repo hash file (last commit changed only argument parsing; I read the diff).
2. **`agents/proofs/check_unsat.sh CNF`**: cadical LRAT (or `-s kissat`: DRAT -> drat-trim -L) -> cake_lpr; log with
   sha256 of CNF and proof (`logs/`), one line per run in `checked.tsv`; binary proofs by default. Self-test
   `tests/run_tests.sh` 12/12 PASS, incl. 3 rejection cases (weakened CNF, corrupted proof, empty proof).
   **`cc_check.py RUN`**: independent re-check of sat's cube-and-conquer (glue summary == F + negated cubes, summary
   proof via cake_lpr, leaves rebuilt and checked). Test: sat cc/test_k7 PASS 62/62; one cube dropped -> FAIL.
3. **First certified UNSAT**: n=3, k=9, R=12, I0, outputs fixed at the end (old model v0, NOT an AlphaDev bound),
   6 types, no rules: cadical 555 s, LRAT 3.3 GB, cake_lpr `s VERIFIED UNSAT` in 166 s.
4. **Symmetry breaking certified** (`SYMMETRY_CERT.md`, agreed with theory): VeriPB dominance proof F0 -> F1,
   F0 = rule-free CNF, F1 = F0 + SB clauses, `output DERIVABLE` = "F0 SAT => F1 SAT"; then cake_lpr on F1 gives F0 UNSAT.
   - canon (scratch first-touch order) and pcanon (input first-touch order; input swap witness also maps type y -> y o tau).
   - Works on sat's encoder (with pairwise AMO) AND on lean-lrat's verified enc. Script checks every swap is a literal
     symmetry (sigma(F0) == F0) before VeriPB checks it again.
   - Target sort3 model (n=3, k=10, R=13, I1, snap, 13 weak orders): 11 dom steps, VeriPB 0.2 s.
   - Negative tests rejected (wrong witness, unjustified output clause, wrong direction).
5. **Encoding link** (`ENCODING_CERT.md`, agreed with lean): chain = theory L5 (paper) + lean Relax/Snap/Rename +
   lean-lrat Sound.lean (prog => enc SAT, rule-free) + VeriPB/CakePB for literal-symmetry SB + cake_lpr. No Lean lemma is
   needed for canon/pcanon; comm/dead/flags/cmpord/movfresh need theory G3 + Lean. Differential test of sat's encoder vs
   my own simulator: 13500 cases, 0 mismatch.

## Numbers
| item | result |
|---|---|
| sort3 k=9 I0 fixed, 6 types, no rules (old model) | VERIFIED UNSAT (cake_lpr), cnf sha256 64fb265d… |
| SB proof, lean-lrat enc, k=10 snap I1, canon+pcanon | VeriPB `s VERIFIED OUTPUT DERIVABLE`, 11 dom steps |
| check_unsat self-test | 12/12 |
| diff test sat encoder | 13500 / 0 mismatch |

## Running (4 cores, my quota; results go to board/claims.md)
- `symcert/ll_k10/F0.cnf` — lean-lrat enc, rule-free, sort3 target k=10 (the only fully verified path today).
- `symcert/ll_k10/F1.cnf` (canon), `symcert/rc_ll_k10_inp/F1.cnf` (canon+pcanon), `symcert/k10_I1_snap/F1.cnf` (sat enc, comparison).
  Proofs grow ~100-170 MB/min (binary LRAT). No result yet after ~15 min.

## Open problems
- **Blocked by the session permission check (needs the user's OK):** compile CakePB from the Zenodo prebuilt `.S`
  (`gcc basis_ffi.c cnf/cake_pb_cnf.S`, same as cake_lpr); build satsuma + dsr-trim; build CakePB from source.
  Until then VeriPB parts are checked by an unverified checker.
- sat's final claims are cube-and-conquer runs with leaf files deleted: asked sat to log per-leaf CNF/LRAT sha256.
- sat2 has not sent CNF paths yet (binary register encoding: VeriPB symmetry witnesses do not fit).
- sat's rule set now has snapcmov (not reviewed); comm/dead/flags/cmpord/movfresh have no machine certificate.

## Next
1. cake_lpr results for the k=10 runs; post sha256s for critic.
2. cc_check on sat's n3_I1_snap_k10_r8_perm (full summary + 300-leaf sample).
3. CakePB on the SB proofs (after OK); two verified checks of one LRAT (cake_lpr + lean-lrat `lrat-tool check`).
4. sort4: does canon+pcanon on lean-lrat enc make k=19 feasible? Then decide which further rules need path D (Lean).

## Addendum (after the user's OK to build)
- **CakePB built** (Zenodo prebuilt `.S`, `tools/bin/cake_pb_cnf`, VeriPB 3.0 kernel). This version has no output-file
  check and no core deletion, so the certificate is ONE proof "F0 UNSAT": `symcert/full_proof.py` joins the elaborated
  SB prefix (canon + pcanon) and the cadical LRAT of F1 (as kernel `rup` with hints, IDs remapped).
- Test n=3, k=4, I1, snap, 13 types, F0 = lean-lrat verified enc: **CakePB `s VERIFIED UNSAT`**; broken witness and
  removed hint are rejected. So the chain lean-lrat enc + canon/pcanon + solver proof needs no unverified checker.
- The LRATs of the two lean-lrat k=10 F1 runs are kept (hard links `F1.lrat.keep`) for this CakePB check when they finish.
- satsuma and dsr-trim built; on our CNF dsr-trim stops with an internal error and satsuma's VeriPB output is incomplete
  (experimental). Not used.
- k=10 runs: still running at ~70-85 CPU min each, no result yet.
