**A1 remains unproved. A2 does not yet supply a valid routing charge. For A3, residual R1 distance gives a provable sort4 slack of at most 5.**

1. **A1: the weaker target is a preservation-cost bound.**

   Let \(b_i\ge1\) be the cmov count in comparison block \(i\). Define
   \[
   S=\#\{i:b_i=1\},\qquad E=\sum_i(b_i-2)_+.
   \]
   Then
   \[
   m=2c-S+E,\qquad W=2c-S+E+v.
   \]
   Thus the sufficient weaker statement is
   \[
   \boxed{S\le E+v+1\quad\Longleftrightarrow\quad W\ge2c-1.}
   \]
   It closes \(c\ge11\), since \(k\ge3c-1\ge32\).

   **I cannot prove this statement.** A singleton block can store information in one selected value. Later comparisons and cmovs can use that value. Charging each singleton to a *different* mov or surplus cmov needs a new lemma. Local necessity does not give that injection.

   A provable partial statement is:

   > If the last comparison splits a comparison-history class, its block contains at least two cmovs.

   **Proof sketch.** Choose two permutations with the same preceding outcomes and different last outcomes. Before the last comparison, every node has the same input symbol on both runs. With one subsequent cmov, only one new node can differ. Therefore at most one output symbol can differ. Two distinct permutations require at least two output symbols to differ. Contradiction.

   This permits a last singleton block whose comparison splits no history class. It does not bound earlier singleton blocks.

   **Sort4 test:** existing R4 can test the stronger singleton prohibition:
   ```sh
   ./agents/bounds/rsearch 4 4 1 20 10
   ```
   The comparison cap 10 covers length 20 because \(m\ge10\). `none` would establish the stronger statement for this relaxation. A singleton witness alone would refute the block claim; check its aggregate counts separately before concluding \(m<2c\).

2. **A2: balance constrains outcomes, but does not charge routing.**

   Let \(O_t\) be comparison outcome \(t\), under uniform input permutations. Correctness makes the full outcome history identify the permutation. Hence
   \[
   \sum_{t=1}^{c}\left[1-H(O_t\mid O_{<t})\right]
   =c-\log_2(n!).
   \]
   For sort5, the total entropy deficit is
   \[
   0.093109\quad(c=7),\qquad1.093109\quad(c=8).
   \]
   Thus \(c=7\) forces nearly balanced splits **in weighted average**. The \(c=8\) constraint is substantially weaker. Neither equation specifies where comparison operands came from.

   The valid extension of Lemma D is a **union bound**. For permutation \(s\), define:

   - \(L(s)\): total length of the output active paths.
   - \(R(s)\): number of cmov nodes on comparison-operand active paths that are absent from every output active path.

   Then
   \[
   m\ge L(s)+R(s),\qquad
   W\ge\operatorname{Huff}(n)+\mathbb E R+v.
   \]
   Paths for operands and outputs holding the same symbol can overlap. Counting them separately is invalid.

   With the existing Huffman bound, closing sort5 requires
   \[
   \boxed{\mathbb E R+v\ge13\ (c=7),\qquad
          \mathbb E R+v\ge12\ (c=8).}
   \]
   There is no derivation of these numbers from balance alone.

   **The required small-\(n\) tests expose a missing term.** I computed active-path unions on the local AlphaDev cores:

   | Program | \(m\) | \(v\) | \(\mathbb E L\) | \(\mathbb E R\) |
   |---|---:|---:|---:|---:|
   | sort3, supplementary 17 | 6 | 2 | \(17/3\) | 0 |
   | sort4, supplementary 28 | 10 | 5 | 10 | 0 |

   Keeping only the Huffman baseline would require \(\mathbb E R+v\ge3\) for sort3 and \(\ge7\) for sort4. These examples give 2 and 5.

   Therefore **Huffman plus a routing-only charge cannot recover the requested analogues**. A2 must also quantify increased output-path cost or value preservation. A cmov-only bound cannot establish those analogues either: the witnesses already have \(c+m=9\) and 15.

3. **A3: use residual R1 distance, with the comparison count fixed.**

   For state \(s=(A,f,\mathrm{done})\), let \(D(s)\) be the exact remaining R1 cmov cost:

   - Comparisons and copies are free.
   - Columns remain available after creation.
   - Already completed outputs need no further work.
   - The current flag vector \(f\) remains available as a free selector.

   The last condition is necessary: the operands that produced \(f\) may have disappeared from \(A\).

   In case \(c=c_0\), after \(a\) comparisons, use
   \[
   \boxed{h(s)=c_0-a+D(s).}
   \]
   Every real suffix induces an R1 suffix. Its comparison and cmov costs are disjoint. Thus \(h\) is admissible.

   **Sort4 slack is provably at most 5.** Let \(q\) be the prefix’s set-cmov count and let \(p=g-a-q\ge0\) be its remaining cost, including copies. Write \(M_n\) for the root R1 minimum. Concatenation gives
   \[
   q+D(s)\ge M_n.
   \]
   Therefore, on a length-\(K\) trajectory,
   \[
   K-g-h(s)\le K-c_0-M_n-p.
   \]
   For sort4, \(K=20,\ c_0\ge5,\ M_4=10\):
   \[
   \boxed{\text{slack}\le5-p\le5.}
   \]

   I checked the weaker count bound
   \[
   h_{\rm count}=c_0-a+\max(0,10-q)
   \]
   on five local sort4 traces with set cost 20. Each had maximum slack 5. I did **not** compute residual R1 distances.

   **Measurement:** use `hr_slack.py:set_trace` to obtain states and \(g\). Record \(a,q\), evaluate \(D(s)\), and print \(20-g-h(s)\). The current script calls mode 7; residual R1 evaluation needs a start-state interface to mode 1. Include `done` and the cached selector \(f\). For register-based `TRACE`, compare this bound directly with `rem`; R1 already makes copies free.

   **Sort5 threshold:** the same argument guarantees slack at most 6 if
   \[
   M_5\ge17\quad(c_0=9),\qquad M_5\ge16\quad(c_0=10).
   \]
   These are concrete targets. Neither is currently established. This moves the main difficulty into the R1 bound.

4. **The route is unresolved, but your slack criterion is not a necessity theorem.**

   Small slack on optimal trajectories is insufficient. Failed branches can still dominate the search. Large early slack is also permissible if few prefixes survive. Measure frontier counts and heuristic evaluation time alongside trace slack.

   Under your empirical factor \(20\), reducing the sort5 bound gap from \(32-19=13\) to 6 represents
   \[
   20^7=1.28\times10^9
   \]
   in extrapolated search reduction. Fixing \(c=9\) raises the current root bound only to \(9+12=21\); five units still separate its gap from 6.

   The reported sort4 rate is about \(2.4\times10^5\) states/s. At that rate, \(10^{15}\) states take about **131 years**. At 64 bytes/state, storage is **64 PB**. These are extrapolations, not lower bounds on search cost.

   One model qualification matters: [enum STATUS](/path/to/repo/agents/enum/STATUS.md) reports the sort4 length-19 result with `NG=1`. Under PRUNING v3, that establishes the **strict** lower bound. That run alone does not establish the unrestricted T-relaxed optimum as 20.

No files were changed.