# sort5-lab round 1 report (2026-10-25) — Claude x Codex (thread 01a171d0), log agents/sort5-lab/LOG.md
Goal was: a method for k_out(5) >= 32. Result: no proof method; 3 facts that set the cost of a proof; 1 new tool.

## Why the candidate methods fail (checked)
- Input subsets (CEGIS core) for an exact search: at n=3 every permutation is needed (5 of 6 perms -> min 10), and fewer
  inputs give MORE states. Dead.
- A1 "m >= 2c" (kills c >= 11): unproved. Exact identity m = 2c - S + E (S = 1-cmov blocks). Only the last block is provable.
- A2 "routing cost for c = 7, 8": the operand-routing union bound is sound, but on AlphaDev sort3/4 the routing term is 0 and
  every node is on an output path for every input (E L = m): the loose part is Huffman, not routing. Cannot give 11 / 20.
- A3 residual-R1 heuristic: admissible, slack <= K - c - M_n - p; moves are never counted, so slack 5 stays; needs M_5 >= 17.
- Barrier: enum grows ~x20 per unit of slack; root gap 13 at n=5 -> ~1e15 states (~131 years at 2.4e5 states/s).

## Facts for the proof-effort file (theory)
1. W = m + v is CONSTANT on all sampled optima: sort4 k=20: c=5, W=15; sort5 k=32: c=9, W=23 ((m,v) = (18,5)..(23,0)).
   Codex: the right count is W_set = q + |A_final| - n (creating cmovs + kept copies); provable only W >= 7 / 11 / 13.
2. Lattice structure: all cmov results and cmp operands of AlphaDev sort3/4/5 are max-min polynomials of the inputs.
   48 % of sampled sort5 optima are pure lattice; Codex: "non-lattice cmov D,S -> mov D,S" keeps every sampled optimum
   correct (29,133 + 3,443 rewrites, 0 failures). Local care-set version is false (conditional-swap prefix).
3. Search size in the pure-lattice, no-T space (tools/lat_out, enum_out + filter): n=4 k<=19: 11,299 states (enum: 1.39e9);
   n=3, 4 minima 11, 20 found. n=5: none <= 28 (13.3e6 states, 4.2 GB, 38 min); k <= 29 running.
4. TE lemma (sketch, for theory review): a strict-correct program never needs to read garbage (extends NG to garbage movs:
   choose g := the other operand at the first real access; equal length). Alone it gives x8-10 fewer states at n=4.
=> A sort5 proof by search is feasible ONLY with a proved lattice normal form (L-NF, open). Without it: >= 1e14 states.

## Discovery (new phase, D2)
The LAT=2 run is an exact, complete search of all pure-lattice no-T programs: "none <= 31" there means no pure-lattice sort5
shorter than AlphaDev (a search result, not a proof); a find is a candidate for the strict judge. k <= 31 needs ~120 GB
in memory -> disk mode (EXTDIR) and the go after the sort4 check.
