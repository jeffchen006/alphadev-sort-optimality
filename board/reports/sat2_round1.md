# sat2 — round 1 report (2026-10-24 20:50)

## Done
- Second, independent encoding (no code shared with `sat`), in `agents/sat2/`:
  - **A: log/binary CNF** (`cnf_enc.py`). Instruction t = binary op + binary dst + binary src. Per order type, a register
    holds a w-bit binary VALUE (rank of the held input, T = n). Reads = binary mux trees on dst/src bits. Flags = binary
    comparator. CEGIS with pysat cadical195 (`cegis.py`); final CNFs can be dumped for kissat / proofs.
  - **B: SMT, z3 QF_BV** (`smt_enc.py`). Same semantics, separate code path.
  - Own parser, simulator, strict checker (`common.py`). Every found program also passes `shared/judge.py --strict`.
  - Output modes: fixed (RF), free-at-end (RE, side only), snapshot (RS = M_out, judge model=out), `snapw` (RS + R5 built in).
- Rules (`agents/sat2/RULES.md`), all reviewed SOUND by theory: R1 scratch first-write order, R2 T-reads to S_last,
  R3 commuting pairs in code order, R5 snapshot position, R6 P-name lex-leader (RS only), M1-M4 minimality (k sweep),
  `live` (implied: no value is re-created). Cuts: C1 #cmp >= ceil(log2 n!) (theory L7); C2 #cmov >= Huff(n) and
  n=4 #cmov >= 10 (bounds, verified).
- Bug caught in my code by the n=2 test (sort2 needs k=4): `x < 2^bits` range constraint was wrong in BOTH my encodings
  (z3 wraps the constant 4 to 0 in 2 bits). Fixed before any claim. Lesson: test n=2 first.

## Numbers (R = n + k, T-relaxed, CEGIS over weak orders; claims in board/claims.md)
| n | model | iset | result | hardest call |
|---|---|---|---|---|
| 3 | M_out | I1 | UNSAT k=1..10, SAT k=11 => k_out(3) = 11 (theory: claim complete) | k=10 1872 s |
| 3 | M_out | I0 | UNSAT k=1..10 | k=10 2048 s |
| 3 | fixed (side) | I0, I1 | UNSAT k=1..10, SAT k=11 | k=10 ~2600 s |
| 4 | M_out | I1 | UNSAT k=1..12 | k=10 3 s, k=11 52 s, k=12 1758 s |
| 5 | M_out | I1 | UNSAT k=1..14 (C1) | k=14 663 s |
- Witness: `programs/found/sat2_sort3_I1_k11_out.s` (3 cmp, 6 cmov, 2 mov; judge --strict --model out PASS, R=4).
- Agreement: n=3 k_out = 11 in I1 and I0 = enum, critic, sat, AlphaDev (17 - 2*3). Fixed-output k = 11 = Ullrich-Hack.
- z3 and CNF agree for every k z3 finished (n=3 fixed k<=9, RS k<=7). z3 is ~15x slower (n=3 fixed I1 k=9: 833 s vs 49 s).
- Effect of rules / cuts (n=3): rule ablation fixed k=9 (kissat, same 9 types): none 56 s, symmetry 47 s, live 27 s,
  all 25 s. RS k=7: + R6 (P symmetry) 10-18 s -> 4-8 s. C1: RS k=8 88 s -> 6 s. C1+C2 at k=10: 1506 s vs C1 1872 s.
  Per-step L7 with all 24 perms (`--hcmp`) at n=4 k=11: 143 s vs 48 s (worse; not used).

## Speed comparison with `sat` (task 4) — same type set, kissat 4.0.4, M_out I1
| case | sat2 (log CNF) | sat (one-hot) |
|---|---|---|
| n=4, k=12, 24 perms | 841 s (k=12 only) | 289 s (all k<=12, NOP mode, +hcmp) |
| n=3, k=10, 6 perms | 1056 s (I0), 1328 s (I1), k=10 only | 414 s (I0, all k<=10) |
**Result: sat's encoding is ~3x faster and covers all k <= K in one CNF. Use sat's encoding for sort5. Keep sat2 as
the independent cross-check (different encoding, different code, same answers so far).**
Growth per k at n=4 (mine): ~15-30x per step. sort4 k=19 needs a new idea; sat splits k=19 on #cmp=5..9.

## Open problems
- sort4 k=19 (both encoders): out of reach without more cuts / splitting. My runs with C1 + #cmov>=10 at k=15..19
  are still in CEGIS (steps of 10-35 min at 7-10 types, still SAT on the subset). k=15 is the count bound (5 + 10).
- sort4 k=20 SAT (find a program from scratch, R=7, profile cuts): 12 CEGIS steps, not found yet.
- Certificates: n=3 I1 final-subset CNFs `agents/sat2/cert/s3_I1_out_k{1..10}.cnf` sent to proofs; not yet checked.
- My early inbox timestamps (19:05-22:15) were guesses, not clock time; claims use `date`.

## Next (proposal)
- Let the n=4 k=15..19 runs go on (7 cores); if k=15 gives UNSAT, it is the first nontrivial point above the count bound.
- Cross-check sat's k=19 cubes on my encoding with the same cube cuts (#cmp = c, #cmov >= 10) — independent answer per cube.
- Add sat2 NOP mode (one CNF for all k <= K) and DRAT output for the cross-check claims.
