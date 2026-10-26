# sat2 symmetry / minimality rules (cnf_enc.py `--rules`) — for review by `theory`

Setting: relaxed model of `shared/MODEL.md` v0 (scratch = T, flags = eq at start), registers P0..P{n-1}, S0..S{R-n-1}.
R = n + k. Instruction code = binary number (op, dst, src), op most significant, op order = order in `common.ISETS`
(mov=0, cmp=1, cmovl=2, cmovg=3, cmovle=4, cmovge=5). For `cmp A, B`, dst field = A, src field = B.

## Proof frame (sweep)
A claim "no program of length <= k" is made only from a sweep j = 1..k with UNSAT at every j under the same rules.
Induction hypothesis at j: no program of length < j sorts. So a sorting program P of length j is *minimal*:
it has no removable instruction (removing one would give a sorting program of length j-1).

Canonicalization rules (C) map P to an equivalent program of the same length (same outputs on every input, relaxed
model). An equivalent program of a minimal program is minimal, so the minimality rules (M) hold on the canonical form.

## C rules (equivalence classes)
- `scr` (R1): scratch registers are first written (by mov or cmov*) in index order: a write to S_{j+1} at step t needs
  a write to S_j at some step < t. Proof: rename written scratch registers in order of first write (a bijection on
  scratch names; all scratch registers start equal to T, so semantics is unchanged).
- `tread` (R2): every read (src of any op; dst of cmp) of a scratch S_j (j < last) at step t needs a write to S_j
  before t; S_last = S_{R-n-1} is never written. Proof: a read of a scratch before its first write gives T; replace it
  by a read of S_last (also T). With R = n + k at most k - 1 scratch registers are written (a sorting program for n >= 2
  needs one cmp), so after R1 renaming S_last is free. (Note: the dst read of a cmov is not changed: a cmov to an unwritten
  scratch is its first write.)
- `comm` (R3): if steps t, t+1 commute syntactically, then code(t) <= code(t+1). Syntactic commute (Bernstein):
  W = written set, Rd = read set; mov D,S: W={D}, Rd={S}; cmov* D,S: W={D}, Rd={S,D,flags}; cmp A,B: W={flags},
  Rd={A,B}. comm(a,b) := W_a ∩ (Rd_b ∪ W_b) = ∅ and W_b ∩ Rd_a = ∅. Encoded as:
  dst_a != dst_b and [ (cmp_a and mov_b and dst_b != src_a) or (mov_a and cmp_b and dst_a != src_b)
  or (write_a and write_b and dst_a != src_b and dst_b != src_a) ].
  Proof of compatibility with R1+R2: let canon(Q) = R1+R2 normal form of Q. In the commutation class of P choose Q*
  with lexicographically least code sequence of canon(Q*). If canon(Q*) has commuting t, t+1 with code(t) > code(t+1),
  swap them in Q* to get Q'. (i) If not both are first writes of scratch registers, the R1 renaming does not change and
  R2 substitution does not change (a commuting pair never reads what the other writes), so canon(Q') = canon(Q*) with
  t, t+1 swapped: lexicographically smaller. (ii) If both are first writes, in canon(Q*) they write S_a and S_{a+1}
  (a+1 > a), so code(t) > code(t+1) forces op(t) > op(t+1); canon(Q') agrees before t (R2 makes reads before a first
  write independent of the renaming) and has op(t+1) at step t: smaller. Both contradict the choice of Q*.
  Snapshot outputs (`--out snap`, judge model=out): snapshots are free (not instructions, not in the code order). If a
  snapshot sits between swapped a, b and reads r: r in W_a => move it after b (b does not touch r); r in W_b => move it
  before a (a does not touch r); else keep it. So the swapped program with moved snapshots is equivalent (theory, 18:38).
- `precmov` part for cmovle/cmovge (I1): before the first cmp, flags = eq, so cmovle/cmovge = mov. Replace them by mov
  first (same length). cmov* reads flags and cmp writes flags, so R1-R3 never move a cmov* across a cmp. 

- `snapT` / `--out snapw` (R5, snap mode only): every snapshot is at the end (t = k) or just before an instruction that
  writes its register (t < k, instruction t is mov/cmov* with dst = that register). Proof: if instruction t does not write
  r, the snapshot of r after t steps equals the snapshot after t+1 steps; move it later until the end or a write. Moves are
  free (snapshots are not instructions) and do not change the code sequence, so R5 is applied after R1-R3, R6.
  `--out snapw` builds R5 into the encoding: output j = old value of dst_t (operand A of step t, which must write) or a
  final register.
- `llP` / `llPall` (R6, free/snap modes only): Q <=lex pi(Q) for every P-register permutation pi (llP: adjacent
  transpositions only; llPall: all n!-1). Inputs are symmetric: if Q sorts all inputs then pi(Q) (P names permuted, output
  selectors permuted) sorts all inputs. Compatibility with R1-R3 (base A): let canon = R1+R2 normal form and
  O = {canon(sigma(Q')) : Q' in the commutation class of P, sigma a P-permutation}; take Q* = lex-min of O.
  R3: an out-of-order commuting pair in Q* = canon(X) gives canon(swap(X)) < Q* by the R1-R3 proof, and
  swap(X) = sigma(swap(Q')) is in the domain. R6: canon only renames scratch (by first-write order) and substitutes T-reads,
  which P-renaming does not change, so pi(canon(X)) = canon(pi(X)) is in O, so Q* <= pi(Q*).
  `llS` (lex-leader for adjacent scratch transpositions) is an alternative base B to R1+R2 and is NOT combined with them.

## M rules (removable instruction => contradiction with minimality)
- `noop` (M1): no mov/cmov* D, D (no effect).
- `precmov` for cmovl/cmovg (M2): no cmovl/cmovg before the first cmp (flags = eq, never fires).
- `deadcmp` (M3): after a cmp, some cmov* comes before the next cmp and before the end (else the cmp only writes flags
  that nobody reads).
- `deadw` (M4): a write to r (mov/cmov*) is not followed by `mov r, X` (X != r) with no read of r in between (read = src
  of any op, dst of cmp or cmov*); with fixed outputs, the last write to a scratch register is read later. (A write that
  nobody reads is removable.)

## Implied constraint (no sweep needed)
- `live`: for every order type e, step t and value v of e: some register holds v at t (fixed/free modes); in snap mode
  only while some output j with sorted(e)[j] = v has outtime_j >= t. Proof: no instruction creates a value; a value lost
  at t cannot be in any register later, so it cannot be output later.

`deadw` in snap/snapw mode: a snapshot of r counts as a read of r; at the end every pending write must be snapshotted.
`--rules all` = scr, tread, comm, noop, precmov, deadcmp, deadw, live, + llPall (non-fixed modes) + snapT (snap mode).

Review: theory 2026-10-24 18:38: R1-R3, M1-M4 SOUND (board/inbox/sat2.md). `live` added after the review.

All rules are tested empirically: minimal k for n = 2, 3 with `--rules all` equals minimal k without rules.

## Round 2: NOP mode (`--nop`, theory L4 NOP-suffix) and cube cuts
- Op `nop` is the LAST op code; NOPs form a suffix (nop at t => nop at t+1); a NOP is fixed as `nop S_last, S_last`.
  It writes nothing, reads nothing semantically, does not change flags. One CNF with K slots covers every length <= K.
- Soundness with the rules: let m* = least length of a correct program (m* <= K if any exists). L6.0 gives p* of length
  m* that satisfies R1-R6, M1-M4 (minimality is about m*, not K). Pad p* with K - m* NOPs. Check per rule:
  R1/R2/M1-M4 use wr = mov or cmov* and iscmov (NOP is neither); the M3/M4 end conditions are at the end of p* = end of K
  (NOPs change nothing). R2: S_last is never written (NOP is not a write; NOP reads S_last = T, allowed).
  R3: a pair (real, NOP) gets no constraint (my syntactic "commute" needs cmp/mov/write on both sides); (NOP, real)
  cannot occur (suffix). R6: P-permutations do not touch S_last, so pi(NOP) = NOP and the lex-leader argument is the
  same on the padded sequence. R5/snapw: a snapshot at t < K needs a write at t, so it is in p*; a snapshot at K = end of p*.
  Cardinality cuts count real cmp / cmov* only.
- Cube split for n=4, K=19 (agreed with sat): c = #cmp in {5..9} exactly (`--min-cmp c --max-cmp c`), plus #cmov >= 10
  (bounds R1, verified). Complete: #cmp >= 5 (L7) and #cmp + #cmov <= 19 with #cmov >= 10 => #cmp <= 9.
