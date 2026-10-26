I would test the following five techniques, in this order. Their reductions are sound. **None currently establishes 32.** The numerical targets below are tests to run, not verified bounds.

Write \(c=\#cmp\) and \(W=\#mov+\#cmov\).

1. **Separate comparison trees from routing costs.**

   **Statement:** For each depth-\(c\) comparison tree, compute a lower bound on the writes needed to supply its comparison operands and outputs. Represent each required value as a column over the 120 permutations. Fix each comparison’s flag column. Charge in-place selection 1 and selection into a copy 2, as in Lemma S. Require operand columns before their comparison.

   **Soundness:** Every sorting program induces such a tree. Its register execution supplies a feasible routing execution. Thus \(k\ge c+\min_T W(T)\). A master search can choose trees; routing failures can exclude trees or partial trees.

   **Expected bound:** Best prospect for closing \(c=7,8\): the required bounds are respectively \(W\ge25,24\). This directly charges the expensive adaptive operand selection that comparison counting misses.

   **Cheap test:** Recover \(W=8\) for sort3 with \(c=3\), then \(W=15\) for sort4 with \(c=5\). Start with prescribed trees before enumerating all trees.

2. **Solve short suffixes exactly through flag partitions.**

   **Statement:** During a block with no new comparison, partition the permutations by `lt`, `eq`, and `gt`. On each partition, every resulting register equals one register from the block’s entry state. Thus, with \(a\) entry columns, every possible resulting column has an origin tuple from at most \((a+1)^3\) choices, including \(T\).

   **Soundness:** Within each partition, every conditional move has a fixed outcome. Induction through the block proves the origin claim. This gives a finite, exact block model, including copy costs and free outputs.

   **Expected bound:** A stronger suffix bound, rather than a new root bound. Compute exact completion costs for one or two remaining comparison blocks. Use them to reject prefixes whose remaining budget is too small. This avoids assuming two conditional moves per block.

   **Cheap test:** Enumerate one-block completions of sort3 prefixes. Then test two-block completion costs on sort4 prefixes. Each computed cost must not exceed the known suffix length.

3. **Use rank-row inclusion for state dominance.**

   **Statement:** Store each scenario as a row of register ranks and flags. Treat these rows as a set. State \(A\) dominates state \(B\) if a common register mapping makes the projected row set of \(A\) a subset of that of \(B\), \(A\) has at least the outputs already taken by \(B\), and \(A\) costs no more. At block boundaries, omit flags.

   **Soundness:** Every suffix acts on rows independently. A suffix that succeeds on every row of \(B\) also succeeds on the matched rows of \(A\). Output rank \(j\) is the same constant target in every row. Duplicate rows add no requirement.

   **Expected bound:** No numerical root improvement. This can preserve an exact search for 32 while merging states beyond the existing input-renaming and column-superset rules.

   **Cheap test:** Compare state counts against existing canonicalization. My in-memory sort3 test found **no extra merges among non-dead states through cost 5**. Require a measurable reduction at greater depth before investing further.

4. **Synchronize small input projections with a flow LP.**

   **Statement:** Build transition graphs for small subsets of permutations. Keep physical operand indices. For each instruction position, introduce one common instruction distribution. Require each projected graph’s transition flow to have that same instruction distribution. Start each flow at its initial state and require it to finish at a goal.

   **Soundness:** Every real program gives integral flows with identical instruction labels in every projection. Allowing fractional flows is a relaxation. Therefore LP infeasibility at length 31 excludes every real program of that length. A rational infeasibility certificate can be checked independently.

   **Expected bound:** Potentially stronger than taking the maximum of independent pattern distances, because instruction choices must agree across patterns. There is no justified numerical forecast yet.

   **Cheap test:** Use overlapping pairs or triples of sort3 permutations. Compare the LP bound with independent pattern bounds at short horizons. Stop if synchronization adds nothing.

5. **Test a comparison relaxation that retains routing costs.**

   **Statement:** Forget order consistency. For each required output permutation, let each comparison choose either direction independently when its operands hold different input symbols. Keep equality and comparisons involving \(T\) exact. Keep the shared instruction text, register writes, and output snapshot choices.

   **Soundness:** Every actual sorting execution supplies permitted choices. Hence every sorter is feasible in this relaxation.

   **Expected bound:** It might establish 32 from permutation routing and copy preservation alone. If it admits a shorter program, that program identifies which order constraints the stronger encoding must restore.

   **Cheap test:** First exclude length 10 for sort3 and length 19 for sort4. My 12-second sort3 SAT pilot was inconclusive. Do not proceed directly to sort5.

The sort4 lemma needs care: the existing sentinel restriction yields a different machine. Its optimum cannot simply be replaced by 20. I would prioritize techniques 1 and 2 because they charge routing and copy costs directly, without that induction gap.

No files were changed.