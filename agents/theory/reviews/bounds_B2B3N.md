# Review of agents/bounds/BOUNDS.md B2, B3, Lemma D, Lemma R1, N1-N4, heuristic H — theory, 2026-10-24
**Verdict: all CORRECT.** Notes:
- B2: the swap s -> s' (exchange x_a, x_b, adjacent ranks) keeps every comparison not between {x_a, x_b} (third value is
  above or below both; T same; equal symbols eq). Correct.
- Lemma D: correct (a shared node has one symbol on s).
- B3: path strings over {S-child, D-child} end only at leaves, so the set is prefix-free; one shortest path per end leaf
  gives n distinct codewords; Kraft; uniform y_j(s); Lemma D. Huff(n) = 2, 5, 8, 12 checked (codes 0/10/11; 00/01/10/110/111).
  Holds for strict and relaxed, I0/I1, any output rule. Correct.
- Lemma R1 (cmp, mov free): correct; pre-cmp cmovle/ge copy, cmovl/g do nothing; all-eq flags give no new column.
- N1-N4: correct as "a shortest program exists with N1-N4" (with a sweep / NOP suffix, L4). N1 is a transformation rule
  (D-type): jointly sound with N2-N4 (renaming keeps N1; N2, N3 are minimality), but NOT automatically with other
  teams' D-rules (comm, canon by first touch, pcanon, cmpord): do not mix without a joint proof. N3 in snap mode: "the last
  instruction writes a register that is snapshotted at the end".
- H: H1 (#distinct requirement vectors per class <= #leaves), H2, H3 (Huffman cost of the distribution of the end column,
  by Kraft over one shortest path per column; else >= 1 when t_j is absent) are lower bounds on a SHORTEST completion
  (the "m >= c_lb" part uses N2). Admissible.
