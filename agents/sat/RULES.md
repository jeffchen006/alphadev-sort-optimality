# sat: symmetry-breaking / normal-form rules (encoder `encode.py --rules ...`)

Status: v3 (adds the snapcmov step 4 and measure c4, as theory asked). Rules canon, pcanon, comm, dead, flags, cmpord, movfresh: reviewed SOUND by theory (v1, agents/theory/reviews/sat_RULES_v1.md).
snapcmov, mincmp: reviewed SOUND by theory (19:13). NOT yet reviewed: hcmp. cmpT WITHDRAWN (unsound in general). No final claim uses an unreviewed item.

Setting: relaxed model of MODEL.md §2 (scratch = T, initial flags = eq), registers R = n + k, program length <= k
(nop mode: opcode `nop`, nops only at the end). Output modes:
- `fixed`: at the end P_j holds the j-th smallest value.
- `free`: at the end output j is in register out(j) (one map for all inputs).
- `snap`: output j is a snapshot of one register at one time (spec's model for AlphaDev's stores). Canonical
  snapshot slot: input P_r at time 0, or "the destination of step i just after step i" (a register value only changes
  at a step that writes it, so every (time, register) cell equals one of these slots). Snapshot of a nop/cmp step is
  excluded (it equals an earlier slot). Two outputs never share a slot (implied by full correctness: for n >= 2 a strict
  order type gives distinct targets).

Normal-form argument (shared by all rules). Let P be any relaxed-correct program of length <= k (nops at end).
First make P L3-normal (theory L3: all reads of never-written scratch use ONE T register), so with R = n + k a
fresh scratch always exists for movfresh. Apply canon, pcanon, movfresh renaming once at the start. Then apply
these transformations while possible:
1. remove an instruction listed as removable below (append a nop) — the number of non-nop instructions decreases;
2. replace / flip (rules flags, cmpord) — second measure component decreases;
3. swap two adjacent independent instructions in the wrong lexicographic order (rule comm) — lex order decreases;
4. (snapcmov) move a snapshot from a mov slot to the slot of the mov's source (its last-write slot, or input slot) —
   c4 = sum of snapshot slot indices decreases, c1-c3 unchanged (no instruction changes); if the mov becomes dead,
   step 1 removes it next (c1 decreases);
and after each step 1/2 re-apply the canonical renaming (rules canon, pcanon, movfresh), which does not change the
number of instructions. Measure (c1 = non-nop count + #cmov-before-first-cmp, c2 = #misoriented cmps, c3 = program in lex order,
c4 = sum of snapshot slot indices)
decreases strictly in each round: removal and the flags-replacement decrease the first component (renaming after
them may change the others); a cmpord flip decreases the second and changes no register; a comm swap decreases the
third and keeps the renaming canonical (see comm). No step increases the first component (a deleted dead cmp has no
cmov reader, so no cmov becomes "before the first cmp"; swaps never move a cmov across a cmp). The measure is well founded (finite set), so the process stops,
and the final program is relaxed-correct, has length <= k and satisfies all rules. Hence: no program satisfying the
rules => no relaxed-correct program => (MODEL §2) no correct program.

| rule | statement (what the encoder forbids) | why sound |
|---|---|---|
| canon | scratch S_j (j>=1) touched (read or written) at step i only if S_{j-1} was touched at a step < i, or (only as src) S_{j-1} is the dst of step i. | Renaming scratch registers by order of first touch (dst before src inside one step) is a bijection on registers; all scratch start equal (T), so semantics is unchanged. |
| pcanon | same for input registers P_0..P_{n-1}. Only `snap`/`free`. | Renaming inputs by a permutation s: the new program on x computes the old one on x∘s; sorted(x∘s) = sorted(x); snapshot/out map are renamed with it. Not valid for `fixed`. |
| comm | for adjacent steps A=i, B=i+1, both non-nop and independent, (op,d,s)(A) <=lex (op,d,s)(B) — unless A and B both touch a register that is untouched before (canonical classes). Independent: no flag dependence (cmp/cmp, cmp->cmov, cmov->cmp) and neither writes (mov/cmov) a register the other one touches. | Independent steps commute (each reads the same values in both orders and writes disjoint locations). If at most one of A, B has a first touch, the first-touch order of registers does not change, so canon/pcanon stay true after the swap. Lex order decreases. (snap: the slot of a swapped step moves with it; its value is the same.) |
| dead | (nop mode) no mov/cmov r,r; every write of register r at step i (mov or cmov) is live after i: r is read (src of any op, dst of cmp/cmov) before the next mov to r, or at the end r is an output (fixed: r<n; free: r in out map), or (snap) the slot of step i is a snapshot. | The written value is never observed, so deleting the step does not change any read value or output. mov r,r / cmov r,r is a no-op. |
| flags | (nop mode) every cmp is followed by a cmov before the next cmp/end; no cmovl/cmovg/cmovle/cmovge before the first cmp. | A cmp whose flags are not read can be deleted. Before the first cmp flags = eq: cmovl/cmovg are no-ops (delete); cmovle/cmovge act as mov (replace, second measure component decreases). |
| cmpord | (nop mode) cmp A,B only if index(A) < index(B); no cmp r,r. | cmp B,A = cmp A,B with lt/gt swapped: flip the cmp and swap l<->g, le<->ge in the cmovs that read it (all cmovs up to the next cmp). Inside one step, first-touch order changes only if both A, B are fresh, and then canon already gives index(A) < index(B). cmp r,r sets eq: its readers are no-ops (cmovl/g, delete) or movs (cmovle/ge, replace); then the cmp is dead (delete). |
| movfresh | (snap/free, needs canon + nop) every mov writes a scratch register untouched before (so, with canon, the next fresh one), and a mov never reads an untouched scratch. | The old value of the dst of a mov is dead at that step (mov does not read it). Rename the web (the value created by the mov, through the cmovs that update it, up to the next mov of that register) to a fresh scratch; with R = n + k a fresh scratch always exists (<= k movs). No output position is fixed in snap/free. `mov S_new, S_untouched` copies T onto T: no-op (delete). |

| snapcmov | (snap, n >= 2) every output slot is the slot of a cmov step (not an input slot, not a mov slot). | A mov slot holds the value of its source register, which equals that register's last-write slot (or its input slot). An input slot x_r is never the j-th smallest on all permutations (n >= 2). The last-write slot of a value that is a correct output is therefore a cmov slot. Moving a snapshot changes no instruction. A mov whose value is then never read is dead (rule dead removes it). |
| mincmp c | #cmp >= c (cardinality, sequential counter). | Lemma, not a rule: theory L7 (#cmp >= ceil(log2 n!) for every program correct on all permutations). Valid when the test set contains all permutations or the claim is about all order types (the lemma is about correct programs, so it holds for any CEGIS subset). |

## hcmp (cut, snap mode; needs rules flags + snapcmov; part 2 needs a test set of permutations only)
Part 1 (implied by the rules, pure counting). For each step i let Q_i, M_i = #cmp, #cmov in steps >= i and W_i =
#outputs whose slot is a step >= i. Encoder: exact suffix counters, and Q_i <= M_i, W_i <= M_i, Q_i + max(Q_i, W_i) <= k - i.
Why: rule flags => every cmp in [i, k) is followed by its own cmov before the next cmp (so Q_i <= M_i); snapcmov =>
each such output has its own cmov slot (W_i <= M_i, distinct slots); a step is a cmp or a cmov (or mov/nop), and cmovs
counted for the outputs are the same cmovs as for the cmps only in the max (Q + max(Q,W) <= Q + M <= k - i).
Part 2 (lemma; enum's H1 / theory L7 applied to the suffix). On permutations p, q let E_i(p,q) hold if before step i:
same content (input index or T) in every register, same flags, and same content in every snapshot slot < i.
Claim: if p has >= 2^m other permutations in its E_i-class, then Q_i >= m+1.
Proof: inside the class every later step acts the same on each member, except a cmp, whose outcome is eq on the whole
class (same contents) or lt/gt per member. So members with the same later flag outcomes have the same later contents
and later snapshots; with equal earlier snapshots they have equal output index vectors. A correct program gives p^-1
as output index vector (distinct for distinct p). So the class needs >= |class| distinct outcome sequences <= 2^{Q_i}.
Encoder: E_i is only forced true (never forced false); a forcing counter over E_i(p, .) gives "class >= 2^m + 1"
which implies Q_i >= m+1. A real normal-form program sets all aux variables to their true values and satisfies all
clauses (the lemma), so the cut removes no correct normal-form program.

Rules that need nop mode remove instructions; in exact-k mode they are not allowed (encoder asserts).

Validation required by the brief: minimal k must be the same with each rule on/off (`results.md`).

## Case splits (not rules; v4, 2026-10-24 23:30)
Options of encode.py / gen_full.py (env CMPEQ, MAXMOV, BLOCKS, MINCMOV):
- cmpeq c: exactly c cmps (exact suffix counter Q, needs hcmp).
- blocks b_1..b_c: exactly b_j cmovs have exactly j cmps before them (j = 1..c). With rule flags no cmov is before the
  first cmp, so sum b_j = #cmov. Cmovs never cross a cmp under any rewriting step (flag dependence), and for a
  SHORTEST program no deletion fires, so (c, b) is the same for a program and its normal form: a form-invariant split
  (sat2 can solve the same cases).
- maxmov v: #mov <= v (implied by #cmp = c, #cmov >= m0, length <= K: v = K - c - m0).
Completeness: the cases (c, b) with c >= ceil(log2 n!) (theory L7), b_j >= 1 (rule flags), c + sum b <= K, and
sum b >= m0 (a verified #cmov lemma, e.g. bounds R1: m0 = 10 for n = 4) cover every normal-form program of length <= K.
List: `python3 split_cases.py K cmin m0 [cmax]`.
