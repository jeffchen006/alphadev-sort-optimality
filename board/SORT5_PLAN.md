# sort5 plan (theory lead, 2026-10-25) — target: k_out(5) >= 32 (M_out/RS, I1, T-relaxed; MM via L5)

## Where we are
- Proved for ALL correct programs: #cmp >= 7 (L7), #cmov >= 12 (B3), so k >= 19. AlphaDev: k = 32 = 9 cmp + 18 cmov + 5 mov.
- sort4 done (k_out(4) = 20, enum strict, 1.39e9 states, 168 GB). A plain sort5 search to k = 31 is far out of reach.
- Every known optimal program (n = 3, 4, 5) has c = S(n) = 3 / 5 / 9 (optimal network size) and >= 2 cmovs per block.

## Theory results for the ideas (proofs: agents/theory/lemmas.md L12, L13, C1)
1. **Restriction (idea 1) — L12, PROVED.** Restricting to "x_i is max" (or min) maps a sort-n program to a sort-(n-1)
   program in model M^e_{n-1} = RS(n-1) + one sentinel register (H between inputs and T, or L below inputs), same length.
   - Global form k(n) >= k^e(n-1) + d gives NOTHING program-independent: d is a property of the program (measured:
     d_max = 7 on optimal sort3, >= 8 on optimal sort4, agents/theory/sort5/restrict.py). A proof of d >= 12 for all
     sort5 programs of length <= 31 is as hard as the search.
   - Usable form: admissible heuristic h_R(s) = max over the 10 restrictions of dist^e_4(restricted state) (pattern database,
     = idea 4). Root value = k^e(4) (<= 20). Its value is in the deep part of the search.
2. **m >= 2c (idea 2) — Conjecture C1, NOT provable by the class/information argument** (one cmov is enough to keep the
   bit of a cmp). True for n = 3 (exhaustive). Use only after an exhaustive proof; for n = 5 it would itself need the search.
3. **Prefix generate-and-prune (idea 3) — L13, PROVED.** At block boundaries (next op is a cmp) flags are dead; a state
   (A1, done1) with cost g1 subsumes (A2, done2) with g2 >= g1 if sigma(A1) ⊇ A2 for some input relabelling sigma and
   done1 ⊇ done2 (rule G + Lemma M). This is the Codish et al. scheme for sorting networks.
4. **Case split on c (SORT5_SPLIT, reviewed)**: c in 7..15 with #cmov >= max(12, c). c = 7 is near-forced (2^7 = 128 vs
   120 permutations: every cmp must split its class almost evenly).

## Estimated reach
- Counting alone: 19 (now). + C1 (if proved) per case: c + 2c + v >= 27 for c = 9, still needs v >= 5 (no proof idea).
- So the bound must come from SEARCH; ideas 1, 3, 4 are pruning. Expected order: c = 7, 8 cases first (small), then
  c = 9 (the AlphaDev case, hard), then c >= 10 (fewer cmovs left: W <= 31 - c).

## Who tests what (first round = measurements, each <= 1 day of CPU at your quota)
| who | task | output |
|---|---|---|
| bounds | (a) k^max(4), k^min(4): sort4 set model + one constant column H (or L). (b) Conjecture C1 for n = 4: exhaustive search for a program of cost <= 20 with a 1-cmov block (strict/NG ok). (c) h_R slack: dist^e_3 along prefixes of optimal sort4 programs (n = 4 analog of h_R) | numbers in BOUNDS.md |
| enum | (a) L13 block-boundary subsumption in enum_out (keep only non-subsumed boundary states per done-set, S_n-canonical); measure the state count on n = 4 (k <= 19) vs 1.39e9. (b) h_R for n = 4 using exact dist^e_3 tables (cheap) — measure the reduction. (c) sort5 case c = 7 (#cmp = 7 exactly, #cmov >= 12) | counts, then a c = 7 result |
| sat | sort5 cubes c = 7 and c = 8 at K = 31 (NOP mode, rules v3 + hcmp + #cmp = c + #cmov >= max(12,c)); report time per cube; then c = 9 split by the first two blocks (needs an L9 coverage proof — send it to theory first) | per-cube UNSAT + cake_lpr |
| theory | proofs of every new rule (L12, L13 done; h_R admissibility = L12(b)); review the c = 9 sub-split; certificate obligations for L13 and h_R (a checker must re-derive dist^e_4 values or receive sub-certificates) | lemmas.md, reviews |
| coq / lean-reflect | L13 is Lemma M + G (both already proved): add the boundary-subsumption check to the certificate checker | checker support |

## Certificate note
A certificate that uses h_R must also certify every dist^e_4 value it uses (sub-certificates, or recompute in the
checker). L13 needs no extra data (the dominating state is in the certificate). Prefer: c = 7, 8 by SAT + cake_lpr;
c = 9.. by enum + L13 with a checkable certificate.
