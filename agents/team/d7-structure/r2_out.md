**Checked: 54 distinct pools, 86 BFS runs. Every run returned `NONE <= 31`.** No FOUND path was available for T2.

Files are `codex_work/pool_<ID>.txt`. Size includes the five inputs. `N` means `NONE <= 31` for each listed R. Exact definitions and logs are in the [manifest](/path/to/repo/agents/team/d7-structure/codex_work/round2_manifest.json) and [results table](/path/to/repo/agents/team/d7-structure/codex_work/round2_summary.tsv).

| ID / idea | Size | R | Result |
|---|---:|---|---|
| merge23: supplied adaptive merge | 23 | 9 | N |
| merge_rev0: opposite first route | 24 | 9 | N |
| merge_rev1: opposite second route | 24 | 9 | N |
| merge_rev2: opposite third route | 24 | 9 | N |
| merge_rev_all: three opposite routes | 26 | 9 | N |
| merge_projected: lattice counterparts | 26 | 9 | N |
| merge_cross0: min/max of routes 15,16 | 25 | 9 | N |
| merge_cross1: min/max of routes 16,17 | 25 | 9 | N |
| base_low_both: two associated maxima | 25 | 9/10 | N |
| base_low_one: one associated maximum | 24 | 9/10 | N |
| base_high_both: two associated minima | 25 | 9/10 | N |
| base_high_one: one associated minimum | 24 | 9/10 | N |
| base_split: central selected pivots | 25 | 9/10 | N |
| base_right: upper selected pivots | 25 | 9/10 | N |
| base_middle: middle selected pivots | 25 | 9/10 | N |
| base_last: final selected pivots | 25 | 9/10 | N |
| fj7_00: singleton first, clamps 0/0 | 27 | 9/10 | N |
| fj7_11: singleton first, clamps 1/1 | 27 | 9/10 | N |
| fj7_22: singleton first, clamps 2/2 | 27 | 9/10 | N |
| fj7_33: singleton first, clamps 3/3 | 27 | 9/10 | N |
| fj7_03: singleton first, clamps 0/3 | 27 | 9/10 | N |
| fj7_30: singleton first, clamps 3/0 | 27 | 9/10 | N |
| fj7_12: singleton first, clamps 1/2 | 27 | 9/10 | N |
| fj7_21: singleton first, clamps 2/1 | 27 | 9/10 | N |
| fj8_00: pending low first, variant 00 | 26 | 9/10 | N |
| fj8_70: pending low first, variant 70 | 26 | 9/10 | N |
| fj8_21: pending low first, variant 21 | 26 | 9/10 | N |
| fj8_51: pending low first, variant 51 | 26 | 9/10 | N |
| base_sur3138: selected comparison operand | 24 | 9/10 | N |
| base_sur3139: selected comparison operand | 24 | 9/10 | N |
| base_sur4615: selected comparison operand | 24 | 9/10 | N |
| base_sur4616: selected comparison operand | 24 | 9/10 | N |
| base_sur4619: selected comparison operand | 24 | 9/10 | N |
| base_sur4620: selected comparison operand | 24 | 9/10 | N |
| base_sur6213: selected comparison operand | 24 | 9/10 | N |
| base_sur6233: selected comparison operand | 24 | 9/10 | N |
| base_sur3_0: three selected operands | 26 | 9/10 | N |
| base_sur3_1: three selected operands | 26 | 9/10 | N |
| base_sur3_2: three selected operands | 26 | 9/10 | N |
| base_sur3_3: three selected operands | 26 | 9/10 | N |
| hybrid_low: aligned merge + lower terms | 27 | 9 | N |
| hybrid_clip: aligned merge + clamp terms | 27 | 9 | N |
| hybrid_high: aligned merge + upper terms | 27 | 9 | N |
| hybrid_bridge: aligned merge + shared terms | 27 | 9 | N |
| hybrid_core: aligned merge + sort4 terms | 27 | 9 | N |
| hybrid_middle: aligned merge + middle terms | 27 | 9 | N |
| merge_m1: conditional middle exchange | 23 | 9 | N |
| merge_m1_altcore: alternate sort3 core | 23 | 9 | N |
| merge_m1_bothcore: both sort3 intermediates | 24 | 9 | N |
| merge_m1_routes: original routes added | 25 | 9 | N |
| merge_m1_caps: bounded copy sources | 26 | 9 | N |
| merge_m1_altcaps: alternate core + sources | 26 | 9 | N |
| merge_m1_capsroute: sources + original route | 27 | 9 | N |
| merge_m1_projected: lattice counterparts | 26 | 9 | N |

**T3 — Guess:** sort2+sort3 with adaptive merge remains most promising. Its relaxed bounds stay at 18 creations plus eight comparison blocks. The singleton-first FJ pools required 20 creations plus nine blocks; they did not realize the intended seven comparisons. I would target merge routes that replace copies.

All searches used two workers at `nice -n 10`. Individual search durations summed to 20.1 minutes.