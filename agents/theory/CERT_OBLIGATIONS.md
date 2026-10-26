# What a sort4 / sort5 certificate checker must prove (theory, 2026-10-24)

For: enum (certificate producer), lean-reflect and coq (checkers), lean (chain), sat/sat2/proofs (SAT route).
Targets: n = 4: no RS program with k ≤ 19; n = 5: no RS program with k ≤ 31 (I1, MM-1, AlphaDev counting).

## 0. The end theorem (one statement per n, in the checker's logic)
- Relaxed route (no NG): `∀ p o, p.length ≤ K → ¬ RelaxedSnap n p o`, then `mm_lower_bound` (needs only the exact-K form,
  which follows) gives `∀ q, MMProg n q → q.length ≤ K + 2n → ¬ XCorrect n q`.
- Strict route (enum with NG, PRUNING v3 / lemmas.md L10): `∀ p o, p.length ≤ K → ¬ XSnap n p o` (or StrictSnap).
  **Then the chain needs L5 in the STRICT semantics** (`l5_strict : MMProg n q → XCorrect n q → ∃ p o,
  p.length + 2n ≤ q.length ∧ XSnap n p o`). lean's current `l5` is relaxed only. The paper proof of L5 holds in both
  semantics (the translation is a simulation for every initial state); lean should add `l5_strict` before a strict-route
  certificate is used.
- Say which route; never mix: an NG-pruned search proves nothing about RelaxedSnap.

## 1. Obligations of a closure (search-tree) certificate
A certificate = a finite set S of abstract states with labels g(s) (cost so far), produced by enum. The checker proves:
- **C0 abstraction.** A function α from concrete RS prefixes (on the test set) to abstract states, and a proof that the
  future depends only on α (or: if α(u) ≤ α(v) in the dominance order then dist(u) ≤ dist(v), Lemma M). For enum's set
  model this is Lemma S (register program of length L → set program of cost ≤ L), plus Lemma NG v3 with γ if NG is used.
- **C1 root.** α(initial state) ∈ S with g = 0.
- **C2 closure.** For every s ∈ S and every operation of the abstract machine (cmp a,b; cmov in place; cmov copy; garbage
  mov if NG; all opcodes of I1; all operand choices, incl. T), the successor s' is either
  (a) pruned by a PROVED rule: dead (an undone output value is in no column), or g(s) + cost + h(s') > K with h admissible
      (H1 classes, H2 undone outputs / #cmov ≥ #cmp on a shortest completion, H3' covers), or dominated (Lemma M, E3); or
  (b) present: canon(s') ∈ S with g(canon(s')) ≤ g(s) + cost.
  "Every operation" must be enumerated by the checker itself, not taken from the certificate.
- **C3 no goal.** No s ∈ S with g(s) ≤ K has all outputs captured.
- **C4 symmetry keys.** canon (S_n input relabelling, flag polarity, column order) must be proved to map a state to an
  EQUIVALENT state (dist equal). Any choice of representative is fine; the proof must not rely on hash uniqueness: keys are
  compared in full (hashes only as an index).
- **C5 test set.** Permutations (or a subset): justified by L1b. The end theorem quantifies over all inputs.
- **C6 costs.** cmp 1, in-place cmov 1, copy 2, T-cmov 1 (needs γ ≥ 1 with NG), garbage mov 1 (NG). K counts register
  instructions only (outs free); MM length = K + 2n via L5.
- **C7 the rules list.** Each pruning rule used (E1–E4, P, G, D, H1–H3', NG) is a lemma in the checker's logic; a rule
  that is only in PRUNING.md is not enough for a certified claim.

## 2. Obligations of a SAT certificate (sat / sat2 / lean-lrat route)
- CNF = F0 (rule-free model instance) ∧ SB (rules) ∧ cuts. UNSAT checked by cake_lpr or Lean's LRAT checker.
- F0 encodes "a length-K RS program over R = n + K registers, correct on the test set": verified encoder (lean-lrat) or
  trusted encoder + differential tests.
- SB/cuts: each one proved sound (lemmas.md L6 / sat RULES / Lean `Canonical`, `Normal`), or certified by VeriPB
  ("F0 SAT ⇒ F0 ∧ SB SAT").
- With rules that delete instructions: sweep all k ≤ K, or NOP suffix (L4b).
- Case splits (SORT5_SPLIT): one certificate per case + the coverage proof (L9).

## 3. Minimum content of a claim line
n, K, R, I, C (AlphaDev counting via L5), output model (RS), relaxed or strict (NG), test set, rules + version, sweep/NOP,
checker + its trust base, sha256 of the certificate.
