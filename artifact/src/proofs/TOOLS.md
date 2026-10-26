# proofs — tools (versions, hashes, trust base)

All in `agents/proofs/tools/` (binaries in `tools/bin/`, sources in `tools/src/`). Built 2026-10-24.

| tool | role | source / version | commit | binary sha256 |
|---|---|---|---|---|
| cake_lpr | VERIFIED LRAT/LPR checker (CakeML, x64) | github.com/tanyongkiam/cake_lpr (prebuilt `cake_lpr.S`, built with `gcc -O2 basis_ffi.c cake_lpr.S`) | repo a36874a8b750b43fe4b385b8ddbf5b033e46a3fa (2026-07-22); `.S` from HOL4 0ae7030322cdf2b0d46dc9d5503e2d5eae2fa726 + CakeML fb377b4bb704497c921cde68ccc8da3b4f0e9132 | 98c1649dc01f6ba38e4424beeff1b4681069b6175d90047b8c2c73316cd9ef2f |
| drat-trim | DRAT -> LRAT (`-L`), untrusted | github.com/marijnheule/drat-trim | 2e3b2dc0ecf938addbd779d42877b6ed69d9a985 (2024-11-25; same as `bin/drat-trim`) | b535cc5334e97fba5b5db6013625c5a0b16ce348a98d59ff91b45a83fa56b39e |
| lrat-check | unverified C LRAT checker (2nd opinion) | same repo | same | 609239a504b605e03d21b2f0a5dc4f4542787d6663fcee32ecc7e4e7a1eb9d78 |
| veripb | PB proof checker (RUP, cutting planes, redundance, dominance), unverified, Rust | gitlab.com/MIAOresearch/software/VeriPB, v3.0.2 | f41ce91a6bba0223b925f8277d79a531a50d925c (2026-10-15) | see `sha256sum tools/bin/veripb` |
| rust | to build VeriPB | rustup, rustc 1.99.1 / cargo 1.99.1, in `tools/rust/` (`RUSTUP_HOME`, `CARGO_HOME` there) | — | — |
| CakePB (`cake_pb`) | VERIFIED backend for VeriPB kernel proofs | CakeML `examples/pseudo_bool/array/compilation` (no prebuilt binary found on GitHub / SAT-comp site) | NOT BUILT (see below) | — |
| cadical / kissat | solvers, untrusted | `bin/cadical` 3.0.1, `bin/kissat` 4.0.4 (team builds, `../schur6`) | kissat 8af8e56f174b778aef3aa45af9f739b2a5f492c2 | — |

Checks done:
- `cake_lpr.sha256` in the repo: `Makefile`, `cake_lpr.S`, `cake_lpr_arm8.S` OK. `basis_ffi.c` FAILS the hash: the last commit
  (a36874a, "Replace heap/stack size env variables with command-line flags") changed it and did not update the hash file.
  I read the diff: only argument parsing for `--CML_HEAP_SIZE=` / `--CML_STACK_SIZE=` / `--h` in `main`. Benign.
  Note: `basis_ffi.c` is trusted, unverified C in every CakeML binary.
- `tests/run_tests.sh`: 8/8 PASS (php 5/4 and 8/7 UNSAT on both paths; php 4/4 SAT; proof on weakened CNF, corrupted proof
  and empty proof are rejected by cake_lpr).

## CakePB (BUILT 2026-10-24, after the user's OK)
- Prebuilt `.S` from Zenodo record 17609070 "CakePB: AAAI2026" (`cakepb-AAAI26.zip`, sha256
  a7e106de3aeefe300649bc16b18f973eed9df3efa8adafcc6d4095eac37472dc), unpacked in `tools/src/cakepb_zenodo/`.
- `tools/bin/cake_pb_cnf` (VERIFIED, VeriPB 3.0 kernel syntax, CNF input): from `cnf/cake_pb_cnf.S`
  (sha256 8e7c151fccaef59ea7b1905e807038590951d7743243ac22ba4799f2828ac3df; HOL4 718b3aaabc70079271693d5540ba16669c2e7ad2,
  CakeML b2281624c2592f8a54e39f8ff2988154eaa8704b), `gcc basis_ffi.c cnf/cake_pb_cnf.S -std=c99 -DCML_HEAP_SIZE=65536
  -DCML_STACK_SIZE=16384` (no -O2: glibc fortify error). Binary sha256 f0095c64d061235858a96ad8cb9aefe6d5ed745e348ed27cfa5e09710846e6c7.
- `tools/bin/cake_pb` (OPB input; old syntax: does NOT parse 3.0 orders) sha256 8dad480d2c656a66e256e468f41c10da1c96f7d535643f2fb35362aa8f63dd81.
- Limits of this cake_pb_cnf: no output-formula check, no checked core deletion (`delc`). So the certificate is ONE
  proof "F0 UNSAT" (SB prefix + LRAT of F1 as kernel `rup` with hints): `symcert/full_proof.py`.

## satsuma, dsr-trim (BUILT, not used for claims)
- satsuma c6ad1b59f29fa32dae587ef369135735f40d498a (dejavu f9844859d9f3be5558a8f3957029236a7d26ff65), sha256 63391ea4….
- dsr-trim / lsr-check c3119d8570b881d0179a8ae46f1974a32d41d9fc (`make long`), sha256 ebe787d9… / c2eb6043….
- Test on lean-lrat enc n=3 k=4: satsuma fix finds 18 symmetry units; dsr-trim on (SR prefix + cadical DRAT) stops with an
  internal error ("Clause … not in watch pointers"); satsuma lex VeriPB proof has no output/end section (its README:
  VeriPB output experimental). Not pursued: my own regcanon + CakePB path covers canon/pcanon.

## Peer binaries used (read-only copies in `vendor/`)
- `vendor/lrat-tool` (lean-lrat, `lrat-tool dimacs` = their verified `enc`), sha256 48b3f8c033db69a5b5abd4db81878579b154ff137e9c8026d44491334c59a726.
- `vendor/sat_2bb2bc0bd534/` (sat's encode.py, sim.py, cegis.py, RULES.md; name = sha256 prefix of encode.py).

## Trust base, cake_lpr vs the other verified checkers in the team
| checker | what is proved | trusted (not proved) |
|---|---|---|
| cake_lpr (this folder) | HOL4 theorem: if the x64 binary prints `s VERIFIED UNSAT`, the parsed DIMACS formula is UNSAT. Proof covers parser, checker and compilation to x64 machine code (CakeML verified compiler, in-logic compile) | HOL4 kernel; x64 ISA model vs real CPU; `basis_ffi.c` + gcc (link only) + OS/file system; that the CNF file is the CNF that `sat` meant |
| lean-lrat (Lean `Std.Tactic.BVDecide` LRAT checker) | Lean theorem: the LRAT checker is sound, so `F` UNSAT as a Lean proposition | Lean kernel; the checker runs by `Lean.ofReduceBool` / compiled native code (`native_decide`-like axiom: trusts the Lean compiler + runtime + GMP); the Lean parser of the CNF/LRAT text, unless the CNF is built inside Lean (their plan) |
| coq (SMTCoq / Cruz-Filipe-Schneider-Kamp style) | Coq theorem for the certificate checker; result is a Coq theorem | Coq kernel; if `vm_compute`/`native_compute` is used: the VM / OCaml compiler; extraction to OCaml if they extract (then OCaml compiler is trusted) |
Strongest end-to-end story: lean-lrat (encoder AND checker inside one theorem prover, so the "CNF means the model" gap
closes). cake_lpr has the smallest trusted computing base for the "CNF is UNSAT" step (machine code is verified, no
compiler trusted). Using both on the same LRAT file gives two independent verified checks.
