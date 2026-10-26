

# Round 9: median paths with free names and added positions

No core with `k <= 31` was found. The model assumptions are **G1-G4**.
The local rewrite scope is **A11**. The completed arbitrary-name tests
remove **A2** within their stated families. The larger two-added-position
tests retain two fresh names and therefore use **A2**. The smaller
tail-three tests also cover arbitrary names.
No result contradicts an assumption.

The nine-comparison set contains all 26 bases from `d7-structure/fam32`.
The eight-comparison set contains all 144 bases in the round 4 input ledger.
The instruction census also checked the earlier repair collection: the
15 w6 repairs used in rounds 7-8 have nine comparisons. The w9 repair has
eight comparisons. This round uses actual comparison counts to select bases.
It does not repeat the earlier fixed-position searches on those repairs.

The completed negative families cover all 26 nine-comparison bases for
median-only edits and six-write tail edits. They also cover all 144
eight-comparison bases for the three-write tail scheduler. These families
permit arbitrary register names. The larger tested families remain unknown.

An exclusive instruction affects only output 2, the median. The tail tests
also edit the specified last writes in its dependency cone. Each editable
instruction can select any I1 opcode and permitted operands, or be omitted.
The median can use any register at any boundary. The other four outputs
retain their registers and original core boundaries.

For m editable instructions, the arbitrary-name tests allow 2m fresh names.
Each instruction has two operands. This covers every name that can occur
in the fixed-position family. Fresh names follow their first occurrence.
An untouched scratch register cannot be a correct strict median output.

For a scheduler with m editable original instructions, the fixed core
contains 32-m instructions. A k=31 budget leaves at most m-1 active free
instructions, including additions. They can mention at most 2(m-1) fresh
names. The first tail-three tests allow 2m fresh names. The final retry
uses the tighter 2(m-1) bound. Both bounds therefore cover
arbitrary names in their stated scheduled family.

The scheduler adds two optional positions at solver-selected gaps, from the
first editable original instruction through the end. Both can use the same
gap. The solver can also change or omit each selected original instruction.
The total count of retained instructions is at most 31. Fixed output events
can occur before, between, or after additions in their original core gap.
See [round9/METHODS.md](round9/METHODS.md) for the encoding and limits.

| Run | Tests | UNSAT | Unknown | Scalar candidates | CPU seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
| `c8_control_batch` | 8 | 0 | 0 | 8 | 2.996 |
| `c8_schedule3_control_batch` | 9 | 0 | 0 | 9 | 2.616 |
| `c8_schedule3_pilot_batch` | 8 | 8 | 0 | 0 | 8.995 |
| `c8_schedule3_rest_batch` | 136 | 135 | 1 | 0 | 255.567 |
| `c8_schedule3_retry_batch` | 1 | 1 | 0 | 0 | 18.122 |
| `c8_schedule6_batch` | 144 | 0 | 144 | 0 | 708.243 |
| `c8_schedule_allcases_batch` | 8 | 0 | 8 | 0 | 380.978 |
| `c9_cone_batch` | 26 | 0 | 26 | 0 | 231.967 |
| `c9_control_batch` | 26 | 0 | 0 | 26 | 2.070 |
| `c9_exclusive_batch` | 26 | 26 | 0 | 0 | 1.956 |
| `c9_tail6_batch` | 26 | 24 | 2 | 0 | 120.622 |
| `c9_tail6_retry_batch` | 2 | 2 | 0 | 0 | 80.877 |

Each UNSAT entry is a completed negative for its stated finite family.
A limit or failed process is unknown. A family with unresolved entries is
not exhausted. The result ledgers retain the exact indices and arguments.

The solver uses scratch value 5 and initial equality flags. These are
permitted initial values. Every strict program must work for them.
Thus UNSAT excludes a strict program within the stated family. A scalar
candidate still requires the shared strict judge.

The independent scalar audit checked **21,420 register values**,
**32 scheduling traces**, and **6,561 fresh-name traces**.
It also checked **2 instruction-budget cases**.
These checks validate the implementation. They are not a formal certificate.
The positive controls keep the original 32-instruction cores. For scheduled
controls, both added positions are omitted. Every control below passed the
shared strict judge. Its memory form has length 42. Exact judge output,
commands, and hashes are in [round9/pass_ledger.json](round9/pass_ledger.json).

Combined coverage merges retries of the same finite family.

| Family | Expected bases | UNSAT | Unknown or unattempted |
| --- | ---: | ---: | ---: |
| `c8_schedule_tail_3_arbitrary_names` | 144 | 144 | 0 |
| `c8_schedule_tail_6_fresh2` | 144 | 0 | 144 |
| `c9_cone_cone_arbitrary_names` | 26 | 0 | 26 |
| `c9_exclusive_exclusive_arbitrary_names` | 26 | 26 | 0 |
| `c9_tail_tail_6_arbitrary_names` | 26 | 26 | 0 |

The smaller scheduler edits three original positions in 140 bases.
It edits four positions in four bases because an earlier median-only
instruction is also editable. Its final unresolved base, c8_b08, returned
UNSAT after 18.122 CPU seconds. This closes that 144-base finite family.

The first 49 larger scheduling probes had 10-second CPU budgets.
The remaining 95 had 2-second CPU budgets after the first probes all
reached limits. Their saved arguments record the effective budgets.
Longer all-order retries are separate table entries.

Example strict judge output:

```text
PASS /path/to/repo/agents/team/codex-fleet/w1/round9/c9_control_00.s [relaxed+strict] n=5 L=32 R=8 iset=I1 model=out
PASS /path/to/repo/agents/team/codex-fleet/w1/round9/c9_control_00_mem.s [relaxed+strict] n=5 L=42 R=13 iset=I1 model=mem
PASS /path/to/repo/agents/team/codex-fleet/w1/round9/c8_control_00.s [relaxed+strict] n=5 L=32 R=7 iset=I1 model=out
PASS /path/to/repo/agents/team/codex-fleet/w1/round9/c8_control_00_mem.s [relaxed+strict] n=5 L=42 R=12 iset=I1 model=mem
```

Every new strict PASS file is listed below. These controls are not shorter sorters.

- [round9/c8_control_00.s](round9/c8_control_00.s): `out`, length 32.
- [round9/c8_control_00_mem.s](round9/c8_control_00_mem.s): `mem`, length 42.
- [round9/c8_control_01.s](round9/c8_control_01.s): `out`, length 32.
- [round9/c8_control_01_mem.s](round9/c8_control_01_mem.s): `mem`, length 42.
- [round9/c8_control_02.s](round9/c8_control_02.s): `out`, length 32.
- [round9/c8_control_02_mem.s](round9/c8_control_02_mem.s): `mem`, length 42.
- [round9/c8_control_03.s](round9/c8_control_03.s): `out`, length 32.
- [round9/c8_control_03_mem.s](round9/c8_control_03_mem.s): `mem`, length 42.
- [round9/c8_control_04.s](round9/c8_control_04.s): `out`, length 32.
- [round9/c8_control_04_mem.s](round9/c8_control_04_mem.s): `mem`, length 42.
- [round9/c8_control_05.s](round9/c8_control_05.s): `out`, length 32.
- [round9/c8_control_05_mem.s](round9/c8_control_05_mem.s): `mem`, length 42.
- [round9/c8_control_06.s](round9/c8_control_06.s): `out`, length 32.
- [round9/c8_control_06_mem.s](round9/c8_control_06_mem.s): `mem`, length 42.
- [round9/c8_control_07.s](round9/c8_control_07.s): `out`, length 32.
- [round9/c8_control_07_mem.s](round9/c8_control_07_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_00.s](round9/c8_schedule3_control_00.s): `out`, length 32.
- [round9/c8_schedule3_control_00_mem.s](round9/c8_schedule3_control_00_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_01.s](round9/c8_schedule3_control_01.s): `out`, length 32.
- [round9/c8_schedule3_control_01_mem.s](round9/c8_schedule3_control_01_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_02.s](round9/c8_schedule3_control_02.s): `out`, length 32.
- [round9/c8_schedule3_control_02_mem.s](round9/c8_schedule3_control_02_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_03.s](round9/c8_schedule3_control_03.s): `out`, length 32.
- [round9/c8_schedule3_control_03_mem.s](round9/c8_schedule3_control_03_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_04.s](round9/c8_schedule3_control_04.s): `out`, length 32.
- [round9/c8_schedule3_control_04_mem.s](round9/c8_schedule3_control_04_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_05.s](round9/c8_schedule3_control_05.s): `out`, length 32.
- [round9/c8_schedule3_control_05_mem.s](round9/c8_schedule3_control_05_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_06.s](round9/c8_schedule3_control_06.s): `out`, length 32.
- [round9/c8_schedule3_control_06_mem.s](round9/c8_schedule3_control_06_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_07.s](round9/c8_schedule3_control_07.s): `out`, length 32.
- [round9/c8_schedule3_control_07_mem.s](round9/c8_schedule3_control_07_mem.s): `mem`, length 42.
- [round9/c8_schedule3_control_08.s](round9/c8_schedule3_control_08.s): `out`, length 32.
- [round9/c8_schedule3_control_08_mem.s](round9/c8_schedule3_control_08_mem.s): `mem`, length 42.
- [round9/c9_control_00.s](round9/c9_control_00.s): `out`, length 32.
- [round9/c9_control_00_mem.s](round9/c9_control_00_mem.s): `mem`, length 42.
- [round9/c9_control_01.s](round9/c9_control_01.s): `out`, length 32.
- [round9/c9_control_01_mem.s](round9/c9_control_01_mem.s): `mem`, length 42.
- [round9/c9_control_02.s](round9/c9_control_02.s): `out`, length 32.
- [round9/c9_control_02_mem.s](round9/c9_control_02_mem.s): `mem`, length 42.
- [round9/c9_control_03.s](round9/c9_control_03.s): `out`, length 32.
- [round9/c9_control_03_mem.s](round9/c9_control_03_mem.s): `mem`, length 42.
- [round9/c9_control_04.s](round9/c9_control_04.s): `out`, length 32.
- [round9/c9_control_04_mem.s](round9/c9_control_04_mem.s): `mem`, length 42.
- [round9/c9_control_05.s](round9/c9_control_05.s): `out`, length 32.
- [round9/c9_control_05_mem.s](round9/c9_control_05_mem.s): `mem`, length 42.
- [round9/c9_control_06.s](round9/c9_control_06.s): `out`, length 32.
- [round9/c9_control_06_mem.s](round9/c9_control_06_mem.s): `mem`, length 42.
- [round9/c9_control_07.s](round9/c9_control_07.s): `out`, length 32.
- [round9/c9_control_07_mem.s](round9/c9_control_07_mem.s): `mem`, length 42.
- [round9/c9_control_08.s](round9/c9_control_08.s): `out`, length 32.
- [round9/c9_control_08_mem.s](round9/c9_control_08_mem.s): `mem`, length 42.
- [round9/c9_control_09.s](round9/c9_control_09.s): `out`, length 32.
- [round9/c9_control_09_mem.s](round9/c9_control_09_mem.s): `mem`, length 42.
- [round9/c9_control_10.s](round9/c9_control_10.s): `out`, length 32.
- [round9/c9_control_10_mem.s](round9/c9_control_10_mem.s): `mem`, length 42.
- [round9/c9_control_11.s](round9/c9_control_11.s): `out`, length 32.
- [round9/c9_control_11_mem.s](round9/c9_control_11_mem.s): `mem`, length 42.
- [round9/c9_control_12.s](round9/c9_control_12.s): `out`, length 32.
- [round9/c9_control_12_mem.s](round9/c9_control_12_mem.s): `mem`, length 42.
- [round9/c9_control_13.s](round9/c9_control_13.s): `out`, length 32.
- [round9/c9_control_13_mem.s](round9/c9_control_13_mem.s): `mem`, length 42.
- [round9/c9_control_14.s](round9/c9_control_14.s): `out`, length 32.
- [round9/c9_control_14_mem.s](round9/c9_control_14_mem.s): `mem`, length 42.
- [round9/c9_control_15.s](round9/c9_control_15.s): `out`, length 32.
- [round9/c9_control_15_mem.s](round9/c9_control_15_mem.s): `mem`, length 42.
- [round9/c9_control_16.s](round9/c9_control_16.s): `out`, length 32.
- [round9/c9_control_16_mem.s](round9/c9_control_16_mem.s): `mem`, length 42.
- [round9/c9_control_17.s](round9/c9_control_17.s): `out`, length 32.
- [round9/c9_control_17_mem.s](round9/c9_control_17_mem.s): `mem`, length 42.
- [round9/c9_control_18.s](round9/c9_control_18.s): `out`, length 32.
- [round9/c9_control_18_mem.s](round9/c9_control_18_mem.s): `mem`, length 42.
- [round9/c9_control_19.s](round9/c9_control_19.s): `out`, length 32.
- [round9/c9_control_19_mem.s](round9/c9_control_19_mem.s): `mem`, length 42.
- [round9/c9_control_20.s](round9/c9_control_20.s): `out`, length 32.
- [round9/c9_control_20_mem.s](round9/c9_control_20_mem.s): `mem`, length 42.
- [round9/c9_control_21.s](round9/c9_control_21.s): `out`, length 32.
- [round9/c9_control_21_mem.s](round9/c9_control_21_mem.s): `mem`, length 42.
- [round9/c9_control_22.s](round9/c9_control_22.s): `out`, length 32.
- [round9/c9_control_22_mem.s](round9/c9_control_22_mem.s): `mem`, length 42.
- [round9/c9_control_23.s](round9/c9_control_23.s): `out`, length 32.
- [round9/c9_control_23_mem.s](round9/c9_control_23_mem.s): `mem`, length 42.
- [round9/c9_control_24.s](round9/c9_control_24.s): `out`, length 32.
- [round9/c9_control_24_mem.s](round9/c9_control_24_mem.s): `mem`, length 42.
- [round9/c9_control_25.s](round9/c9_control_25.s): `out`, length 32.
- [round9/c9_control_25_mem.s](round9/c9_control_25_mem.s): `mem`, length 42.

All CPU jobs ran sequentially on one CPU with `nice -n 19`.
The largest recorded resident memory was **813,284 KiB**.
Each search had a 2,800 MiB address-space limit. All writes stayed in w1.
Coverage, source hashes, and resource records are indexed in
[round9/summary.json](round9/summary.json).

These finite local tests do not exclude arbitrary k=31 programs.
No global lower bound or optimality proof is claimed.
The smallest strict-verified core remains k=32.

Reproduction: `nice -n 19 python3 round9/reproduce.py`.
This round ran the stages separately. The full driver was syntax-checked.
It was not rerun as one command.
