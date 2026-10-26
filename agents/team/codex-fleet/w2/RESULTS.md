No program with core k <= 31 has passed the strict judge.

The best verified reference core has k=32 and memory length 42. It comes
from worker w6. This matches AlphaDev's length. It is not a w2 discovery.

All paths below are relative to this worker folder. The latest completed
round routes 300 new ten-comparison skeletons at K=31. It has 300 exhaustive
NONE and 0 unknown results. The 06:20 audit below records the results.
The preceding nine-comparison round has 208 exhaustive NONE and 0 unknown.

| Family | Cases | Method and limit | Recorded results |
| --- | ---: | --- | --- |
| Ten-comparator networks | 21,162 | Conservative DAG routing, 30 million nodes | NONE 21,162 |
| New tail repeats in nine-comparison mutation skeletons | 300 | DAG routing, no node limit; 3,600-second wall limit | NONE 300 |
| Repeat one earlier comparison | 1,476 | DAG routing, 3 million nodes | LIMIT 777, NONE 699 |
| Add a comparison among earlier terms | 7,656 | DAG routing, 100,000 nodes | LIMIT 7,644, TIMEOUT 2, NONE 10 |
| Two refreshes in eight-comparison seeds | 924 | 462 DAG cases at 300,000 nodes; 462 SAT cases at 20,000 conflicts | LIMIT 462, UNSAT 462 |
| Add a final comparison | 2,212 | SAT, 5,000 conflicts | UNSAT 1,042, LIMIT 1,169, ERROR 1 |
| Retry limited final-comparison cases | 1,170 | SAT, 20,000 conflicts | UNSAT 1,170 |
| Selected cases, including reused results | 721 | SAT, 20,000 conflicts | UNSAT 721 |

The selected SAT row overlaps the other rows. The deeper pass retries
limited or failed broad cases. These are not additional distinct counts.
Six extra workers helped finish pending deep cases after the broad batches
ended. Completed results were reused. At most eight solver processes ran
at the same time.

After the retries, all 2,212 final-comparison cases returned UNSAT in the
stated finite-pool SAT model. No unresolved limit or error remains in that
family at the 20,000-conflict retry budget.

Network search:

- Generated 486,474 network sequences with the supplied network generator.
  It omits redundant comparators and keeps one order of adjacent disjoint
  comparators. Input renaming reduced these to 21,162 value skeletons.
- Each generated skeleton has 20 distinct non-input terms among its
  comparison operands and final outputs.
- The conservative router returned NONE on all 21,162 skeletons. It made
  202,390,388 recursive calls. No case reached the node or time limit.
- The original router also returned NONE on this set. The final network
  result uses the more conservative open-requirement bound.
- Source sequences: `networks10.txt`. Source mapping:
  `network_manifest.json`. Corrected generation counts:
  `logs/network_counts_corrected.json`.

Routing model and limits:

- A value column records a value for each test input order. A skeleton
  fixes the comparison operand columns. The DAG router searches moves,
  conditional moves, register reuse, and free output times.
- Routing uses the 120 distinct input orders. NONE is a search result for
  that representation and skeleton. It is not a general sort5 lower bound.
- The repeat and broad refresh batches span the original and conservative
  router versions. LIMIT and TIMEOUT leave those cases unresolved.
- Equivalent operand pairs can reproduce the same conditional move masks.
  The flag router maps opcodes to the selected pair. This includes binary
  lt/gt predicates represented with lt/eq outcomes.
- The SAT router uses a fixed value pool for each case. It permits at most
  two copies of each value column. It has no fixed total register limit.
  Its UNSAT results apply only to this pool and copy restriction.
- Later SAT jobs add value conservation and bounds on instruction times.
  A value must remain live until its output is recorded. A comparison
  must follow creation of its required operand columns.
- A free-copy relaxation enumerates subsets of value columns. It ignores
  copy costs and supplies a lower bound on conditional moves. That bound
  limits the number of counted moves in the real routing query.
- Glucose 4 and CaDiCaL 1.9.5 solve the SAT queries. Each log names its
  solver when that field is available. New constraints passed the known
  33-instruction control and both strict judges.
- The older eight-comparison seed is the supplied position33 program.
  The newer seed is `../w6/candidates/c8c_len32_c29288.s`. Each produced
  462 ten-comparison skeletons with two predicate refreshes.
- The new seed's 462 SAT cases all returned UNSAT. The selected initial
  SAT batch contained 694 cases, including reused new-seed results.
- All upper-bound candidates require the strict judge. Only a PASS on all
  541 weak orders and arbitrary scratch state counts as a verified result.

Strict judge PASS files:

| Program | Model | Length | Judge log |
| --- | --- | ---: | --- |
| [programs/conservation_control33.s](programs/conservation_control33.s) | out | k=33 | [logs/conservation_control33.judge.log](logs/conservation_control33.judge.log) |
| [programs/conservation_control33_mem.s](programs/conservation_control33_mem.s) | mem | L=43 | [logs/conservation_control33_mem.judge.log](logs/conservation_control33_mem.judge.log) |
| [programs/control_c10_k33.s](programs/control_c10_k33.s) | out | k=33 | [logs/control_c10_k33.judge.log](logs/control_c10_k33.judge.log) |
| [programs/control_c10_k33_mem.s](programs/control_c10_k33_mem.s) | mem | L=43 | [logs/control_c10_k33_mem.judge.log](logs/control_c10_k33_mem.judge.log) |
| [programs/control_flags_k33.s](programs/control_flags_k33.s) | out | k=33 | [logs/control_flags_k33.judge.log](logs/control_flags_k33.judge.log) |
| [programs/control_flags_k33_mem.s](programs/control_flags_k33_mem.s) | mem | L=43 | [logs/control_flags_k33_mem.judge.log](logs/control_flags_k33_mem.judge.log) |
| [programs/gate_control33.s](programs/gate_control33.s) | out | k=33 | [logs/gate_control33.judge.log](logs/gate_control33.judge.log) |
| [programs/gate_control33_mem.s](programs/gate_control33_mem.s) | mem | L=43 | [logs/gate_control33_mem.judge.log](logs/gate_control33_mem.judge.log) |
| [programs/sat_control.s](programs/sat_control.s) | out | k=33 | [logs/sat_control.judge.log](logs/sat_control.judge.log) |
| [programs/sat_control_mem.s](programs/sat_control_mem.s) | mem | L=43 | [logs/sat_control_mem.judge.log](logs/sat_control_mem.judge.log) |
| [programs/sat_w6_control32_repaired.s](programs/sat_w6_control32_repaired.s) | out | k=32 | [logs/sat_w6_control32_repaired.judge.log](logs/sat_w6_control32_repaired.judge.log) |
| [programs/sat_w6_control32_repaired_mem.s](programs/sat_w6_control32_repaired_mem.s) | mem | L=42 | [logs/sat_w6_control32_repaired_mem.judge.log](logs/sat_w6_control32_repaired_mem.judge.log) |
| [programs/timing_control33.s](programs/timing_control33.s) | out | k=33 | [logs/timing_control33.judge.log](logs/timing_control33.judge.log) |
| [programs/timing_control33_mem.s](programs/timing_control33_mem.s) | mem | L=43 | [logs/timing_control33_mem.judge.log](logs/timing_control33_mem.judge.log) |
| [programs/w6_seed_c8_k32.s](programs/w6_seed_c8_k32.s) | out | k=32 | [logs/w6_seed_c8_k32.judge.log](logs/w6_seed_c8_k32.judge.log) |
| [programs/w6_seed_c8_k32_mem.s](programs/w6_seed_c8_k32_mem.s) | mem | L=42 | [logs/w6_seed_c8_k32_mem.judge.log](logs/w6_seed_c8_k32_mem.judge.log) |

Controls, failed tests, and dead ends:

- The 33-instruction controls have 10 comparisons, 18 conditional moves,
  and 5 copies. Their memory conversions have length 43. They validate
  routing and decoding. They do not improve the known bound.
- The SAT reconstruction `programs/sat_w6_control32.s` and its `_mem.s`
  conversion failed on ties. The first counterexample was `[0,0,1,0,0]`.
  Both failed files and their judge logs are retained.
- `src/repair_ties.py` keeps register operands and comparison instructions
  fixed. An SMT query selects strict or inclusive conditions on all 541
  weak orders. The repaired 32-instruction reconstruction passed both
  strict judges. A repair still needs those independent checks.
- The independent concrete simulator checked control_c10_k33 and
  control_flags_k33 in both models. It used all 541 weak orders, three
  initial flag states, and three uniform scratch values. Each file passed
  4,869 cases. This finite check does not
  replace strict verification. Log: `logs/independent_check.log`.
- A maximum-clique extension did not reduce the first 3,000,000-call
  routing benchmark and ran more slowly. Main batches do not use it.
- The 27-term control SAT query returned UNSAT at k=31 without fixed
  instructions. It used 12,434 conflicts. Log: `logs/sat_target31.log`.
- The same control pool returned UNSAT at k=32 with no fixed instructions.
  It used 8,551 conflicts. Log: `logs/c10_competitive32.log`.
- One broad tail job stopped with an IndentationError while loading a
  source update. Its clean 20,000-conflict retry returned UNSAT. The
  retry log is `logs/tail_deep_accel/vc14_tail_137.log`.

Files and reproduction:

- `RUNS.md` gives build, search, verification, and tie-repair commands.
- `logs/final_batch_stats.json` records final summaries. Individual logs are in
  `logs/net10_safe/`, `logs/repeat/`, `logs/refresh/`,
  `logs/nonlattice10/`, `logs/refresh_tail/`, `logs/tail_deep/`,
  `logs/tail_deep_accel/`, and `logs/sat_selected/`.
- Search processes used `nice -n 10`. All writes stayed in this worker
  folder.

## Next round: c=9, recomputation, 2026-10-25

No new program with k <= 31 has passed the strict judge in this round.
This section supersedes the earlier CPU settings: one search job at a time,
`nice -n 19`, address-space limit below 3 GB. All writes remain in w2.

The d1 status already lists all 25 unchanged `d7-structure/fam32` skeletons
as NONE at k=31. This round does not repeat that search. The DAG router can
create a new gate even when a finished node has the same value column.
Thus it already permits recomputation, rather than only distinct-term gates.

The new generator starts with each of the 25 k=32 programs. It removes a
copy by assigning its destination to its source register for subsequent
instructions. This register sharing can change later values. It then inserts
one conditional move between any two remaining core instructions. Both
register operands must already be initialized on all 120 strict orders.
The generator retains a comparison skeleton only if its nine comparison
outcomes distinguish all 120 orders. This condition is necessary for sorting;
it does not establish that the source trace sorts.

Input renaming and comparison-operand reversal remove duplicate skeletons.
The wider pass also excludes 3,003 canonical skeletons read from 3,862
nine-comparison d1 files and the seeds. For a file with alternative operand
pairs, this exclusion reads the first pair only. It does not enumerate all
combinations of those alternatives.

| Generation | Mutations | Retained before deduplication | Excluded | Duplicate mutations | New skeletons |
| --- | ---: | ---: | ---: | ---: | ---: |
| Remove two copies, insert one cmov; exclude seeds only | 1,283,256 | 6 | 2 seed equivalents | 3 | 1 |
| Remove one copy, insert one cmov | 796,736 | 17,642 | 16,388 prior skeleton equivalents | 1,046 | 208 |

The first source traces have C=9, G=19, Q=3, hence k=31. The wider source
traces have C=9, G=19, Q=4, hence k=32. Here G counts conditional moves
and Q counts copies. Inserted operations can produce either an earlier value
or a new value. Classification is recorded separately; the generator permits
both so that it contains the recomputation cases.

The expanded exclusion check later identified the first pass's single
skeleton in the prior d1 corpus. With that corpus excluded, all six retained
two-copy-removal recipes are prior cases and there are zero new skeletons.
The first exact routing run below is therefore a recheck, not a new negative.

Completed exhaustive routing recheck:

- `sk/recompute9/r000001.txt`, k=31: **NONE**, 28,633,830 calls,
  4,320 leaves, 195.6 seconds. The 30,000,000-node limit was not reached.
  Log: `logs/recompute9_r000001_k31.log`. This result applies only to this
  fixed value skeleton in the 120-order routing representation.
- The representative k=31 source trace supplies only outputs 1, 2, and 4
  on the 120 orders. It is not a sorting candidate and has no strict PASS.
  Trace summary: `sk/recompute9/trace_checks.json`.

Both wider routing batches are complete:

| Routing scope | Cases | Calls | Exhaustive NONE | Unknown LIMIT |
| --- | ---: | ---: | ---: | ---: |
| All gates permitted by k=31 | 208 | 78,619,831 | 0 | 208 |
| At most 19 conditional moves, k=31 | 208 | 78,619,623 | 0 | 208 |

In each batch, the first six cases used a 3,000,000-node limit. The other
202 used a 300,000-node limit. Each changed-budget log starts with
`ROUND_BUDGET` and states the actual limit. The temporary launch wrappers
have been removed from the active router paths. Their saved copies end in
`_round_wrapper.saved`. LIMIT and TIMEOUT are unknown results, not negatives.

All 208 representative traces fail to supply all five sorted output columns
on the 120 orders. They are skeleton sources, not valid sorting programs.
Among the representatives, 206 inserted operations produce a new value;
two duplicate an existing value. None restores a lost value. Nevertheless,
different recipes can produce the same comparison skeleton, so this
representative-only classification does not describe every recipe.

The full recipe check repeats generation with value-history tracking:

| Removed copies | Retained recipes | New value | Duplicate existing value | Restore a lost value |
| --- | ---: | ---: | ---: | ---: |
| Two | 6 | 4 | 2 | 0 |
| One | 17,642 | 17,054 | 518 | 70 |

Of the 70 lost-value recipes, 68 have skeletons in the prior corpus. The
other two have the same new skeleton, `sk/recompute9_wide/r000008.txt`.
They use `net9_100_k32.s`, remove the copy at zero-based core index 21,
and insert `cmovl P2,S1` or `cmovle P2,S1` at boundary 19 of the shortened
core. Each inserted operation restores a previously held value which is
absent from every register just before insertion. This statement concerns
the 120-order representation.

The unrestricted 30,000,000-node retry of `r000008` returned LIMIT after
30,000,173 calls and 275.9 seconds. No complete leaf was reached. It remains
unknown. Log: `logs/recompute9_deep_k31/r000008.log`.

A second deep retry tested `r000111`. It is the only wider skeleton
whose comparison operands are all min/max terms. It is distinct from the
earlier exhaustive recheck under input renaming and comparison reversal.
Logs: `logs/recompute9_compare_lattice.log` and
`logs/recompute9_deep_k31/r000111.log`.
This run also returned LIMIT: 30,000,097 calls, zero leaves, 168.1 seconds,
with a 30,000,000-node limit. Both deep cases remain unknown. Neither is
an exhaustive negative. All 208 new wider skeletons therefore remain unknown
in unrestricted routing at k=31.

The lost-value recipes contain a pair of conditional moves which cancel.
Removing the pair gives `programs/recompute9_simplified30_source.s`, with
9 comparisons, 17 conditional moves, and 4 copies. This is a source trace,
not a sorting program. A finite one-instruction insertion/replacement search
is implemented in `src/insert_one.cpp`. The simplified trace's comparison
skeleton matches `r000008` under the stated symmetries. Check log:
`logs/recompute9_simplified30_compare.log` (`EQUIVALENT`).

The finite edit searches are complete:

| Source | Edit | Instruction choices tested | Sorting candidates on 120 orders |
| --- | --- | ---: | ---: |
| Simplified k=30 trace | Insert one mov or cmov, giving k=31 | 8,848 | 0 |
| Simplified k=30 trace | Replace one instruction, keeping k=30 | 6,480 | 0 |
| Four partial k=31 traces | Replace one instruction, keeping k=31 | 4 x 6,800 = 27,200 | 0 |

These enumerations use the eight named registers P0..P4 and S0..S2. They
permit identical source and destination registers. A conditional move and
a comparison require initialized operands. A move requires an initialized
source. Insertions occur at every core boundary and keep nine comparisons.
A comparison replacement stays a comparison; other replacements stay mov
or cmov. The search permits an output as soon as a register holds the same
sorted rank on all 120 orders. Counts include equivalent instruction choices.
They are not counts of distinct programs.

Four insertion traces supplied exactly four sorted output columns. Their
files are `programs/recompute9_insert31/partial_1.s` through `partial_4.s`.
All four remain invalid sorting programs. The follow-up replacement searches
found no completion. Logs: `logs/recompute9_insert31.log`,
`logs/recompute9_replace30.log`, and `logs/recompute9_partial_replacements/`.
Earlier logs ending in `_distinct_operands.log` cover a smaller subset and
must not be added to the final enumeration counts.

The finite edit results exclude only these edit sets on this source trace.
They do not exclude arbitrary c=9 programs or longer recomputation sequences.
No k<=31 sorting candidate reached strict verification in this round. The
only new strict PASS files are the two k=33 / length-43 control files listed
below. There is no new exhaustive routing negative beyond the prior-case
recheck.

Router control for the optional gate bound:

- `src/build_gatecap_router.py` adds `MAXGATES` to the conservative router.
  It bounds conditional moves, including repeated values. With no setting,
  it uses the original gate budget. A run with `MAXGATES=19` is a restricted
  routing search; its negatives do not cover G>=20.
- The first control input used flag alternatives that this router rejects.
  That parse failure is not a routing result. The corrected input,
  `sk/recompute9_gatecap_control.txt`, contains fixed comparison columns
  extracted from the known `programs/control_c10_k33.s` program.
- With `MAXGATES=18`, the corrected control returned cost 33, G=18, Q=5,
  after 164,424 calls. Both strict judges passed:
  `programs/recompute9_gatecap_control33.s` (out, k=33), and
  `programs/recompute9_gatecap_control33_mem.s` (mem, length 43).
  Logs: `logs/recompute9_gatecap_control33_fixed.log`,
  `logs/recompute9_gatecap_control33.judge.log`, and
  `logs/recompute9_gatecap_control33_mem.judge.log`.
  These are controls, not shorter sort5 programs.

Files:

- Generator: `src/recompute9.cpp`; recipes: each `manifest.tsv` in
  `sk/recompute9/` and `sk/recompute9_wide/`.
- Generator logs: `logs/recompute9_generation.log` and
  `logs/recompute9_wide_generation.log`.
- Sequential router driver: `src/recompute9_batch.py`; broad routing logs:
  `logs/recompute9_wide_k31/`; batch log: `logs/recompute9_wide_batch.log`.
- Source-trace checks: `src/recompute9_materialize.py`.
- Value classification: `src/recompute9_classify.py`.
- Full recipe classifications: `sk/recompute9_classified/` and
  `sk/recompute9_wide_classified/`, including `all_viable_recipes.tsv`.
- Final routing counts and per-case limits: `logs/recompute9_round_summary.json`.
- The three batch drivers recorded a maximum child RSS of 12,008 KiB in
  their `summary.json` files. Search jobs had an address-space limit below
  3 GB. Each batch ran one child search at a time.

Reproduction uses one job for each command:

```sh
nice -n 19 g++ -O3 -std=c++17 src/recompute9.cpp -o recompute9
nice -n 19 ./recompute9 /path/to/repo/agents/team/d7-structure/fam32 sk/recompute9 2
nice -n 19 ./dagx_safe_exact_bin sk/recompute9/r000001.txt 31 1 30000000
nice -n 19 ./recompute9 /path/to/repo/agents/team/d7-structure/fam32 sk/recompute9_wide 1 /path/to/repo/agents/team/d1-skeleton/sk
nice -n 19 python3 src/recompute9_batch.py sk/recompute9_wide logs/reproduce_recompute9 --nodes 300000 --seconds 120 --engine ./dagx_safe_exact_bin
nice -n 19 python3 src/build_gatecap_router.py
nice -n 19 g++ -O3 -std=c++17 src/dagx_gatecap.cpp -o dagx_gatecap
MAXGATES=19 nice -n 19 python3 src/recompute9_batch.py sk/recompute9_wide logs/reproduce_gatecap19 --nodes 300000 --seconds 90 --engine ./dagx_gatecap
nice -n 19 python3 src/recompute9_batch.py sk/recompute9_deep logs/reproduce_deep --nodes 30000000 --seconds 600 --engine ./dagx_safe
nice -n 19 g++ -O3 -std=c++17 src/insert_one.cpp -o insert_one
nice -n 19 ./insert_one programs/recompute9_simplified30_source.s programs/reproduce_insert31
nice -n 19 ./insert_one programs/recompute9_simplified30_source.s programs/reproduce_replace30 replace
```

Apply an address-space limit below 3 GB when reproducing these commands.

## Next round: larger c=9 retries, supervisor 23:10

No new program with k <= 31 has passed the strict judge in this round.

The requested set contains 208 distinct unresolved skeletons. The earlier
logs actually used 300,000 nodes for 202 cases, 3,000,000 nodes for six
cases, and later 30,000,000-node retries for two of those cases. All 208
were unknown before this round. This retry uses K=31 and a 60,000,000-node
limit per case. The wall limit is 1,800 seconds per case. A limit or timeout
is unknown. Only an exhausted search is a negative.

The initial 208-case pass finished with NONE 161 and LIMIT 47. Both cases
which originally ran with root order zero, r000111 and r000037, received
one further pass with ROOTORDER=1 and a 120,000,000-node limit. Both
returned LIMIT. The table
below uses the latest completed result for each distinct skeleton. Logs
for these two extra runs are in `logs/recompute9_priority/priority_deeper/`.

Final exact count of newly exhausted skeletons: **161 / 208**.

| Status in this retry | Cases |
| --- | ---: |
| Exhaustive NONE | 161 |
| Unknown LIMIT | 47 |
| Unknown TIMEOUT | 0 |
| Unknown ERROR | 0 |
| Relaxed FOUND, see strict judge logs | 0 |
| Active search | 0 |
| Paused between cases | 0 |
| Not yet started | 0 |

Calls for retained per-case results: 6,678,141,033. Router time for those results: 7929.5 seconds.
All completed full-limit runs: 210; calls: 6,798,141,254; router time: 8968.8 seconds.
Counts above exclude all pilot runs and all previously tested controls.
They apply only to these fixed skeletons in the 120-order routing model.
They do not establish a general sort5 lower bound.

| Exhausted skeleton | Calls | Router seconds | Log |
| --- | ---: | ---: | --- |
| r000036.txt | 58,225,208 | 420.9 | `logs/recompute9_priority/deep/r000036.log` |
| r000107.txt | 33,495,414 | 34.5 | `logs/recompute9_priority/deep/r000107.log` |
| r000109.txt | 38,138,030 | 36.3 | `logs/recompute9_priority/deep/r000109.log` |
| r000009.txt | 45,463,218 | 35.3 | `logs/recompute9_priority/deep/r000009.log` |
| r000012.txt | 47,768,106 | 36.7 | `logs/recompute9_priority/deep/r000012.log` |
| r000014.txt | 39,472,156 | 29.6 | `logs/recompute9_priority/deep/r000014.log` |
| r000015.txt | 40,146,284 | 31.5 | `logs/recompute9_priority/deep/r000015.log` |
| r000016.txt | 40,438,220 | 38.1 | `logs/recompute9_priority/deep/r000016.log` |
| r000017.txt | 35,174,028 | 28.1 | `logs/recompute9_priority/deep/r000017.log` |
| r000018.txt | 53,281,932 | 53.6 | `logs/recompute9_priority/deep/r000018.log` |
| r000028.txt | 32,535,212 | 42.5 | `logs/recompute9_priority/deep/r000028.log` |
| r000050.txt | 24,787,082 | 21.5 | `logs/recompute9_priority/deep/r000050.log` |
| r000065.txt | 41,671,434 | 42.7 | `logs/recompute9_priority/deep/r000065.log` |
| r000066.txt | 48,000,402 | 54.2 | `logs/recompute9_priority/deep/r000066.log` |
| r000068.txt | 45,620,138 | 57.1 | `logs/recompute9_priority/deep/r000068.log` |
| r000069.txt | 40,157,098 | 55.0 | `logs/recompute9_priority/deep/r000069.log` |
| r000075.txt | 56,480,490 | 69.9 | `logs/recompute9_priority/deep/r000075.log` |
| r000093.txt | 34,901,163 | 49.4 | `logs/recompute9_priority/deep/r000093.log` |
| r000095.txt | 29,253,364 | 39.6 | `logs/recompute9_priority/deep/r000095.log` |
| r000164.txt | 21,266,854 | 27.6 | `logs/recompute9_priority/deep/r000164.log` |
| r000165.txt | 24,611,926 | 34.8 | `logs/recompute9_priority/deep/r000165.log` |
| r000166.txt | 21,297,462 | 30.8 | `logs/recompute9_priority/deep/r000166.log` |
| r000167.txt | 22,586,886 | 33.1 | `logs/recompute9_priority/deep/r000167.log` |
| r000168.txt | 16,777,910 | 23.8 | `logs/recompute9_priority/deep/r000168.log` |
| r000169.txt | 15,085,414 | 22.2 | `logs/recompute9_priority/deep/r000169.log` |
| r000170.txt | 21,425,414 | 26.2 | `logs/recompute9_priority/deep/r000170.log` |
| r000202.txt | 33,211,194 | 35.5 | `logs/recompute9_priority/deep/r000202.log` |
| r000204.txt | 41,823,914 | 40.5 | `logs/recompute9_priority/deep/r000204.log` |
| r000205.txt | 31,828,202 | 31.8 | `logs/recompute9_priority/deep/r000205.log` |
| r000206.txt | 20,499,178 | 18.9 | `logs/recompute9_priority/deep/r000206.log` |
| r000207.txt | 29,646,122 | 28.2 | `logs/recompute9_priority/deep/r000207.log` |
| r000208.txt | 28,836,266 | 25.7 | `logs/recompute9_priority/deep/r000208.log` |
| r000108.txt | 33,638,454 | 34.5 | `logs/recompute9_priority/deep/r000108.log` |
| r000114.txt | 52,160,846 | 48.4 | `logs/recompute9_priority/deep/r000114.log` |
| r000115.txt | 10,910,518 | 9.3 | `logs/recompute9_priority/deep/r000115.log` |
| r000117.txt | 11,078,486 | 9.7 | `logs/recompute9_priority/deep/r000117.log` |
| r000118.txt | 53,294,109 | 50.9 | `logs/recompute9_priority/deep/r000118.log` |
| r000119.txt | 10,740,598 | 11.3 | `logs/recompute9_priority/deep/r000119.log` |
| r000120.txt | 15,311,350 | 14.4 | `logs/recompute9_priority/deep/r000120.log` |
| r000121.txt | 23,183,556 | 24.1 | `logs/recompute9_priority/deep/r000121.log` |
| r000122.txt | 10,916,438 | 11.3 | `logs/recompute9_priority/deep/r000122.log` |
| r000124.txt | 11,199,054 | 12.2 | `logs/recompute9_priority/deep/r000124.log` |
| r000125.txt | 13,271,502 | 13.4 | `logs/recompute9_priority/deep/r000125.log` |
| r000126.txt | 11,827,702 | 12.3 | `logs/recompute9_priority/deep/r000126.log` |
| r000127.txt | 10,642,994 | 11.2 | `logs/recompute9_priority/deep/r000127.log` |
| r000100.txt | 16,726,400 | 17.2 | `logs/recompute9_priority/deep/r000100.log` |
| r000101.txt | 13,048,790 | 12.4 | `logs/recompute9_priority/deep/r000101.log` |
| r000104.txt | 45,596,163 | 42.6 | `logs/recompute9_priority/deep/r000104.log` |
| r000106.txt | 30,009,047 | 29.5 | `logs/recompute9_priority/deep/r000106.log` |
| r000013.txt | 37,672,204 | 32.3 | `logs/recompute9_priority/deep/r000013.log` |
| r000024.txt | 30,918,060 | 23.7 | `logs/recompute9_priority/deep/r000024.log` |
| r000025.txt | 25,037,580 | 18.9 | `logs/recompute9_priority/deep/r000025.log` |
| r000029.txt | 26,219,404 | 20.2 | `logs/recompute9_priority/deep/r000029.log` |
| r000030.txt | 25,691,564 | 22.6 | `logs/recompute9_priority/deep/r000030.log` |
| r000031.txt | 18,383,868 | 15.7 | `logs/recompute9_priority/deep/r000031.log` |
| r000032.txt | 13,435,980 | 12.1 | `logs/recompute9_priority/deep/r000032.log` |
| r000033.txt | 14,437,104 | 12.8 | `logs/recompute9_priority/deep/r000033.log` |
| r000034.txt | 23,906,934 | 20.9 | `logs/recompute9_priority/deep/r000034.log` |
| r000035.txt | 15,964,332 | 14.7 | `logs/recompute9_priority/deep/r000035.log` |
| r000047.txt | 49,959,322 | 47.4 | `logs/recompute9_priority/deep/r000047.log` |
| r000051.txt | 24,019,994 | 22.5 | `logs/recompute9_priority/deep/r000051.log` |
| r000059.txt | 11,623,730 | 11.4 | `logs/recompute9_priority/deep/r000059.log` |
| r000060.txt | 13,934,486 | 13.7 | `logs/recompute9_priority/deep/r000060.log` |
| r000061.txt | 17,413,870 | 17.5 | `logs/recompute9_priority/deep/r000061.log` |
| r000062.txt | 15,490,906 | 15.2 | `logs/recompute9_priority/deep/r000062.log` |
| r000063.txt | 14,476,562 | 13.4 | `logs/recompute9_priority/deep/r000063.log` |
| r000064.txt | 17,376,468 | 17.1 | `logs/recompute9_priority/deep/r000064.log` |
| r000071.txt | 19,142,506 | 16.7 | `logs/recompute9_priority/deep/r000071.log` |
| r000072.txt | 19,925,898 | 17.7 | `logs/recompute9_priority/deep/r000072.log` |
| r000073.txt | 19,371,274 | 17.2 | `logs/recompute9_priority/deep/r000073.log` |
| r000074.txt | 19,741,674 | 17.8 | `logs/recompute9_priority/deep/r000074.log` |
| r000082.txt | 3,577,494 | 3.5 | `logs/recompute9_priority/deep/r000082.log` |
| r000092.txt | 38,726,876 | 36.0 | `logs/recompute9_priority/deep/r000092.log` |
| r000094.txt | 11,689,033 | 10.9 | `logs/recompute9_priority/deep/r000094.log` |
| r000097.txt | 13,340,230 | 10.8 | `logs/recompute9_priority/deep/r000097.log` |
| r000131.txt | 39,894,894 | 36.9 | `logs/recompute9_priority/deep/r000131.log` |
| r000132.txt | 39,427,430 | 35.5 | `logs/recompute9_priority/deep/r000132.log` |
| r000141.txt | 42,417,700 | 42.6 | `logs/recompute9_priority/deep/r000141.log` |
| r000153.txt | 28,896,806 | 39.2 | `logs/recompute9_priority/deep/r000153.log` |
| r000154.txt | 22,762,950 | 24.1 | `logs/recompute9_priority/deep/r000154.log` |
| r000155.txt | 25,667,030 | 24.5 | `logs/recompute9_priority/deep/r000155.log` |
| r000179.txt | 21,871,082 | 18.1 | `logs/recompute9_priority/deep/r000179.log` |
| r000180.txt | 34,928,568 | 31.5 | `logs/recompute9_priority/deep/r000180.log` |
| r000181.txt | 18,905,642 | 17.8 | `logs/recompute9_priority/deep/r000181.log` |
| r000182.txt | 44,671,046 | 42.7 | `logs/recompute9_priority/deep/r000182.log` |
| r000192.txt | 11,023,026 | 10.6 | `logs/recompute9_priority/deep/r000192.log` |
| r000193.txt | 13,935,626 | 14.6 | `logs/recompute9_priority/deep/r000193.log` |
| r000194.txt | 12,212,398 | 12.6 | `logs/recompute9_priority/deep/r000194.log` |
| r000195.txt | 14,433,626 | 14.6 | `logs/recompute9_priority/deep/r000195.log` |
| r000196.txt | 13,485,682 | 12.6 | `logs/recompute9_priority/deep/r000196.log` |
| r000197.txt | 21,606,388 | 22.0 | `logs/recompute9_priority/deep/r000197.log` |
| r000199.txt | 19,609,194 | 18.6 | `logs/recompute9_priority/deep/r000199.log` |
| r000200.txt | 19,192,362 | 20.3 | `logs/recompute9_priority/deep/r000200.log` |
| r000201.txt | 19,228,618 | 17.7 | `logs/recompute9_priority/deep/r000201.log` |
| r000203.txt | 19,481,770 | 17.9 | `logs/recompute9_priority/deep/r000203.log` |
| r000003.txt | 13,284,528 | 12.4 | `logs/recompute9_priority/deep/r000003.log` |
| r000004.txt | 16,464,345 | 15.3 | `logs/recompute9_priority/deep/r000004.log` |
| r000019.txt | 40,786,510 | 35.2 | `logs/recompute9_priority/deep/r000019.log` |
| r000020.txt | 16,224,124 | 14.9 | `logs/recompute9_priority/deep/r000020.log` |
| r000022.txt | 15,880,620 | 14.6 | `logs/recompute9_priority/deep/r000022.log` |
| r000023.txt | 17,218,284 | 16.5 | `logs/recompute9_priority/deep/r000023.log` |
| r000040.txt | 16,490,006 | 16.3 | `logs/recompute9_priority/deep/r000040.log` |
| r000052.txt | 26,187,770 | 25.3 | `logs/recompute9_priority/deep/r000052.log` |
| r000053.txt | 18,725,026 | 19.0 | `logs/recompute9_priority/deep/r000053.log` |
| r000054.txt | 36,765,064 | 35.7 | `logs/recompute9_priority/deep/r000054.log` |
| r000055.txt | 44,719,131 | 51.1 | `logs/recompute9_priority/deep/r000055.log` |
| r000056.txt | 18,245,418 | 29.7 | `logs/recompute9_priority/deep/r000056.log` |
| r000057.txt | 23,027,626 | 23.2 | `logs/recompute9_priority/deep/r000057.log` |
| r000076.txt | 3,182,646 | 3.0 | `logs/recompute9_priority/deep/r000076.log` |
| r000077.txt | 7,555,078 | 6.6 | `logs/recompute9_priority/deep/r000077.log` |
| r000078.txt | 24,695,152 | 24.1 | `logs/recompute9_priority/deep/r000078.log` |
| r000079.txt | 24,429,852 | 26.1 | `logs/recompute9_priority/deep/r000079.log` |
| r000080.txt | 3,292,990 | 3.1 | `logs/recompute9_priority/deep/r000080.log` |
| r000081.txt | 3,508,302 | 3.2 | `logs/recompute9_priority/deep/r000081.log` |
| r000083.txt | 3,358,042 | 3.2 | `logs/recompute9_priority/deep/r000083.log` |
| r000084.txt | 3,485,434 | 3.3 | `logs/recompute9_priority/deep/r000084.log` |
| r000085.txt | 26,832,784 | 24.7 | `logs/recompute9_priority/deep/r000085.log` |
| r000086.txt | 6,075,680 | 5.7 | `logs/recompute9_priority/deep/r000086.log` |
| r000087.txt | 3,518,582 | 3.3 | `logs/recompute9_priority/deep/r000087.log` |
| r000088.txt | 3,352,982 | 3.1 | `logs/recompute9_priority/deep/r000088.log` |
| r000089.txt | 6,203,676 | 5.8 | `logs/recompute9_priority/deep/r000089.log` |
| r000090.txt | 3,221,906 | 3.1 | `logs/recompute9_priority/deep/r000090.log` |
| r000091.txt | 3,486,554 | 3.3 | `logs/recompute9_priority/deep/r000091.log` |
| r000116.txt | 38,324,884 | 35.5 | `logs/recompute9_priority/deep/r000116.log` |
| r000123.txt | 11,306,538 | 10.9 | `logs/recompute9_priority/deep/r000123.log` |
| r000133.txt | 9,892,694 | 9.6 | `logs/recompute9_priority/deep/r000133.log` |
| r000134.txt | 23,123,378 | 21.9 | `logs/recompute9_priority/deep/r000134.log` |
| r000135.txt | 27,886,455 | 26.7 | `logs/recompute9_priority/deep/r000135.log` |
| r000136.txt | 22,512,476 | 21.4 | `logs/recompute9_priority/deep/r000136.log` |
| r000137.txt | 9,850,062 | 9.6 | `logs/recompute9_priority/deep/r000137.log` |
| r000138.txt | 9,910,734 | 9.7 | `logs/recompute9_priority/deep/r000138.log` |
| r000140.txt | 14,657,486 | 16.1 | `logs/recompute9_priority/deep/r000140.log` |
| r000145.txt | 22,087,898 | 22.4 | `logs/recompute9_priority/deep/r000145.log` |
| r000146.txt | 13,480,534 | 13.3 | `logs/recompute9_priority/deep/r000146.log` |
| r000147.txt | 13,173,046 | 13.0 | `logs/recompute9_priority/deep/r000147.log` |
| r000148.txt | 8,182,322 | 7.7 | `logs/recompute9_priority/deep/r000148.log` |
| r000149.txt | 8,028,722 | 7.8 | `logs/recompute9_priority/deep/r000149.log` |
| r000157.txt | 16,816,534 | 14.6 | `logs/recompute9_priority/deep/r000157.log` |
| r000158.txt | 59,857,256 | 50.2 | `logs/recompute9_priority/deep/r000158.log` |
| r000159.txt | 57,391,997 | 51.8 | `logs/recompute9_priority/deep/r000159.log` |
| r000161.txt | 20,342,294 | 16.6 | `logs/recompute9_priority/deep/r000161.log` |
| r000162.txt | 17,092,246 | 14.3 | `logs/recompute9_priority/deep/r000162.log` |
| r000163.txt | 17,341,718 | 14.6 | `logs/recompute9_priority/deep/r000163.log` |
| r000172.txt | 17,289,376 | 16.8 | `logs/recompute9_priority/deep/r000172.log` |
| r000184.txt | 25,495,002 | 22.8 | `logs/recompute9_priority/deep/r000184.log` |
| r000185.txt | 18,333,010 | 17.1 | `logs/recompute9_priority/deep/r000185.log` |
| r000186.txt | 14,676,082 | 14.4 | `logs/recompute9_priority/deep/r000186.log` |
| r000187.txt | 17,823,882 | 18.2 | `logs/recompute9_priority/deep/r000187.log` |
| r000188.txt | 14,932,170 | 14.4 | `logs/recompute9_priority/deep/r000188.log` |
| r000189.txt | 43,639,734 | 61.2 | `logs/recompute9_priority/deep/r000189.log` |
| r000190.txt | 39,857,947 | 49.7 | `logs/recompute9_priority/deep/r000190.log` |
| r000191.txt | 22,603,786 | 19.8 | `logs/recompute9_priority/deep/r000191.log` |
| r000102.txt | 11,896,662 | 16.8 | `logs/recompute9_priority/deep/r000102.log` |
| r000096.txt | 24,927,818 | 17.5 | `logs/recompute9_priority/deep/r000096.log` |
| r000129.txt | 39,442,822 | 34.9 | `logs/recompute9_priority/deep/r000129.log` |
| r000142.txt | 16,668,578 | 16.6 | `logs/recompute9_priority/deep/r000142.log` |
| r000150.txt | 9,470,086 | 8.6 | `logs/recompute9_priority/deep/r000150.log` |
| r000151.txt | 9,500,550 | 8.8 | `logs/recompute9_priority/deep/r000151.log` |
| r000156.txt | 20,675,942 | 17.7 | `logs/recompute9_priority/deep/r000156.log` |
| r000171.txt | 10,858,521 | 10.8 | `logs/recompute9_priority/deep/r000171.log` |
| r000160.txt | 15,978,006 | 19.6 | `logs/recompute9_priority/deep/r000160.log` |

Priority measurement:

- A 200,000-node pilot ran on each of the 208 cases. All returned LIMIT.
  Total calls: 41,619,896. Total reported router time: 180.6 seconds.
- The recorded comparison prefix counts assigned operand nodes. Such a
  node can still have unfinished dependencies. The partial cost bound is
  C + current gates + the resolved-DAG copy bound + the open-requirement
  bound after the current requirement is removed. It is a lower bound,
  not a complete program cost.
- At prefix nine, the minimum observed bounds had this distribution:
  27: one case; 28: 16; 29: 61; 30: 119; 31: ten. One case, r000002,
  reached only prefix six during its pilot and is placed last.
- The retry order uses the lowest observed bound first. The first four
  cases are r000111, r000037, r000005, and r000008. Root-bound ties use
  the lower root bound and then the file name.
- Priority records: `logs/recompute9_priority/priority.json`. Pilot logs:
  `logs/recompute9_priority/pilot/`.

The first retry uses `src/dagx_progress.cpp`, which adds progress output
to the conservative router. After the first two cases, the batch uses
`src/dagx_order.cpp` with ROOTORDER=1. It assigns the last comparison
requirements first. Only the initial requirement order changes. The
instruction set and pruning bounds stay the same. Each case records its
root order. Build details are in `logs/recompute9_priority/order_change.json`. The batch driver is
`src/recompute9_priority_batch.py`. Every search uses nice level 19 and an
address-space limit of 2,800,000,000 bytes. One CPU search runs at a time.
The per-case logs state the node and wall limits. The full audit is
`logs/recompute9_priority/audit_summary.json`; individual retry logs are in
`logs/recompute9_priority/deep/`. Live driver counts are in
`logs/recompute9_priority/summary.json` after the first completed case.

Tests and dead ends in this round:

- `src/dagx_priority.cpp` records the partial bound and caches consistency
  checks with exact keys. On r000008, it made exactly the same 1,000,108
  calls as the original router at a one-million-node limit. Both took
  4.3 seconds. This check did not establish a negative.
- `src/dagx_future.cpp` adds a bound for unique values needed by later
  comparisons. The previously exhausted r000001 control returned NONE
  with exactly 28,633,830 calls and 4,320 leaves, as before. Runtime rose
  to 549.3 seconds. This recheck is not a newly exhausted skeleton.
- On 42 three-input sorting skeletons at four cost limits, the added
  bound matched the baseline on all 168 queries. There were 120 matched
  NONE results and 48 matched FOUND results. Both settings made 39,780
  calls. This is a test result, not a proof of the bound. Logs:
  `logs/future_control3/`; summary: `logs/future_control3/summary.json`.
- `src/dagx_memo.cpp` adds an optional cache of failed states. A benchmark
  on r000008 made 600,338 lookups, with zero hits and 250,000 stored
  states. Runtime was 7.6 seconds with the cache and 4.6 seconds without
  it. Both runs reached the same one-million-node limit. The main retry
  does not use this cache or the later-comparison bound.

Requirement-order controls:

- On the same 42 three-input skeletons and four cost limits, five root
  orders matched all 840 exhaustive baseline results. Total calls by
  order 0..4 were 39,780; 38,106; 36,240; 44,741; and 36,240. This is a
  test result, not a proof. Log: `logs/root_order_control3_batch.log`.
- One-million-node pilots on r000111 remained LIMIT for orders 1..4.
  Their reported times were 2.8, 3.6, 6.0, and 7.4 seconds. These are
  unknown results. They do not add any exhaustive negatives. Logs:
  `logs/recompute9_rootorder_r000111_mode1.log` through `mode4.log`.

Further bounded checks:

- Three full-requirement priority orders matched all 504 three-input
  baseline checks. Their one-million-node pilots on r000111 and r000008
  all reached LIMIT. Logs end in `mode5.log` through `mode7.log`.
- `src/dagx_partition.cpp` separates gates whose columns equal a required
  full column from gates outside that pool. An optional mode removes
  repeated conditional-move columns. Across six settings, 504 three-input
  controls matched the baseline. Both one-million-node r000111 pilots
  remained LIMIT. The main batch uses neither setting. Logs:
  `logs/partition_control3/` and `logs/recompute9_partition_r000111_*.log`.
- `src/ssa_exact.py` uses symbolic register versions. A move allocates a
  fresh register. A conditional move replaces its destination version.
  Constraints prevent later reads of an overwritten version. All 120
  strict orders enter the query. Comparisons use the supplied fixed
  columns. Intermediate columns are unrestricted; there is no fixed
  value pool or two-copy restriction. Outputs can record any produced
  sorted-rank column. This is the initialized-operand SSA routing model.
- The fixed k=33 control query was SAT. Its decoded program passed both
  independent strict judges. The unrestricted r000111 query at K=31 was
  UNKNOWN after its 20-second solver timeout. It used 11,331 conflicts
  and a peak RSS of 178,084 KiB. This is not an exhaustive negative.
  Logs: `logs/ssa_control33.log` and `logs/ssa_r000111_k31.log`.

Copy-bound cache used from r000041 onward:

- `src/dagx_fast.cpp` caches the original copy-bound calculation. Each
  entry stores the resolved gate indices, their blocks and destination /
  source edges, and all comparison uses. These are the data read by that
  calculation. Cache hits compare the entire key. Hash collisions cause
  misses; a hash alone never establishes a match.
- The main batch sets LEGACYFILL=1. Every cache miss uses the original
  copy-bound calculation. Program emission also uses the original
  allocator. This change does not add a routing restriction or change a
  cost. It avoids repeated calculations on the same dependency graph.
- The one-million-node r000008 benchmarks all made exactly 1,000,029
  calls. The baseline took 3.4 seconds. The cached original calculation
  took 1.8 seconds, with 480,372 hits and 55,582 misses. Timing depends
  on shared CPU use. Logs: `logs/recompute9_fast_legacy_benchmark.log`
  and `logs/recompute9_legacy_cached_benchmark.log`.
- A separate stack-based calculation matched 535,954 original copy-bound
  results in its one-million-node check. The main batch fills its cache
  with the original calculation, so it does not rely on this rewrite.
- With every cached result checked again against the original, 336
  three-input control queries matched the baseline. The first positive
  control processed later comparison requirements first and reached its three-million
  node limit. That limit is unknown. The corrected control uses root
  order zero; its decoded k=33 program passed both strict judges.
- Build and control records: `logs/recompute9_priority/copy_cache_change.json`,
  `logs/fast_copy_control3/summary.json`, and
  `logs/recompute9_fast_control33_fixed.log`.

Open-requirement bound implementation used from r000044 onward:

- `src/dagx_lb.cpp` computes each requirement domain and each unfinished
  node domain once per bound call. It stores the open list in a local
  array and uses the same size ordering and greedy incompatible set.
  It keeps the original copy-bound calculation on cache misses.
- On r000008, 768,946 fast open bounds matched the original calculation.
  All four one-million-node variants made exactly 1,000,029 calls. Their
  times were 1.7 seconds for the original open bound, 1.6 with both
  calculations checked, 0.7 with the new implementation, and 0.8 with a
  native build. The main build uses `-O3 -mpopcnt`, as recorded in
  `logs/recompute9_priority/open_bound_change.json`.
- Both copy and open bounds were checked on 336 three-input queries.
  Every exhaustive result matched the baseline. The decoded k=33 control
  also passed both independent strict judges. These are implementation
  checks, not a general sorting lower bound.
- Logs: `logs/fast_open_control3/`,
  `logs/recompute9_lb_checked_benchmark.log`, and
  `logs/recompute9_lb_control33_verify.log`.

New strict judge PASS control files:

| Program | Model | Length | Judge log |
| --- | --- | ---: | --- |
| `programs/recompute9_future_control33.s` | out | k=33 | `logs/recompute9_future_control33.judge.log` |
| `programs/recompute9_future_control33_mem.s` | mem | L=43 | `logs/recompute9_future_control33_mem.judge.log` |
| `programs/ssa_control33_verified.s` | out | k=33 | `logs/ssa_control33_verified.judge.log` |
| `programs/ssa_control33_verified_mem.s` | mem | L=43 | `logs/ssa_control33_verified_mem.judge.log` |
| `programs/recompute9_fast_control33.s` | out | k=33 | `logs/recompute9_fast_control33.judge.log` |
| `programs/recompute9_fast_control33_mem.s` | mem | L=43 | `logs/recompute9_fast_control33_mem.judge.log` |
| `programs/recompute9_lb_control33.s` | out | k=33 | `logs/recompute9_lb_control33.judge.log` |
| `programs/recompute9_lb_control33_mem.s` | mem | L=43 | `logs/recompute9_lb_control33_mem.judge.log` |

All eight control files passed the strict judge. They do not improve the sort5 bound.
No sorting candidate with k <= 31 was produced in these retries.

Final audit and reproduction:

- All 208 distinct skeletons completed their 60,000,000-node pass at K=31.
  The two additional 120,000,000-node runs both returned LIMIT. No timeout
  or error remains. These limits are unknown results, not negatives.
- Across 210 full-limit runs, the routers made 6,798,141,254 calls and
  reported 8,968.8 seconds of wall time. Pilot and control work is excluded
  from these totals. The main driver recorded maximum child RSS of
  16,176 KiB. The deeper driver recorded 11,204 KiB. Each search used
  nice level 19, one CPU job at a time, and an address-space limit of
  2,800,000,000 bytes.
- Final machine-readable summary: `logs/recompute9_priority/final_summary.json`.
  All 208 retained result records: `logs/recompute9_priority/audit_summary.json`.
  The 47 unresolved cases, in priority order and with their actual limits:
  `logs/recompute9_priority/unknown_priority.tsv`.
- The exhausted-case table above names all 161 negative logs. All eight
  new strict PASS control paths are listed above. Every control has k=33
  or memory length 43. No control improves the sort5 bound.

| Pilot group | Exhaustive NONE | Unknown LIMIT |
| --- | ---: | ---: |
| 27 | 0 | 1 |
| 28 | 3 | 13 |
| 29 | 46 | 15 |
| 30 | 104 | 15 |
| 31 | 8 | 2 |
| prefix6 | 0 | 1 |

The numeric groups are observed partial bounds at assigned-comparison prefix
nine. The last group reached only prefix six in its pilot. These pilot
bounds are not global minimum costs.

To reproduce routing, use a fresh log folder. The batch driver reuses
completed logs in an existing folder. Each command below uses one CPU job.

```sh
ulimit -v 2800000
nice -n 19 g++ -O3 -mpopcnt -std=c++17 src/dagx_lb.cpp -o dagx_lb
ROOTORDER=1 nice -n 19 python3 src/recompute9_priority_batch.py --engine ./dagx_lb --reuse-priority logs/recompute9_priority/priority.json --folder logs/reproduce_large60m --nodes 60000000 --seconds 1800
ROOTORDER=1 nice -n 19 ./dagx_lb sk/recompute9_wide/r000111.txt 31 1 120000000 > logs/reproduce_r000111_120m.log
ROOTORDER=1 nice -n 19 ./dagx_lb sk/recompute9_wide/r000037.txt 31 1 120000000 > logs/reproduce_r000037_120m.log
```

The original first two main runs used root order zero. The two deeper runs
use root order one. The reproduction above uses root order one for all
cases. Both orders keep the supplied comparison execution sequence.
Any emitted candidate must still pass both strict judges. The helper
`src/verify_log.py` extracts a candidate, converts it to the memory model,
and runs those judges.

## Next round: supervisor 03:25, 120M retries and new families

The 04:30 retry below superseded this unfinished round. No new k<=31
candidate reached strict verification. The planned 200-case generation
did not start before the instruction changed.

Assumptions tested: [A4, A6]. Each routing query fixes the comparison operand
columns and their execution order. Routing permits non-lattice conditional-move
values and has no register cap. NONE applies to that fixed skeleton on the
120 strict input orders. It is not a general sort5 lower bound. No result so
far contradicts an assumption in `board/ASSUMPTIONS_42.md`.

The retry covers the 47 previously unresolved skeletons in the recorded
partial-cost priority order. The prior 120M runs for r000111 and r000037 are
reused. The remaining 45 cases receive a 120,000,000-node limit and a
1,800-second wall limit. A limit or timeout is unknown. Only NONE counts as
an exhausted case. Driver: `src/round0325.py`. Live results:
`logs/round0325/summary.json`; per-case logs: `logs/round0325/`.

The next generator uses the 70 earlier recipes which restore an earlier
value that is absent from every register just before restoration. These
recipes come from six fam32 source families. It inserts a second conditional
move after that restoration. The generator checks the restoration again
on all 120 strict orders. It retains only sequences whose nine comparison
histories distinguish all 120 input orders. This is a necessary condition,
not a sorting test. The source traces have C=9, G=20, Q=4, hence k=33.

Input renaming and independent reversal of comparison operands remove
repeated skeletons. The exclusion set includes all readable nine-comparison
skeletons in the current d1 skeleton folder, all fam32 seeds, and the earlier
w2 recomputation skeletons. A round-robin selection across source families
aims to retain 200 new skeletons. The generator records a complete source
trace and mutation recipe for each retained skeleton.

The new-case driver waits until the 47-case retry is complete. It then
builds and runs the generator. It routes each new skeleton at K=31 without
a node limit. Each case has a 1,800-second wall limit; a timeout remains
unknown. Generator: `src/recompute9_two.cpp`; driver:
`src/round0325_new.py`; generation log and routing logs:
`logs/round0325_new/`. Every emitted routing candidate goes to both strict
judges through `src/verify_log.py`.

All CPU work is sequential at nice level 19. Each driver sets an address-space
limit of 2,800,000,000 bytes. The second driver waits without a solver process
while the first driver runs. All new writes stay in w2.

## Next round: supervisor 04:30, 500M retries

This round is complete. No new k<=31 program has passed the strict judge.

The preceding 120M driver stopped after nine of its 47 records. Its completed
results contain four exhaustive NONE cases: r000008, r000041, r000042, and
r000045. Those results are retained without another search. The other 43
cases receive a 500,000,000-node limit in the earlier partial-cost priority
order. A 3,600-second wall limit protects each run. LIMIT, TIMEOUT, and ERROR
remain unknown. The incomplete r000174 log from the preceding round has no
RESULT line and supplies no negative result.

Assumptions tested: [A4, A6]. The comparison operand columns and execution
order stay fixed. Conditional moves can produce non-lattice columns. The
router has no register cap. Thus adding one register to this router would
not extend its search model. Each NONE result applies only to its fixed
skeleton on the 120 strict input orders. It does not establish a general
sort5 lower bound. No current result contradicts a listed assumption.

Driver: `src/round0430.py`. Live audit: `logs/round0430/summary.json`.
Per-case logs: `logs/round0430/`. Each new log records the executable hash,
node limit, wall limit, elapsed time, and final router result. All runs use
nice level 19, one CPU search at a time, and an address-space limit of
2,800,000,000 bytes. Completed logs are retained when the driver resumes.

Progress checkpoint: the first 16 retry records are exhaustive NONE. They
include 12 newly exhausted skeletons and four retained 120M results. The
cumulative set has 177 exhaustive NONE and 31 unresolved cases at this
checkpoint. All remaining cases with pilot partial bounds 27 or 28 have
been exhausted. [A4, A6]

### Completed 04:30 retry audit

Final retained results for the 47-case retry: **NONE 47, LIMIT 0, TIMEOUT 0, ERROR 0, FOUND 0**.

This round exhausted 43 additional skeletons. It retained 4 earlier exhaustive results without repeating them. The cumulative 208-case set now has **208 exhaustive NONE** and **0 unknown** results.

New searches made 5,447,816,925 recursive calls. Their measured wall time was 5695.728 seconds. Maximum recorded child RSS was 15,460 KiB. Each search used one CPU job at nice level 19 and an address-space limit of 2,800,000,000 bytes.

Assumptions tested: [A4, A6]. Exhaustive results apply only to the supplied comparison columns and order on the 120 strict input orders. Limits remain unknown. These results do not establish a general sort5 lower bound.

The router has no register cap. Adding one register would leave its routing model unchanged. The requested condition that all 47 cases remain unknown did not occur. No extra-register retry was needed.

No new k<=31 sorting program reached strict verification in this retry. No new strict PASS file was produced. No result contradicts an assumption listed in `board/ASSUMPTIONS_42.md`.

| Skeleton | Result | Calls | Seconds | Log |
| --- | --- | ---: | ---: | --- |
| r000111.txt | NONE | 162,347,926 | 137.258 | `logs/round0430/r000111.log` |
| r000037.txt | NONE | 440,272,953 | 344.338 | `logs/round0430/r000037.log` |
| r000005.txt | NONE | 141,880,092 | 121.767 | `logs/round0430/r000005.log` |
| r000008.txt | NONE (retained) | 61,792,460 | 55.571 | `logs/round0325/r000008.log` |
| r000041.txt | NONE (retained) | 64,864,890 | 57.199 | `logs/round0325/r000041.log` |
| r000042.txt | NONE (retained) | 61,808,826 | 57.115 | `logs/round0325/r000042.log` |
| r000043.txt | NONE | 126,001,494 | 111.577 | `logs/round0430/r000043.log` |
| r000044.txt | NONE | 141,084,620 | 145.739 | `logs/round0430/r000044.log` |
| r000045.txt | NONE (retained) | 63,980,090 | 61.291 | `logs/round0325/r000045.log` |
| r000174.txt | NONE | 95,286,914 | 98.418 | `logs/round0430/r000174.log` |
| r000176.txt | NONE | 118,098,146 | 122.079 | `logs/round0430/r000176.log` |
| r000110.txt | NONE | 145,359,403 | 191.447 | `logs/round0430/r000110.log` |
| r000112.txt | NONE | 60,684,814 | 80.219 | `logs/round0430/r000112.log` |
| r000113.txt | NONE | 63,139,862 | 76.839 | `logs/round0430/r000113.log` |
| r000006.txt | NONE | 118,933,891 | 97.431 | `logs/round0430/r000006.log` |
| r000007.txt | NONE | 97,271,132 | 83.443 | `logs/round0430/r000007.log` |
| r000010.txt | NONE | 230,796,481 | 198.879 | `logs/round0430/r000010.log` |
| r000011.txt | NONE | 196,092,537 | 178.239 | `logs/round0430/r000011.log` |
| r000026.txt | NONE | 91,475,980 | 75.123 | `logs/round0430/r000026.log` |
| r000027.txt | NONE | 120,312,940 | 128.167 | `logs/round0430/r000027.log` |
| r000067.txt | NONE | 66,063,274 | 58.223 | `logs/round0430/r000067.log` |
| r000070.txt | NONE | 115,330,694 | 94.831 | `logs/round0430/r000070.log` |
| r000173.txt | NONE | 63,954,330 | 62.071 | `logs/round0430/r000173.log` |
| r000175.txt | NONE | 60,473,082 | 87.602 | `logs/round0430/r000175.log` |
| r000177.txt | NONE | 133,783,468 | 143.762 | `logs/round0430/r000177.log` |
| r000021.txt | NONE | 88,719,996 | 77.355 | `logs/round0430/r000021.log` |
| r000058.txt | NONE | 96,566,038 | 89.683 | `logs/round0430/r000058.log` |
| r000103.txt | NONE | 67,480,511 | 88.802 | `logs/round0430/r000103.log` |
| r000105.txt | NONE | 64,094,669 | 86.198 | `logs/round0430/r000105.log` |
| r000046.txt | NONE | 94,899,143 | 129.046 | `logs/round0430/r000046.log` |
| r000048.txt | NONE | 77,288,988 | 107.986 | `logs/round0430/r000048.log` |
| r000049.txt | NONE | 63,689,010 | 64.202 | `logs/round0430/r000049.log` |
| r000128.txt | NONE | 61,622,674 | 57.183 | `logs/round0430/r000128.log` |
| r000130.txt | NONE | 117,872,746 | 147.507 | `logs/round0430/r000130.log` |
| r000143.txt | NONE | 89,181,881 | 129.259 | `logs/round0430/r000143.log` |
| r000144.txt | NONE | 69,574,388 | 98.529 | `logs/round0430/r000144.log` |
| r000152.txt | NONE | 88,852,096 | 112.358 | `logs/round0430/r000152.log` |
| r000178.txt | NONE | 75,909,095 | 97.534 | `logs/round0430/r000178.log` |
| r000183.txt | NONE | 61,978,620 | 81.522 | `logs/round0430/r000183.log` |
| r000198.txt | NONE | 68,705,254 | 89.642 | `logs/round0430/r000198.log` |
| r000039.txt | NONE | 262,063,365 | 353.098 | `logs/round0430/r000039.log` |
| r000139.txt | NONE | 102,978,882 | 132.630 | `logs/round0430/r000139.log` |
| r000098.txt | NONE | 143,135,172 | 188.738 | `logs/round0430/r000098.log` |
| r000099.txt | NONE | 179,270,289 | 245.226 | `logs/round0430/r000099.log` |
| r000001.txt | NONE | 231,845,222 | 220.318 | `logs/round0430/r000001.log` |
| r000038.txt | NONE | 161,785,896 | 151.114 | `logs/round0430/r000038.log` |
| r000002.txt | NONE | 391,658,957 | 310.346 | `logs/round0430/r000002.log` |

Full audit: `logs/round0430/final_audit.json`. Remaining unknown cases: `logs/round0430/unknown.tsv`. Reproduction uses the unchanged `dagx_lb` executable with SHA-256 `97acc52f0c055488031dc8f8460de486a22ca7d31e9feca0f769fbfdc7bce1f8`.

```sh
ulimit -v 2800000
nice -n 19 python3 src/round0430.py > logs/round0430_batch.log 2>&1
nice -n 19 python3 src/round0430_report.py
```

The driver retains completed results. Use a fresh log folder for a new search. Per-case commands set ROOTORDER=1, FASTCPL=1, CACHECPL=1, LEGACYFILL=1, and FASTLB=1. Each new case uses K=31, a 500M-node limit, and a 3,600-second wall limit.

## Next round: supervisor 06:20, new repeated-comparison skeletons

This round uses the requested c=10 option. Generation produced 300 new
skeletons from the 208 exhausted c=9 mutation skeletons. Each new skeleton
adds one exact repeat of an earlier comparison. The repeated comparison
comes after the original nine comparisons. The repeat restores earlier
flags after later comparisons have replaced them. The router can then
delay conditional moves that use those flags. Its copy-cost calculation
decides whether this delay saves a move. The first 208 cases repeat
comparison one. The remaining 92 repeat comparison two.
The source mutations come from eight fam32 seed families.

Generation removes equivalent cases under input renaming and independent
comparison reversal. Its exclusion set reads the complete d1 skeleton
folder, including its w8 subfolders, and the earlier w2 repeat, refresh,
non-lattice, network, and selected SAT sets. It reads 41,773 c=10 files in
d1 and retains 56,438 distinct exclusion keys after adding the w2 sets.
For files with alternative comparison operands, it also excludes the
entire comparison-flag class. None of the 300 retained cases matched an
exclusion key or a retained case. Generation log:
`logs/round0620/generation.log`. Recipes: `sk/round0620/manifest.tsv`.
Generator: `src/round0620_generate.cpp`.

Assumptions tested: [A4, A6]. Routing fixes the comparison operand columns
and their order. The router permits non-lattice conditional-move values
and has no register cap. An exhaustive NONE applies only to that fixed
skeleton on the 120 strict input orders. It is not a general sort5 lower
bound. No current result contradicts a listed assumption.

Each search uses K=31, hence a 21-instruction budget for conditional moves
and moves. It has no node limit. A 3,600-second wall limit protects each
case. TIMEOUT and ERROR remain unknown. The unchanged `dagx_lb` executable
has SHA-256 `97acc52f0c055488031dc8f8460de486a22ca7d31e9feca0f769fbfdc7bce1f8`.
The driver uses one CPU job at nice level 19 and an address-space limit of
2,800,000,000 bytes. Driver: `src/round0620.py`. Live results:
`logs/round0620/summary.json`. Each emitted candidate goes to both strict
judges through `src/verify_log.py`.

### Completed 06:20 audit

Final results: **NONE 300, LIMIT 0, TIMEOUT 0, ERROR 0, FOUND 0**.
All 300 cases are exhaustive at K=31 in the stated routing model.
The first three pilot logs were retained. No completed search was repeated.

| Added comparison | Cases | Exhaustive NONE | Unknown |
| --- | ---: | ---: | ---: |
| Repeat comparison one after comparison nine | 208 | 208 | 0 |
| Repeat comparison two after comparison nine | 92 | 92 | 0 |
| Total | 300 | 300 | 0 |

The searches made **1,196,212,062 recursive calls**. Their measured wall
time was **943.054 seconds**. Maximum recorded search-child RSS was
**17,260 KiB**. Each search used one CPU job at nice level 19. No node limit
or wall limit stopped a case.

The final audit checked each added comparison against its recorded source
pair. Removing that added comparison reproduced the original nine-column-pair
sequence in every case. Each ten-comparison history still distinguished
all 120 strict input orders. This history check is a necessary condition,
not a sorting test.

A threshold-function check classified 299 of the 300 skeletons as having
at least one comparison operand outside the min/max expression class on
the 120 strict orders. Thus this set includes non-lattice comparison
operands. Routing remains unrestricted in its intermediate value columns.
These NONE results still depend on fixed comparison columns and order.
[A4, A6]

The final exclusion audit also treats binary comparison outcomes with
different labels as equivalent when they permit the same conditional-move
masks. It regenerated all 300 skeletons in a separate audit folder. Every
skeleton file and the complete manifest matched the searched set byte for
byte. No case matched an earlier exclusion key or an excluded alternative
flag class. Audit generation log:
`logs/round0620/generation_exclusion_audit.log`.

| fam32 source | Exhaustive NONE |
| --- | ---: |
| `net9_100_k32.s` | 70 |
| `net9_105_k32.s` | 2 |
| `net9_135_k32.s` | 2 |
| `net9_19_k32.s` | 76 |
| `net9_25_k32.s` | 39 |
| `net9_50_k32.s` | 30 |
| `net9_68_k32.s` | 44 |
| `net9_95_k32.s` | 37 |

This round did not find a saving from repeating either of the first two
comparisons at the end of these fixed skeletons. It does not cover other
repeat positions or all ten-comparison programs. It does not establish a
general sort5 lower bound. No result contradicts a listed assumption.

No sorting candidate reached strict verification. No new strict PASS file
was produced. The best verified reference remains k=32, memory length 42.

Full audit with all 300 log paths, call counts, times, source recipes, and
skeleton hashes: `logs/round0620/final_audit.json`. Compact summary:
`logs/round0620/final_summary.txt`. Unknown cases:
`logs/round0620/unknown.tsv` (header only). Audit source:
`src/round0620_report.py`.

```sh
ulimit -v 2800000
nice -n 19 g++ -O3 -std=c++17 src/round0620_generate.cpp -o round0620_generate
nice -n 19 ./round0620_generate sk/recompute9_wide sk/round0620_exclusion_audit /path/to/repo/agents/team/d1-skeleton/sk sk/repeat sk/refresh sk/refresh_old sk/refresh_tail sk/nonlattice10 sk/net10 sk/sat_selected > logs/round0620/generation_exclusion_audit.log 2>&1
nice -n 19 python3 src/round0620.py > logs/round0620/batch.log 2>&1
nice -n 19 python3 src/round0620_report.py > logs/round0620/final_summary.txt
```

The driver retains completed logs. Keep the skeleton files unchanged when
resuming. Use a fresh log folder for a new search. The strengthened exclusion
audit uses the output folder `sk/round0620_exclusion_audit`.

## Next round: supervisor 08:00, two repeats and eleven comparisons

This round generated 300 new c=10 skeletons and 300 new c=11 skeletons.
The c=10 cases add two exact repeats to c=8 sources. The c=11 cases add
one exact repeat to c=10 sources. Each repeat uses the same operand value
columns as its original comparison. The router can delay conditional moves
until the repeated comparison restores the required flags.

Generation retained 162 distinct c=8 sources from 991 source files.
These files include d1's c8k32, c8u, c8r2, and d4c8 sets, w6's round-2
sources, and the local c=8 reference. The c=11 generation uses 80 distinct
c=10 sources: 20 each from nonlattice10, refresh, net10, and round0620.
For a source with alternative operand pairs, generation selects its first
pair on each comparison line. Routing fixes these selected pairs.

The exclusion scan read the complete d1 skeleton folder and the complete
w6 worker folder. It also read the earlier w2 repeat, refresh, non-lattice,
network, selected-SAT, and round0620 sets. Its final inventory contains
85,677 c=10 keys after input renaming and independent comparison reversal.
It also excludes entire selectable-mask classes for files with alternative
operand pairs. No retained case matched a prior key or a retained case.
No c=11 file was found in that exclusion inventory.

Assumptions tested: [A4, A6]. Each query fixes the comparison operand
columns and their order. Routing has no register cap and permits
non-lattice intermediate columns. NONE applies only to the fixed skeleton
on the 120 strict input orders. It is not a general sort5 lower bound.
No current result contradicts a listed assumption.

Each search uses K=31 and no node limit. The c=10 move budget is 21;
the c=11 move budget is 20. A 3,600-second wall limit protects each case.
LIMIT, TIMEOUT, and ERROR remain unknown. Only exhausted searches count
as negatives. One search runs at a time at nice level 19, with an
address-space limit of 2,800,000,000 bytes. The unchanged router is
`dagx_lb`, SHA-256
`97acc52f0c055488031dc8f8460de486a22ca7d31e9feca0f769fbfdc7bce1f8`.

Generator: `src/round0800_generate.cpp`. Generation log:
`logs/round0800/generation.log`. Recipes:
`sk/round0800_c10/manifest.tsv` and `sk/round0800_c11/manifest.tsv`.
Sequential driver: `src/round0800.py`. Live results:
`logs/round0800/summary.json`. Per-case logs:
`logs/round0800/c10_q*.log` and `logs/round0800/c11_q*.log`.
Any emitted candidate goes to both strict judges through
`src/verify_log.py`. Generation is not a completed routing result.
