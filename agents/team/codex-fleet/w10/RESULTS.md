# w10: partially written scratch registers

No sort5 program with core length k <= 31 has passed the strict judge in this work.
The general same-length lattice rewrite claim remains open.

The finite normalization check succeeded for all 868,567 programs in the source
collection. This includes all 157,559 programs with non-lattice full columns.
The check used all 541 weak orders. Selected original and normalized examples
have strict judge PASS records. This is sample evidence for A15, not a general
rewrite proof.

## Purpose and terms

The target is a strict-correct sort5 program with k <= 31. The memory target is
L <= 41. The permitted instructions and counting follow shared/MODEL.md.

A **column** gives one register value for each of the 120 strict input orders.
A **partial column** contains an input value on some orders and an arbitrary
initial scratch value on other orders. A **lattice column** is the value of one
expression made from input variables, min, and max. A **lattice completion**
agrees with every defined entry of a partial column. A value is **live** if a
later output or a later required comparison uses that value before replacement.
An entry is **dead** if no required output or comparison uses it before replacement.
Here, pure lattice has A15's semantic meaning: each produced register value
equals some min/max expression in the five inputs.

## Method

All writes stay in this worker folder. Sources from other workers are read-only.
The CPU search uses six workers at nice level 10. Two CPU slots remain for the
independent analysis and the strict judge. No sub-agents are used.

`src/analyze.py` contains an independent parser and a conservative simulator.
It does not import the judge. At threshold t, the **upper set** contains the
input indices whose values are at least t. The lattice test assigns a Boolean
value to every upper set. A defined column value fixes these assignments.
Conflicting assignments, or an assignment that decreases under set inclusion,
exclude every lattice completion. Unspecified entries add no constraints.

`src/normalize.py` computes value and flag dependencies backwards from explicit
output snapshots. If changing a conditional write to `mov` preserves every live
entry of its result, the script makes that change. A change can alter dead
entries. Every published sort candidate is checked separately by the strict
judge. The lattice classification itself uses only the 120 strict orders.

`src/gap_mcmc.c` is a local copy of upper's MCMC search with extra state and a
fitness penalty. MCMC means a random search that can accept a worse candidate.
The extra state records partial columns and later reads of those columns.
The penalty favors programs that contain those reads. The simulator permits
non-lattice values. It uses all 541 weak orders and conservative unknown values.
`src/run_campaign.py` saves the commands, seeds, limits, and search summaries.

## Result: the four recorded rewrite exceptions can be normalized

The source is `agents/team/d2-lattice/te_exceptions.s`. This worker copied its
four original programs and four first-access rewrites into `programs/`.

Each original has two partial columns and no non-lattice full column on the 120
strict orders. Its first-access rewrite has one non-lattice full column.
The independent check reproduces that observation for all four programs.

For each original, replace these two instructions:

```
cmovle S1, P1   ->   mov S1, P1
cmovle S1, P2   ->   mov S1, P2
```

These are core instructions 2 and 6. The resulting programs keep k = 32. Every
computed column is a full lattice column on the 120 strict orders. They are
saved as `programs/exception_{0,1,2,3}_normalized.s`.

The first replacement preserves the use of S1 in the first comparison block.
On the other branch, no instruction needs that old S1 value before replacement.
After the second replacement, no instruction reads S1 before the complementary
`cmovge S1, P4`. Thus both changes preserve the required values, including ties.
All four originals, all four first-access rewrites, and all four normalized
programs passed the strict judge in both models. The complete judge output is
in `logs/judge_selected.log`. The memory translations have L = 42.

This closes these four examples as objections to a lattice rewrite. It does not
prove a rewrite theorem for other programs.

## Result: preserving all defined intermediate entries is too strong

In `programs/exception_0_original.s`, inspect S1 after core instruction 6.
Two strict inputs give:

| input (P0,P1,P2,P3,P4) | S1 | indices with input >= 2 |
|---|---:|---|
| (0,1,3,2,4) | 3 | {2,3,4} |
| (0,1,3,4,2) | 1 | {2,3,4} |

Both entries are defined input values. They do not depend on scratch garbage.
Let h(v) = 1 if v >= 2, and h(v) = 0 otherwise. The map h commutes with min and
max. Both input vectors map to (0,0,1,1,1). Every min/max expression must therefore
give the same Boolean result on both vectors. The two S1 values map to 1 and 0.
This is a contradiction. No lattice expression can complete this partial column
while preserving all its defined entries.

The witness is saved in `analysis/exception_trace.json`. It refutes a
column-preserving normalization rule. It does **not** refute an output-preserving
rewrite of the whole program. The normalized program above demonstrates that
distinction: the conflicting entries can be changed because they are dead.

## Conditional rewrite lemma

Consider `cmovC D,S` at time t. Suppose that, on each execution where C is false,
no instruction reads or outputs the current D value before a later write
replaces D. Then replacing this instruction with `mov D,S` preserves the outputs
and the instruction count.

Proof: when C is true, the two executions agree. When C is false, only D can
differ after t. The condition guarantees that this difference cannot affect a
comparison, a source value, or an output. The later write removes the difference.
Apply this argument to every input, initial scratch assignment, and initial flag
assignment. The rewrite is valid in the strict model.

This lemma is sufficient for the two changes above. It does not establish that
every partial program admits such changes, or that repeated changes always
produce lattice columns.

## Result: larger normalization samples

The Python implementation and the independent C++ implementation agree on the
1,613 programs from the smoke collection. All 1,613 contain a partial column.
Of those programs, 1,401 have no non-lattice full column. The rewrite makes all
1,401 pure lattice programs with no partial columns. The C++ analysis finds 86
programs with a partial column that has no lattice completion if every defined
entry must be preserved. None has that obstruction after dead entries are
removed from the constraints.

The C++ implementation also checked the first 5,000 programs from
`agents/upper/runs/r4/s5k32_coll.txt.gz`. It found 2,242 programs with partial
columns. Of those, 1,920 have only lattice full columns. The new rewrite makes
all 1,920 pure lattice programs. This includes the four earlier exceptions.
The Python check of the same 5,000 programs finished and agreed with these
counts. Its record is `analysis/old5000_python.json`.

The C++ implementation then checked the first 100,000 programs in that file:

| observation | programs |
|---|---:|
| analyzed | 100,000 |
| contains a partial column | 49,213 |
| contains a partial column with no completion that preserves every defined entry | 572 |
| lattice full columns plus partial columns | 41,178 |
| same-length pure lattice result after the rewrite | 41,178 |
| conflicting live partial constraints | 0 |
| changed outputs on the 541 weak orders | 0 |

These are finite sample checks, not a proof of A15. The C++ implementation uses
all 541 weak orders for the dependency analysis and output comparison. It uses
the 120 strict orders for lattice classification. The sampled programs have
not each been submitted to the reference judge. Only the selected program
files listed below carry a strict PASS claim.

The full collection check then reached the end of the file. It analyzed all
868,567 programs in 116.589 CPU seconds:

| observation | programs |
|---|---:|
| analyzed | 868,567 |
| contains a partial column | 441,515 |
| contains a partial column with no completion that preserves every defined entry | 5,706 |
| lattice full columns plus partial columns | 368,301 |
| same-length pure lattice result after the rewrite | 368,301 |
| conflicting live partial constraints | 0 |
| changed outputs on the 541 weak orders | 0 |

The record is `analysis/large_census.json`. The checker reports absent count keys
as zero. The source collection had no unsupported garbage comparison.

A second count on the first 5,000 programs tested the result without first
requiring lattice full columns. All 5,000 became pure lattice programs. This
includes 676 programs that initially had a non-lattice full column. The record
is `analysis/old5000_total.json`.

The full check with lattice classification on all 541 weak orders also reached
the end of the collection. It reproduced the 368,301 successful rewrites in
159.940 CPU seconds. Its record is `analysis/large_census_weak.json`.

The final checker counted every normalized program, including programs that
initially had non-lattice full columns. It found:

| observation on all 541 weak orders | programs |
|---|---:|
| analyzed | 868,567 |
| initially contains a non-lattice full column | 157,559 |
| pure lattice after the same-length rewrite | 868,567 |
| initially non-lattice, then pure lattice | 157,559 |
| changed output entries | 0 |
| unsupported garbage comparisons | 0 |

This final run used 103.204 CPU seconds. It precomputed sorted expected values
to reduce repeated work. Its record is `analysis/large_census_weak_total.json`.
The input file path, byte count, and SHA-256 are in `analysis/provenance.json`.
No claim above substitutes for a strict reference-judge PASS on an individual
candidate. The bulk result is an independent finite analysis of the given
collection.

For a selected example with an initially non-lattice full column, see collection
index 613. `programs/nonlat_full_original.s` has one partial column and one
non-lattice full column on strict orders. Replacing conditional writes 3 and 11
with `mov` makes the program pure lattice without changing k = 32. The original
and normalized programs passed the strict judge in both models. Their record
is `logs/judge_nonlat_full.log`.

`src/check_completion.py` compared the completion criterion with the explicit
catalog of all 7,579 nonconstant lattice functions from d1-skeleton. It checked
3,000 partial columns and found zero disagreements. Of those columns, 1,001
had a completion. The record is `analysis/completion_crosscheck.json`.

## Search and verification status

In the first search campaign, four runs used 31 instruction slots and
6, 10, 16, or 24 scratch registers. Two runs use 32 slots and 10 or 16 scratch
registers. Each run had a 240-second CPU limit and a 900-second wall limit.
The 31-slot seeds remove one instruction from an original exception program.
The search can change instructions, operands, registers, and instruction order.
It does not fix the comparison skeleton or a lattice term pool.

All six runs reached the 900-second wall limit. The four length-31 runs kept a
best error score of 75. This score is the sum of wrong output entries across
five outputs and 541 weak orders. The two length-32 runs reached k = 32.
No run produced k <= 31. This version did not print periodic proposal counts,
so the exact iteration totals for these terminated runs are unavailable. Their
results are finite searches, not UNSAT results. Commands and termination
records are in `logs/wave0_config.json` and `logs/campaign0.log`.

The 2-second smoke run made 49,152 proposals. It reported 43,754 evaluated
proposals with a partial-column read and 5,828 accepted proposals of that kind.
It reached k = 32. It did not reach k <= 31.

The second campaign started from the two known eight-comparison families in
worker w6. `src/guard_seeds.py` changed one or two safe initial `mov` writes to
conditional writes. It produced eight length-32 programs with partial columns.
All eight passed the strict judge in both models. These examples also contain
non-lattice full columns. They are outside the lattice-only search scope.
They do not refute an arbitrary same-length rewrite of the whole sort5 program.

The second campaign removed one instruction from these seeds and ran six
searches with length 31 and 6, 10, 16, or 24 scratch registers. Every run finished
500,000 iterations normally. The totals were:

| observation | count |
|---|---:|
| search iterations | 3,000,000 |
| evaluated proposals with a partial-column read | 2,107,118 |
| accepted proposals with a partial-column read | 273,267 |
| all accepted proposals | 385,002 |
| reported CPU seconds, summed after rounding | 27.1 |
| correct length-31 program | 0 |

The best error scores were 99, 163, 163, 99, 163, and 163. Each score counts
wrong output entries, as above. The initial family changed, but these searches
did not cross the length-31 gap. Their commands, progress counters, final
iteration totals, and error scores are in `logs/wave1_config.json`,
`logs/campaign1.log`, and `logs/wave1_{0,1,2,3,4,5}.log`.

The strict judge rejected all ten retained length-31 near misses in both models.
The 20 FAIL records and counterexamples are in `logs/judge_near.log`. These
programs are not solutions.

The rewrite method also has a direct limit on the eight-comparison family.
For `programs/c8_guard_0_0.s`, it changes writes 3 and 18. The result has no
partial column, but it still has five non-lattice full columns. See
`analysis/c8_guard_normalization_limit.json`. Thus the method used for the large
collection is not a general construction of a pure lattice program. This does
not refute an arbitrary same-length rewrite: changing the comparisons could
permit another program of length 32.
The resulting `programs/c8_guard_0_0_movified.s` and its memory translation
passed the strict judge. Their record is `logs/judge_c8_limit.log`.

The current selected strict PASS files are below. Each row names the out model
file and its memory model translation. The out files have k = 32. The memory
files have L = 42. Every row passed `--strict --model out` and
`--strict --model mem`, respectively. There are 52 PASS records across
`logs/judge_selected.log`, `logs/judge_c8_guards.log`, and
`logs/judge_nonlat_full.log`, and `logs/judge_c8_limit.log`. Their JSON files
provide one record per command.

| out file | memory file |
|---|---|
| `programs/exception_0_original.s` | `programs/exception_0_original_mem.s` |
| `programs/exception_1_original.s` | `programs/exception_1_original_mem.s` |
| `programs/exception_2_original.s` | `programs/exception_2_original_mem.s` |
| `programs/exception_3_original.s` | `programs/exception_3_original_mem.s` |
| `programs/exception_0_eliminated.s` | `programs/exception_0_eliminated_mem.s` |
| `programs/exception_1_eliminated.s` | `programs/exception_1_eliminated_mem.s` |
| `programs/exception_2_eliminated.s` | `programs/exception_2_eliminated_mem.s` |
| `programs/exception_3_eliminated.s` | `programs/exception_3_eliminated_mem.s` |
| `programs/exception_0_normalized.s` | `programs/exception_0_normalized_mem.s` |
| `programs/exception_1_normalized.s` | `programs/exception_1_normalized_mem.s` |
| `programs/exception_2_normalized.s` | `programs/exception_2_normalized_mem.s` |
| `programs/exception_3_normalized.s` | `programs/exception_3_normalized_mem.s` |
| `programs/smoke_len32_b31726.s` | `programs/smoke_len32_b31726_mem.s` |
| `programs/wave0_4_len32_4c79eb.s` | `programs/wave0_4_len32_4c79eb_mem.s` |
| `programs/wave0_5_len32_7b005e.s` | `programs/wave0_5_len32_7b005e_mem.s` |
| `programs/c8_guard_0_0.s` | `programs/c8_guard_0_0_mem.s` |
| `programs/c8_guard_0_1.s` | `programs/c8_guard_0_1_mem.s` |
| `programs/c8_guard_0_2.s` | `programs/c8_guard_0_2_mem.s` |
| `programs/c8_guard_0_3.s` | `programs/c8_guard_0_3_mem.s` |
| `programs/c8_guard_0_4.s` | `programs/c8_guard_0_4_mem.s` |
| `programs/c8_guard_1_0.s` | `programs/c8_guard_1_0_mem.s` |
| `programs/c8_guard_1_1.s` | `programs/c8_guard_1_1_mem.s` |
| `programs/c8_guard_1_2.s` | `programs/c8_guard_1_2_mem.s` |
| `programs/nonlat_full_original.s` | `programs/nonlat_full_original_mem.s` |
| `programs/nonlat_full_normalized.s` | `programs/nonlat_full_normalized_mem.s` |
| `programs/c8_guard_0_0_movified.s` | `programs/c8_guard_0_0_movified_mem.s` |

## Limits

No result here establishes a global lower bound. The search has finite register
caps and finite run time [A1, A2]. Its unknown-value semantics can reject useful
programs whose comparisons involve garbage. The initial classification used
strict input orders. The final classification used all 541 weak orders [A15].
Only a strict judge PASS
establishes a sort candidate's correctness under the requested acceptance rule.

The global A15 statement remains open. A k = 32 example cannot by itself exclude
all same-length lattice rewrites: a pure lattice sort5 with k = 32 already exists.
For k >= 32, that program can replace any sort5 program without increasing its
length. Padding can preserve an exact length. The unresolved part concerns
strict-correct programs shorter than 32.

## Round 2: bounded SAT tests of A15

### Purpose

Test whether partial scratch registers give a shorter sorting program than
pure lattice registers at the same comparison count. Start with sort4.
Then test one sort5 program class at k = 31. The general A15 claim remains
open. This round found no counterexample to it. [A15]

The resource statement in the earlier Method section describes the earlier
round. This round ran one CPU job at a time, at nice level 19. All new files
are in this worker folder.

### Terms

A **flag column** gives a comparison's less/equal/greater result for each input
order. Fixing flag columns does not fix the comparison operands or intermediate
value columns. A **data instruction** is a mov or cmov. A **data block** contains
the data instructions after one comparison and before the next comparison.

The encoder uses an **undefined value** for any initial scratch value that has
not been replaced. This value is not a numeric sentinel. The encoder forbids
comparisons and outputs that contain it. It permits conditional copies from
partially defined values. It also permits fully defined non-lattice values.

### Method

`src/partial_sat.py` is a new SAT encoder. Each data instruction creates a value
column. A mov creates a fresh register. A cmov overwrites its previous
destination. The encoder forbids later reads of that old destination value.
An output can save any historical value. The encoder also permits a cmov into
a fresh undefined register. Thus it has no fixed register cap. [A2/A7]

The `partial` mode requires a written column with both defined and undefined
entries. A later counted instruction must read that column. Other columns can
be non-lattice. The `lattice` mode requires every written column to be a full
min/max polynomial. The `full` mode permits arbitrary columns, including
undefined entries, and does not require a partial witness.

For each lattice column, the encoder selects a monotone Boolean truth table
with endpoints 0 and 1. At every input threshold, that table must agree with
the column. This gives the min/max representation test. Input identities,
rather than ranks, support equality constraints between executions with the
same flag history. Those constraints follow from deterministic execution.

All comparisons select their operands freely from live columns. The sort4
fixed-flag tests use the flag columns of the comparator sequence
`01,23,02,13,12`. No intermediate value pool is fixed. The sort5 test uses the
flag columns of `programs/exception_0_original.s`. These remain fixed-flag
tests, not global searches. [A4, A15]

`src/partial_validate.py` independently simulates all weak orders. It classifies
the written columns and calls the reference strict judge in both models.
Every SAT assignment was also checked against its saved CNF formula.
`src/partial_proofs.py` checks UNSAT certificates with the separate `drat-trim`
program. The CNF files, solver output, certificates, hashes, commands, and
checker output are saved in `round2/`.

### Result

There were 25 SAT queries, including controls: 8 SAT, 15 UNSAT, and 2 UNKNOWN.
The table gives the main queries. Each row specifies an exact core length and comparison count.
Times include formula construction and solver execution.

| n | k | comparisons | columns and additional constraints | solver result | seconds |
|---|---:|---:|---|---|---:|
| 2 | 3 | 1 | partial; all 3 weak orders | UNSAT | 0.013 |
| 2 | 3 | 1 | pure lattice; all 3 weak orders | UNSAT | 0.014 |
| 3 | 10 | 3 | partial; all 13 weak orders; flag columns free | UNSAT | 76.631 |
| 3 | 10 | 3 | pure lattice; all 13 weak orders; flag columns free | UNSAT | 7.185 |
| 3 | 11 | 3 | partial; all 13 weak orders; flag columns free | SAT, strict PASS | 6.237 |
| 3 | 11 | 3 | pure lattice; fixed normalized control | SAT, strict PASS | 0.082 |
| 4 | 19 | 5 | pure lattice; 24 strict orders; fixed flags; block sizes free | UNSAT | 14.087 |
| 4 | 19 | 5 | partial; 24 strict orders; fixed flags; block sizes free | UNSAT | 114.401 |
| 4 | 19 | 5 | arbitrary columns; 24 strict orders; fixed flags; block sizes free | UNSAT | 106.005 |
| 4 | 19 | 5 | partial; 75 weak orders; fixed flags; blocks 3,3,3,3,2 | UNSAT | 7.246 |
| 4 | 19 | 5 | partial; 24 strict orders; flag columns and block sizes free | UNKNOWN, 180-second limit | 180.502 |
| 4 | 20 | 5 | partial; 75 weak orders; fixed flags; blocks 3,3,3,3,3 | SAT, strict PASS | 5.450 |
| 4 | 20 | 5 | pure lattice; 75 weak orders; fixed flags; blocks 3,3,3,3,3 | SAT, strict PASS | 4.658 |
| 5 | 31 | 9 | partial; 120 strict orders; fixed flags; blocks 3,5,2,2,2,2,2,2,2 | UNSAT | 72.530 |
| 5 | 32 | 9 | fixed original control; 120 strict orders | SAT, strict PASS | 6.421 |

The strongest sort4 query has 4,430 variables and 103,090 clauses. It permits
arbitrary intermediate columns, including partial and non-lattice columns.
It does not require each data value to have a later use. Its UNSAT result
therefore also covers the fixed-flag case where partial columns occur only on
tied inputs. This follows because that query has no partial-column requirement.
Its record is `round2/n4_k19_any_freeblocks.json`.

The synthesized sort4 partial program has two partial written columns and one
fully defined non-lattice column on the 75 weak orders. Thus this encoder does
reach values outside the pure lattice model. The synthesized lattice program
has 15 full lattice written columns. Both programs have k = 20 and five
comparisons. Neither program shows a length advantage for partial registers.

The sort5 k = 31 query has 34,513 variables and 1,201,345 clauses. It leaves
all data instructions and comparison operands free, subject to the fixed flag
columns and block sizes. It permits arbitrary non-lattice values. Its UNSAT
result applies to that class only. The class also requires a partial column
on the 120 strict orders. The record is
`round2/n5_k31_partial_flags_blocks.json`. [A4, A15]

The other UNKNOWN result is the initial sort4 k = 20 partial query. It used
rank values, fixed flags, and fixed block sizes. It reached its 30-second solver
limit. Later queries used input identities and completed. Neither UNKNOWN
result is an UNSAT result.

Two negative controls behaved as required. The lattice model rejected the
fixed partial control. The partial model rejected the fixed lattice control.
Both returned UNSAT. The remaining query details are in each `round2/*.json`
run record and in `round2/campaign.log`, `round2/extra.log`, and
`round2/finish.log`.

The separate checker accepted 14 of 15 UNSAT certificates. The sort5 check
`n5_k31_partial_flags_blocks` reached the 300-second limit and returned
`TIMEOUT`. Its certificate verification remains incomplete. The solver result
is UNSAT. The checker did not report a certificate rejection.
The checker records are `round2/proof_checks.json` and `round2/*.proofcheck.json`. The first checker pass used a 90-second limit. Incomplete checks were retried with a 300-second limit.

The new strict PASS files are listed below. Each row passed both `--strict --model out` and `--strict --model mem`. The associated `.validation.json` file contains the complete judge output. There are 20 new PASS records.

| n | out file | memory file | k | memory length |
|---|---|---|---:|---:|
| 2 | `round2/n2_k4_partial.s` | `round2/n2_k4_partial_mem.s` | 4 | 8 |
| 3 | `round2/n3_k11_lattice_fixed.s` | `round2/n3_k11_lattice_fixed_mem.s` | 11 | 17 |
| 3 | `round2/n3_k11_lattice_normalized.s` | `round2/n3_k11_lattice_normalized_mem.s` | 11 | 17 |
| 3 | `round2/n3_k11_partial.s` | `round2/n3_k11_partial_mem.s` | 11 | 17 |
| 4 | `round2/n4_k20_lattice_fixed.s` | `round2/n4_k20_lattice_fixed_mem.s` | 20 | 28 |
| 4 | `round2/n4_k20_lattice_synth.s` | `round2/n4_k20_lattice_synth_mem.s` | 20 | 28 |
| 4 | `round2/n4_k20_partial_fixed.s` | `round2/n4_k20_partial_fixed_mem.s` | 20 | 28 |
| 4 | `round2/n4_k20_partial_normalized.s` | `round2/n4_k20_partial_normalized_mem.s` | 20 | 28 |
| 4 | `round2/n4_k20_partial_synth.s` | `round2/n4_k20_partial_synth_mem.s` | 20 | 28 |
| 5 | `round2/n5_k32_partial_fixed.s` | `round2/n5_k32_partial_fixed_mem.s` | 32 | 42 |

For `round2/n4_k20_partial_normalized.s`, replace three writes in the synthesized partial program with `mov`: `cmovle P1, P2`, `cmovg S1, P3`, and `cmovge S2, P0`. The result has 15 full lattice written columns on all 75 weak orders. It keeps k = 20 and five comparisons. Both strict judge checks passed. This is one more finite rewrite example, not a rewrite theorem.

`round2/summary.json` lists all 25 solver records, all certificate records, all new PASS paths, and source hashes.

### Limits

Every query excludes comparisons that read an undefined scratch value on its
encoded input orders. Every data instruction follows the first comparison. Except where `--free-first`
is set, the first comparison is `cmp P0, P1`. Outputs are free snapshots and
register allocation has no fixed cap. Some runs fix flag columns or data block
sizes. Some runs use only strict input orders. A partial-column requirement
on strict orders does not include programs whose partial entries occur only
on ties. The arbitrary-column sort4 query avoids that last restriction.

The UNSAT results describe the saved bounded formulas. They do not prove A15,
exclude all sort5 programs of length 31, or show a global same-length rewrite.
No assumption is marked CHALLENGED by this round. [A4, A15]

## Round 3: strengthened free-outcome query [A15]

The prior results were read before this round. The new search extends the
previous UNKNOWN query. It does not repeat a completed search.

`src/partial_sym.py` adds comparison operand orientation, canonical condition
selectors for mov, and the remaining P2/P3 input symmetry. Scratch names are
already absent in the creation-order value model. The chronological comparison
block order remains free. Equal flag histories imply equal origin identities.
History classes also have binary decision-tree capacity bounds. Full details
and the soundness arguments are in `round3/METHOD.md`.

The new sort4 query has k=19 and c=5. It uses all 24 strict orders, free flag
columns, free data block sizes, and no register cap. It requires a used partial
column. It excludes comparisons of undefined scratch values. The formula has
19,156 variables and 293,114 clauses. Its SHA-256 is
`dd810dfdc370f835aa214b0c132dd28bfa46923e37d39a5d89e1cf5648b2b54d`.
The solver limit is 3,600 seconds. A limited run will remain UNKNOWN.

Both fixed k=20 controls returned SAT. Each saved assignment satisfied every
clause of its formula. Their decoded files passed the reference strict judge:

| out file | memory file | k | memory length |
|---|---|---:|---:|
| `round3/control_partial.s` | `round3/control_partial_mem.s` | 20 | 28 |
| `round3/control_lattice.s` | `round3/control_lattice_mem.s` | 20 | 28 |

These four PASS records are in `round3/control_{partial,lattice}.judge` and
`.validation.json`. The partial control has two partial columns and one full
non-lattice column on all 75 weak orders. The lattice control has 15 full
lattice columns. These controls test the new constraints; they are not shorter
programs.

`src/round3_run.py` runs jobs serially at nice level 19. Each child has a memory
limit below 3 GB. After the sort4 run, it will retry the pending sort5 k=31
certificate with a 1,800-second limit. New checker records go in `round3/`.
The old certificate and its 300-second timeout record remain unchanged.

Status when this entry was written: sort4 target RUNNING; sort5 checker retry
PENDING. The general A15 claim remains open. No assumption is marked
CHALLENGED by these controls.

## Round 4: three partial columns [A15]

The earlier results were read before this round. The prior sort4 log has not
advanced. Its last line reports 1,485.49 CPU seconds, with no final solver
status. A process list in a separate isolated command cannot establish the old
session's process state. No sort5 certificate retry record was present. The old files
remain unchanged. An incomplete run is UNKNOWN.

The new sort4 run uses the exact saved round-3 formula. It has a one-hour wall
limit and omits proof output. The best verified sort4 upper bound in these
files remains k=20 with five comparisons. The free-outcome k=19 query has no
complete result when this entry is written.

`src/partial_gap.py` adds an exact cap of three written columns with undefined
entries. This is a cap on created value columns, not a register cap. In gap
mode, every other written value must be a full lattice function. At least one
partial column must be read later. In arbitrary mode, full non-lattice columns
are also allowed. [A15]

The new sort5 queries use k=31 and nine comparisons. Their 22 data nodes permit
1,793 nonempty choices of at most three partial positions. The free block sizes
permit 5,852,925 distributions. The formulas cover those choices together.
These are syntax-space counts. They are not counts of correct programs.
The queries retain the ban on comparisons of undefined values. They encode
120 strict orders. Two queries fix the flag columns of the original exception
program; one leaves flag columns free. [A4, A15]

The full method, controls, limits, and resource settings are in
`round4/METHOD.md`. `src/round4_run.py` runs new jobs serially at nice level 19,
with address-space limits below 3 GB. It includes a 1,800-second retry of the
pending sort5 certificate. It does not rerun the completed round-2 block query.

Status when this entry was written: one-hour sort4 retry RUNNING; new controls,
certificate check, and sort5 queries PENDING. No A15 counterexample or new
strict PASS program has been established in this round.

The serial queue is already launched. It automatically starts the controls
and sort5 queries when `round4/sort4_retry.json` appears. Do not launch a
duplicate CPU job. The active exec session IDs are 13500 for sort4 and 33838
for the serial queue. The sort4 retry started near 03:29 CET and has a
one-hour wall limit. The new sort5 queries run before the old certificate retry.
After session 33838 exits successfully, run
`nice -n 19 python3 src/round4_report.py` for the final hash and PASS-file audit.
The script refuses an incomplete query set or an incomplete certificate retry.

The retry has now finished: UNKNOWN at the 3,600.014-second wall limit. The
child used 2,463.274 CPU seconds and reached 73,336 KiB maximum resident memory.
The timeout return code is 124. There is no final SAT or UNSAT result from
this run. Its record is `round4/sort4_retry.json`. The CNF hash matches round 3.
The best verified upper bound remains k=20, c=5. The free-outcome k=19 class
remains unresolved. This run establishes no new global lower bound. [A15]

### Restricted one-column rewrite argument

`round4/ONE_COLUMN_LEMMA.md` gives a same-length rewrite under these hypotheses:
at most one written value column contains undefined entries; every other
written column is lattice; and comparisons read only defined values. The
count includes completely undefined written columns. It counts register
versions, not active register names. [A15]

The replacement is one mov. A conditional copy from a full source into an
unwritten destination becomes a mov from that source. A conditional copy from
unwritten scratch into a full destination becomes `mov D,D`. A completely
undefined result becomes a mov from any full lattice register. In each case,
the new column is lattice and agrees at every originally defined entry.

An induction preserves every originally defined entry after the change. Each
comparison still has the same operands and flags. Therefore every original
full column and every output remains unchanged. The unique partial column
becomes lattice at the same cost. This is a restricted mathematical argument,
not a test result. It does not apply when two or three written columns contain
undefined entries, or when a comparison reads undefined scratch values.
The general A15 claim remains open.

The argument also extends to any number of columns with undefined entries if
no such write directly reads another such column. A cmov reads its source and old
destination; a mov reads its source. Replacing these writes in execution
order preserves every original defined entry and makes each new written
column lattice. Therefore the unresolved case needs a direct dependency
between partial written versions, under the same full-column and comparison
hypotheses. The SAT formulas in this round do not use this extra restriction.
The full induction is in `round4/ONE_COLUMN_LEMMA.md`. [A15]
These rewrites also preserve every comparison instruction and result. They
therefore preserve the comparison count as well as the total core length.

The same document also gives a general construction that removes scratch
garbage under the defined-comparison hypothesis, without a lattice guarantee.
Replace a never-written data source with current P0. Change each first cmov
write to a mov. Every new written value is then full. An induction preserves
every original defined entry, every comparison operand and result, and every
required final output. No instruction is added or removed. The construction
can create full non-lattice columns. The known noncompletable partial witness
shows why preserving defined entries alone cannot establish A15. [A15]

The six new controls completed as expected: three SAT and three UNSAT. The
three SAT assignments satisfied their saved formulas. All three decoded
programs passed the strict reference judge in both models. Their k is 32 and
their memory length is 42. The separate checker accepted all three negative
control certificates. [A15]

The independent classification on all 541 weak orders found two partial
columns and no full non-lattice column in `round4/gap_control_partial.s`.
It found 23 full lattice columns in `round4/gap_control_pure.s`. It found
one partial column and six full non-lattice columns in
`round4/arbitrary_control_c8.s`. These finite classifications confirm that the
new modes reach the intended values. They do not prove a general rewrite.
The individual `.validation.json` files contain all strict judge output.

### Completed narrow sort5 counts [A4, A15]

All eight new fixed-block queries returned UNSAT at k=31, c=9. Each has
exhaustive satisfying-program count zero in its saved scope. Each permits
at most three undefined-containing written columns. Every other written
column is lattice. All data instructions, comparison operands, output
snapshots, and partial positions remain free. The flag columns are fixed to
the original exception program. The inputs are the 120 strict orders.

The base block sizes are `3,6,2,2,2,2,2,2,2`. Each query subtracts one data
instruction from block 0, 2, 3, 4, 5, 6, 7, or 8. The eight formulas cover
14,344 choices of a block vector and one to three undefined-containing
positions. Those choices are syntax counts; the correct-program count is
zero for each formula. Block 1 was already UNSAT in round 2 under a larger
class and was not solved again.

The separate checker accepted the certificates for blocks 2, 5, 6, and 8.
The checks for blocks 0, 3, 4, and 7 reached their 120-second limits. They
did not report certificate rejection. The solver results remain UNSAT;
those four certificate checks remain incomplete.

The new fixed-flag query with free block sizes reached its 600-second solver
limit and returned UNKNOWN. Its correct-program count is unknown. Thus the
eight zero counts do not exclude the whole three-column class, all block
sizes, or all flag histories. The general A15 claim remains open. No
assumption is marked CHALLENGED by these results.

<!-- ROUND4_LIVE_BEGIN -->
### Round 4 live result record [A4, A15]

This block is updated after each completed query. A limit means UNKNOWN.
The general A15 claim remains open unless a counterexample is separately established.

Sort4 one-hour retry: UNKNOWN.
Sort4 verified upper bound in this worker: k=20, c=5, unless a new strict PASS is listed below.

| query | n | k | c | mode | solver result | exhaustive satisfying-program count |
|---|---:|---:|---:|---|---|---:|
| gap_control_partial | 5 | 32 | 9 | gap | SATISFIABLE | unknown |
| gap_control_pure | 5 | 32 | 9 | pure | SATISFIABLE | unknown |
| gap_reject_partial_bound1 | 5 | 32 | 9 | gap | UNSATISFIABLE | 0 |
| gap_reject_partial_pure | 5 | 32 | 9 | pure | UNSATISFIABLE | 0 |
| gap_reject_nonlattice | 5 | 32 | 8 | gap | UNSATISFIABLE | 0 |
| arbitrary_control_c8 | 5 | 32 | 8 | arbitrary | SATISFIABLE | unknown |
| n5_k31_gap3_fixedflags_freeblocks | 5 | 31 | 9 | gap | UNKNOWN | unknown |
| n5_k31_gap3_delete_block0 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block2 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block3 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block4 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block5 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block6 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block7 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block8 | 5 | 31 | 9 | gap | UNSATISFIABLE | 0 |
| n5_k31_gap3_freeflags | 5 | 31 | 9 | gap | UNKNOWN | unknown |
| n5_k31_arbitrary3_fixedflags_freeblocks | 5 | 31 | 9 | arbitrary | UNKNOWN | unknown |
| n5_k31_c8_arbitrary3_fixedflags_freeblocks | 5 | 31 | 8 | arbitrary | UNKNOWN | unknown |

A zero count applies only to the saved bounded formula.
The formula scope and remaining limits are in `round4/METHOD.md`.

New strict judge PASS files in this round:

- k=32: `round4/gap_control_partial.s` and `round4/gap_control_partial_mem.s`.
- k=32: `round4/gap_control_pure.s` and `round4/gap_control_pure_mem.s`.
- k=32: `round4/arbitrary_control_c8.s` and `round4/arbitrary_control_c8_mem.s`.

Certificate records completed so far:

- `gap_reject_partial_bound1.proofcheck.runlog`: VERIFIED.
- `gap_reject_partial_pure.proofcheck.runlog`: VERIFIED.
- `gap_reject_nonlattice.proofcheck.runlog`: VERIFIED.
- `n5_k31_gap3_delete_block0.proofcheck.runlog`: s TIMEOUT.
- `n5_k31_gap3_delete_block2.proofcheck.runlog`: VERIFIED.
- `n5_k31_gap3_delete_block3.proofcheck.runlog`: s TIMEOUT.
- `n5_k31_gap3_delete_block4.proofcheck.runlog`: s TIMEOUT.
- `n5_k31_gap3_delete_block5.proofcheck.runlog`: VERIFIED.
- `n5_k31_gap3_delete_block6.proofcheck.runlog`: VERIFIED.
- `n5_k31_gap3_delete_block7.proofcheck.runlog`: s TIMEOUT.
- `n5_k31_gap3_delete_block8.proofcheck.runlog`: VERIFIED.
- `n5_k31_partial_flags_blocks_long.proofcheck.runlog`: VERIFIED.

<!-- ROUND4_LIVE_END -->

<!-- ROUND4_FINAL_BEGIN -->
### Round 4 completed run record [A4, A15]

The 18 new synthesis queries returned 3 SATISFIABLE, 4 UNKNOWN, 11 UNSATISFIABLE.
The separate one-hour sort4 retry returned UNKNOWN.
The sort4 upper bound remains k=20. Its free-outcome k=19 class is unresolved.

| sort5 k=31 query | c | mode | blocks | solver result | program count |
|---|---:|---|---|---|---:|
| n5_k31_gap3_fixedflags_freeblocks | 9 | gap | free | UNKNOWN | unknown |
| n5_k31_gap3_delete_block0 | 9 | gap | 2,6,2,2,2,2,2,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block2 | 9 | gap | 3,6,1,2,2,2,2,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block3 | 9 | gap | 3,6,2,1,2,2,2,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block4 | 9 | gap | 3,6,2,2,1,2,2,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block5 | 9 | gap | 3,6,2,2,2,1,2,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block6 | 9 | gap | 3,6,2,2,2,2,1,2,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block7 | 9 | gap | 3,6,2,2,2,2,2,1,2 | UNSATISFIABLE | 0 |
| n5_k31_gap3_delete_block8 | 9 | gap | 3,6,2,2,2,2,2,2,1 | UNSATISFIABLE | 0 |
| n5_k31_gap3_freeflags | 9 | gap | free | UNKNOWN | unknown |
| n5_k31_arbitrary3_fixedflags_freeblocks | 9 | arbitrary | free | UNKNOWN | unknown |
| n5_k31_c8_arbitrary3_fixedflags_freeblocks | 8 | arbitrary | free | UNKNOWN | unknown |

The zero counts have the exact scopes stated above and in `round4/METHOD.md`.
An UNKNOWN query has an unknown correct-program count.

New certificate checks: 7 VERIFIED, 4 s TIMEOUT.
Old sort5 certificate retry records:

- `n5_k31_partial_flags_blocks_long.proofcheck.runlog`: s VERIFIED; verified=true; 358.379 seconds.

There are 6 new strict judge PASS files. Their paths are listed in the live result table.
No sort5 k<=31 candidate passed the strict judge in this round.
The restricted rewrite argument is in `round4/ONE_COLUMN_LEMMA.md`.
The general A15 claim remains open. No assumption is marked CHALLENGED.

Recorded child CPU use, including sort4 and checks: 5706.220 seconds.
Maximum recorded child resident memory: 387,964 KiB.
All CPU jobs ran serially at nice level 19. All hashes were rechecked.
The audit and source hashes are in `round4/final_report.json`.
<!-- ROUND4_FINAL_END -->

The original round-4 queue and its final audit finished successfully. The
full-column extension is now launched in exec session 83459, at nice level 19.
Do not launch another CPU job while that session is active.

The full-column bound has a sharper constructive form. If q>0 written
versions contain undefined entries, replace the earliest one by a lattice
value using the one-column cases. This preserves every original defined
entry even if later columns remain partial. Then apply the general garbage
removal. All already full columns remain unchanged. At most the remaining
q-1 original partial versions can become non-lattice. Thus the original
three-column class maps into full programs with at most two non-lattice
written versions, with the same core length and comparison count. [A15]

The detailed induction is in `round4full/METHOD.md`. After session 83459 ends,
`nice -n 19 python3 -u src/full_two_run.py` will test the fixed and free flag
scopes with bound two. These are sharper probes than the initial bound-three
relaxations. The encoder and resource limits stay the same.
Both bound-three probes returned UNKNOWN. The bound-two follow-up is now
running in exec session 30245, serially at nice level 19.

<!-- ROUND4_FULL_BEGIN -->
## Round 4 extension: full columns after garbage removal [A4, A15]

The construction in `round4/ONE_COLUMN_LEMMA.md` maps the three-partial-column
gap into full programs with at most three non-lattice written columns.
Comparison operands and required output columns remain lattice.
The extension searches this larger, fully defined class. Its method is in
`round4full/METHOD.md`. A limit means UNKNOWN.

| query | k | bound | flags | solver result | program count |
|---|---:|---:|---|---|---:|
| control_one_exception | 32 | 3 | free | SATISFIABLE | unknown |
| control_pure | 32 | 0 | free | SATISFIABLE | unknown |
| reject_nonlat_bound0 | 32 | 0 | free | UNSATISFIABLE | 0 |
| n5_k31_full3_fixedflags | 31 | 3 | fixed | UNKNOWN | unknown |
| n5_k31_full3_freeflags | 31 | 3 | free | UNKNOWN | unknown |
| n5_k31_full2_fixedflags | 31 | 2 | fixed | UNKNOWN | unknown |
| n5_k31_full2_freeflags | 31 | 2 | free | UNKNOWN | unknown |

Strict judge PASS files in this extension:

- k=32: `round4full/control_one_exception.s` and `round4full/control_one_exception_mem.s`.
- k=32: `round4full/control_pure.s` and `round4full/control_pure_mem.s`.

Certificate records:

- `reject_nonlat_bound0.proofcheck.runlog`: s VERIFIED.

Counts apply to the saved formulas. Fixed flag outcomes cover one family.
The free-outcome query has c=9, the first input pair fixed, and input and
comparison symmetries. Both queries use 120 strict orders and free block sizes.
They do not cover comparisons of undefined scratch values, data before the
first comparison, or other comparison counts. The general A15 claim remains open.
<!-- ROUND4_FULL_END -->

<!-- FULL_AUDIT_BEGIN -->
### Full-column extension completed [A4, A15]

The sharper reduction is constructive: q columns with undefined entries give
at most max(0,q-1) full non-lattice written versions, when all original full
columns are lattice and comparisons read defined values. It preserves core
length, comparison count, comparison operand values, and required outputs.
The proof and its limits are in `round4full/METHOD.md`.

| query | bound | variables | clauses | solver CPU seconds | result | program count |
|---|---:|---:|---:|---:|---|---:|
| control_one_exception | 3 | 37021 | 1932708 | 0.409 | SATISFIABLE | unknown |
| control_pure | 0 | 37021 | 1923874 | 0.405 | SATISFIABLE | unknown |
| reject_nonlat_bound0 | 0 | 37021 | 1923876 | 0.380 | UNSATISFIABLE | 0 |
| n5_k31_full3_fixedflags | 3 | 32577 | 1339387 | 547.578 | UNKNOWN | unknown |
| n5_k31_full3_freeflags | 3 | 35817 | 1835950 | 552.103 | UNKNOWN | unknown |
| n5_k31_full2_fixedflags | 2 | 32577 | 1333612 | 581.289 | UNKNOWN | unknown |
| n5_k31_full2_freeflags | 2 | 35817 | 1830175 | 589.784 | UNKNOWN | unknown |

Extension decisions: 2 SATISFIABLE, 4 UNKNOWN, 1 UNSATISFIABLE.
Combined new synthesis decisions in this round: 5 SATISFIABLE, 8 UNKNOWN, 12 UNSATISFIABLE.
The separate one-hour sort4 retry remains UNKNOWN; its verified upper bound is k=20.

Extension certificate checks: 1 VERIFIED.

The strict PASS paths are listed above. Every new sorting candidate was checked
by the reference judge in both models. Source, formula, and certificate hashes
were rechecked. The audit is `round4full/final_audit.json`.
No sort5 k<=31 candidate passed. The general A15 claim remains open.
No assumption is marked CHALLENGED by this round.
The original pending sort5 certificate was accepted in the longer retry.
Four new fixed-block certificate checks remain incomplete at their limits.
Their solver decisions remain UNSAT; the four checks did not report rejection.
Extension recorded child CPU use: 2333.338 seconds.
Extension maximum recorded child resident memory: 386,044 KiB.
All CPU jobs ran serially at nice level 19. All queued solver and certificate-checker processes have exited.
<!-- FULL_AUDIT_END -->

<!-- ROUND5_BEGIN -->
## Round 5: two full non-lattice values [A4, A15]

The threshold SAT formula leaves every lattice shape free. A lattice shape
is a monotone Boolean table on all 32 input subsets. No network term pool
or fixed comparison outcome family is imposed. The method and limits are
in `round5/METHOD.md`. A time limit means UNKNOWN.

| query | n | k | solver result | correct-program count |
|---|---:|---:|---|---:|
| control_one_exception | 5 | 32 | SATISFIABLE | unknown |
| control_pure | 5 | 32 | SATISFIABLE | unknown |
| reject_nonlat_bound0 | 5 | 32 | UNSATISFIABLE | 0 |
| n2_k4_control | 2 | 4 | SATISFIABLE | unknown |
| n2_k3_reject | 2 | 3 | UNSATISFIABLE | 0 |

Position cases completed: 0/254.
Position case decisions: .
Every UNSAT case has exhaustive count zero in its saved formula.
Every UNKNOWN case has unknown count. Counts are not added across
overlapping program classes.

New strict judge PASS files:

- n=5, k=32: `round5/control_one_exception.s` and `round5/control_one_exception_mem.s`.
- n=5, k=32: `round5/control_pure.s` and `round5/control_pure_mem.s`.
- n=2, k=4: `round5/n2_k4_control.s` and `round5/n2_k4_control_mem.s`.

Certificate checks accepted: 2/2.
Campaign complete: False.
The general A15 claim remains open. No assumption is marked CHALLENGED.
<!-- ROUND5_END -->

C2 SHORT STATUS 2026-10-26T07:00:07.328811+00:00 [A15]: 0 cases decided / 1351 remaining / 0 unknown. Five-second passes complete: 0/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:01:09.047504+00:00 [A15]: 0 cases decided / 1351 remaining / 45 unknown. Five-second passes complete: 45/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:02:10.922126+00:00 [A15]: 0 cases decided / 1351 remaining / 93 unknown. Five-second passes complete: 93/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:03:12.938455+00:00 [A15]: 0 cases decided / 1351 remaining / 141 unknown. Five-second passes complete: 141/1351. Long position cases remain with d2-lattice.

## C2 support round: coverage review and short passes [A12, A15]

The supervisor assigns all long position cases to d2-lattice. w10 runs only
five-second position passes. The runner is `src/c2_short.py`. It uses at most
four concurrent jobs, nice level 19, and a 2800 MiB per-job address-space cap.
It saves shared formulas, all case units and hashes, solver logs, and every
complete negative certificate. It checks each new negative certificate.

The written coverage argument and encoder review are in
`round5/C2_COVERAGE.md`. The original bases cover 1351 position cases across
c=9..15: 254, 232, 211, 191, 172, 154, and 137. This split covers all position
selectors in those formulas. It does not cover comparisons of non-lattice
values. C2b also needs c=7 and c=8. The reduction for q partial versions
assumes all original full values are lattice. It does not by itself cover
mixed partial and original non-lattice values, or three original full
non-lattice versions.

The d2 source changed during this review. At first inspection, its runner
deleted every accepted LRAT certificate. The revised runner now retains
zstd-compressed case formulas and certificates by default. Its --nokeep
option still deletes them. The independent checker must handle compressed
proof files and must treat any missing certificate as incomplete. No d2 file
was edited by w10. There were no completed d2 results at these inspections.

A new d2 encoder, `c2/src/threshold_cmpx.py`, now permits exceptional
comparison operands. Its bases are named `base_k31_cC_v2.cnf`. These bases
are distinct from the original formulas used for this short pass. The V2
comparison change is under independent review. The current task does not
authorize w10 to start long position cases.

The independent checker records its random seed and selects ceil(N/10)
verified d2 UNSAT cases. It rebuilds each exact formula and checks its hash
and the certificate hash before running `bin/lrat-check`. With no completed
d2 result, the sample check remains pending.

No new strict PASS file or A15 counterexample is reported. These scope gaps
do not contradict the existing bounded results.

C2 SHORT STATUS 2026-10-26T07:04:15.129845+00:00 [A15]: 0 cases decided / 1351 remaining / 189 unknown. Five-second passes complete: 189/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:05:17.097517+00:00 [A15]: 0 cases decided / 1351 remaining / 237 unknown. Five-second passes complete: 237/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:06:19.700954+00:00 [A15]: 0 cases decided / 1351 remaining / 285 unknown. Five-second passes complete: 285/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:07:21.839798+00:00 [A15]: 0 cases decided / 1351 remaining / 333 unknown. Five-second passes complete: 333/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:08:23.777664+00:00 [A15]: 0 cases decided / 1351 remaining / 381 unknown. Five-second passes complete: 381/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:09:25.411354+00:00 [A15]: 0 cases decided / 1351 remaining / 429 unknown. Five-second passes complete: 429/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:10:28.264118+00:00 [A15]: 0 cases decided / 1351 remaining / 477 unknown. Five-second passes complete: 477/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:11:31.517880+00:00 [A15]: 0 cases decided / 1351 remaining / 525 unknown. Five-second passes complete: 525/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:12:31.973073+00:00 [A15]: 0 cases decided / 1351 remaining / 572 unknown. Five-second passes complete: 572/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:13:32.836222+00:00 [A15]: 0 cases decided / 1351 remaining / 615 unknown. Five-second passes complete: 615/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:14:33.562099+00:00 [A15]: 0 cases decided / 1351 remaining / 662 unknown. Five-second passes complete: 662/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:15:33.738657+00:00 [A15]: 0 cases decided / 1351 remaining / 708 unknown. Five-second passes complete: 708/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:16:34.281561+00:00 [A15]: 0 cases decided / 1351 remaining / 753 unknown. Five-second passes complete: 753/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:17:37.092123+00:00 [A15]: 0 cases decided / 1351 remaining / 802 unknown. Five-second passes complete: 802/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:18:39.075893+00:00 [A15]: 0 cases decided / 1351 remaining / 850 unknown. Five-second passes complete: 850/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:19:41.019675+00:00 [A15]: 0 cases decided / 1351 remaining / 898 unknown. Five-second passes complete: 898/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:20:43.907457+00:00 [A15]: 0 cases decided / 1351 remaining / 947 unknown. Five-second passes complete: 947/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:21:45.674492+00:00 [A15]: 0 cases decided / 1351 remaining / 993 unknown. Five-second passes complete: 993/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:22:47.513433+00:00 [A15]: 0 cases decided / 1351 remaining / 1041 unknown. Five-second passes complete: 1041/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:23:49.591897+00:00 [A15]: 0 cases decided / 1351 remaining / 1089 unknown. Five-second passes complete: 1089/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:24:51.531989+00:00 [A15]: 0 cases decided / 1351 remaining / 1137 unknown. Five-second passes complete: 1137/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:25:53.796820+00:00 [A15]: 0 cases decided / 1351 remaining / 1185 unknown. Five-second passes complete: 1185/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:26:55.907541+00:00 [A15]: 0 cases decided / 1351 remaining / 1233 unknown. Five-second passes complete: 1233/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:27:58.601406+00:00 [A15]: 0 cases decided / 1351 remaining / 1281 unknown. Five-second passes complete: 1281/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:29:00.950791+00:00 [A15]: 0 cases decided / 1351 remaining / 1332 unknown. Five-second passes complete: 1332/1351. Long position cases remain with d2-lattice.

C2 SHORT STATUS 2026-10-26T07:29:26.516591+00:00 [A15]: 0 cases decided / 1351 remaining / 1351 unknown. Five-second passes complete: 1351/1351. Long position cases remain with d2-lattice.

### C2 independent review checks [A15]

The finite arithmetic check examined 729 full n=3 strict-order columns. It found 18 lattice columns. It reported zero representation disagreements. It checked 1944 comparison cases and 69984 conditional-copy cases. These are finite implementation checks, not a general proof.

Independent LRAT coverage check: c10_21_21, 43 cubes, VERIFIED.

The coverage certificate checks the split. It does not decide the position formula or any cube. Copied formulas, certificates, hashes, and checker logs are in `c2_short/review_checks/`.

### C2 five-second pass completed [A12, A15]

Cases submitted: 1351. Solver results: 1351 UNKNOWN.

| comparisons | SAT | checked UNSAT | UNKNOWN |
|---:|---:|---:|---:|
| 9 | 0 | 0 | 254 |
| 10 | 0 | 0 | 232 |
| 11 | 0 | 0 | 211 |
| 12 | 0 | 0 | 191 |
| 13 | 0 | 0 | 172 |
| 14 | 0 | 0 | 154 |
| 15 | 0 | 0 | 137 |

Reconstructed formula hashes checked: 1351. Maximum solver memory in the logs: 69210112 bytes. Summed reported solver CPU time: 4481.930 seconds.

The audit is `c2_short/audit.json`. Each UNKNOWN remains open. The formulas are the original lattice-comparison-operand variant. These results do not decide the broader V2 formulas. d2-lattice owns the long position cases.

C2 WATCH STATUS 2026-10-26T07:31:45.094714+00:00 [A15]: 0 cases decided / 1351 remaining / 0 unknown in direct d2 V1 result files. Split parents remain open in this count. Independent sample: 0/0 verified; available verified population 0.

### C2 support handoff [A12, A15]

The short-pass audit completed. All 1351 formulas reconstructed with their
recorded hashes. All 1351 five-second results remain UNKNOWN. No position
case has a new UNSAT result or a new strict PASS candidate from this worker.
The independent LRAT check accepted d2's c10_21_21 coverage certificate for
43 cubes. That check establishes the saved split's coverage only. It does
not decide any position case.

The first random position-certificate sample has population zero. It remains
PENDING, with complete=false in `c2_short/independent_lrat/sample.json`.
A watcher is running at nice level 19 in exec session 15205. Its command is
`python3 src/c2_short.py --watch-sample`. It polls for completed d2 results.
It starts no position solver. When a nonempty sample is fully checked, it
appends the verification record here and exits. If a sampled certificate is
missing, it keeps that check incomplete. The watcher logs are in
`c2_short/sample_watch.runlog`. It appends a status line at least every two
hours while it waits. The sample covers the recorded available population;
it does not claim that the full d2 campaign is complete.

The encoder review and full coverage argument are in
`round5/C2_COVERAGE.md`. The original V1 split covers the class with lattice
comparison operands. V2 permits full non-lattice comparison operands and
needs c=7..15, a total of 1929 position cases. The original 1351 case results
cannot substitute for V2 case decisions. C1 and the mixed three-column
reduction gap remain separate. Judge acceptance of the encoder is pending.

No assumption is marked CHALLENGED. The general A15 claim remains open.

C2 WATCH STATUS 2026-10-26T07:33:08.487321+00:00 [A15]: 0 cases decided / 1351 remaining / 0 unknown in direct d2 V1 result files. Split parents remain open in this count. Independent sample: 0/0 verified; available verified population 0.

C2 SUPPORT STATUS 2026-10-26T07:50:38.653037+00:00 [A15]: 0 cases decided / 3280 remaining / 0 unknown in d2 V1+V2; 3280 not started, 0 incomplete, 0 SAT pending review. Decisions use peer-checked UNSAT with retained artifacts. Independent sample: 0/0 verified from 0 available checked UNSAT result files. The earlier w10 short pass still has 1351 UNKNOWN V1 cases.

## Requested gap report and current C2 support [A15] (2026-10-26T07:52:29.110105+00:00)

`GAPS.md` has exactly two paragraphs. The first states the missing C1-to-C2
column bound. The second states the missing mixed three-column reduction.
The reduction does not yet cover the pairs (q,r)=(1,2), (2,1), and (0,3),
where q counts partial written columns and r counts original full non-lattice
written columns. Each paragraph states what would close its gap.

Message attempts to judge and team-lead failed. Neither recipient is in the
current tool's agent tree. The seven-line message is saved in
`MESSAGE_TO_JUDGE_AND_TEAM_LEAD.md` for supervisor relay. No shared inbox
was modified.

The direction file records judge acceptance of V1 and V2 encoder soundness.
`round5/METHOD.md` and `round5/C2_COVERAGE.md` now distinguish that acceptance
from unresolved formula decisions and reduction gaps. d2-lattice owns all
long position cases. w10 starts no long position solver.

The new V2 audit checked all nine current base CNF hashes against their
metadata and checked the encoder source hash. It checked selector lengths,
variable bounds, distinct selector variables, distinct position pairs, and
the case-count formula. The 1929 cases have counts 301, 277, 254, 232, 211,
191, 172, 154, and 137 for c=7..15. This is a provenance and coverage check,
not a SAT decision. The record is `c2_short/v2_position_audit.json`. The
previous completed V1 short pass was not rerun.

`src/c2_support_watch.py` tracks all 3280 V1+V2 roots. It keeps peer-checked
UNSAT counts separate from the independent sample. A split parent stays open
unless every child has a retained checked result and the current manifest
has its coverage certificate. It samples ceil(N/10) verified d2 UNSAT result
files from both variants, including cube results, with seed 101026. It
continues after the first nonempty sample. It reuses an independent check
only while local artifacts, checker evidence, and peer hashes still agree.
It appends a status line at least every two hours while running.

The earlier 07:50 status used 'not started' for absent d2 result files. That
label was too strong: a job can be running without a completed result. The
current monitor uses NO_RESULT and reports 'without a completed result'.
The earlier 1351 w10 short-pass UNKNOWN results remain open. At this
inspection there are zero completed d2 result files, so the independent
position/cube proof sample remains pending with complete=false. No new UNSAT
claim, strict PASS candidate, or challenged assumption is reported.

C2 SUPPORT STATUS 2026-10-26T07:52:29.302704+00:00 [A15]: 0 cases decided / 3280 remaining / 0 unknown in d2 V1+V2; 3280 without a completed result, 0 incomplete, 0 SAT pending review. Decisions use peer-checked UNSAT with retained artifacts. Independent sample: 0/0 verified from 0 available checked UNSAT result files. The earlier w10 short pass still has 1351 UNKNOWN V1 cases.

C2 SUPPORT STATUS 2026-10-26T07:52:45.699291+00:00 [A15]: 0 cases decided / 3280 remaining / 0 unknown in d2 V1+V2; 3280 without a completed result, 0 incomplete, 0 SAT pending review. Decisions use peer-checked UNSAT with retained artifacts. Independent sample: 0/0 verified from 0 available checked UNSAT result files. The earlier w10 short pass still has 1351 UNKNOWN V1 cases.

C2 SUPPORT HANDOFF 2026-10-26T07:53:13.223825+00:00 [A15]: the two-variant watcher started at nice level 19 in exec session 83532. Command: `python3 src/c2_support_watch.py --watch`. Log: `c2_short/support_watch.runlog`. This replaces the earlier session 15205, which is unavailable after resume. The watcher starts no position solver. Its population is currently empty; no independent position/cube LRAT sample has been completed.
