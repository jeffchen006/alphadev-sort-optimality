# Analytic lower bounds (bounds agent) — v1.1, 2026-10-24
Review status: B1 (theory L7), B2, B3, Lemma D, Lemma R1, N1–N4, H: all reviewed CORRECT by theory.

## 0. Setting (all bounds)
- Model: M_out (MODEL.md v1.2 §4.3): §1 machine, output j = value of a register at a step fixed by the program text
  (`out j, S`, cost 0). k = #mov + #cmp + #cmov. Notation: c = #cmp, m = #cmov, v = #mov, so k = c + m + v.
- Iset I1 (mov, cmp, cmovl, cmovg, cmovle, cmovge). I0 ⊂ I1, so every bound holds in I0 too.
- T-relaxed (§2): scratch = T (> every input), cmp(T,T) = eq, initial flags = eq.
- Inputs: only the n! permutations (sound subset, theory L1b). A program correct on all weak orders, or in the strict
  model, or with outputs fixed at the end (k_end, k_fixed), is also correct here. So each bound below holds in all of these.
- "Symbol" = the label of a register content: an index i (holds x_i) or T.

**Lemma T (run tree).** Fix a program. For a permutation s, the symbolic run is a function of the outcome sequence of its
cmps. At a node of the run tree (an outcome prefix) the two compared symbols u, w are the same for all s at the node.
If u = w (copies of one input, or T,T) or one of them is T, the outcome is the same for all s at the node (1 child).
Else u = x_a, w = x_b, a ≠ b, and the outcome is lt or gt (no ties on permutations): ≤ 2 children.
*Proof.* Induction on the steps: mov / cmov act on symbols and depend only on the flag (theory L1, L7). □

## B1. #cmp ≥ ⌈log2 n!⌉  = 1, 3, 5, 7 (n = 2, 3, 4, 5)   [theory: confirmed, lemmas.md L7]
*Proof.* By Lemma T the run tree has ≤ 2^c leaves. Output j at a leaf is a fixed symbol. For two permutations s ≠ s' the
required output vectors (index of the j-th smallest, j = 0..n-1) differ, so s, s' reach different leaves: n! ≤ 2^c. □
**Tight for n = 5 — the comparator-network bound #cmp ≥ 9 is FALSE here.** `fj5_7cmp.s` (gen: `gen_fj5.py`, merge insertion
/ Ford–Johnson) sorts 5 inputs with 7 cmp, 30 cmov, 35 mov (72 instr), I0, correct on all 541 weak orders and with garbage
scratch / any initial flags (`python3 sim.py 5 fj5_7cmp.s`; also critic's `progcheck.py`). Idea: values in SSA registers;
`sel(a,b)` = `mov z,b ; cmovl z,a`; after each cmp, the operands of the next cmp and all candidate chains are routed with
cmovs of the current flag. With unbounded registers ANY decision tree of depth c can be simulated with c cmps.
For n = 3, 4: tight (AlphaDev: 3, 5).

## B2. Adjacent-pair lemma
For every permutation s and every j < n-1, the run on s has a cmp whose two operands hold exactly the j-th and the
(j+1)-th smallest inputs.
*Proof.* Let a, b be their indices; let s' = s with the values of x_a, x_b exchanged. Every cmp that does not compare the
symbol pair {x_a, x_b} has the same outcome on s and s' (a, b adjacent in the order; T compares the same). If no cmp
compares them, by Lemma T the symbolic runs are equal, so output j has the same symbol on s and s'; but it must be x_a on
s and x_b on s'. □
Corollaries: c ≥ n-1 (weaker than B1). In a shortest program the first cmp compares two different inputs (see N1).

## Value DAG and Lemma D (used by B3, H3)
Every register content is a *node*: a leaf (initial x_i in P_i, or T) or the result of one cmov instruction
(`cmovX D,S` at step t creates node g = ite(cond_t, S-node, old D-node); a mov copies a node, it creates none).
So #non-leaf nodes = m. On a permutation s each node has a symbol; for g, the *active child* on s is the S-node if the
cmov fires on s, else the old D-node; it has the same symbol as g on s.
Output j is a node o_j. Its *active path* on s: o_j, its active child, ..., down to a leaf. Its length l_j(s) = number of
cmov nodes on it. All nodes on it have symbol y_j(s) (= index of the j-th smallest).

**Lemma D.** For each s, the n active paths are node-disjoint. So Σ_j l_j(s) ≤ m for every s.
*Proof.* A node on the paths of j ≠ j' would have symbol y_j(s) = y_j'(s), false on a permutation. □

## B3. #cmov ≥ Huff(n) = n·⌊log2 n⌋ + 2(n − 2^⌊log2 n⌋) = 2, 5, 8, 12 (n = 2, 3, 4, 5)
*Proof.* Fix j. The set of active paths of output j (over all s) is prefix-free (a path stops only at a leaf; two paths
agree until they branch). For each input index a take the shortest such path ending at leaf x_a, length d_j(a); these n paths
are prefix-free, so Σ_a 2^(−d_j(a)) ≤ 1 (Kraft), so Σ_a d_j(a) ≥ Huff(n) (minimum total length of a binary prefix code
with n words). Under uniform s, y_j(s) is uniform on the n indices, so E_s[l_j(s)] ≥ (1/n) Σ_a d_j(a) ≥ Huff(n)/n.
By Lemma D: m ≥ max_s Σ_j l_j(s) ≥ E_s Σ_j l_j(s) ≥ n · Huff(n)/n = Huff(n). □
(Uses only: outputs are nodes, nodes are cmov results. Holds for any output rule, I0/I1, relaxed or strict.)
AlphaDev has m = 6 / 10 / 18. n = 2: tight (exact k = 4 with m = 2).

**Corollary B1+B3.** k ≥ c + m ≥ 3, 8, 13, 19 (n = 2, 3, 4, 5). Targets: 4, 11, 20, 32. The gap is large: the bounds alone
do not settle n ≥ 3; they serve as cuts (cardinality constraints) and in the heuristic H.


## R1. Computed cmov minimum (relaxation R1: cmp and mov free)
R1 state: a set A of columns (column = symbol per permutation), start A = {x_0..x_{n-1}}. One step (cost 1) adds
M = (cond ? S : D) pointwise, with S ∈ A, D ∈ A ∪ {T}, cond ∈ {l, g, le, ge} of the flag vector of some pair u, w ∈ A ∪ {T}.
Goal: every target column t_j ∈ A.
**Lemma R1.** A correct program (T-relaxed, I1, any output rule, any R, any length) with m cmov gives an R1 run with ≤ m
steps. *Proof.* Let A_t = all columns that occurred in any register up to step t. A real cmov at step t creates
M = (cond ? S : D) where S, D are columns held at t (D may be T) and cond reads the flags of the latest cmp, which compared
two columns held then (or T); all are in A_t ∪ {T}. A mov or cmp creates no column. A cmovle/cmovge before the first cmp
copies (no new column); cmovl/cmovg there do nothing. Output j is a column held at some step, so t_j ∈ A_end. □
Search: `mincmov.cpp` (C++) / `mincmov.py` (Python, no symmetry): IDDFS, pruning with the admissible Huffman-sum bound
(§H3; Lemma D holds in R1, columns are nodes), memo on the S_n-canonical set (input relabelling, MODEL/enum rule G).
Results: n = 2: min m = 2. n = 3: min m = 6 (no run with 5; both tools agree). n = 4: running (`logs/mincmov_n4_cpp.log`).
So for n = 3: k ≥ 3 + 6 = 9 for ALL correct programs (exact k = 11).

## R2. Computed minimum of W = #mov + #cmov (cmp free)
R2 = enum's set model (PRUNING.md Lemma S, reviewed by theory) with cmp cost 0. Lemma S gives cost_set ≤ L for every
register program; cost_set = c + (R2 cost), so **R2 cost ≤ L − c = W** for every correct program. Hence
**k ≥ ⌈log2 n!⌉ + W_min** (B1 and R2 hold for every correct program at once).
Search: `rsearch.cpp` mode 2 (state (A, f, done); in-place cmov cost 1, cmov on a T register cost 1, copy cmov cost 2,
free cmp that must be followed by a cmov; memo on canonical (A, f, done) under S_n and flag polarity, failures stored only
when no on-path (cycle) prune occurred in the subtree; pruning by H2/H3/H3' below).
Result: **n = 3: W_min = 8** (W ≤ 7 none, W = 8 found; 12 s). So k ≥ 3 + 8 = 11 = k_out(3): a second, short proof of the
sort3 bound, independent of sat / enum / critic. n = 4: running (target 15, then k ≥ 5 + 15 = 20).

## R3. Exact set model with a cmp cap (own exact solver)
`rsearch.cpp` mode 3: enum's set model with cmp cost 1, optional cap on #cmp, pruning H1 (classes) + H2/H3/H3'.
n = 3: none ≤ 10, found 11 (k_out(3) = 11; agrees with enum, critic, sat). n = 4 with #cmp ≤ 5: none ≤ 16 (73 s);
growth ×25–40 per length step, so k = 19 is out of reach for this tool (see SORT5_SPLIT.md, cost estimates).

## R1 results (update)
n = 4: **m ≥ 10** (m ≤ 9 none, 340 s, 6.3 M columns interned). Tight (AlphaDev sort4: 10). So m ≥ 2·S(n) holds for
n = 2, 3, 4 (S = 1, 3, 5). n = 5 (target 18) is out of reach for this search (root bound 12, slack 6).

## R4. Blocks of shortest sort3 programs have ≥ 2 cmov
Mode 4 = mode 3 + block tracking (bc = #set-cmov in the current block, sg = some closed block had exactly 1).
Result n = 3: no set program of cost ≤ 11 has a block with exactly one cmov; one exists at cost 12.
Register programs: let p be shortest (k = 11) and suppose a block of p has exactly one cmov. Lemma S maps p to a set program
of cost ≤ 11 (so = 11, since none ≤ 10), cmps 1:1, so blocks correspond; each register cmov gives at most one set cmov.
The image block has 0 or 1 set cmovs. With 0, the image cmp is useless: deleting it gives cost 10, contradiction. With 1:
contradiction with the search. So **every shortest n = 3 program has ≥ 2 cmov per block, m ≥ 2c**. n = 4: out of reach.

## H3' (entropy term when values have copies)
For an undone output j whose value y_j(s) is held by several current columns for some s: the future path of output j on s
ends at a current column holding y_j(s); with q_max = max over current columns of the fraction of s where it holds y_j(s):
E_s[l_j(s)] ≥ H(path) ≥ H(leaf) ≥ log2(1/q_max) (prefix code ⇒ E[length] ≥ entropy; min-entropy ≤ entropy), and ≥ 1
because t_j is not yet a column. So the term is max(1, log2(1/q_max)) instead of 1. Sum over j with Lemma D as in H3.
Effect: R1 n = 3 proves m ≥ 6 at the root (1 node instead of 758); R1 n = 4 m ≤ 8 none in 0.2 s.

## Bug log (for critic)
1. rsearch v1 (mode 3) left the flag vector out of the memo key: wrong "none" (n = 3, k = 11). Found by tracing AlphaDev
   sort3 through the search; fixed (flag in key). No claim was posted from it.
2. rsearch v1 / minwrite (modes 2, 3) stored failures at entry; the in-place moves make cycles, so a failure could depend
   on an on-path state (non-genuine). Fixed: a failure is stored only if no on-path prune happened below it. Mode 1 (R1)
   has no cycles (A only grows), so R1 results (n = 3: m ≥ 6) were not affected (also matched the Python tool).

## N. Normal form (sound with a k-sweep from small k, theory L4)
If a sorting program of length ≤ k exists, a shortest one exists that satisfies N1–N4 (so: sweep k' = 1..k, or use a
NOP-suffix encoding; do NOT use N1–N4 with "UNSAT at exact k ⇒ UNSAT below k").
- N1. The first instruction is `cmp` of two different input registers. (Leading cmovl/cmovg are no-ops — delete; leading
  cmovle/cmovge act as mov — replace by mov; a mov commutes past the next cmp after renaming the cmp operands (cmp reads
  only, mov writes only); a cmp of T or of equal symbols at the run-tree root has one outcome and is followed by cmovs of a
  fixed effect — replace each by mov / delete; then the first cmp compares two inputs; cmp P_a,P_a impossible.)
  Caution: the last step ("cmp with one outcome") changes cmov into mov, length kept. Same length, so a shortest program stays shortest.
- N2. Every cmp is followed by ≥ 1 cmov before the next cmp or the end (else the flags are dead: delete the cmp). So m ≥ c
  — for CANONICAL (shortest, normal-form) programs only, not for all correct programs (theory's note).
- N3. The last instruction writes a register that is snapshotted (`out`) at the end (else it is dead: delete).
- N4. Scratch registers are first written in index order (renaming).
Proofs: deleting / replacing gives a program of length ≤ k with the same outputs. Status: reviewed CORRECT by theory
(agents/theory/reviews/bounds_B2B3N.md). N1 is a transformation rule: sound jointly with N2–N4, NOT automatically together
with other teams' transformation rules (comm, first-touch canon, pcanon, cmpord) — needs a joint proof.

## H. Admissible heuristic for IDA* / enum (`heur.py`)
State after a prefix: for each permutation s the register symbols and flags; D = outputs already taken.
Class C = permutations with equal registers AND flags. req_s = (y_j(s))_{j ∉ D}.
- H1 (cmp): remaining c ≥ c_lb := max_C ⌈log2 #{req_s : s ∈ C}⌉ (B1 inside each class; equal state ⇒ equal future until
  a cmp splits the class).
- H2 (cmov): a := #{j ∉ D : no current register holds y_j(s) for all s}. Each such output needs its own new cmov node.
- H3 (cmov, Huffman): treat current nodes as leaves; Lemma D holds for the future nodes. For j ∉ D: if every s has exactly
  one current value-function holding y_j(s), add the Huffman cost of that distribution; else add 1 if a > 0 for j.
  If some y_j(s) (j ∉ D) is in no register: dead state, h = ∞.
- Each remaining cmp needs its own later cmov (N2 for a shortest completion): remaining m ≥ c_lb.
- **h = c_lb + max(c_lb, a, ⌈H3⌉)**. Initial h = 3, 8, 13, 19 (n = 2..5).
Check: `python3 heur.py ../../programs/out/*.s` — h(prefix) ≤ remaining length at every prefix of all 15 AlphaDev
sort3/4/5 M_out programs and fj5_7cmp.s (sanity only; admissibility is by the proof).

## Negative results (do NOT use as constraints)
- #cmp ≥ comparator-network size (9 for n = 5): false (B1 tight with 7).
- #mov ≥ 1: false for n = 2 (exact k = 4 with v = 0: `cmovX S0, P` into a T register = conditional copy).
- "each cmp block has ≥ 2 cmov" (true in all AlphaDev programs: m = 2c): not proved. A block with one cmov can occur in a
  correct program (e.g. the last block can write only the one output not yet known). Open whether a shortest program needs it.

## Empirical checks (own SAT model `exact.py`, own simulator `sim.py`; independent of sat/sat2/enum)
See §E in `board/reports/bounds_round1.md` (updated as runs finish).

## R5. Restriction idea (SORT5_IDEAS idea 1) — refuted as stated (2026-10-25)
restrict.py: x_i = max (x_i acts as T), simplify (fixed cmps, constant cmovs, DCE, copy coalescing), verify the reduced
sort(n-1) program. On upper's shortest programs: max_i d_i = 6..9 (n=4, need 9), 11..12 (n=5, need 12); AlphaDev sort5_42:
11. So "k >= k_out(n-1) + d" with this simplification cannot give k_out(4) >= 20 or k_out(5) >= 32. Report: bounds_round4.md.

## R6. Restriction heuristic h_R (SORT5_PLAN, theory L12(b)) — plain form NOT admissible; corrected form (2026-10-25)
rsearch mode 7 + RESTRICT=max:i|min:i (sort(n-1) with a sentinel column, theory's M^e) and hr_slack.py (Lemma S trace of
a register program, restrict each set state, exact dist^e_{n-1}). k^max(3) = k^min(3) = 11 (sentinel does not help n = 3).
Plain h_R(s) = max_r dist^e(restrict_r(s)) exceeds the remaining set cost on AlphaDev sort3 (t = 8: 4 > 3) and on 4 of 40
optimal sort4 programs. Corrected h_R' = max_r [dist^e − dup_r], dup_r = #non-T columns − #distinct restricted columns:
proof via Lemma S applied to the restricted register image (start potential ≤ dup_r). Slack ≥ 0 on all 41 programs.
Plain h_R slack profile (40 optimal sort4): root 9 (h_R = 11), ~5 at t = 5..9, ~1 from t = 13.
