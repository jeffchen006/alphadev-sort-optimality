**No `k <= 31` program found. CHECKED:** 376 distinct design pools gave `NONE <= 31`. All used automatic `R=10`.

| Idea | Pool files / runs | Result |
|---|---|---|
| Other sort3 steps and reversed merge | `pool_s3_*` / 12 | NONE |
| Alternative bounds; retain old terms | `pool_bound_*` / 8 | NONE |
| Alternative bounds; remove copy substitutes | `pool_trim_bound_*` / 41 | NONE |
| Change final pivots and pair tracking | `pool_trim_tail_*` / 153 | NONE |
| Start merge with new comparison operands | `pool_trim_early_*` / 78 | NONE |
| Add two conditional states at `cmp(max34,max012)` | `pool_hpair_*` / 28 | NONE |
| Add three conditional states; replace first select by mov | `pool_htriple_*` / 56 | NONE |

Every pool filename, size, and result is in [runs.csv](/path/to/repo/agents/team/d7-structure/codex_work/r5/runs.csv).

**CHECKED—fix (a):** [control32_found.s](/path/to/repo/agents/team/d7-structure/codex_work/r5/control32_found.s) computes the maximum by growing `max012`. It preserves `max34`, but copies `max012` instead. Strict judge **PASS**, `c=8, g=19, v=5, k=32`. The six-copy count remains.

**CHECKED—fix (b):** My local SMT model returned **UNSAT** for two comparisons plus four writes from the current state entering the last two blocks. It allows arbitrary selects and conditional writes into fresh scratch through a garbage relaxation. The five-write control produced [window_tail_w5.s](/path/to/repo/agents/team/d7-structure/codex_work/r5/window_tail_w5.s), which passed the strict judge at 32. This result applies only to that entering state.

The completed pool searches used `pool_bfs` with one added pruning rule: reject a state that has lost a required output value. Six preliminary calls to the unchanged binary timed out; three were interrupted. Three larger SMT queries also timed out. These runs give no exclusions.

**GUESS:** Change pair tracking before the last two blocks. Moving the maximum calculation alone transfers the copy cost.

Definitions, formulas, and search limits are in [RESULTS.txt](/path/to/repo/agents/team/d7-structure/codex_work/r5/RESULTS.txt).