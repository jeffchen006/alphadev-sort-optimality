# VeriPB for the symmetry rules? — short plan (theory, 2026-10-24)

## What VeriPB supports now (sources checked 2026-10-24)
- Proof system: cutting planes + RUP + **redundance** (RAT/PR-like, with a substitution witness) + **dominance-based
  strengthening** (Bogaerts, Gocht, McCreesh, Nordström, AAAI 2022 / JAIR 2023, arXiv 2203.12275). At least as strong as
  DRAT; simulates G1 (Kołodziejczyk–Thapen, SAT 2024, arXiv 2406.13657).
- Format: "pseudo-Boolean proof version 2.0"; a 2025 kernel mode "3.0" with only primitive rules + an augmented mode with
  high-level rules (PB26 VeriPB documentation; arXiv 2602.08692).
- Symmetry breaking with proofs: BreakID + a Kissat variant that emits VeriPB (2022, 1058/1089 SAT-competition instances
  checked); **satsuma** with lex-leader orders on auxiliary variables, orders of magnitude faster (arXiv 2511.16637, 2025).
  VeriPB elaborates to the kernel format, checked by **CakePB** (verified in CakeML). Artifacts: Zenodo 17607863
  (satsuma), 17608873 (VeriPB), 17609070 (CakePB).
- Limits: witnesses are substitutions var -> literal/constant; supported symmetry breaking = **static lex-leader for
  syntactic symmetries** (literal permutations of the CNF). Conditional / dynamic symmetry breaking: future work.

## Fit with our rules (lemmas.md L6)
| rule | kind | VeriPB fit |
|---|---|---|
| R1/R1' scratch naming, R6 input naming | permutation of register names | **Good** only if the permutation is a literal permutation of the whole CNF: needs one-hot (or order-encoded) register selectors and a symmetric value encoding. With **binary** selectors (sat2 cnf_enc.py) a register swap is NOT a literal permutation (needs extension variables). Lex-leader over the instruction variables, certified by satsuma/BreakID-style proofs. |
| R5 cmp flip | conditional (block depends on the next cmp) | Poor: witness depends on the assignment. Needs re-encoding (e.g. per-cmp "orientation" variable) or extension variables. |
| R2 adjacent swap | not a permutation (intermediate state changes) | Poor: witness must map the middle state to a new state = extension variables + many subproofs. |
| R7 / μ | opcode replacement | Possible (substitution on opcode bits at one step) but needs state reasoning. |
| S-rules (noop, dead write, dead cmp, cmp A,A) | minimality (needs "no shorter program") | Not expressible in one exact-k instance. Possible with NOP-suffix encoding + objective "#non-NOP" and dominance with objective, but deletion shifts all later states: heavy. |

## Plan
1. **Default trust path for rules = paper proof (lemmas.md) + Lean (lean_plan.md G3) + empirical checks**
   (minimal k with rules = without rules for n = 2, 3, and n = 4 where feasible; sat2 already does n = 2, 3).
2. **Best certificate where affordable: no rules.** For sort3 (UNSAT k <= 10) and maybe sort4 (k <= 19), ask `sat`/`proofs`
   to measure the rule-free (only L1–L5) instances; then the only certificate is DRAT/LRAT + cake_lpr. Rules then matter
   only for sort5.
3. **Optional VeriPB pilot (sort3 or sort4 only):** one-hot encoding, only R1 (+R6) as lex-leader constraints, proof via
   satsuma or hand-written `dom` steps, solver part as RUP steps (DRAT clause additions -> VeriPB `rup`), check with VeriPB,
   elaborate, check with CakePB. Cost/benefit to decide after step 2 numbers. Owner: `proofs` (tools), `theory` (witness design).
4. Not planned: certifying R2/R5/S-rules in VeriPB (high cost; Lean covers them at the model level).
