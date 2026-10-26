# sort5-lab log (Claude x Codex research loop on k_out(5) >= 32)
Codex thread: see CODEX_THREAD (one thread, continued with `codex exec resume <id>`). Prompts: r<k>_prompt.txt, answers r<k>_out.md.

## Round 0 — quick check: input-subset abstraction (my own, before Codex)
Idea: use a small subset W' of permutations (L1b: sound) so the exact set search is cheaper.
Check (enum_out SUBSET=rand:k:seed, n=3, KB=10, I1, SYM=0): |W'| = 3 -> min 7; 4 -> 8 or 10; 5 -> 10 (3 seeds); 6 -> none<=10.
States: |W'|=5: 23.5k, |W'|=6: 13.0k. So at n=3 EVERY permutation is needed for the bound, and fewer inputs give MORE states
(weaker h, less dedup).
Verdict: DEAD as a speed-up (it loses the bound and does not shrink the search).

## Round 1 — position: case trade-off (A1 m>=2c kills c>=11; A2 routing cost kills c<=8; A3 search for c in {9,10})
Prompt: r1_prompt.txt. Observation (mine): for n=3,4 the optimum has c = ceil(log2 n!) (3, 5) = optimal network size,
so the "few cmps cost routing" effect (A2) has NO n=3/4 test case; n=5 is the first n where network size (9) > ceil(log2 120) (7).
Codex view (r1_out.md):
- A1: m = 2c - S + E (S = #1-cmov blocks, E = surplus). Enough: S <= E + v + 1 (W >= 2c-1 kills c >= 11). Not provable now
  (a 1-cmov block can store a bit used later). Provable part: the LAST cmp, if it splits a class, has >= 2 cmovs.
- A2: entropy deficit sum_t [1 - H(O_t|O_<t)] = c - log2 120 = 0.093 (c=7), 1.093 (c=8): balance only on average.
  Operand-routing union bound m >= L(s) + R(s) is sound, but on AlphaDev sort3/sort4 E R = 0 and E L = m (sort4: 10):
  the Huffman bound (E L >= Huff) is the loose part, not routing. So "Huffman + routing" cannot give 11 / 20.
- A3: h = (c0 - a) + D(s), D = residual R1 (cmov-only, cmp+copy free, current flag kept) is admissible; slack <= K - c0 - M_n - p
  (sort4: <= 5). n=5 needs M_5 >= 17 (c0=9). Moves (v) are never counted -> slack 5 stays.
- Barrier: 1e15 states at 2.4e5/s = 131 years.
My check: formulas m = 2c - S + E and the slack inequality verified by hand; the E R / E L table not re-run (plausible:
AlphaDev sort4 uses every node on every s, network-like).
Verdict: A1 open (C1 = theory's conjecture), A2 DEAD in Huffman form, A3 moves the work to M_5 (R1, n=5 out of reach now) and
leaves the v-gap (5). New target named by both: a provable WRITE bound (W = m + v).

## Round 2 — position: lattice normal form + write accounting
My data (tools/mono.py): every cmov result and cmp operand of AlphaDev sort3/4/5 is a LATTICE polynomial (max-min of inputs).
Optimal samples (upper r4): sort4 k=20, 30000: 9908 pure lattice (no T), 9772 lattice + T-partials, 10320 with a non-lattice column.
sort5 k=32, 5000: 2404 pure, 1920 lattice+T, 676 non-lattice. cmp operands: 100% lattice (sort5), 99.8% (sort4).
FJ-like non-optimal programs (c=7, 8) have non-lattice columns. W = m+v is constant on optima: 15 (sort4, c=5), 23 (sort5, c=9).
Prompt: r2_prompt.txt.
Codex view (r2_out.md):
- L-NF: no proof, strong evidence. Rewrite "first non-lattice cmov D,S -> mov D,S" (repeat): 29,133 rewrites in 30,000 sort4
  optima and 3,443 in 5,000 sort5 optima, 0 incorrect results, length and c unchanged (Codex's run; I did not re-run it).
- A local care-set L-NF is FALSE: prefix "cmp P0,P1; mov S,P2; cmovl P2,P3; cmovl P3,S" (conditional swap of x2,x3) + a
  network gives non-lattice columns on every active path. Only optimality can exclude such routing.
- Sound split without L-NF: among correct programs (fixed k, c) take the lexicographically least escape vector; its first
  non-lattice cmov is ESSENTIAL (mov D,S instead makes it wrong). SAT can encode this with one modified run. No cost bound yet.
- Writes: W_set = q + |A_final| - n (q = creating cmovs). Gives only W >= 7 / 11 / 13. No proof of 15 / 23.
- Lattice R1 counts (additions 0..4): 1, 2, 11, 86, 860 canonical sets; root has 200 finite selector columns (20 lattice).
My checks (tools/lat_out = enum_out + filter; LAT=2: only lattice, no T column; LAT=3: only "no T column"):
| run | KB | states | vs enum (NG=1) |
| n=3 LAT=2 | 10 / 11 | 31 / 110 (min 11) | 2219 / 44947 |
| n=4 LAT=2 | 17 / 18 / 19 / 20 | 760 / 2910 / 11299 / 46827 (min 20) | 2.6e6 / 5.6e7 / 1.39e9 / - |
| n=4 LAT=3 | 17 / 18 | 3.4e5 / 5.4e6 | 2.6e6 / 5.6e7 |
| n=5 LAT=2 | 26 / 27 / 28 | none; 1.4 GB 467 s; 13.3e6 states 4.2 GB 2293 s | - |
New lemma sketch (mine) TE "T-elimination": for strict-correct programs, every garbage class (registers holding one unread
initial value g) can be removed at no cost: at the first real access at t1 choose g := the other operand's value (legal: the
run before t1 does not depend on g), delete the class movs, put |G| movs at t1. So WLOG no instruction reads garbage, and
no T column exists (this extends NG rule (a)-(e) to garbage movs). Gain alone: x8-10 states at n=4 (LAT=3). To theory.
Verdict: lattice + no-T space is x1e5 smaller at n=4 and complete for 3/4; a PROOF needs L-NF (open); as a DISCOVERY tool the
LAT=2 search is an exact search of all pure-lattice programs (= D2). Proof work parked by the user (pivot 10:30).

## Pivot (10:30, user via coordinator): proof parked -> DISCOVERY (k_out <= 31). We own D2 + D4 (board/SORT5_DISCOVERY.md).
Tools ready:
- D2 = tools/lat_out (LAT=2: exact search over all pure-lattice no-T programs). tools/lat_out4 adds LAT=4 ESC=e: at most e
  non-lattice columns (budget in the unused NG garbage field). Check: ESC=0 = LAT=2 (n=4 k<=19: 11,299 states, same);
  ESC=1: n=4 k<=19 273,451 states (x24). Script d2_run31.sh (disk mode, k<=31) waits for the go.
- D4 = tools/d4eval.py (relaxed score: failing weak orders of 541), tools/d4near.py (near misses). Data: every single
  deletion from 200 k=32 optima fails >= 75/541 weak orders, the best is always exactly 75 (d4/near31.jsonl).
## Round 3 — Codex as D4 proposal engine (pilot): r3_prompt.txt (structure of the 75-floor, transformations, edit operators)
