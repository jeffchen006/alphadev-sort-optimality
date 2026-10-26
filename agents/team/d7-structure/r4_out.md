**The c=9 claim remains unresolved.** I found no proof and no design with c=9 and writes≤22. The proposed event count does not yet justify removing c=9 from the search.

1. **CHECKED — Counts and candidate inequalities.** Let `w=g+v`.

   | Program | n | c | w | 2c+n | 3c−4 |
   |---|---:|---:|---:|---:|---:|
   | AlphaDev sort3 | 3 | 3 | 8 | 9 | 5 |
   | Recovered sort4 | 4 | 5 | 15 | 14 | 11 |
   | Known optimum families | 5 | 9 | 23 | 23 | 23 |
   | `avoid_a_copy_33.s` | 5 | **11** | **22** | 27 | 29 |

   Thus `w≥2c+n` fails already at n=3. `w≥3c−4` is consistent with the stated n=3 and n=4 examples, but fails at c=11.

   The c=11 program is pure lattice and strict-judge PASS. Deleting **any one of its 11 comparisons** causes a failure on a weak order. This is a real comparison/write trade-off: versus the c=9 optimum, two additional comparisons permit one fewer write.

2. **CHECKED — What the data establishes.**

   - All **868,567** collection programs have c=9, w=23. Every comparison block has at least two writes.
   - All **26** family programs have `(c,g,v)=(9,18,5)`, with at least two writes per block.
   - Ten sampled correct c=9 files passed the strict judge. Their write counts were 24–26.
   - Nevertheless, “every c=9 comparison block has two writes” is false without another hypothesis. This [strict-PASS control](/path/to/repo/agents/team/d7-structure/codex_work/r4/c9_onewrite_block.s) has c=9, w=25 and a one-write block. It inserts a redundant comparison. It does **not** refute the target bound.

3. **ARGUMENT — A precise overwrite invariant, and its limit.**

   Fix a distinct-input case and choose garbage outside the input values. Before rank `j`’s final output snapshot, at least one register must retain that value. Once its last register copy disappears, mov/cmov cannot recreate it.

   Therefore, an overwrite that removes a still-needed value must leave another copy somewhere. But that copy can come from an earlier **useful gate result**, rather than an additional copy instruction. The zero-copy full comparator in net9_103 demonstrates this issue.

   This invariant does not supply five extra instructions. Counting events across input cases also needs care: one cmov handles many cases. Free output snapshots provide no one-write-per-output charge.

   A further constraint on any argument: appending an unused cmp preserves correctness and w. Consequently,
   \[
   W_{\min}(c+1)\le W_{\min}(c).
   \]
   A lower bound that increases with c cannot hold for all c without additional restrictions. This does not disprove the fixed c=9 claim.

4. **CHECKED — n=4 searches, with explicit scope.**

   I enumerated all **22 network term sets** from five- and six-comparator networks, modulo input permutation and reversal. Each pool search used all 75 weak orders.

   | Budget | Result across these pools |
   |---|---|
   | c≤5, w≤14 | NONE |
   | c≤6, w≤13 | NONE |
   | c≤6, w≤14 | NONE |
   | c≤5, w≤15 | MIN k=20 in the five-comparator pool |

   The recovered [length-20 program](/path/to/repo/agents/team/d7-structure/codex_work/r4/n4_positive20.s) passed the strict judge. Within these pools, the sixth comparison saves no writes.

   **These are restricted negatives.** Unbounded-register synthesis relaxations for `(c,w)=(5,14)` and `(6,13)` both timed out after 480 seconds. They established no global n=4 lower bound. I found no n=4 counterexample for part B.

5. **GUESS — Search decision.**

   Keep c=9 active. The missing step is a global charge for **five writes beyond 2c**, valid for non-lattice selections and conditional backups. Neither output count, full-comparator count, nor the tested overwrite invariant supplies that charge.

Full counts and search scopes are saved in [audit.json](/path/to/repo/agents/team/d7-structure/codex_work/r4/audit.json), [net4_results.json](/path/to/repo/agents/team/d7-structure/codex_work/r4/net4_results.json), and [conclusions.json](/path/to/repo/agents/team/d7-structure/codex_work/r4/conclusions.json).