1. **Q1 — Checked: \(Q\ge\#\text{full comparators}\) is false in general.**

   The identity \(k=c+G+Q\) holds if these counts partition the instructions. The proposed lower bound on \(Q\) needs extra conditions.

   **Zero-copy full comparator:** let `A=a`, `B=b`, `C=min(a,d)`, with \(b\le d\). These terms must already exist.
   ```text
   cmp A,B
   cmovl A,B
   cmovl B,C
   ```
   Results: `A=max(a,b)`, `B=min(a,b)`. When \(a<b\), `C=a`, so `C` supplies the destroyed operand.

   **Two full comparators sharing one copy:** assume \(d\le b\).
   ```text
   mov T,A
   cmp A,B
   cmovl A,B
   cmovl B,T
   cmp T,D
   cmovl T,D
   cmovl D,B
   ```
   Results: `A=max(a,b)`, `B=min(a,b)`, `T=max(a,d)`, `D=min(a,d)`.
   When \(a<d\), the bound \(d\le b\) gives `B=a`. Thus the second comparator needs no additional copy.

   Both fragments passed all 541 weak orders with concrete lattice-term inputs. They use no garbage or unknown flags. Their setup costs remain part of any complete program.

2. **Q2 — Checked restrictions and a useful gate block; no complete 31-instruction candidate found.**

   If you impose the observed rules—one copy per full comparator, separate full-comparator comparisons, and at most two halves per remaining comparison—then:
   \[
   k\ge4F+H+\lceil H/2\rceil .
   \]
   Thus:
   - `6 full + 6 half`: minimum **33**. Five borrows require sharing beyond those rules.
   - `4 full + 10 half`: budget **31**.
   - `5 full + 7 half`: budget **31**, if a 17-gate circuit exists.

   **Checked: one comparison can decide four distinct gates.**
   Assume \(a\le d\), \(e\le b\), `N=min(b,d)`, and `P=max(a,e)`.
   ```text
   cmp A,B
   mov T,A
   cmovle A,B
   cmovle B,T
   cmovg N,T
   cmovg P,B
   ```
   All four gates use `cmp A,B`:
   ```text
   A = max(a,b)       B = min(a,b)
   N = max(a,min(b,d))
   P = min(max(a,e),b)
   ```
   Cost: **1 cmp + 4 gates + 1 copy = 6**. Setup is excluded.
   This passed all 541 weak orders with `a=min(x0,x1)`, `d=x0`, `b=max(x2,x3)`, `e=x2`.
   **Guess:** this block is useful when both capped terms already serve other outputs.

   **Checked search results:**
   - The example’s 23-term pool permits 28 min/max gate choices, including alternative decompositions.
   - It still needs at least 18 gates and 9 comparison blocks.
   - I also tested all 155 additional terms formed by one min/max of two base-pool terms, one extra term per search.
   - Every extended pool still needs at least 18 gates and 9 comparison blocks.
   - None permits `G=18,Q≤4` or `G=19,Q≤3` in the relaxed copy search.

   These checks exclude 31 for those pools with distinct-term min/max gates and ordinary copies. They do not cover arbitrary conditional values or two additional terms.

3. **Q3 — Checked local saving from an adaptive comparison; no verified deletion from the 32-instruction example.**

   ```text
   cmp P0,P1
   cmovl P3,P2
   cmp P3,P4
   cmovg P3,P4
   ```
   This computes:
   ```text
   P3 = min((x0<x1 ? x2 : x3), x4)
   ```
   The selected value does real work as a comparison operand. It is generally non-lattice.

   A legal alternative computes both `min(x2,x4)` and `min(x3,x4)`, then compares `x0,x1` and selects. That costs six instructions. This fragment costs four: it removes **one cmp and one min gate**.

   The fragment passed all 541 weak orders. **Guess:** conditional routing of a comparison operand could remove a duplicated comparison branch in a different sorting design. I have no verified mapping that removes a specific instruction from `ex_prog1.txt`; this is not a 31-instruction sorting candidate.

4. **Q4 — Proposed measurements on the 868k programs.**

   - **Alternative source table:** for every cmov, test every live register as its source on all 541 weak orders. Record substitutions that preserve the result. Include sources that agree only where the condition holds. This directly detects the Q1 mechanism.
   - **Conditional copy demand:** for each copy, record the weak orders on which later instructions need its saved value. Find two saved values with disjoint demand sets. Then test whether one conditional register can carry both.
   - **Blocked comparison sharing:** for every comparison that can decide three or more gates, record which comparison operand is unavailable at the earliest useful point. Rank the resulting dependency cycles. The one-extra-term checks suggest testing two-term changes next.
   - **Semantic comparison redundancy:** for each prefix, enumerate available comparison pairs. Group pairs by which remaining gates they can decide, including operand direction and condition. Measure opportunities absent from the executed flag skeleton.
   - **Broader sampling:** compare the term sets of correct `c=8,k=33` programs against these optima. Rank the smallest changes needed to reduce gates or copies. Register variants of one DAG provide limited structural diversity.

Checks and limits are recorded in [RESULTS.md](/path/to/repo/agents/team/d7-structure/codex_work/RESULTS.md). Compute used one core with `nice`, for less than three minutes.