# Shared model (v1.8, 2026-10-24: §4.6 iset I2; §4.5 MM+ search target; §4.3 k_out=k_end settled, §4.5 MM+ variant; §4.1 Ullrich-Hack prior bound; §4.4 I0 sort5 L=42 found by upper; §1 cmovle/cmovge defined (x86 note); §4 counting fixed by spec; §2-3 lemma pointers by theory; v1.2 = §4 segment fix, MM-1, 3 flag states) — ALL sessions use these definitions

Owner of changes: `spec` (counting, AlphaDev facts) and `theory` (soundness lemmas).
Change rule: edit only by owner; bump the version line; post a line in `board/claims.md`; SendMessage to `sat`, `enum`, `lean`.

## 1. Machine model M(n, R, I)
- `n` inputs. Value registers `P0..P{n-1}` hold the inputs at start (`Pi = x_i`).
  At the end `Pj` must hold the j-th smallest input (ascending, j = 0..n-1). Duplicates are judged by VALUE, not identity.
- Scratch registers `S0..S{R-n-1}`. Default `R = n + k` (k = program length): "unbounded registers" without loss of generality
  (a length-k program writes at most k distinct registers).
- Flags: `lt`, `gt` (eq = neither). Signed 32-bit compare.
- Base instruction set I0 (Intel operand order, destination first):
  - `mov D, S`    : D := S
  - `cmp A, B`    : lt := (A < B), gt := (A > B)
  - `cmovl D, S`  : if lt then D := S
  - `cmovg D, S`  : if gt then D := S
- Extension set I1 = I0 + `cmovle D, S` (if not gt then D := S) and `cmovge D, S` (if not lt then D := S)
  (later: `xchg`, `lea`). Encoders must take the instruction set as a parameter. AlphaDev claims need I1 (§4).
- Out of model (write this in the paper): SIMD (pminsd/pmaxsd), branches, arithmetic, immediates.

## 2. Lower-bound relaxation (sound; proof owner: `theory`, formal: `lean`) — v1.1 theory
Proofs: `agents/theory/lemmas.md` (L1-L6). A real program must be correct for EVERY initial value of the scratch
registers and flags. For the lower bound we only need it correct for ONE choice (Lemma L2), so we fix:
- every scratch register starts as the symbol `T` ("top"), larger than every input, and **cmp(T, T) = eq**
  (sound: restrict inputs to < INT_MAX and set garbage = INT_MAX);
- initial flags = eq (lt = gt = false): a cmovl/cmovg before the first cmp is a no-op, a cmovle/cmovge acts as mov;
- `T` in an output = wrong output.
- Optional stronger (still sound) relaxation, only if a relaxed program shorter than AlphaDev's appears: require correctness
  for scratch = +inf AND scratch = -inf, and all 3 initial flags, together (lemmas.md L2.4). Completeness risk of the plain
  relaxation: T is a known +inf sentinel ("cmovX S_fresh, P" = conditional copy), so relaxed k_min may be < real k_min.
For the UPPER bound (a found program), the judge must check the strict model: correct for all garbage values / flags
(e.g. reject any program whose output depends on T or on the initial flags).
Register budget: R = n + k is enough (Lemma L3, relaxed model). Padding: without symmetry rules, UNSAT at exact k implies
UNSAT for all k' <= k (pad with `mov P0, P0`); WITH rules this is false — sweep every k' <= k, or use a NOP-suffix
encoding (Lemma L4). Every lower-bound claim states which.

## 3. Abstract state (order-type lemma; proof owner `theory`, formal `lean`) — v1.1 theory
Behaviour depends only on the weak order type of (x_0..x_{n-1}) (Lemma L1). Fubini numbers: n=3: 13, n=4: 75, n=5: 541.
A register value is an index in {0..n-1} ("holds x_i") or `T`. Flags are computed from the order type.
- Lower bounds may use ANY subset of order types (e.g. the n! permutations, or a CEGIS set): UNSAT on a subset implies
  UNSAT on all (Lemma L1b). Keep I1 then: permutations + I0 is NOT a relaxation (copies of one input give eq).
- Upper bounds (judge) must use all weak orders.
- Symmetry / pruning rules: only rules reviewed in `agents/theory/lemmas.md` L6 (or a reviewed RULES/PRUNING file) may be
  used for a final claim. All lex-type rules of one encoding must use ONE instruction order. Output model for final claims:
  M_out (§4.3) = theory's "RS"; P registers are then interchangeable (extra n! symmetry), in §1 fixed outputs they are not.

## 4. Counting C (v1.2, owner `spec`, 2026-10-24) — FIXED
Sources (copies in `agents/spec/ext/`): Nature 618:257 (2023) Table 1a, Methods "Action pruning rules" and "Brute-force
approach"; Supplementary Information (SI) App. F.1 (Defs 3-5, Assumption 1) and App. G (12 programs);
github google-deepmind/alphadev `sort_functions_test.cc`. Survey: `agents/spec/prior_work.md`.

### 4.1 Facts (verified)
- Reported lengths L_AD (AlphaDev / human benchmark): sort3 17 / 18, sort4 28 / 28, sort5 42 / 46 (Table 1a).
  The repo and libc++ use a 43-instruction sort5 (main text: "For sort 5, we used a 43 length algorithm").
  The 42 program is SI App. G `Sort5_42` = `programs/alphadev_sort5.s`; the 43 one = `programs/alphadev_sort5_43.s`.
- Length = number of x86 instructions. EVERY instruction counts 1: load (mov mem->reg), store (mov reg->mem), mov reg,reg,
  cmp, cmovXX. Data: `int*` buffer (int32) in memory, sorted in place; signed compare (cmovl/le/g/ge are signed).
- Opcodes in all sort3/4/5 programs: mov, cmp, cmovl, cmovle, cmovg, cmovge  => the AlphaDev claim lives in I1.
  cmp and cmov only on registers. Methods, verbatim: "We cannot compare or conditionally move to a memory location
  (illegal)." No published sort3/4/5 program has a memory operand in cmp/cmov. MODEL RESTRICTION MM-1: real x86 allows
  `cmp r, m` and `cmovcc r, m` (memory SOURCE); M_AD forbids them, as AlphaDev's action space did. With MM-1 dropped,
  Lemma 4.1 fails (a cmp/cmov from memory can replace a load); that variant is open (gold level, not the main claim).
  x86 registers used: sort3 4, sort4 5, sort5 6. Program core (L - 2n): 11 / 20 / 32.
- Human benchmark = optimal sorting network, 4 instructions per comparator: L = 2n + 4c = 18 / 28 / 46 (c = 3 / 5 / 9;
  exact match). Reconstruction: `programs/human_sort{3,4,5}.s`.
- AlphaDev search pruning (Methods): memory read in incremental order; registers allocated in incremental order; no
  cmp/cmov to memory; each memory location read and written only once; no uninitialized register; no two consecutive cmp.
  SI Assumption 1: cmov only after a cmp. Published programs break some rules (repo Sort3 reads cells 1,2,0; SI Sort3_17
  reads cell 2 twice; SI Sort3_20 has two consecutive cmp). OUR MODEL DOES NOT ASSUME THESE RULES (stronger result).
- AlphaDev claim (Methods): "a brute-force approach to prove that no program shorter than 17 instructions exists for
  sort 3 ... roughly 10^32 programs ... with pruning heuristics ... more than 3 days ... For sort 4 and above this approach
  is infeasible." No certificate, no exact model. sort4 / sort5 optimality: not claimed.
- Prior lower bound (Ullrich & Hack, CGO 2025, DOI 10.1145/3696443.3708954): register-only k = 11 (n=3) and k = 20
  (n=4, length-19 exhaustive search, 2 weeks) in model I0, permutations only, outputs fixed in r1..rn at the end,
  1 scratch register (from their code). No certificate. n=5: only ~33 found, no bound. Not an AlphaDev bound
  (I0, m=1, fixed outputs); see agents/spec/prior_work.md.

### 4.2 Exact model M_AD(n, I)  (judge: `model=mem`)
- `P0..P{n-1}` = the memory cells (start: Pi = x_i; end: Pj = j-th smallest). `S*` = registers, unbounded.
- Allowed: `mov S,P` (load), `mov P,S` (store), `mov S,S`, `cmp S,S`, `cmovX S,S`. Forbidden: P in cmp/cmov, `mov P,P`.
- L = number of instructions. §2 relaxation (S start T, flags eq) applies unchanged.
- MAIN CLAIM: no M_AD(n, I1) program of length 16 / 27 / 41 (n = 3 / 4 / 5) sorts.

### 4.3 Register model for encoders: M_out(n, I)  (judge: `model=out`)
- §1 machine + pseudo-instruction `out j, S` (cost 0): records the CURRENT value of S as output j. Output j = value at
  the last `out j`; if there is no `out j`, the final value of Pj. k = number of mov/cmp/cmov (outs are free).
  Equivalent for encoders: output j = value of some register r_j at some step t_j (both chosen by the solver).
- LEMMA 4.1 (proof owner `theory`; sketch by spec): L_AD(n) = 2n + k_out(n), relaxed and strict alike, R unbounded.
  (<=) n loads first (x_i into register Pi), body, each `out j, S` -> store `mov Pj(mem), S` at the same position.
  (>=) Each cell i is loaded before its first store (else x_i is lost) and stored >= 1 time (else output j = x_j, wrong
  for n >= 2): >= n loads, >= n stores. Pristine loads l_1..l_m of cell i: l_1..l_{m-1} -> `mov F, Pi`; l_m deleted,
  its target live range renamed to Pi (live range: from a write to the next unconditional mov into that register; a cmov
  continues it). Store to cell j -> `out j, S`, plus `mov C, S` only if cell j is reloaded later (last reload renamed to
  C). C is FRESH PER SEGMENT (segment = time between two stores to the cell; fix by theory). Every other instruction:
  same, registers renamed (each unconditional mov gets a fresh register). Cost <= L - 2n.
  Full proof: `agents/theory/lemmas.md` L5 (theory: correct; theory's name for M_out = "RS"). The `out j, S` syntax and
  semantics are FINAL.
  Tool: `agents/spec/tools/ad2out.py`. Result: all 18 AlphaDev programs map with k <= L - 2n and pass `--strict`
  (`programs/out/`).
- TARGETS: k_out >= 11 / 20 / 32 for n = 3 / 4 / 5 in I1, i.e. UNSAT at k = 10 / 19 / 31.
- Variants: k_out <= k_end <= k_fixed. k_end = outputs in any n registers at the END (= stores last);
  k_fixed = §1 (outputs in P_j at the end). A lower bound on k_end or k_fixed is NOT an AlphaDev lower bound.
- k_out = k_end? SETTLED for our purpose (theory lemmas.md L8, spec): all AlphaDev cores still sort with their outs
  moved to the end (judge + theory check.py), so k_end <= L_AD - 2n. Hence a proof of k_out >= L_AD - 2n gives
  k_out = k_end = L_AD - 2n for that n. n = 2: k_out = k_end = 4 (spec tiny_search.py, exhaustive, no pruning).
  n = 3: k_out = k_end = 11 (enum + critic: RS UNSAT k <= 10, I1, 13 weak orders). n = 4, 5: follows from the main
  claims. A general equality lemma (all n) is NOT needed and stays open.

### 4.4 Instruction set and flags
- Final claims in I1. I0 results are weaker (I0 subset of I1). Data: SI Sort3_17 and both Sort4_28 pass with le->l,
  ge->g, so k_out^{I0} <= 11 (n=3), <= 20 (n=4). The 42 and 43 sort5 FAIL under this replacement, but `upper` found an
  I0 sort5 with L = 42 (programs/found/upper_sort5_I0_L42_mem.s, judge --strict PASS), so k_out^{I0}(5) <= 32 too.
- WARNING: "on distinct inputs cmovle == cmovl" is FALSE in general: cmp of two registers that hold copies of the same
  input (or T and T) gives eq. Permutation-only inputs = sound relaxation; I0 instead of I1 = NOT sound.
- Strict flags: l = SF!=OF, le = ZF | SF!=OF, g = !ZF & SF==OF, ge = SF==OF. cmp sets one of the 3 states lt/eq/gt.
  Initial flags: the 4th x86 state (ZF=1, SF!=OF) acts exactly as lt for l/le/g/ge (lean: X86.lean xeval_eq, all 16
  CF/ZF/SF/OF combos), so 3 initial states lt/eq/gt are exact. The judge also tries the 4th (harmless).
  Relaxed initial flags = eq (a real x86 state, so sound); then cmovle/cmovge before the first cmp act as mov.

### 4.5 Variant MM+ (x86 memory SOURCE operands; judge `model=memplus`) — side result, NOT the main claim
- As M_AD (§4.2), plus the x86-legal forms `cmp S, P`, `cmp P, S` (x86 `cmp r32, m32` / `cmp m32, r32`) and
  `cmovX S, P` (x86 `cmovcc r32, m32`, memory SOURCE). Still forbidden: two P operands in one instruction (no x86 form),
  P as cmov destination (x86 has none), `mov P, P`. Cells are written ONLY by stores. Counting C unchanged: every
  instruction counts 1 (a cmp/cmov with a memory operand is 1 instruction). Outputs = cells at the end.
- What fails: Lemma 4.1 (>=). (a) The step "l_m deleted, target renamed to Pi" fails when a cmp/cmov reads the pristine
  cell after the last load (the renamed range may change Pi before that read). (b) A final store is deletable only if
  no access to the cell follows it. (c) x_i may enter registers through `cmovX S, P_i` only (no load at all).
  Valid (theory L8): MM+ length L -> M_out length <= L - a - b (a = cells whose pre-store segment ends with a load,
  b = cells with no access after the final store), so in general only L_MM+ >= k_out (no +2n).
- Evidence that MM+ is strictly stronger (all judge `--model memplus --strict` PASS; upper + x86 check on hardware):
  n=2: L = 7 (`programs/variants/memplus_sort2_7.s`) < L_AD(2) = 8 (= 2*2 + k_out(2), k_out(2) = 4 exhaustive);
  n=3: L = 15 < 17, n=4: L = 26 < 28, n=5: L = 40 < 42 (`programs/found/upper_sort{3,4,5}_memops_L*.s`).
  So MM-1 is ESSENTIAL for the AlphaDev claim. It is AlphaDev's own rule ("We cannot compare or conditionally move to
  a memory location (illegal)"), so the main claim is fair to AlphaDev; the MM+ result is reported separately
  ("x86 itself allows shorter kernels under AlphaDev's counting").
- MM+ optimality needs its OWN encoding: cells = registers that cmp/cmov may read but only stores write; outputs = cells
  at the end; loads/stores cost 1. L1-L3 carry over; input-relabelling symmetry does NOT (outputs fixed to cells).
- MM+ SEARCH TARGET (round 3; owners of the runs: critic / enum; reference: `agents/spec/tools/mm_bfs.py`):
  model MM+, iset I1, T-relaxed (§2: registers = T, cmp(T,T) = eq, flags eq), all weak orders, unbounded registers,
  L = every instruction (load, store, mov, cmp, cmov). Question: is there an MM+ sort3 with L <= 14? (UNSAT for every
  L <= 14 => upper's 15 is optimal.) Exact state abstraction (no rule beyond these; theory to review):
  state = (n cell vectors, MULTISET of non-T register vectors, flag vector); unconditional writes (load, mov) go to a
  fresh register (dominance: an extra register value never hurts); cmov D,S: D = an existing register (in place) or a
  fresh T register, S = a register or a cell; cmp: two operands from registers (incl. T) and cells, at most one cell;
  operand order of cmp free (iset closed under lt<->gt swap); stores: cell j := register vector. Goal: cells = sorted.
  NO input-relabelling symmetry (outputs fixed to cells). Sound lower-bound heuristic: h = number of cells not yet
  equal to their goal vector (each needs its own store).
  VALIDATION (must match): n=2: MM+ = 7, MM = 8 (mm_bfs.py, exhaustive, 63k states); n=3 MM = 17 (= 2n + 11).
  RESULT (critic 20:13, agents/critic/bf_mm.cpp, validated on n=2): no MM+ sort3 with L <= 14 (I1; 1.2e9 nodes, 35 min)
  => L_MM+(3) = 15 (upper's kernel; a 15 kernel exists in I0 too). Search result, no certificate; h review: theory.

### 4.6 Instruction set I2 (gold-level extension; judge `--iset I2` / header `iset=I2`)
- I2 = I1 + `cmove D, S` (if ZF then D := S), `cmovne D, S` (if not ZF then D := S), `xchg A, B` (swap A and B; flags
  unchanged). Register forms only for xchg (x86 `xchg r, m` exists but has an implicit LOCK; out of model). In MM, MM-1
  applies to cmove/cmovne too (registers only); in MM+, cmove/cmovne may read a memory source like the other cmovs.
  Counting unchanged: every instruction counts 1.
- Flags: cmp still yields 3 states (lt/eq/gt). But the 3-initial-state lemma (lean xeval_eq) holds only for l/le/g/ge:
  with cmove/cmovne the initial state ZF=1 & SF!=OF is a 4th distinct state. The strict judge always tries all 4
  initial states. The T-relaxation (initial flags = eq, a real x86 state) stays sound; then cmove acts as mov and
  cmovne as no-op before the first cmp.
- Lemma 4.1 (L = 2n + k) carries over unchanged to I2 (its proof never looks at the opcode set; xchg is a register
  instruction): theory to confirm.

## 5. Program file format (`programs/*.s`)
```
# n=3 R=4 iset=I0 source=<where it came from>
mov S0, P0
cmp P1, P2
cmovl P0, P1
```
One instruction per line, `#` starts a comment, registers `P<i>` / `S<i>`, opcodes lowercase.
Header keys (first comment line): `n=`, `R=`, `iset=I0|I1|I2`, `model=reg|mem|memplus|out` (default reg; §4), `source=`.
`model=out` adds the line form `out <j>, <reg>` (§4.3). In `model=mem`, P = memory (§4.2).
Every session writes its OWN parser and simulator (independent cross-checks). The reference judge is `shared/judge.py` (owner `spec`).
