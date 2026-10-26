**The samples support a stronger local rewrite than care-set completion: replace a non-lattice cmov by `mov D,S`. I tested this directly.**

1. **L-NF: strong empirical support, but no proof.**

   I repeatedly replaced the first non-lattice cmov result—including T-partials—by an unconditional move from its source. I checked correctness after each replacement.

   | Samples | Initially non-pure | Replacements | Failed programs |
   |---|---:|---:|---:|
   | 30,000 sort4 | 20,092 | 29,133 | 0 |
   | 5,000 sort5 | 2,596 | 3,443 | 0 |

   All permutation checks passed. The first 1,000 normalized programs of each size also passed all 75/541 weak orders, with scratch = T and initial flags = eq. Instruction counts and comparison counts stayed unchanged.

   This explains much of D1: the sampled non-lattice columns can be artifacts of guarded moves.

   **Care-set completion has an exact, cheap test.** For each care permutation and each top-set \(B\), require
   \[
   f(B)=[\text{held index}\in B].
   \]
   Let \(\mathcal P,\mathcal N\) be the required positive and negative sets. A lattice completion exists exactly when
   \[
   \boxed{\nexists P\in\mathcal P,\ N\in\mathcal N:\ P\subseteq N.}
   \]
   A constructive completion is
   \[
   f(B)=1\iff \exists P\in\mathcal P:\ P\subseteq B.
   \]
   For \(n=5\), this operates on 32 Boolean positions.

   Two gaps remain:

   - Output-path care alone omits changes to comparison outcomes.
   - A lattice completion need not be producible by the original one-cmov instruction.

   A general local care-set theorem is false. Prefix a sorter with
   ```text
   cmp P0, P1
   mov S, P2
   cmovl P2, P3
   cmovl P3, S
   ```
   Then sort the resulting permutation with compare-exchanges. The two routed columns are non-lattice and remain on output active paths on every permutation. Their care sets are full. Optimality must rule out this kind of routing.

   For \(n=3,k=11\), an all-lattice optimum already exists. Thus n=3 cannot supply the requested existential counterexample to L-NF.

2. **A sound use without L-NF: require an essential first escape.**

   Include constant \(T\) in the allowed alphabet. For a program \(P\), define a bit vector \(\beta(P)\): position \(t\) is 1 when instruction \(t\) creates a column outside that alphabet.

   Among correct programs with fixed \(k,c\), choose one with lexicographically minimum \(\beta\). Its first non-lattice instruction
   \[
   \texttt{cmovX D,S}
   \]
   must satisfy:
   \[
   \boxed{\text{Replacing it by }\texttt{mov D,S}\text{ makes the program incorrect.}}
   \]

   **Proof sketch.** Before the first escape, \(S\) is lattice or constant T. The replacement therefore changes the first bad bit from 1 to 0. Earlier bits, length, and comparison count stay unchanged. If correctness survived, lexicographic minimality would fail.

   This gives a complete split:

   - Every created column is lattice or constant T.
   - There is a first escape at \(t\), with a witness permutation and output where the unconditional-move version fails.

   A SAT encoding can add **one modified execution**, with an existential witness permutation. Share the instruction choices and change only instruction \(t\). This excludes every sampled escape above from the canonical representative.

   It gives no numeric surcharge yet. It does identify the escape class that needs a cost argument: **genuine routing whose guard cannot be removed**.

   Also, arbitrary T-partials invalidate the 7,579-element alphabet. A max-min polynomial with constant \(+\infty\) is either a finite lattice polynomial or identically T. It cannot be T on only some permutations.

3. **Write accounting: use creating cmovs and charged copies, not raw \(m,v\).**

   Pure lattice does **not** imply that each new result is a minimum or maximum of its source columns. Write \(\wedge=\min,\ \vee=\max\). Let
   \[
   d=a\wedge b\wedge z,\qquad
   s=z\wedge(a\vee b),\qquad
   v=a\wedge z.
   \]
   Then
   ```text
   cmp d, v
   cmovge d, s
   ```
   produces
   \[
   d_{\rm new}=b\wedge z.
   \]
   This result is lattice, but globally equals neither old \(d\), \(s\), \(d\wedge s\), nor \(d\vee s\). Thus comparator-block accounting does not cover all pure-lattice transitions.

   The valid accounting is the following. In a reduced pure-lattice set program, let

   - \(q=\sum_i q_i\): cmovs that create a new column;
   - \(a\): copy operations that preserve the destination column.

   A nontrivial creation into T cannot remain pure lattice. Hence every increase in set size requires a charged copy:
   \[
   \boxed{W_{\rm set}=q+a
      =\sum_i q_i+|A_{\rm final}|-n.}
   \]
   Lemma S gives \(W_{\rm register}\ge W_{\rm set}\).

   Raw mov counts can hide these charges. Among your pure-lattice sort4 samples, 12 have \((m,v)=(13,2)\). For example, zero-based program 14956 maps to
   \[
   q=10,\qquad a=5,\qquad W_{\rm set}=15.
   \]
   Three cmovs supply charges that raw mov counting misses.

   At least one charged copy is necessary: before the first new column, no output is available, and an in-place change would lose an input value on some permutation. Together with the known R1 bounds, this gives only
   \[
   W\ge7,\ 11,\ 13\qquad(n=3,4,5).
   \]
   I have no independent block proof reaching 15 or 23. The missing statement is a bound on **\(q+a\)**. A lower bound on raw \(v\) cannot supply it.

4. **Lattice-only search: smaller alphabet, still no feasible-state estimate.**

   I enumerated all 7,579 finite lattice columns. Then I counted additive lattice-R1 states: retain the initial columns and every new result; comparisons and copies are free. Counts are exact modulo input renaming.

   | Added columns | Canonical reachable sets |
   |---:|---:|
   | 0 | 1 |
   | 1 | 2 |
   | 2 | 11 |
   | 3 | 86 |
   | 4 | 860 |

   The computation took about 1.7 seconds. Every counted set is also reachable by a pure-lattice register prefix of cost at most three instructions per addition. These counts exclude flags and goal-based pruning.

   At the unrestricted root, one selector can create **200 distinct finite columns**: 20 lattice and 180 non-lattice. It can also create 100 T-partials. Thus escapes have substantial branching and can occur immediately.

   For a pure-lattice length-31 search, \(c\ge7\) leaves \(W\le24\). Set growth costs two writes per added column, so \(|A|\le17\). Nevertheless,
   \[
   \binom{7579}{10}\approx1.71\cdot10^{32},\quad
   \binom{7579}{15}\approx1.18\cdot10^{46},\quad
   \binom{7579}{17}\approx2.48\cdot10^{51}.
   \]
   These are candidate-set counts, not reachable-state estimates. The small-depth counts do not justify a runtime forecast at 31. For lattice R1 at 17 additions, continuing the latest \(10\times\) growth would give roughly \(10^{16}\) unpruned sets; target pruning could change that substantially.

No files were changed.