# w12: C1 garbage comparisons

No sort5 program with k<=31 has passed the strict reference judge in this work.

Route selected: written lemma, with a constructive compiler and a small-case
computer check. The proof is in `lemma.md`. It covers the class-root cost
concern explicitly. It uses the invariant E + Phi <= t, where Phi includes
every alias-class member, including roots.

The claimed theorem removes every garbage comparison with no increase in
core length. Judge acceptance is pending. It does not establish the separate
bound of two non-lattice written columns required by C2. The C1-to-C2 scope
bridge therefore remains open. Direction A is not reported closed.

## Current work

- `src/normalize_c1.py`: independent parser, constructive compiler, cost
  assertions, concrete interpreter, and consistent-garbage witness check.
- `src/check_c1.py`: all 884736 length-three programs on two inputs and two
  scratch registers; three weak input orders each; four disjoint shards.
- Targeted root case: five original instructions and five emitted instructions.
  Both the root and its copied register are read later. The defined anchor
  remains live. All 125 signed-int32 input triples passed the construction
  check. The trace has Phi values 1, 2, 2, 1, 0.
- All four exhaustive shards finished. Each covered 221184 programs and
  663552 input-order checks. Total: 884736 programs and 2654208 checks.
  Every specialization and prefix-cost assertion passed. Maximum emitted
  length minus input length: zero. Results: `analysis/c1_small_{0,1,2,3}.json`.
- All 10000 deterministic random length-31 programs passed 50000 additional
  concrete specialization checks. Seed: 120026. Result: `analysis/c1_extras.json`.
- The root-family check covered every split order for one through five
  unbound members plus one defined anchor. Every member is read by a later
  conditional write. It includes every possible position of the root and
  anchor in that order. Each order uses each of the four cmov conditions,
  applied uniformly. All 3488 programs passed all 75 weak input orders:
  261600 checks. Every program kept its original core length. All root and
  anchor moves were included. Result: `analysis/c1_root_families.json`.

The small exhaustive checks cover construction semantics and instruction cost.
They do not count sort5 programs or establish a sort5 lower bound.

## Strict reference-judge controls

The following eight files passed `shared/judge.py --strict` in the stated
model. The full output is in `logs/c1_judge_controls.log`. Individual commands,
outputs, and file hashes are in `analysis/c1_judge_controls.json`.

| out file | memory file | n | out k | memory L |
|---|---|---:|---:|---:|
| `programs/c1_root_live_sort2_original_out.s` | `programs/c1_root_live_sort2_original_mem.s` | 2 | 9 | 13 |
| `programs/c1_root_live_sort2_normalized_out.s` | `programs/c1_root_live_sort2_normalized_mem.s` | 2 | 9 | 13 |
| `programs/c1_gcmp_sort5_control_original_out.s` | `programs/c1_gcmp_sort5_control_original_mem.s` | 5 | 33 | 43 |
| `programs/c1_gcmp_sort5_control_normalized_out.s` | `programs/c1_gcmp_sort5_control_normalized_mem.s` | 5 | 33 | 43 |

The sort2 control reads a garbage class root and its copy after their first
copy. Both later conditional writes need the old class value. The normalized
program has no garbage reads and keeps k=9. The sort5 control adds one garbage
comparison to a known k=32 program. Its normalization removes that comparison
and uses one extra later copy, so k remains 33. These controls are not shorter
sorting results.

The first memory control run failed because its R header omitted the memory
cell count. The header was corrected. The final eight runs all passed. The
initial parser rejection remains in `logs/c1_judge_controls_header_error.log`.

These are construction checks. They are not sort5 UNSAT queries. No UNSAT
result without a checked certificate is used. No solver query is left UNKNOWN.

## Earlier work retained

Earlier source files, programs, logs, and JSON records remain in this folder.
They include MCMC, local mutation, redirected-operand, and branch-splitting
experiments. No retained candidate is recorded as a strict PASS. Their finite
searches do not exclude the requested program class. New work follows the
supervisor's proof-or-certificate priority and does not repeat those searches.

## Status

2026-10-26T07:01Z: construction cases decided 0 / remaining 884736 /
unknown 0; C1 judge review pending; C1-to-C2 column bound open.

2026-10-26: construction cases decided 884736 / remaining 0 / unknown 0;
targeted root cases decided 125 / remaining 0 / unknown 0; random cases
decided 10000 / remaining 0 / unknown 0; strict control runs PASS 8/8.
C1 judge review pending. The C1-to-C2 column bound remains open. There are
no pending SAT queries and no unverified UNSAT claims.

2026-10-26T07:12Z: exhaustive construction cases decided 884736 /
remaining 0 / unknown 0; root-family cases decided 3488 / remaining 0 /
unknown 0. All 261600 root-family input-order checks passed. Proof and
code are ready for judge review. C1-to-C2 column bound remains open.

## Supervisor gap report and continued column analysis

`GAPS.md` has exactly two paragraphs. The first states the C1-to-C2 column
bound gap. The second states the mixed three-column reduction gap and its
missing cases (q,r)=(1,2), (2,1), and (0,3). Each paragraph states what would
close the gap. d2-lattice owns the V1 and V2 position cases. No C2 solver
campaign was started here.

The requested messages could not be delivered through the available agent
tool. `judge` is not a live agent in this thread. The tool does not accept
the external `team-lead` session name. The file-mailbox fallback writes
outside this worker's permitted directory. Both message texts and the
delivery failures are recorded in `GAPS_MESSAGES.txt`. They are not marked
as sent.

Continued work found that the current C1 compiler does not preserve the C2
column budget. `COLUMN_BOUND.md` gives the derivation and limits. An original
sort5 control has two partial written versions and one full non-lattice
written version. Its normalized program has three full non-lattice written
versions. Every original instruction is live under ordinary backward
analysis of data and flags. The exact classifier checks all 4683 joint weak
orders of five inputs and the one relevant initial garbage value. The
original and normalized programs passed the strict judge in both models.

The original has k=40 and its normalization has k=39. Thus this is not a
counterexample within k<=31. It refutes a column-count guarantee for this
implementation, not the existence of another reduction. A semantic rewrite
can simplify its prefix. An earlier control with a dead prefix gives the
same three-column image from q=1 and r=1 at k=38. These are implementation
checks, not UNSAT decisions.

Additional strict PASS files:

| out file | memory file | n | out k | memory L |
|---|---|---:|---:|---:|
| `programs/c1_column_growth_original_out.s` | `programs/c1_column_growth_original_mem.s` | 5 | 38 | 48 |
| `programs/c1_column_growth_normalized_out.s` | `programs/c1_column_growth_normalized_mem.s` | 5 | 38 | 48 |
| `programs/c1_live_growth_original_out.s` | `programs/c1_live_growth_original_mem.s` | 5 | 40 | 50 |
| `programs/c1_live_growth_normalized_out.s` | `programs/c1_live_growth_normalized_mem.s` | 5 | 39 | 49 |

Exact judge output: `logs/c1_column_growth_judge.log` and
`logs/c1_live_growth_judge.log`. Classifier results, witnesses, paths, and
hashes: `analysis/c1_column_growth.json` and `analysis/c1_live_growth.json`.

2026-10-26T07:55Z: gap statements written 2/2; message deliveries 0/2;
new column-growth controls decided 2 / remaining 0 / unknown 0;
new strict judge runs PASS 8/8. Earlier construction counts remain
884736 exhaustive programs, 3488 root cases, and 10000 random programs,
all complete with no unknown construction cases. Both scope gaps remain open.

CPU limit: four processes. Each runs at nice level 19. Jobs use less than
3 GB each. All new files are in this worker folder.
