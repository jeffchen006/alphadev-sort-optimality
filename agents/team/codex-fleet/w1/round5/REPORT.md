# Round 5: purpose and method

Search new rank and merge designs. No earlier 32-instruction base was
used. No core with `k <= 31` was found.

The constructed sort3-plus-sort2 prefix costs 15 instructions. It leaves
16 instructions for a merge. The alternate sort3-only prefix costs 11
instructions. It leaves 20 instructions for the two single inputs.
The suffix searches choose register sources, destinations, opcodes,
comparison positions, and output positions. They can change intermediate
values. See [round5/METHODS.md](round5/METHODS.md) for the exact families.

# Round 5: completed rank-chain searches

Each output has an independent accumulator. It can start at any original
entry for free. Conditional moves read the original entries. These entries
remain available for free. This family does not share intermediate values.

| Input lists | Cases | Comparison orders | Functional orders | Minimum conditional moves |
| --- | ---: | ---: | ---: | ---: |
| Sorted pair + sorted triple; ties included | 76 | 720 | 120 | 12 |
| Sorted pair + sorted triple; distinct | 10 | 720 | 120 | 12 |
| Two single inputs + sorted triple; ties included | 132 | 5,040 | 0 | No plan |
| Two single inputs + sorted triple; distinct | 20 | 5,040 | 0 | No plan |

For the sorted pair and triple, all 120 functional orders need 12
conditional moves. The six comparisons therefore give a merge cost of
at least 18 instructions, even before physical copy costs. With the
15-instruction prefix, this restricted design needs at least 33 core
instructions. The other 600 orders have no complete independent-chain
plan. This is a finite family result, not a general sorting bound.

# Round 5: shared values and merge schedules

The shared selection search gives copies and retained operands for free.
Its ten gates can share earlier results. The register searches use eight
registers. The triple-only prefix permits one fresh register.
The binary merge design compares
both pair entries with the triple middle. Those flags select the operands
for two insertion comparisons. The triple-only prefix also permits the
pair comparison and its writes to share work with the merge.

| Search | Status | Cases in final formula | CPU seconds | Conflicts |
| --- | --- | ---: | ---: | ---: |
| `binary16_c4` | UNKNOWN | 10 | 233.050 | 1,935,119 |
| `binary16_shapes` | UNKNOWN | 10 | 181.884 | 1,200,550 |
| `binary17_c4` | UNKNOWN | 10 | 300.077 | 2,433,431 |
| `merge16_c4` | UNKNOWN | 10 | 300.037 | 3,812,169 |
| `rank_dag10` | UNKNOWN | 10 | 300.093 | 2,947,305 |
| `rank_dag10_batch` | UNKNOWN | 10 | 194.381 | 2,638,737 |
| `rank_dag10_fixed` | UNSAT | 10 | 6.749 | 177,741 |
| `rank_dag10_units` | UNKNOWN | 10 | 300.328 | 6,675,433 |
| `triple20_c5` | UNKNOWN | 20 | 180.106 | 1,056,598 |

`UNSAT` is a completed solver result for the stated finite encoding.
`UNKNOWN` means a CPU limit or interruption. It is not a negative result.
`SAT_DAG` is an abstract selection plan, not a verified executable program.
Every executable candidate must pass the shared strict judge.

The fixed raw order `(a,c), (a,d), (a,e), (b,e), (b,d), (b,c)`
has no plan with ten or fewer shared selection gates. This completed
solver result uses all ten strict interleavings. Thus six comparisons
plus at most ten selection gates cannot give a 16-instruction merge
for this order, even when copies are free.

The rank-order batch records 1 completed UNSAT order, 0 abstract plans, and 719 unknown orders.
It queries all 720 orders directly. It does not infer untested results
from value reversal. Each completed order and each bounded attempt is
listed in `round5/rank_dag10_batch.json`.

The incremental rank-order run was interrupted. Its CPU entry is
the last saved checkpoint, not a final resource measurement.

The separate fixed-order formulas record 28 distinct completed UNSAT orders, including the earlier fixed-order result.
Within the 120 best independent-chain orders, 28 are closed and 92 remain unknown.
The formulas keep every earlier value for free. They check all ten
strict interleavings with ten selection gates. A completed negative
therefore excludes a 16-instruction six-comparison merge for that
order, even before physical copy costs. The complete order ledger is
`round5/rank_dag10_units.json`.

The comparison-position batch completed 97 UNSAT tests out of 455. The other 358 tests are unknown.
Its first comparison is at instruction zero. The other three
comparisons can occupy all 455 possible position triples. Every
write opcode and operand remains free. The per-position ledger is
`round5/binary16_shapes.json`.

The combined binary16 search was interrupted to prioritize the
comparison-position batch. Its CPU entry is the last completed
progress record, not a final resource measurement. It remains unknown.

# Round 5: verification and resources

The independent C++ forward search matched all 3,600 cost entries through
cost 4: 720 orders times five outputs. An absent column costs at least
5. These bounded entries also give a global lower bound of 12
conditional moves for the independent-chain family. The scalar
audit replayed 2,640 finite output-chain witnesses on all 76 weak orders.
The encoding controls checked a constructed merge, incorrect outputs,
288 random transition-value pairs, a 12-gate shared plan, and the four
binary comparison predicates. They also checked condition normalization
on strict raw comparisons and fresh-register guards on 50 weak orders.
See [round5/check_encoding.log](round5/check_encoding.log)
and [round5/forward_check.log](round5/forward_check.log).

The final ledger audit checked coverage counts and the current hashes
of both strict-PASS files. Its result is in
[round5/audit.json](round5/audit.json).

Every new program with a shared strict PASS is listed below. Controls
validate the search. They do not establish a shorter sorter.

- [round5/control34.s](round5/control34.s): `k=34`, out.
- [round5/control34_mem.s](round5/control34_mem.s): `L=44`, memory.

The constructed control received these judge results:

```text
PASS /path/to/repo/agents/team/codex-fleet/w1/round5/control34.s [relaxed+strict] n=5 L=34 R=8 iset=I1 model=out
PASS /path/to/repo/agents/team/codex-fleet/w1/round5/control34_mem.s [relaxed+strict] n=5 L=44 R=13 iset=I1 model=mem
```

The largest measured resident memory was 221,812 KiB. SAT search jobs used
a 2,800 MiB address-space limit. All CPU jobs ran sequentially under
`nice -n 19` on CPU 68. The commands and source hashes are in
[round5/jobs.json](round5/jobs.json). The complete result ledger is
[round5/summary.json](round5/summary.json).

# Round 5: limits and conclusion

The completed chain result excludes shared intermediate values. The
shared selection model omits physical copy costs. The register model
uses the stated prefix, comparison count, and register count. Fixed
binary predicates exclude other comparison orders and merge decisions.
Timed searches remain unknown. No general lower bound is claimed.

The smallest verified core from this worker has 32 instructions.
Its memory form has 42 instructions.

Run `nice -n 19 python3 round5/run_jobs.py finite` for the completed
finite searches and controls. The `binary`, `triple`, `rankfixed`,
`rankbatch`, `rankunits`, and `shapes` phases are separate search entry points. The unrestricted
merge and all-order shared-value searches were run directly. Their
exact arguments are retained in their result JSON files.
