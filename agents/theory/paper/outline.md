# Paper outline (theory, draft 0, 2026-10-24)

Working title: **"AlphaDev's sort3/sort4/sort5 are shortest: certified lower bounds for cmov sorting kernels"**
(title depends on results; if sort5 is not closed: "... sort3 and sort4 are shortest; sort5 ...").

## 1. Introduction
- AlphaDev (Mankowitz et al., Nature 618:257, 2023) found sort3/4/5 kernels of length 17/28/42 (human 18/28/46);
  it states a brute-force proof only for sort3 (~10^32 programs, pruning, no certificate, model not stated).
- Question: are they shortest? Answer needs (i) a precise model, (ii) a sound reduction to a finite search, (iii) certificates.
- Contributions: (C1) precise model incl. memory and counting; (C2) a chain of soundness lemmas, each proved on paper and
  formalized in Lean 4; (C3) SAT/CEGIS + independent enumerative search, DRAT/LRAT proofs checked by cake_lpr;
  (C4) results table; (C5) threats-to-validity list: what is outside the model.

## 2. Problem statement and model
- 2.1 x86 fragment: mov, cmp, cmovl/g (I0), + cmovle/ge (I1); signed int32; memory only via mov (AlphaDev rule).
- 2.2 Memory model MM (= AlphaDev's game, without its search-pruning rules — a stronger result).
- 2.3 Strict correctness: all inputs, all garbage registers, all initial flags (4 real flag states → 3 abstract).
- 2.4 Counting C: every instruction, incl. n loads and n stores.
- 2.5 Main theorem (template): in MM, iset I1, unbounded registers, no program of length ≤ L−1 sorts n int32 values;
  L = 17 / 28 / 42.

## 3. The trust chain (one subsection per lemma; proofs in appendix; Lean names in a column)
| # | link | lemma | proof | Lean | check |
|---|---|---|---|---|---|
| 1 | x86 flags → 3-valued flag | X86 | appendix | X86.lean | – |
| 2 | strict → T-relaxed | L2 | appendix | Relax.lean | – |
| 3 | MM length L → snapshot model length L−2n | L5 | appendix | (G2) | ad2out + judge on all 18 AlphaDev programs |
| 4 | unbounded registers → R = n+k | L3 | appendix | Rename.lean | – |
| 5 | all int32 inputs → weak orders; subset/CEGIS | L1 | appendix | OrderType/Reps | – |
| 6 | symmetry + pruning rules keep one shortest program | L6 | appendix | (G3) | rules on/off agree for n=2,3,(4) |
| 7 | exact-k sweep ⇒ all lengths ≤ k | L4 | appendix | Rename.lean (pad) | – |
| 8 | CNF = model instance | encoder | – | (G4) | 2+ independent encoders, enum agreement, found AlphaDev programs at k = L−2n |
| 9 | CNF UNSAT | – | – | – | DRAT/LRAT + cake_lpr (+ lrat-check) |
- 3.x "Why the obvious model is wrong": outputs fixed in P_j at the end (RF) is stricter than MM; all AlphaDev cores
  fail RF; the snapshot model (RS) is exact (L_MM = k_RS + 2n).

## 4. Encodings and search
- enum's set model (Lemma S: M_out with unbounded registers = sets of distinct columns, mov only inside copies; Lemma M monotonicity) — reviewed, agents/theory/reviews/enum_PRUNING_v1.md.
- SAT encoding (value-level, per order type), CEGIS, symmetry rules; enum (BFS over abstract states, dedup).
- Rule list with the lemma that justifies each; one global lex order.

## 5. Results
- Table: n, iset, model, rules, test set, k range swept, solver time, proof size, checker, check time.
- Side results: I0 bounds; RF/RE bounds (and the gap to RS); #cmp lower bounds (bounds); upper bounds found
  (e.g. sort5 in I0 with L = 42, `upper`).
- Agreement table sat / sat2 / enum per (n, model, iset).

## 6. Threats to validity (what is outside the model)
- Other instructions: SIMD (pminsd/pmaxsd), branches, arithmetic/masks (sub/sbb/and), setcc, xchg, lea, cmove/ne,
  unsigned cmovb/a, memory operands in cmp/cmov (x86 allows `cmp r,m`, `cmovcc r,m`: AlphaDev excluded them).
- Other cost measures: latency/throughput, µops, code bytes (AlphaDev fixed sort: length ~ latency).
- Data: signed int32 only; floats / unsigned use other opcodes and the order-type lemma needs one total order.
- Registers: unbounded in the lower bound (stronger); real x86 has ≤ 14 usable GPRs (upper bounds checked against this).
- Trust base: SAT encoder(s) (mitigated by independent encoders and Lean checker), cake_lpr, Lean kernel, Python judge
  vs real hardware (x86 differential tests).
- Relaxation completeness (not soundness): T-sentinel may make the relaxed optimum smaller.

## 7. Related work
AlphaDev and follow-ups (spec survey: agents/spec/prior_work.md); **Ullrich & Hack, "Synthesis of Sorting Kernels", CGO 2025** (closest: n=3 k=11 all optima, n=4 no 19 by A*, model I0, fixed outputs, permutations, 1 scratch register, no certificate — we differ in model (MM/RS, I1, unbounded registers), counting and certificates); superoptimization (Massalin, STOKE, Souper);
optimal sorting networks (Codish et al. SAT proofs for n ≤ 10/11/12, Bundala–Závodný); certified SAT (DRAT/LRAT,
cake_lpr); certified symmetry breaking (VeriPB, dominance, satsuma); Lean/SAT bridges.

## Appendix
A. Full proofs L1–L6 (from agents/theory/lemmas.md). B. Rule statements in Lean syntax. C. Artifact: commands to
re-run every number in §5.
