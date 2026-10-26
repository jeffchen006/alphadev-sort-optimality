# Result

No program with `k <= 31` was found.

The exhaustive search found that **five moves are necessary and sufficient**
for the nine-comparator copy-reuse family. Thus this family has minimum
`k = 9 cmp + 18 cmov + 5 mov = 32`, or 42 memory instructions.

The search permits min-side reuse, max-side reuse, arbitrary live destinations,
arbitrary live sources, both output orders, and all four I1 conditions.
It includes input registers and early `out` instructions.

This is a search result. It is not a lower bound for arbitrary programs in the
AlphaDev model. See [METHODS.md](METHODS.md) for the family and completeness
arguments.

# Exhaustive counts

The enumerator fixes the first input pair by input symmetry. It keeps all
subsequent comparator orders. It found 14,904 sorting term-pair sequences,
or 149,040 before fixing the first pair. Physical wire drawings that give the
same term-pair sequence are counted once.

| Minimum moves | Sequences with first pair fixed | All ten first pairs | Core instructions |
| --- | ---: | ---: | ---: |
| 5 | 1,710 | 17,100 | 32 |
| 6 | 7,296 | 72,960 | 33 |
| 7 | 5,154 | 51,540 | 34 |
| 8 | 744 | 7,440 | 35 |
| Total | 14,904 | 149,040 | |

The exact minimum for each sequence is in [minimum_moves.tsv](minimum_moves.tsv).
Its zero-based index selects a line of [networks.txt](networks.txt).
There are 1,962 distinct unordered comparator sets among the sequences with
the first pair fixed. Every completed sequence produces eighteen distinct
non-input min/max terms.

The forward enumeration has the following channel-state counts at depths
one through nine:

`1, 9, 57, 262, 867, 1934, 2282, 1002, 91`.

No sorting state occurs at depths zero through eight. The complete graph and
backward reachability counts are in [enumeration.log](enumeration.log).

# Searches and dead ends

- Budget four: no plan for any of the 14,904 sequences. The search generated
  7,707,624 register states. The largest single gate layer had 108 states.
  See [reuse_q4.log](reuse_q4.log).
- Budget five: 1,710 sequences reached five moves. The other 13,194 sequences
  needed more. The search generated 31,097,496 register states.
  See [reuse_q5.log](reuse_q5.log).
- Budget seven: minimum counts five, six and seven were found for 14,160
  sequences. The other 744 sequences needed more. The search generated
  392,163,888 register states. See [reuse_q7.log](reuse_q7.log).
- Budget nine on those 744 sequences: all had minimum eight. The search
  generated 31,213,800 register states.
  See [reuse_q9_unresolved.log](reuse_q9_unresolved.log).

The independent Python implementation regenerated exactly the same sequence
set. It also found no four-move plan on all 120 strict input orders. It
generated the same 7,707,624 register states. See
[crosscheck.log](crosscheck.log).

The C++ searches used eight threads under `nice -n 10`. Their measured wall
times were approximately 4.5, 5.5, 23.3 and 1.7 seconds. The independent Python
check used one process under `nice -n 10` and took 28.0 seconds. All writes
were confined to this worker folder.

# Programs checked by the judge

All eight files below received `PASS` from the shared judge with `--strict`.
The register files use `--model out`; the memory files use `--model mem`.
The corresponding `judge_q*_*.log` files retain the exact output.

| Minimum moves | Sequence index | Register program | Memory program |
| --- | ---: | --- | --- |
| 5 | 184 | [witness_q5_out.s](witness_q5_out.s), `k=32` | [witness_q5_mem.s](witness_q5_mem.s), `L=42` |
| 6 | 14 | [witness_q6_out.s](witness_q6_out.s), `k=33` | [witness_q6_mem.s](witness_q6_mem.s), `L=43` |
| 7 | 0 | [witness_q7_out.s](witness_q7_out.s), `k=34` | [witness_q7_mem.s](witness_q7_mem.s), `L=44` |
| 8 | 288 | [witness_q8_out.s](witness_q8_out.s), `k=35` | [witness_q8_mem.s](witness_q8_mem.s), `L=45` |

Best judge outputs:

```text
PASS witness_q5_out.s [relaxed+strict] n=5 L=32 R=10 iset=I1 model=out
PASS witness_q5_mem.s [relaxed+strict] n=5 L=42 R=15 iset=I1 model=mem
```

The independent parser and simulator also checked the four register files on
all 541 weak orders. See [witness_check.log](witness_check.log).

# Reproduction

Run `nice -n 10 python3 reproduce.py` in this folder. It uses at most eight
CPU threads. It rebuilds both C++ tools, runs the complete searches, runs the
independent check, emits the four examples, and checks all eight examples with
the strict judge. The source files are `enumerate.cpp`, `reuse.cpp`,
`crosscheck.py`, and `check_witnesses.py`.

The full reproduction run completed successfully. Its eight strict `PASS`
lines and final status are in [reproduction.log](reproduction.log).

# Round 2: purpose

Extend copy reuse to six, seven, and eight comparisons. Permit partial comparator
outputs, copies from any earlier value, and mixed conditional-move/copy counts.
No program with `k <= 31` was found.

# Round 2: method

Used the round 1 diagrams as dataflow templates. Removed one or two comparison
instructions. At each removed comparison, independently selected both outputs
from its operands and the current flags. Then permitted one or both outputs to
select from any earlier value. Old values stayed available until the allocation
search decided which copies to retain. A history-class size bound rejected
comparison sequences that could not distinguish all 120 input orders.
Six comparisons cannot distinguish 120 distinct input orders because `2^6=64`.

For each functional eight-comparison plan, searched min-side, max-side, and
arbitrary-register reuse. Searched all four I1 conditions and every order of
conditional moves in each comparison block. An independent implementation used
tuples of register values and threshold sets. See [round2/METHODS.md](round2/METHODS.md)
for the exact family, counting argument, copy normalization, and limits.

All round 2 CPU jobs ran with `nice -n 19`. At most two CPU jobs ran at once.
All programs were single-threaded. No round 1 search or excluded full `dagx`
comparison-structure search was repeated.

# Round 2: result

The completed semantic searches have these counts. A node is one visited partial
plan. A leaf has enough comparison histories to distinguish the input orders.
A functional plan also produces all five sorted value columns.

| Search | Comparisons | Nodes | Leaves | Functional plans | Recorded seconds |
| --- | ---: | ---: | ---: | ---: | ---: |
| Local partial outputs | 7 | 13,911,168 | 0 | 0 | 1.066 |
| Local partial outputs | 8 | 3,145,338 | 198 | 198 | 0.681 |
| One unrestricted output per removed stage | 8 | 82,582,920 | 264 | 198 | 24.221 |
| Both outputs unrestricted per removed stage | 8 | 986,691,720 | 264 | 198 | 288.070 |
| One unrestricted output per removed stage | 7 | 4,586,741,148 | 0 | 0 | 1981.430 |

The generalized seven-comparison run completed templates `[0,13900)` before
it was interrupted at its recorded boundary. Two suffix jobs completed
`[13900,14402)` and `[14402,14904)`. The combined log records their exact
coverage. Its node count includes only the completed ranges. Its recorded
seconds are the sum of segment wall times; the suffix jobs overlapped.
Unreported partial work at interruption is excluded from those counts.

The three eight-comparison searches found the same 198 plans. Independent scalar
simulation checked every plan on all 541 weak orders. The broader selections
produced exactly the same strict-order and weak-order value columns as the local
plans. The plans form 33 exact comparison-structure classes. Their complete
comparison and unordered target-block signatures also agree within each class,
after input renaming and value reversal. None matches the 18 immutable w6
comparison structures checked in `prepare.py`.

Every plan contains eighteen distinct non-input value columns. The exhaustive
fixed-column allocation search found these minimum costs:

| Copies | Conditional moves | Comparisons | Core k | Plans |
| ---: | ---: | ---: | ---: | ---: |
| 7 | 18 | 8 | 33 | 18 |
| 8 | 18 | 8 | 34 | 108 |
| 9 | 18 | 8 | 35 | 72 |

Thus this eight-comparison family has no four-copy or five-copy plan. The C++
and independent Python allocation searches both retained **27,048** comparison
boundary states at the five-copy bound. Both rejected all 198 plans. The C++
search over all 541 weak orders and its distinct-order relaxation gave the same
negative result. Earlier unpruned runs are retained. The final cost bound reserves
one instruction for each remaining distinct target column.

A further exhaustive extension added one new full selected value to any
comparison block. It checked **46,724** distinct block/value cases across all
33 representatives. It generated **2,593,446** allocation boundary states.
No case had `k <= 31`. This tests **8 cmp + 19 conditional moves + at most 4 mov**.
The run took 24.369 seconds. Sources: `round2/extra.cpp` and `round2/route.cpp`.
Log: [round2/extra_fast.log](round2/extra_fast.log). An initial unpruned attempt
was stopped before it completed one class; its empty log is retained.

The smallest emitted example uses **8 cmp + 18 conditional moves + 7 mov**.
It passed both strict judges:

```text
PASS round2/witness_out.s [relaxed+strict] n=5 L=33 R=12 iset=I1 model=out
PASS round2/witness_mem.s [relaxed+strict] n=5 L=43 R=17 iset=I1 model=mem
```

Every new strict PASS file is listed here:

- [round2/witness_out.s](round2/witness_out.s): `k=33`.
- [round2/witness_mem.s](round2/witness_mem.s): `L=43`.

The independent scalar audit also checked all 541 weak orders, all four initial
flag states, and initialization of every scratch read. Its log is
[round2/audit33.log](round2/audit33.log). The earlier 34-instruction witness was
replaced with this smaller witness. Its earlier judge log remains historical.

Reproduce round 2 with `nice -n 19 python3 round2/reproduce.py` from this folder.
The script runs CPU jobs sequentially. The complete semantic search logs are
`round2/omit7.log`, `round2/omit8.log`, `round2/extend1.log`,
`round2/extend2.log`, and `round2/extend7.log`. The final allocation logs are
`round2/route_fast23.log` and `round2/route_fast27.log`. Independent checks are
`round2/crossroute.log`, `round2/exact_check.log`,
`round2/compare_extensions.log`, and `round2/check_class_targets.log`.

# Round 2: limits

These results concern the defined dataflow and fixed-column families. They are
search results, not a general lower bound or a formal certificate. The searches
do not cover every program with seven or eight comparisons. In particular, the
seven-comparison search permits one unrestricted output at each of its two
removed stages. It does not exhaust the case where both outputs at both removed
stages are unrestricted. Its semantic selections use greater-than flags and
their complement; it does not vary all I1 conditions when copied identities
compare equal. The additional-value search permits one extra full
selected value. It does not exhaust two extra values, unknown intermediate
scratch values, new comparison operands, or arbitrary intermediate columns.
The verified 43-instruction memory program does not beat AlphaDev's 42.

# Round 3: purpose

Analyse the 143 new w6 eight-comparison programs. Test removal of a copy with
global register reuse and changes to the remaining conditional moves.
**No program with core `k <= 31` was found.**

The bases are `../w6/round2/verified/*.s`, not the 18 older representatives in
`../w6/verified`. No excluded network enumeration, fixed-operand dagx run, or
Hamming-three search was repeated.

# Round 3: terms and method

A value column records one register value for each of the 541 weak input orders.
A case mask identifies the input orders on which a value is required. The
search can share a register between values that agree on their required cases.
It can also retain partial copies with unknown entries outside those cases.

The search permits any source and destination register, mov or any I1
conditional-move condition at each retained write position, and fresh registers.
Its first modes preserve required comparison conditions rather than exact
operand values. The broader modes free every comparison operand and condition
outcome. They permit earlier outputs and later reconstruction of intermediate
values. They retain original event order and some base masked value targets.
See [round3/METHODS.md](round3/METHODS.md) for each search family and its limits.

# Round 3: common structure

All 143 bases have eight comparisons and 24 writes. Their mov counts range
from zero to five. The collection contains **397 mov copies** and **232
conditional copies**. For each of those conditional copies, the old destination
is never required on a case where the condition is false. These 629 positions
are the direct copy-removal targets. No base write is wholly unused.

Backward analysis found **2,131 writes** whose results are required on only
some input cases. The largest number of required value identifiers at one
boundary is six for 10 bases, seven for 99 bases, and eight for 34 bases.

Every base compares a value that cannot be expressed using only min and max
in **both comparison 7 and comparison 8**. In 115 bases these are the only such
comparisons. The other bases also have such a value in comparison 3 (four
bases), comparison 4 (15 bases), or comparison 5 (nine bases).

Before comparison 5, 102 bases hold a complete sorted pair and sorted triple
in their current registers. The other 41 bases do not. The prefix costs are
15 instructions for 54 bases, 16 for 87 bases, and 17 for two bases. A separate
test found no base that holds a complete sorted quartet plus its remaining
input before comparison 6. Thus that alternative description was rejected.

On 120 distinct input orders, the numbers of comparison histories are:

| After comparisons 1 through 8 | Bases |
| --- | ---: |
| 2, 4, 6, 12, 24, 48, 84, 120 | 26 |
| 2, 4, 8, 12, 24, 48, 84, 120 | 76 |
| 2, 4, 8, 16, 24, 48, 84, 120 | 41 |

Input renaming, value-order reversal, and comparison reversal give **72 exact
comparison-outcome classes** on distinct inputs. They give **141 classes** on
all weak input orders. Ties therefore distinguish many bases that agree on
distinct inputs. Full data is in [round3/analysis.json](round3/analysis.json)
and [round3/predicate_classes.json](round3/predicate_classes.json).

# Round 3: search results

Every row below completed with NONE for all listed tests at `k <= 31`.
No beam truncation, CPU limit, column limit, or state limit occurred in these
runs. A retained state is one register-column multiset and flag state at an
event boundary. The early-output modes also record completed outputs.

| Search | Tests | Retained boundary states | CPU seconds |
| --- | ---: | ---: | ---: |
| Required values retained | 143 | 327,948 | 2.406 |
| One internal write omitted | 2,717 | 2,569,957 | 11.663 |
| Values required only at creation | 143 | 1,069,476 | 5.805 |
| Creation masks plus one write omitted | 2,717 | 11,374,789 | 50.279 |
| One input value requirement waived | 715 | 2,081,368 | 15.707 |
| Free comparisons and early outputs | 143 | 5,860,811 | 43.273 |
| Each copy omitted; free comparisons and early outputs | 629 | 3,880,239 | 17.259 |

Each base has 19 internal write positions, which gives 2,717 single-write
omission tests. The final row omits each of the **629 actual copies** in turn.
It frees all comparison operands, permits earlier outputs, and changes the
sources, destinations, and conditions of all remaining writes. It retains the
other base creation masks. It found no 31-instruction candidate.

The independent Python implementation checked all 143 bases. It omitted the
C++ future-full-column cost bound and retained **564,751**
boundary states. It also found no 31-instruction candidate. Its recorded CPU
time was 131.926 seconds. See
[round3/crosscheck.log](round3/crosscheck.log).

All CPU jobs ran one at a time with `nice -n 19` on CPU 68. The largest recorded
search resident memory was **70,996 KiB**,
below the 3 GB job limit. Logs, input hashes, counters, and resource records are
indexed in [round3/summary.json](round3/summary.json).

# Round 3: verification

The router regenerated a **32-instruction control for every base**. All 143
controls passed the shared strict out-model judge. An added unused copy gave
a 33-instruction positive control. The broad copy-deletion search removed it
and emitted a strict-PASS 32-instruction control. A delayed-output control
also checked the earlier-output path. Its memory form passed at length 42.

The memory judge reports:

```text
PASS /path/to/repo/agents/team/codex-fleet/w1/round3/control_mem42.s [relaxed+strict] n=5 L=42 R=11 iset=I1 model=mem
```

Every new strict PASS file is listed below. The full ledger includes SHA-256
hashes and exact judge log paths: [round3/pass_ledger.json](round3/pass_ledger.json).
The 33-instruction padded control tests the search; it is not an improvement.

- [round3/control32_d-1_c8_10040eff416c0867.s](round3/control32_d-1_c8_10040eff416c0867.s): `k=32`, out.
- [round3/control32_d-1_c8_100fdc9beb7f87fb.s](round3/control32_d-1_c8_100fdc9beb7f87fb.s): `k=32`, out.
- [round3/control32_d-1_c8_1125a776aad66f0f.s](round3/control32_d-1_c8_1125a776aad66f0f.s): `k=32`, out.
- [round3/control32_d-1_c8_1133ec48c6cddf1b.s](round3/control32_d-1_c8_1133ec48c6cddf1b.s): `k=32`, out.
- [round3/control32_d-1_c8_11c9d4867493ab47.s](round3/control32_d-1_c8_11c9d4867493ab47.s): `k=32`, out.
- [round3/control32_d-1_c8_11ff7541f319ba6f.s](round3/control32_d-1_c8_11ff7541f319ba6f.s): `k=32`, out.
- [round3/control32_d-1_c8_1225fd780bdd0fe7.s](round3/control32_d-1_c8_1225fd780bdd0fe7.s): `k=32`, out.
- [round3/control32_d-1_c8_12651d8baa33ba0f.s](round3/control32_d-1_c8_12651d8baa33ba0f.s): `k=32`, out.
- [round3/control32_d-1_c8_12b75491c4d308a3.s](round3/control32_d-1_c8_12b75491c4d308a3.s): `k=32`, out.
- [round3/control32_d-1_c8_1338d3424477e129.s](round3/control32_d-1_c8_1338d3424477e129.s): `k=32`, out.
- [round3/control32_d-1_c8_141a02776a21d45.s](round3/control32_d-1_c8_141a02776a21d45.s): `k=32`, out.
- [round3/control32_d-1_c8_153074ef2f383393.s](round3/control32_d-1_c8_153074ef2f383393.s): `k=32`, out.
- [round3/control32_d-1_c8_156fdd193572fb27.s](round3/control32_d-1_c8_156fdd193572fb27.s): `k=32`, out.
- [round3/control32_d-1_c8_15a18d5fe8f0f427.s](round3/control32_d-1_c8_15a18d5fe8f0f427.s): `k=32`, out.
- [round3/control32_d-1_c8_15bdbe5ff6cbe16f.s](round3/control32_d-1_c8_15bdbe5ff6cbe16f.s): `k=32`, out.
- [round3/control32_d-1_c8_161f27bdd6e9955b.s](round3/control32_d-1_c8_161f27bdd6e9955b.s): `k=32`, out.
- [round3/control32_d-1_c8_164a24929b8970bb.s](round3/control32_d-1_c8_164a24929b8970bb.s): `k=32`, out.
- [round3/control32_d-1_c8_166731603245e2eb.s](round3/control32_d-1_c8_166731603245e2eb.s): `k=32`, out.
- [round3/control32_d-1_c8_17907dae653ca8f.s](round3/control32_d-1_c8_17907dae653ca8f.s): `k=32`, out.
- [round3/control32_d-1_c8_185d571c2e0f14f.s](round3/control32_d-1_c8_185d571c2e0f14f.s): `k=32`, out.
- [round3/control32_d-1_c8_1a082026b9b8a97.s](round3/control32_d-1_c8_1a082026b9b8a97.s): `k=32`, out.
- [round3/control32_d-1_c8_1a613ac2485250c7.s](round3/control32_d-1_c8_1a613ac2485250c7.s): `k=32`, out.
- [round3/control32_d-1_c8_1a63d93b1f04a2cb.s](round3/control32_d-1_c8_1a63d93b1f04a2cb.s): `k=32`, out.
- [round3/control32_d-1_c8_1ac755463afdc2ab.s](round3/control32_d-1_c8_1ac755463afdc2ab.s): `k=32`, out.
- [round3/control32_d-1_c8_1b0c08cec2e379c3.s](round3/control32_d-1_c8_1b0c08cec2e379c3.s): `k=32`, out.
- [round3/control32_d-1_c8_1be80efe56e14ebf.s](round3/control32_d-1_c8_1be80efe56e14ebf.s): `k=32`, out.
- [round3/control32_d-1_c8_1c180823effee2ab.s](round3/control32_d-1_c8_1c180823effee2ab.s): `k=32`, out.
- [round3/control32_d-1_c8_1cc416f5fb6c5bef.s](round3/control32_d-1_c8_1cc416f5fb6c5bef.s): `k=32`, out.
- [round3/control32_d-1_c8_1d4ad416e35cc60b.s](round3/control32_d-1_c8_1d4ad416e35cc60b.s): `k=32`, out.
- [round3/control32_d-1_c8_1e7b08432020f0b7.s](round3/control32_d-1_c8_1e7b08432020f0b7.s): `k=32`, out.
- [round3/control32_d-1_c8_1f71d7979bb91b7.s](round3/control32_d-1_c8_1f71d7979bb91b7.s): `k=32`, out.
- [round3/control32_d-1_c8_1fa5731a2358af7.s](round3/control32_d-1_c8_1fa5731a2358af7.s): `k=32`, out.
- [round3/control32_d-1_c8_203f14ede4be42f.s](round3/control32_d-1_c8_203f14ede4be42f.s): `k=32`, out.
- [round3/control32_d-1_c8_215cbe6f0d1c7837.s](round3/control32_d-1_c8_215cbe6f0d1c7837.s): `k=32`, out.
- [round3/control32_d-1_c8_21a6f16bedc5b8bf.s](round3/control32_d-1_c8_21a6f16bedc5b8bf.s): `k=32`, out.
- [round3/control32_d-1_c8_21abacdf36bcd7b3.s](round3/control32_d-1_c8_21abacdf36bcd7b3.s): `k=32`, out.
- [round3/control32_d-1_c8_21f839ca06fe77d3.s](round3/control32_d-1_c8_21f839ca06fe77d3.s): `k=32`, out.
- [round3/control32_d-1_c8_220dcb420effb46b.s](round3/control32_d-1_c8_220dcb420effb46b.s): `k=32`, out.
- [round3/control32_d-1_c8_22389f7b99df6097.s](round3/control32_d-1_c8_22389f7b99df6097.s): `k=32`, out.
- [round3/control32_d-1_c8_224e45102f6e86b.s](round3/control32_d-1_c8_224e45102f6e86b.s): `k=32`, out.
- [round3/control32_d-1_c8_2289ab6219955a3b.s](round3/control32_d-1_c8_2289ab6219955a3b.s): `k=32`, out.
- [round3/control32_d-1_c8_22e8c2d0d1b113b.s](round3/control32_d-1_c8_22e8c2d0d1b113b.s): `k=32`, out.
- [round3/control32_d-1_c8_23831cd511228447.s](round3/control32_d-1_c8_23831cd511228447.s): `k=32`, out.
- [round3/control32_d-1_c8_24853a2a978e287f.s](round3/control32_d-1_c8_24853a2a978e287f.s): `k=32`, out.
- [round3/control32_d-1_c8_24abc8199dc03077.s](round3/control32_d-1_c8_24abc8199dc03077.s): `k=32`, out.
- [round3/control32_d-1_c8_24f787e7e88ef5ab.s](round3/control32_d-1_c8_24f787e7e88ef5ab.s): `k=32`, out.
- [round3/control32_d-1_c8_2596dc2f20910faf.s](round3/control32_d-1_c8_2596dc2f20910faf.s): `k=32`, out.
- [round3/control32_d-1_c8_2642972b24ea19b.s](round3/control32_d-1_c8_2642972b24ea19b.s): `k=32`, out.
- [round3/control32_d-1_c8_267a2e3d4909af4b.s](round3/control32_d-1_c8_267a2e3d4909af4b.s): `k=32`, out.
- [round3/control32_d-1_c8_2726f4afb2d799.s](round3/control32_d-1_c8_2726f4afb2d799.s): `k=32`, out.
- [round3/control32_d-1_c8_273efbe5788053db.s](round3/control32_d-1_c8_273efbe5788053db.s): `k=32`, out.
- [round3/control32_d-1_c8_2755e8d9e8382207.s](round3/control32_d-1_c8_2755e8d9e8382207.s): `k=32`, out.
- [round3/control32_d-1_c8_27f65daa1cee4f4b.s](round3/control32_d-1_c8_27f65daa1cee4f4b.s): `k=32`, out.
- [round3/control32_d-1_c8_281eb7be1ab4dfb.s](round3/control32_d-1_c8_281eb7be1ab4dfb.s): `k=32`, out.
- [round3/control32_d-1_c8_289340d6380f179f.s](round3/control32_d-1_c8_289340d6380f179f.s): `k=32`, out.
- [round3/control32_d-1_c8_2896d97bea6f9f9f.s](round3/control32_d-1_c8_2896d97bea6f9f9f.s): `k=32`, out.
- [round3/control32_d-1_c8_290ba1ab50398fa7.s](round3/control32_d-1_c8_290ba1ab50398fa7.s): `k=32`, out.
- [round3/control32_d-1_c8_2a67840a0b9e7f13.s](round3/control32_d-1_c8_2a67840a0b9e7f13.s): `k=32`, out.
- [round3/control32_d-1_c8_2ab6c13ccb245a63.s](round3/control32_d-1_c8_2ab6c13ccb245a63.s): `k=32`, out.
- [round3/control32_d-1_c8_2e9b0f58dbb178a7.s](round3/control32_d-1_c8_2e9b0f58dbb178a7.s): `k=32`, out.
- [round3/control32_d-1_c8_2fc2edb8474e5733.s](round3/control32_d-1_c8_2fc2edb8474e5733.s): `k=32`, out.
- [round3/control32_d-1_c8_308486b4944cbdf.s](round3/control32_d-1_c8_308486b4944cbdf.s): `k=32`, out.
- [round3/control32_d-1_c8_30f500aaf2d3b42b.s](round3/control32_d-1_c8_30f500aaf2d3b42b.s): `k=32`, out.
- [round3/control32_d-1_c8_3169712e775f63e7.s](round3/control32_d-1_c8_3169712e775f63e7.s): `k=32`, out.
- [round3/control32_d-1_c8_336a411e8b85279.s](round3/control32_d-1_c8_336a411e8b85279.s): `k=32`, out.
- [round3/control32_d-1_c8_33e730edcd75dbbf.s](round3/control32_d-1_c8_33e730edcd75dbbf.s): `k=32`, out.
- [round3/control32_d-1_c8_33fd8cbe2fbbf34f.s](round3/control32_d-1_c8_33fd8cbe2fbbf34f.s): `k=32`, out.
- [round3/control32_d-1_c8_34bda9f2efbb141b.s](round3/control32_d-1_c8_34bda9f2efbb141b.s): `k=32`, out.
- [round3/control32_d-1_c8_35006f3bfb8deb1b.s](round3/control32_d-1_c8_35006f3bfb8deb1b.s): `k=32`, out.
- [round3/control32_d-1_c8_3524001ad0523527.s](round3/control32_d-1_c8_3524001ad0523527.s): `k=32`, out.
- [round3/control32_d-1_c8_3631163abf06d7af.s](round3/control32_d-1_c8_3631163abf06d7af.s): `k=32`, out.
- [round3/control32_d-1_c8_36b2b7961244aaf3.s](round3/control32_d-1_c8_36b2b7961244aaf3.s): `k=32`, out.
- [round3/control32_d-1_c8_36c3eb8e6d6769f.s](round3/control32_d-1_c8_36c3eb8e6d6769f.s): `k=32`, out.
- [round3/control32_d-1_c8_36c68fd07f08ff.s](round3/control32_d-1_c8_36c68fd07f08ff.s): `k=32`, out.
- [round3/control32_d-1_c8_36e5e6298381a683.s](round3/control32_d-1_c8_36e5e6298381a683.s): `k=32`, out.
- [round3/control32_d-1_c8_397c742a631c1cdb.s](round3/control32_d-1_c8_397c742a631c1cdb.s): `k=32`, out.
- [round3/control32_d-1_c8_399842c2f1576827.s](round3/control32_d-1_c8_399842c2f1576827.s): `k=32`, out.
- [round3/control32_d-1_c8_39a6ceb5b893673.s](round3/control32_d-1_c8_39a6ceb5b893673.s): `k=32`, out.
- [round3/control32_d-1_c8_39ca71836246603.s](round3/control32_d-1_c8_39ca71836246603.s): `k=32`, out.
- [round3/control32_d-1_c8_3af92b135d8fbddb.s](round3/control32_d-1_c8_3af92b135d8fbddb.s): `k=32`, out.
- [round3/control32_d-1_c8_3c8472e7eb77e88f.s](round3/control32_d-1_c8_3c8472e7eb77e88f.s): `k=32`, out.
- [round3/control32_d-1_c8_3dab8eea3595c0cf.s](round3/control32_d-1_c8_3dab8eea3595c0cf.s): `k=32`, out.
- [round3/control32_d-1_c8_3f3513bf9cd6caf3.s](round3/control32_d-1_c8_3f3513bf9cd6caf3.s): `k=32`, out.
- [round3/control32_d-1_c8_3f8371a2666ae5c7.s](round3/control32_d-1_c8_3f8371a2666ae5c7.s): `k=32`, out.
- [round3/control32_d-1_c8_3ff1974fb517ed2b.s](round3/control32_d-1_c8_3ff1974fb517ed2b.s): `k=32`, out.
- [round3/control32_d-1_c8_4033c0cef9939583.s](round3/control32_d-1_c8_4033c0cef9939583.s): `k=32`, out.
- [round3/control32_d-1_c8_4065e579161132f.s](round3/control32_d-1_c8_4065e579161132f.s): `k=32`, out.
- [round3/control32_d-1_c8_40718fc8b65bfb.s](round3/control32_d-1_c8_40718fc8b65bfb.s): `k=32`, out.
- [round3/control32_d-1_c8_43a93e06324c3bc3.s](round3/control32_d-1_c8_43a93e06324c3bc3.s): `k=32`, out.
- [round3/control32_d-1_c8_43e28701f70f0cf.s](round3/control32_d-1_c8_43e28701f70f0cf.s): `k=32`, out.
- [round3/control32_d-1_c8_4480f6c61beea14b.s](round3/control32_d-1_c8_4480f6c61beea14b.s): `k=32`, out.
- [round3/control32_d-1_c8_44a89463151f5b8f.s](round3/control32_d-1_c8_44a89463151f5b8f.s): `k=32`, out.
- [round3/control32_d-1_c8_45647ba89f2ce4ff.s](round3/control32_d-1_c8_45647ba89f2ce4ff.s): `k=32`, out.
- [round3/control32_d-1_c8_4568144e518d6cff.s](round3/control32_d-1_c8_4568144e518d6cff.s): `k=32`, out.
- [round3/control32_d-1_c8_490153be8f1298b.s](round3/control32_d-1_c8_490153be8f1298b.s): `k=32`, out.
- [round3/control32_d-1_c8_4a225b46e63e8737.s](round3/control32_d-1_c8_4a225b46e63e8737.s): `k=32`, out.
- [round3/control32_d-1_c8_4c82686d8d30d33.s](round3/control32_d-1_c8_4c82686d8d30d33.s): `k=32`, out.
- [round3/control32_d-1_c8_504956aa3c140ea3.s](round3/control32_d-1_c8_504956aa3c140ea3.s): `k=32`, out.
- [round3/control32_d-1_c8_54b8fd94e189948f.s](round3/control32_d-1_c8_54b8fd94e189948f.s): `k=32`, out.
- [round3/control32_d-1_c8_59bb347d4b01a577.s](round3/control32_d-1_c8_59bb347d4b01a577.s): `k=32`, out.
- [round3/control32_d-1_c8_5bdf24a222d2b63.s](round3/control32_d-1_c8_5bdf24a222d2b63.s): `k=32`, out.
- [round3/control32_d-1_c8_63f1e94b2830099.s](round3/control32_d-1_c8_63f1e94b2830099.s): `k=32`, out.
- [round3/control32_d-1_c8_6580b4e99d6036b.s](round3/control32_d-1_c8_6580b4e99d6036b.s): `k=32`, out.
- [round3/control32_d-1_c8_66303d2fe517211.s](round3/control32_d-1_c8_66303d2fe517211.s): `k=32`, out.
- [round3/control32_d-1_c8_66ea7778158faf.s](round3/control32_d-1_c8_66ea7778158faf.s): `k=32`, out.
- [round3/control32_d-1_c8_6e38bedf286f04f.s](round3/control32_d-1_c8_6e38bedf286f04f.s): `k=32`, out.
- [round3/control32_d-1_c8_70dac6520f0a05af.s](round3/control32_d-1_c8_70dac6520f0a05af.s): `k=32`, out.
- [round3/control32_d-1_c8_784551952e246563.s](round3/control32_d-1_c8_784551952e246563.s): `k=32`, out.
- [round3/control32_d-1_c8_7c7f65877f171ab.s](round3/control32_d-1_c8_7c7f65877f171ab.s): `k=32`, out.
- [round3/control32_d-1_c8_7f146a90e5e9bcf.s](round3/control32_d-1_c8_7f146a90e5e9bcf.s): `k=32`, out.
- [round3/control32_d-1_c8_8034dffd5d8c457.s](round3/control32_d-1_c8_8034dffd5d8c457.s): `k=32`, out.
- [round3/control32_d-1_c8_81ed52dfbe00faf.s](round3/control32_d-1_c8_81ed52dfbe00faf.s): `k=32`, out.
- [round3/control32_d-1_c8_845547c9459fdb7b.s](round3/control32_d-1_c8_845547c9459fdb7b.s): `k=32`, out.
- [round3/control32_d-1_c8_85b4809f0fae497.s](round3/control32_d-1_c8_85b4809f0fae497.s): `k=32`, out.
- [round3/control32_d-1_c8_8a1b7bc87d5e633.s](round3/control32_d-1_c8_8a1b7bc87d5e633.s): `k=32`, out.
- [round3/control32_d-1_c8_8d0dd0ee89a970f.s](round3/control32_d-1_c8_8d0dd0ee89a970f.s): `k=32`, out.
- [round3/control32_d-1_c8_8fce06357f6d127.s](round3/control32_d-1_c8_8fce06357f6d127.s): `k=32`, out.
- [round3/control32_d-1_c8_9356fd7b120de37.s](round3/control32_d-1_c8_9356fd7b120de37.s): `k=32`, out.
- [round3/control32_d-1_c8_9755d36ddedc6b7.s](round3/control32_d-1_c8_9755d36ddedc6b7.s): `k=32`, out.
- [round3/control32_d-1_c8_978e4716e9a7b55.s](round3/control32_d-1_c8_978e4716e9a7b55.s): `k=32`, out.
- [round3/control32_d-1_c8_9e1a0f74131d81f.s](round3/control32_d-1_c8_9e1a0f74131d81f.s): `k=32`, out.
- [round3/control32_d-1_c8_a333f1fdc61ed4b.s](round3/control32_d-1_c8_a333f1fdc61ed4b.s): `k=32`, out.
- [round3/control32_d-1_c8_a7b174f83a0f43b.s](round3/control32_d-1_c8_a7b174f83a0f43b.s): `k=32`, out.
- [round3/control32_d-1_c8_adb02b770a6193.s](round3/control32_d-1_c8_adb02b770a6193.s): `k=32`, out.
- [round3/control32_d-1_c8_b1dc9333293688f.s](round3/control32_d-1_c8_b1dc9333293688f.s): `k=32`, out.
- [round3/control32_d-1_c8_bcbcb19411aea31.s](round3/control32_d-1_c8_bcbcb19411aea31.s): `k=32`, out.
- [round3/control32_d-1_c8_c060accd56c0c2f.s](round3/control32_d-1_c8_c060accd56c0c2f.s): `k=32`, out.
- [round3/control32_d-1_c8_c3208d05a5329e7.s](round3/control32_d-1_c8_c3208d05a5329e7.s): `k=32`, out.
- [round3/control32_d-1_c8_cd249ed48c06697.s](round3/control32_d-1_c8_cd249ed48c06697.s): `k=32`, out.
- [round3/control32_d-1_c8_cd2c6a654c268eb.s](round3/control32_d-1_c8_cd2c6a654c268eb.s): `k=32`, out.
- [round3/control32_d-1_c8_ce431b9f3a92ab9.s](round3/control32_d-1_c8_ce431b9f3a92ab9.s): `k=32`, out.
- [round3/control32_d-1_c8_d7ea38d35580a9b.s](round3/control32_d-1_c8_d7ea38d35580a9b.s): `k=32`, out.
- [round3/control32_d-1_c8_d971bb526287b89.s](round3/control32_d-1_c8_d971bb526287b89.s): `k=32`, out.
- [round3/control32_d-1_c8_db8ff5154396dd7.s](round3/control32_d-1_c8_db8ff5154396dd7.s): `k=32`, out.
- [round3/control32_d-1_c8_dbbbb77809455d7.s](round3/control32_d-1_c8_dbbbb77809455d7.s): `k=32`, out.
- [round3/control32_d-1_c8_e1c0ebef11c2d07.s](round3/control32_d-1_c8_e1c0ebef11c2d07.s): `k=32`, out.
- [round3/control32_d-1_c8_e32bfb331db9cf7.s](round3/control32_d-1_c8_e32bfb331db9cf7.s): `k=32`, out.
- [round3/control32_d-1_c8_ee55e6ba214fb31.s](round3/control32_d-1_c8_ee55e6ba214fb31.s): `k=32`, out.
- [round3/control32_d-1_c8_efa0c71440608fb.s](round3/control32_d-1_c8_efa0c71440608fb.s): `k=32`, out.
- [round3/control32_d-1_c8_f76ab7383f3162f.s](round3/control32_d-1_c8_f76ab7383f3162f.s): `k=32`, out.
- [round3/control32_d-1_c8_f861da3879904ef.s](round3/control32_d-1_c8_f861da3879904ef.s): `k=32`, out.
- [round3/control32_d-1_c8_f8dffa39345ffaf.s](round3/control32_d-1_c8_f8dffa39345ffaf.s): `k=32`, out.
- [round3/control32_d-1_c8_ffb1da4812016b.s](round3/control32_d-1_c8_ffb1da4812016b.s): `k=32`, out.
- [round3/control_exact_c8_10040eff416c0867.s](round3/control_exact_c8_10040eff416c0867.s): `k=32`, out.
- [round3/control_mem42.s](round3/control_mem42.s): `L=42`, memory.
- [round3/delayed_control32.s](round3/delayed_control32.s): `k=32`, out.
- [round3/delayed_early_d-1_delayed_control32.s](round3/delayed_early_d-1_delayed_control32.s): `k=32`, out.
- [round3/deleted_control_d32_padded_control33.s](round3/deleted_control_d32_padded_control33.s): `k=32`, out.
- [round3/early_control32_d-1_c8_10040eff416c0867.s](round3/early_control32_d-1_c8_10040eff416c0867.s): `k=32`, out.
- [round3/padded_control33.s](round3/padded_control33.s): `k=33`, out.

# Round 3: limits and conclusion

These are completed finite abstract searches with fixed event positions and
specified masked value targets. They do not cover arbitrary intermediate
values, every comparison schedule, or outputs later than their base deadlines.
The unknown-value simulator can also reject programs that depend on correlations
between scratch values. No general lower bound or formal certificate is claimed.

The direct copy-removal tests found no improvement. The smallest verified core
remains **32 instructions**, with a **42-instruction** memory form. Run
`nice -n 19 python3 round3/reproduce.py` from this worker folder to reproduce
the completed searches and strict checks on one CPU.


# Round 4: purpose and method

Test delete-two/insert-one changes to all 144 eight-comparison cores and all
26 nine-comparison cores in `d7-structure/fam32`. No core with `k <= 31`
was found. The first 143 c=8 bases are the earlier w6 variants. The additional
base is `../w6/candidates/c8c_len32_c29288.s`.

The direct search deletes every pair of core instructions. It inserts every
permitted opcode with every source and destination from the base register set
plus one fresh register. It keeps the other instruction operands and order.
The free-output run permits every output register and time. The search uses
all 541 weak orders with scratch values fixed above the inputs and equal
initial flags. This is a concrete relaxation of strict correctness.

See [round4/METHODS.md](round4/METHODS.md) for the exact family, action sharing,
output intersection, global reuse extension, and limits. The input ledger is
[round4/manifest.json](round4/manifest.json). No excluded enumeration, dagx,
or Hamming-three search was repeated.

# Round 4: exhaustive direct edit results

Every row completed with NONE. There was no timeout or truncation. A slot is
one deletion pair and insertion gap. Raw edits count all six opcodes and all
ordered register pairs, including self operands. Equivalent concrete effects
share a suffix simulation within one input case.

| Output choices | Bases | Slots | Raw edits | Suffix simulations | CPU seconds |
| --- | --- | ---: | ---: | ---: | ---: |
| Original outputs | 144 c=8 bases | 2,571,264 | 1,346,699,520 | 146,935,602 | 32.925 |
| Original outputs | 26 c=9 bases | 464,256 | 256,162,176 | 26,785,738 | 6.835 |
| Any output register and time | 144 c=8 bases | 2,214,144 | 1,159,657,920 | 279,946,827 | 52.941 |
| Any output register and time | 26 c=9 bases | 399,776 | 220,584,096 | 51,044,419 | 9.521 |

Both runs cover all 496 deletion pairs for every base. The fixed-output run
has 36 gaps per pair. The free-output run has 31 gaps per pair. The logs are
[round4/fixed.log](round4/fixed.log) and [round4/free.log](round4/free.log).
These completed negatives apply to this edit family, not to all programs.

# Round 4: global register reuse

The additional driver deletes one write and makes another write unrestricted.
It can change the opcode, source, and destination of every retained write.
It retains the other masked creation targets. Creation-only modes permit outputs
past their base deadlines. Hold mode retains the other boundary requirements.
One mode also frees every comparison outcome. The other retains
the base required comparison predicates with freely chosen register operands.

- `reuse_copy_free_hold`: 2,730 completed test records; LIMIT 15, NONE 2,715; recorded CPU 122.818 seconds.
- `reuse_copy_hold`: 2,730 completed test records; NONE 2,730; recorded CPU 13.537 seconds.
- `reuse_pilot`: 228 completed test records; LIMIT 35, NONE 193; recorded CPU 176.321 seconds.
- `reuse_pred_pilot`: 40 completed test records; NONE 40; recorded CPU 0.290 seconds.
- `reuse_pred_suffix`: 466 completed test records; LIMIT 24, NONE 442; recorded CPU 83.011 seconds.
- `reuse_resolve_0_15`: 1 completed test records; NONE 1; recorded CPU 1.087 seconds.
- `reuse_resolve_103_15`: 1 completed test records; NONE 1; recorded CPU 0.868 seconds.
- `reuse_resolve_106_11`: 1 completed test records; NONE 1; recorded CPU 1.031 seconds.
- `reuse_resolve_106_15`: 1 completed test records; NONE 1; recorded CPU 2.124 seconds.
- `reuse_resolve_106_3`: 1 completed test records; NONE 1; recorded CPU 0.963 seconds.
- `reuse_resolve_106_7`: 1 completed test records; NONE 1; recorded CPU 1.067 seconds.
- `reuse_resolve_107_15`: 1 completed test records; NONE 1; recorded CPU 1.173 seconds.
- `reuse_resolve_119_15`: 1 completed test records; NONE 1; recorded CPU 1.219 seconds.
- `reuse_resolve_143_15`: 1 completed test records; NONE 1; recorded CPU 0.804 seconds.
- `reuse_resolve_1_15`: 1 completed test records; NONE 1; recorded CPU 1.154 seconds.
- `reuse_resolve_23_15`: 1 completed test records; NONE 1; recorded CPU 1.064 seconds.
- `reuse_resolve_33_15`: 1 completed test records; NONE 1; recorded CPU 1.636 seconds.
- `reuse_resolve_34_15`: 1 completed test records; NONE 1; recorded CPU 2.024 seconds.
- `reuse_resolve_35_15`: 1 completed test records; NONE 1; recorded CPU 1.029 seconds.
- `reuse_resolve_46_15`: 1 completed test records; NONE 1; recorded CPU 1.175 seconds.

- `reuse_copy_hold`: expected 2,730 tests; recorded 2,730; coverage complete; result NONE.
- `reuse_copy_free_hold`: expected 2,730 tests; recorded 2,730; coverage complete; result NONE.
- `predicate_one_base`: expected 506 tests; recorded 506; coverage complete; family result unknown.

A NONE record exhausts that finite abstract test. A LIMIT record is unknown.
A completed retry can resolve that test. A family with missing tests or
unresolved LIMIT records is unknown. The summary ledger
records the exact completed test indices. These runs do not establish a global
copy-count minimum. The global driver uses the round 3 unknown-value abstraction
and can reject programs that depend on scratch correlations.

# Round 4: verification and resources

The independent scalar implementation matched 908 candidate-mask hashes.
It directly simulated 186,186 edited programs across 372 insertion slots.
The checks cover 12 deletion pairs from seven bases. Its log is
[round4/crosscheck.log](round4/crosscheck.log). This is validation evidence,
not a formal certificate. The independent check does not cover all edit slots.

The positive control adds one unused copy to a correct 32-instruction core.
Both direct output modes restore a 32-instruction core after two deletions and
one insertion. The following files received strict PASS from the shared judge:

- [round4/control_fixed_padded33_0_32_0_0_5_2.s](round4/control_fixed_padded33_0_32_0_0_5_2.s): `k=32`, out.
- [round4/control_free_padded33_0_32_0_0_5_2.s](round4/control_free_padded33_0_32_0_0_5_2.s): `k=32`, out.
- [round4/control_mem42.s](round4/control_mem42.s): `L=42`, mem.
- [round4/reuse_control_a0_b32_padded33.s](round4/reuse_control_a0_b32_padded33.s): `k=32`, out.
- [round4/reuse_copy_control_a0_b32_padded33.s](round4/reuse_copy_control_a0_b32_padded33.s): `k=32`, out.

All CPU jobs ran sequentially under `nice -n 19` on CPU 68. Each search had
a 2,800 MiB virtual-memory limit. The largest recorded search resident memory
was 68,528 KiB. The strict judge outputs, source hashes, resource
records, and coverage counts are indexed in
[round4/summary.json](round4/summary.json).

The smallest verified core remains 32 instructions. Its memory form has 42
instructions. No four-move improvement or general lower bound was obtained.

The reproduction driver is `nice -n 19 python3 round4/reproduce.py`.
This round ran the commands individually. The full driver was syntax-checked
but was not run as one command.


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


# Round 6: failing-value classification and exhaustive insertions

No program with `k <= 31` was found. All four finite edit searches completed.
The completed negative results test **A11**, local repair near specified failing
cores. They use the I1 rules in G1 through G4. They do not establish a general
lower bound. No assumption was contradicted.

The inputs are the 15 w6 round 6 representatives and
`w9/candidates/residual_b_near31_out.s`. Their paths, hashes, exact instructions,
and register names are in [round6/manifest.json](round6/manifest.json).
Earlier replacement searches and fixed-value routing searches were not repeated.

# Round 6: failed weak orders

All 15 w6 representatives have the same failure condition after input renaming.
One specified input is the unique median. A specified pair lies strictly below
it. The other pair lies strictly above it. Each pair permits internal ties.
This gives four failures with distinct inputs and five failures with ties.
Only output 2 fails. The core loses its last register copy of the required
median immediately after counted instruction 24 or 25.

For base b00, the exact condition is `x0 < x1 < x2` and `x3 < x1 < x4`.
Here `xi` means original input Pi. All values of each condition were checked
against all 541 weak orders. The per-base conditions follow.

| Base | Median input | Inputs below median | Inputs above median | First loss after instruction |
| --- | --- | --- | --- | ---: |
| b00 | x1 | x0, x3 | x2, x4 | 24 |
| b01 | x1 | x0, x3 | x2, x4 | 24 |
| b02 | x3 | x0, x1 | x2, x4 | 24 |
| b03 | x3 | x0, x1 | x2, x4 | 25 |
| b04 | x2 | x1, x3 | x0, x4 | 24 |
| b05 | x4 | x0, x1 | x2, x3 | 25 |
| b06 | x4 | x0, x1 | x2, x3 | 25 |
| b07 | x4 | x0, x1 | x2, x3 | 25 |
| b08 | x1 | x0, x3 | x2, x4 | 25 |
| b09 | x4 | x0, x1 | x2, x3 | 25 |
| b10 | x3 | x0, x1 | x2, x4 | 24 |
| b11 | x1 | x0, x3 | x2, x4 | 24 |
| b12 | x2 | x1, x3 | x0, x4 | 24 |
| b13 | x2 | x1, x3 | x0, x4 | 24 |
| b14 | x1 | x0, x3 | x2, x4 | 24 |

The w9 core fails exactly when
`min(x0,x1) < x2 < min(x3,x4)` and
`max(x0,x1) >= max(x3,x4)`. Four failures have distinct inputs. Eight have ties.
Only output 1 fails. The core loses its last copy of x2 after instruction 23.
The independent audit reproduced this earlier w9 classification.

Every failed case, incorrect output, required value, last copy, and available
earlier occurrence is recorded in [round6/analysis.json](round6/analysis.json).
The audit checked that the original cores do not compare or output initial
scratch data on any weak order. Each conditional move follows a comparison.
Thus the classification does not depend on the concrete scratch values or
initial flags used by the search.

# Round 6: exhaustive edit results

Each inserted instruction permits all six I1 opcodes and all ordered operand
pairs, including equal operands. Operands use every base register plus one
fresh register. Eleven bases have seven named registers. Five have eight.
Fixed-output searches preserve the original output instructions. Free-output
searches choose each output register and time independently, with the same
choice required across all 541 cases. Retained core instructions stay fixed.

| Edit | Output choices | Bases | Insertion slots | Raw edits | Relaxed survivors |
| --- | --- | ---: | ---: | ---: | ---: |
| Insert one; k=32 | Original outputs | 16 | 592 | 246,198 | 374 |
| Insert one; k=32 | Any register and time | 16 | 512 | 212,928 | 356 |
| Delete one, insert one; k=31 | Original outputs | 16 | 17,856 | 7,425,864 | 0 |
| Delete one, insert one; k=31 | Any register and time | 16 | 15,376 | 6,394,494 | 0 |

An insertion slot is one insertion gap, with a selected deletion where required.
Raw edit counts include equivalent and unchanged effects. The two output modes
can describe the same core more than once. Counts are edit sequences, not
distinct algorithms. Every search completed without truncation or timeout.

The primary insertion scans found 374 fixed-output repairs and 356 free-output
repairs in the concrete relaxation. They include a repair for every base.
Every one of these **730 emitted cores passed the shared strict out-model
judge at k=32**. The first repair for each base in each mode also passed the
strict memory-model judge: **32 memory files, each with length 42**.

The successful insertions use mov or a conditional move. None uses cmp.
None uses the fresh register. The repair therefore copies an existing value
within the original registers. A first w6 repair copies the required median
before the old core loses it. The w9 repairs copy P2 into S3 at a suitable
position or condition. The per-base repair pairs, insertion gaps, and effects
on comparison histories are in [round6/summary.json](round6/summary.json).

For ten w6 representatives, the first checked repair preserves every original
comparison outcome on all 541 weak orders. For the other five, it changes
comparison outcomes only on the nine failed orders. The first w9 repair changes
comparison outcomes only on its twelve failed orders. Thus ten representatives
can be repaired by preserving the median without changing the comparison paths.

The delete-one/insert-one scans tested **13,820,358** raw edits. They retained
no candidate, including with free output registers and times. Thus adding
one instruction repairs these failures at k=32, but removing another original
instruction cannot keep the repair at k=31 in this stated edit family.

# Round 6: verification and resources

The independent implementation directly executed every edited program.
It regenerated the weak orders in a different order. It matched every
surviving edit and every free-output occurrence mask in all four searches.
This is independent validation evidence, not a formal certificate.
See [round6/audit.log](round6/audit.log) and
[round6/METHODS.md](round6/METHODS.md) for the exact scope.

Each strict judge command used its default 20,000 random concrete tests,
in addition to the weak-order and symbolic checks. The command, output log,
file hash, and result for every emitted file are recorded in
[round6/pass_ledger.json](round6/pass_ledger.json).

The largest recorded resident memory was 21,388 KiB.
All CPU jobs ran sequentially on CPU 68 under `nice -n 19`.
The search address-space limit was 2,800 MiB. Every job stayed below 3 GB.
Reproduction: `nice -n 19 python3 round6/reproduce.py`.
This round executed its commands individually. The complete reproduction
driver was syntax-checked and was not rerun as one command.

# Round 6: limits

The negative result retains the other original instruction operands and order.
It permits one new register. It does not cover arbitrary k=31 cores or
multiple inserted instructions with broader changes. No global lower bound
or new optimality proof is claimed. The shortest verified core remains k=32.

# Round 6: every strict PASS file

All register files below have k=32. All memory files have length 42.

- [round6/verified/fixed_0000_b00.s](round6/verified/fixed_0000_b00.s): out, 32.
- [round6/verified/fixed_0000_b00_mem.s](round6/verified/fixed_0000_b00_mem.s): mem, 42.
- [round6/verified/fixed_0001_b00.s](round6/verified/fixed_0001_b00.s): out, 32.
- [round6/verified/fixed_0002_b00.s](round6/verified/fixed_0002_b00.s): out, 32.
- [round6/verified/fixed_0003_b00.s](round6/verified/fixed_0003_b00.s): out, 32.
- [round6/verified/fixed_0004_b00.s](round6/verified/fixed_0004_b00.s): out, 32.
- [round6/verified/fixed_0005_b00.s](round6/verified/fixed_0005_b00.s): out, 32.
- [round6/verified/fixed_0006_b00.s](round6/verified/fixed_0006_b00.s): out, 32.
- [round6/verified/fixed_0007_b00.s](round6/verified/fixed_0007_b00.s): out, 32.
- [round6/verified/fixed_0008_b00.s](round6/verified/fixed_0008_b00.s): out, 32.
- [round6/verified/fixed_0009_b00.s](round6/verified/fixed_0009_b00.s): out, 32.
- [round6/verified/fixed_0010_b00.s](round6/verified/fixed_0010_b00.s): out, 32.
- [round6/verified/fixed_0011_b00.s](round6/verified/fixed_0011_b00.s): out, 32.
- [round6/verified/fixed_0012_b00.s](round6/verified/fixed_0012_b00.s): out, 32.
- [round6/verified/fixed_0013_b00.s](round6/verified/fixed_0013_b00.s): out, 32.
- [round6/verified/fixed_0014_b00.s](round6/verified/fixed_0014_b00.s): out, 32.
- [round6/verified/fixed_0015_b00.s](round6/verified/fixed_0015_b00.s): out, 32.
- [round6/verified/fixed_0016_b00.s](round6/verified/fixed_0016_b00.s): out, 32.
- [round6/verified/fixed_0017_b00.s](round6/verified/fixed_0017_b00.s): out, 32.
- [round6/verified/fixed_0018_b00.s](round6/verified/fixed_0018_b00.s): out, 32.
- [round6/verified/fixed_0019_b00.s](round6/verified/fixed_0019_b00.s): out, 32.
- [round6/verified/fixed_0020_b01.s](round6/verified/fixed_0020_b01.s): out, 32.
- [round6/verified/fixed_0020_b01_mem.s](round6/verified/fixed_0020_b01_mem.s): mem, 42.
- [round6/verified/fixed_0021_b01.s](round6/verified/fixed_0021_b01.s): out, 32.
- [round6/verified/fixed_0022_b01.s](round6/verified/fixed_0022_b01.s): out, 32.
- [round6/verified/fixed_0023_b01.s](round6/verified/fixed_0023_b01.s): out, 32.
- [round6/verified/fixed_0024_b01.s](round6/verified/fixed_0024_b01.s): out, 32.
- [round6/verified/fixed_0025_b01.s](round6/verified/fixed_0025_b01.s): out, 32.
- [round6/verified/fixed_0026_b01.s](round6/verified/fixed_0026_b01.s): out, 32.
- [round6/verified/fixed_0027_b01.s](round6/verified/fixed_0027_b01.s): out, 32.
- [round6/verified/fixed_0028_b01.s](round6/verified/fixed_0028_b01.s): out, 32.
- [round6/verified/fixed_0029_b01.s](round6/verified/fixed_0029_b01.s): out, 32.
- [round6/verified/fixed_0030_b01.s](round6/verified/fixed_0030_b01.s): out, 32.
- [round6/verified/fixed_0031_b01.s](round6/verified/fixed_0031_b01.s): out, 32.
- [round6/verified/fixed_0032_b01.s](round6/verified/fixed_0032_b01.s): out, 32.
- [round6/verified/fixed_0033_b01.s](round6/verified/fixed_0033_b01.s): out, 32.
- [round6/verified/fixed_0034_b01.s](round6/verified/fixed_0034_b01.s): out, 32.
- [round6/verified/fixed_0035_b01.s](round6/verified/fixed_0035_b01.s): out, 32.
- [round6/verified/fixed_0036_b01.s](round6/verified/fixed_0036_b01.s): out, 32.
- [round6/verified/fixed_0037_b01.s](round6/verified/fixed_0037_b01.s): out, 32.
- [round6/verified/fixed_0038_b01.s](round6/verified/fixed_0038_b01.s): out, 32.
- [round6/verified/fixed_0039_b01.s](round6/verified/fixed_0039_b01.s): out, 32.
- [round6/verified/fixed_0040_b02.s](round6/verified/fixed_0040_b02.s): out, 32.
- [round6/verified/fixed_0040_b02_mem.s](round6/verified/fixed_0040_b02_mem.s): mem, 42.
- [round6/verified/fixed_0041_b02.s](round6/verified/fixed_0041_b02.s): out, 32.
- [round6/verified/fixed_0042_b02.s](round6/verified/fixed_0042_b02.s): out, 32.
- [round6/verified/fixed_0043_b02.s](round6/verified/fixed_0043_b02.s): out, 32.
- [round6/verified/fixed_0044_b02.s](round6/verified/fixed_0044_b02.s): out, 32.
- [round6/verified/fixed_0045_b02.s](round6/verified/fixed_0045_b02.s): out, 32.
- [round6/verified/fixed_0046_b02.s](round6/verified/fixed_0046_b02.s): out, 32.
- [round6/verified/fixed_0047_b02.s](round6/verified/fixed_0047_b02.s): out, 32.
- [round6/verified/fixed_0048_b02.s](round6/verified/fixed_0048_b02.s): out, 32.
- [round6/verified/fixed_0049_b02.s](round6/verified/fixed_0049_b02.s): out, 32.
- [round6/verified/fixed_0050_b02.s](round6/verified/fixed_0050_b02.s): out, 32.
- [round6/verified/fixed_0051_b02.s](round6/verified/fixed_0051_b02.s): out, 32.
- [round6/verified/fixed_0052_b02.s](round6/verified/fixed_0052_b02.s): out, 32.
- [round6/verified/fixed_0053_b02.s](round6/verified/fixed_0053_b02.s): out, 32.
- [round6/verified/fixed_0054_b02.s](round6/verified/fixed_0054_b02.s): out, 32.
- [round6/verified/fixed_0055_b02.s](round6/verified/fixed_0055_b02.s): out, 32.
- [round6/verified/fixed_0056_b02.s](round6/verified/fixed_0056_b02.s): out, 32.
- [round6/verified/fixed_0057_b02.s](round6/verified/fixed_0057_b02.s): out, 32.
- [round6/verified/fixed_0058_b02.s](round6/verified/fixed_0058_b02.s): out, 32.
- [round6/verified/fixed_0059_b02.s](round6/verified/fixed_0059_b02.s): out, 32.
- [round6/verified/fixed_0060_b02.s](round6/verified/fixed_0060_b02.s): out, 32.
- [round6/verified/fixed_0061_b02.s](round6/verified/fixed_0061_b02.s): out, 32.
- [round6/verified/fixed_0062_b02.s](round6/verified/fixed_0062_b02.s): out, 32.
- [round6/verified/fixed_0063_b02.s](round6/verified/fixed_0063_b02.s): out, 32.
- [round6/verified/fixed_0064_b02.s](round6/verified/fixed_0064_b02.s): out, 32.
- [round6/verified/fixed_0065_b03.s](round6/verified/fixed_0065_b03.s): out, 32.
- [round6/verified/fixed_0065_b03_mem.s](round6/verified/fixed_0065_b03_mem.s): mem, 42.
- [round6/verified/fixed_0066_b03.s](round6/verified/fixed_0066_b03.s): out, 32.
- [round6/verified/fixed_0067_b03.s](round6/verified/fixed_0067_b03.s): out, 32.
- [round6/verified/fixed_0068_b03.s](round6/verified/fixed_0068_b03.s): out, 32.
- [round6/verified/fixed_0069_b03.s](round6/verified/fixed_0069_b03.s): out, 32.
- [round6/verified/fixed_0070_b03.s](round6/verified/fixed_0070_b03.s): out, 32.
- [round6/verified/fixed_0071_b03.s](round6/verified/fixed_0071_b03.s): out, 32.
- [round6/verified/fixed_0072_b03.s](round6/verified/fixed_0072_b03.s): out, 32.
- [round6/verified/fixed_0073_b03.s](round6/verified/fixed_0073_b03.s): out, 32.
- [round6/verified/fixed_0074_b03.s](round6/verified/fixed_0074_b03.s): out, 32.
- [round6/verified/fixed_0075_b03.s](round6/verified/fixed_0075_b03.s): out, 32.
- [round6/verified/fixed_0076_b03.s](round6/verified/fixed_0076_b03.s): out, 32.
- [round6/verified/fixed_0077_b03.s](round6/verified/fixed_0077_b03.s): out, 32.
- [round6/verified/fixed_0078_b03.s](round6/verified/fixed_0078_b03.s): out, 32.
- [round6/verified/fixed_0079_b03.s](round6/verified/fixed_0079_b03.s): out, 32.
- [round6/verified/fixed_0080_b03.s](round6/verified/fixed_0080_b03.s): out, 32.
- [round6/verified/fixed_0081_b03.s](round6/verified/fixed_0081_b03.s): out, 32.
- [round6/verified/fixed_0082_b03.s](round6/verified/fixed_0082_b03.s): out, 32.
- [round6/verified/fixed_0083_b03.s](round6/verified/fixed_0083_b03.s): out, 32.
- [round6/verified/fixed_0084_b03.s](round6/verified/fixed_0084_b03.s): out, 32.
- [round6/verified/fixed_0085_b03.s](round6/verified/fixed_0085_b03.s): out, 32.
- [round6/verified/fixed_0086_b03.s](round6/verified/fixed_0086_b03.s): out, 32.
- [round6/verified/fixed_0087_b03.s](round6/verified/fixed_0087_b03.s): out, 32.
- [round6/verified/fixed_0088_b03.s](round6/verified/fixed_0088_b03.s): out, 32.
- [round6/verified/fixed_0089_b03.s](round6/verified/fixed_0089_b03.s): out, 32.
- [round6/verified/fixed_0090_b03.s](round6/verified/fixed_0090_b03.s): out, 32.
- [round6/verified/fixed_0091_b03.s](round6/verified/fixed_0091_b03.s): out, 32.
- [round6/verified/fixed_0092_b03.s](round6/verified/fixed_0092_b03.s): out, 32.
- [round6/verified/fixed_0093_b04.s](round6/verified/fixed_0093_b04.s): out, 32.
- [round6/verified/fixed_0093_b04_mem.s](round6/verified/fixed_0093_b04_mem.s): mem, 42.
- [round6/verified/fixed_0094_b04.s](round6/verified/fixed_0094_b04.s): out, 32.
- [round6/verified/fixed_0095_b04.s](round6/verified/fixed_0095_b04.s): out, 32.
- [round6/verified/fixed_0096_b04.s](round6/verified/fixed_0096_b04.s): out, 32.
- [round6/verified/fixed_0097_b04.s](round6/verified/fixed_0097_b04.s): out, 32.
- [round6/verified/fixed_0098_b04.s](round6/verified/fixed_0098_b04.s): out, 32.
- [round6/verified/fixed_0099_b04.s](round6/verified/fixed_0099_b04.s): out, 32.
- [round6/verified/fixed_0100_b04.s](round6/verified/fixed_0100_b04.s): out, 32.
- [round6/verified/fixed_0101_b04.s](round6/verified/fixed_0101_b04.s): out, 32.
- [round6/verified/fixed_0102_b04.s](round6/verified/fixed_0102_b04.s): out, 32.
- [round6/verified/fixed_0103_b04.s](round6/verified/fixed_0103_b04.s): out, 32.
- [round6/verified/fixed_0104_b04.s](round6/verified/fixed_0104_b04.s): out, 32.
- [round6/verified/fixed_0105_b04.s](round6/verified/fixed_0105_b04.s): out, 32.
- [round6/verified/fixed_0106_b04.s](round6/verified/fixed_0106_b04.s): out, 32.
- [round6/verified/fixed_0107_b04.s](round6/verified/fixed_0107_b04.s): out, 32.
- [round6/verified/fixed_0108_b04.s](round6/verified/fixed_0108_b04.s): out, 32.
- [round6/verified/fixed_0109_b04.s](round6/verified/fixed_0109_b04.s): out, 32.
- [round6/verified/fixed_0110_b04.s](round6/verified/fixed_0110_b04.s): out, 32.
- [round6/verified/fixed_0111_b04.s](round6/verified/fixed_0111_b04.s): out, 32.
- [round6/verified/fixed_0112_b04.s](round6/verified/fixed_0112_b04.s): out, 32.
- [round6/verified/fixed_0113_b04.s](round6/verified/fixed_0113_b04.s): out, 32.
- [round6/verified/fixed_0114_b04.s](round6/verified/fixed_0114_b04.s): out, 32.
- [round6/verified/fixed_0115_b04.s](round6/verified/fixed_0115_b04.s): out, 32.
- [round6/verified/fixed_0116_b04.s](round6/verified/fixed_0116_b04.s): out, 32.
- [round6/verified/fixed_0117_b04.s](round6/verified/fixed_0117_b04.s): out, 32.
- [round6/verified/fixed_0118_b04.s](round6/verified/fixed_0118_b04.s): out, 32.
- [round6/verified/fixed_0119_b05.s](round6/verified/fixed_0119_b05.s): out, 32.
- [round6/verified/fixed_0119_b05_mem.s](round6/verified/fixed_0119_b05_mem.s): mem, 42.
- [round6/verified/fixed_0120_b05.s](round6/verified/fixed_0120_b05.s): out, 32.
- [round6/verified/fixed_0121_b05.s](round6/verified/fixed_0121_b05.s): out, 32.
- [round6/verified/fixed_0122_b05.s](round6/verified/fixed_0122_b05.s): out, 32.
- [round6/verified/fixed_0123_b05.s](round6/verified/fixed_0123_b05.s): out, 32.
- [round6/verified/fixed_0124_b05.s](round6/verified/fixed_0124_b05.s): out, 32.
- [round6/verified/fixed_0125_b05.s](round6/verified/fixed_0125_b05.s): out, 32.
- [round6/verified/fixed_0126_b05.s](round6/verified/fixed_0126_b05.s): out, 32.
- [round6/verified/fixed_0127_b05.s](round6/verified/fixed_0127_b05.s): out, 32.
- [round6/verified/fixed_0128_b05.s](round6/verified/fixed_0128_b05.s): out, 32.
- [round6/verified/fixed_0129_b05.s](round6/verified/fixed_0129_b05.s): out, 32.
- [round6/verified/fixed_0130_b05.s](round6/verified/fixed_0130_b05.s): out, 32.
- [round6/verified/fixed_0131_b05.s](round6/verified/fixed_0131_b05.s): out, 32.
- [round6/verified/fixed_0132_b05.s](round6/verified/fixed_0132_b05.s): out, 32.
- [round6/verified/fixed_0133_b05.s](round6/verified/fixed_0133_b05.s): out, 32.
- [round6/verified/fixed_0134_b05.s](round6/verified/fixed_0134_b05.s): out, 32.
- [round6/verified/fixed_0135_b05.s](round6/verified/fixed_0135_b05.s): out, 32.
- [round6/verified/fixed_0136_b05.s](round6/verified/fixed_0136_b05.s): out, 32.
- [round6/verified/fixed_0137_b05.s](round6/verified/fixed_0137_b05.s): out, 32.
- [round6/verified/fixed_0138_b05.s](round6/verified/fixed_0138_b05.s): out, 32.
- [round6/verified/fixed_0139_b05.s](round6/verified/fixed_0139_b05.s): out, 32.
- [round6/verified/fixed_0140_b05.s](round6/verified/fixed_0140_b05.s): out, 32.
- [round6/verified/fixed_0141_b05.s](round6/verified/fixed_0141_b05.s): out, 32.
- [round6/verified/fixed_0142_b05.s](round6/verified/fixed_0142_b05.s): out, 32.
- [round6/verified/fixed_0143_b05.s](round6/verified/fixed_0143_b05.s): out, 32.
- [round6/verified/fixed_0144_b05.s](round6/verified/fixed_0144_b05.s): out, 32.
- [round6/verified/fixed_0145_b06.s](round6/verified/fixed_0145_b06.s): out, 32.
- [round6/verified/fixed_0145_b06_mem.s](round6/verified/fixed_0145_b06_mem.s): mem, 42.
- [round6/verified/fixed_0146_b06.s](round6/verified/fixed_0146_b06.s): out, 32.
- [round6/verified/fixed_0147_b06.s](round6/verified/fixed_0147_b06.s): out, 32.
- [round6/verified/fixed_0148_b06.s](round6/verified/fixed_0148_b06.s): out, 32.
- [round6/verified/fixed_0149_b06.s](round6/verified/fixed_0149_b06.s): out, 32.
- [round6/verified/fixed_0150_b06.s](round6/verified/fixed_0150_b06.s): out, 32.
- [round6/verified/fixed_0151_b06.s](round6/verified/fixed_0151_b06.s): out, 32.
- [round6/verified/fixed_0152_b06.s](round6/verified/fixed_0152_b06.s): out, 32.
- [round6/verified/fixed_0153_b06.s](round6/verified/fixed_0153_b06.s): out, 32.
- [round6/verified/fixed_0154_b06.s](round6/verified/fixed_0154_b06.s): out, 32.
- [round6/verified/fixed_0155_b06.s](round6/verified/fixed_0155_b06.s): out, 32.
- [round6/verified/fixed_0156_b06.s](round6/verified/fixed_0156_b06.s): out, 32.
- [round6/verified/fixed_0157_b06.s](round6/verified/fixed_0157_b06.s): out, 32.
- [round6/verified/fixed_0158_b06.s](round6/verified/fixed_0158_b06.s): out, 32.
- [round6/verified/fixed_0159_b06.s](round6/verified/fixed_0159_b06.s): out, 32.
- [round6/verified/fixed_0160_b06.s](round6/verified/fixed_0160_b06.s): out, 32.
- [round6/verified/fixed_0161_b06.s](round6/verified/fixed_0161_b06.s): out, 32.
- [round6/verified/fixed_0162_b06.s](round6/verified/fixed_0162_b06.s): out, 32.
- [round6/verified/fixed_0163_b06.s](round6/verified/fixed_0163_b06.s): out, 32.
- [round6/verified/fixed_0164_b06.s](round6/verified/fixed_0164_b06.s): out, 32.
- [round6/verified/fixed_0165_b06.s](round6/verified/fixed_0165_b06.s): out, 32.
- [round6/verified/fixed_0166_b06.s](round6/verified/fixed_0166_b06.s): out, 32.
- [round6/verified/fixed_0167_b06.s](round6/verified/fixed_0167_b06.s): out, 32.
- [round6/verified/fixed_0168_b06.s](round6/verified/fixed_0168_b06.s): out, 32.
- [round6/verified/fixed_0169_b07.s](round6/verified/fixed_0169_b07.s): out, 32.
- [round6/verified/fixed_0169_b07_mem.s](round6/verified/fixed_0169_b07_mem.s): mem, 42.
- [round6/verified/fixed_0170_b07.s](round6/verified/fixed_0170_b07.s): out, 32.
- [round6/verified/fixed_0171_b07.s](round6/verified/fixed_0171_b07.s): out, 32.
- [round6/verified/fixed_0172_b07.s](round6/verified/fixed_0172_b07.s): out, 32.
- [round6/verified/fixed_0173_b07.s](round6/verified/fixed_0173_b07.s): out, 32.
- [round6/verified/fixed_0174_b07.s](round6/verified/fixed_0174_b07.s): out, 32.
- [round6/verified/fixed_0175_b07.s](round6/verified/fixed_0175_b07.s): out, 32.
- [round6/verified/fixed_0176_b07.s](round6/verified/fixed_0176_b07.s): out, 32.
- [round6/verified/fixed_0177_b07.s](round6/verified/fixed_0177_b07.s): out, 32.
- [round6/verified/fixed_0178_b07.s](round6/verified/fixed_0178_b07.s): out, 32.
- [round6/verified/fixed_0179_b07.s](round6/verified/fixed_0179_b07.s): out, 32.
- [round6/verified/fixed_0180_b07.s](round6/verified/fixed_0180_b07.s): out, 32.
- [round6/verified/fixed_0181_b07.s](round6/verified/fixed_0181_b07.s): out, 32.
- [round6/verified/fixed_0182_b07.s](round6/verified/fixed_0182_b07.s): out, 32.
- [round6/verified/fixed_0183_b07.s](round6/verified/fixed_0183_b07.s): out, 32.
- [round6/verified/fixed_0184_b07.s](round6/verified/fixed_0184_b07.s): out, 32.
- [round6/verified/fixed_0185_b07.s](round6/verified/fixed_0185_b07.s): out, 32.
- [round6/verified/fixed_0186_b07.s](round6/verified/fixed_0186_b07.s): out, 32.
- [round6/verified/fixed_0187_b07.s](round6/verified/fixed_0187_b07.s): out, 32.
- [round6/verified/fixed_0188_b07.s](round6/verified/fixed_0188_b07.s): out, 32.
- [round6/verified/fixed_0189_b07.s](round6/verified/fixed_0189_b07.s): out, 32.
- [round6/verified/fixed_0190_b07.s](round6/verified/fixed_0190_b07.s): out, 32.
- [round6/verified/fixed_0191_b07.s](round6/verified/fixed_0191_b07.s): out, 32.
- [round6/verified/fixed_0192_b07.s](round6/verified/fixed_0192_b07.s): out, 32.
- [round6/verified/fixed_0193_b08.s](round6/verified/fixed_0193_b08.s): out, 32.
- [round6/verified/fixed_0193_b08_mem.s](round6/verified/fixed_0193_b08_mem.s): mem, 42.
- [round6/verified/fixed_0194_b08.s](round6/verified/fixed_0194_b08.s): out, 32.
- [round6/verified/fixed_0195_b08.s](round6/verified/fixed_0195_b08.s): out, 32.
- [round6/verified/fixed_0196_b08.s](round6/verified/fixed_0196_b08.s): out, 32.
- [round6/verified/fixed_0197_b08.s](round6/verified/fixed_0197_b08.s): out, 32.
- [round6/verified/fixed_0198_b08.s](round6/verified/fixed_0198_b08.s): out, 32.
- [round6/verified/fixed_0199_b08.s](round6/verified/fixed_0199_b08.s): out, 32.
- [round6/verified/fixed_0200_b08.s](round6/verified/fixed_0200_b08.s): out, 32.
- [round6/verified/fixed_0201_b08.s](round6/verified/fixed_0201_b08.s): out, 32.
- [round6/verified/fixed_0202_b08.s](round6/verified/fixed_0202_b08.s): out, 32.
- [round6/verified/fixed_0203_b08.s](round6/verified/fixed_0203_b08.s): out, 32.
- [round6/verified/fixed_0204_b08.s](round6/verified/fixed_0204_b08.s): out, 32.
- [round6/verified/fixed_0205_b08.s](round6/verified/fixed_0205_b08.s): out, 32.
- [round6/verified/fixed_0206_b08.s](round6/verified/fixed_0206_b08.s): out, 32.
- [round6/verified/fixed_0207_b08.s](round6/verified/fixed_0207_b08.s): out, 32.
- [round6/verified/fixed_0208_b08.s](round6/verified/fixed_0208_b08.s): out, 32.
- [round6/verified/fixed_0209_b08.s](round6/verified/fixed_0209_b08.s): out, 32.
- [round6/verified/fixed_0210_b08.s](round6/verified/fixed_0210_b08.s): out, 32.
- [round6/verified/fixed_0211_b08.s](round6/verified/fixed_0211_b08.s): out, 32.
- [round6/verified/fixed_0212_b08.s](round6/verified/fixed_0212_b08.s): out, 32.
- [round6/verified/fixed_0213_b08.s](round6/verified/fixed_0213_b08.s): out, 32.
- [round6/verified/fixed_0214_b08.s](round6/verified/fixed_0214_b08.s): out, 32.
- [round6/verified/fixed_0215_b08.s](round6/verified/fixed_0215_b08.s): out, 32.
- [round6/verified/fixed_0216_b08.s](round6/verified/fixed_0216_b08.s): out, 32.
- [round6/verified/fixed_0217_b09.s](round6/verified/fixed_0217_b09.s): out, 32.
- [round6/verified/fixed_0217_b09_mem.s](round6/verified/fixed_0217_b09_mem.s): mem, 42.
- [round6/verified/fixed_0218_b09.s](round6/verified/fixed_0218_b09.s): out, 32.
- [round6/verified/fixed_0219_b09.s](round6/verified/fixed_0219_b09.s): out, 32.
- [round6/verified/fixed_0220_b09.s](round6/verified/fixed_0220_b09.s): out, 32.
- [round6/verified/fixed_0221_b09.s](round6/verified/fixed_0221_b09.s): out, 32.
- [round6/verified/fixed_0222_b09.s](round6/verified/fixed_0222_b09.s): out, 32.
- [round6/verified/fixed_0223_b09.s](round6/verified/fixed_0223_b09.s): out, 32.
- [round6/verified/fixed_0224_b09.s](round6/verified/fixed_0224_b09.s): out, 32.
- [round6/verified/fixed_0225_b09.s](round6/verified/fixed_0225_b09.s): out, 32.
- [round6/verified/fixed_0226_b09.s](round6/verified/fixed_0226_b09.s): out, 32.
- [round6/verified/fixed_0227_b09.s](round6/verified/fixed_0227_b09.s): out, 32.
- [round6/verified/fixed_0228_b09.s](round6/verified/fixed_0228_b09.s): out, 32.
- [round6/verified/fixed_0229_b09.s](round6/verified/fixed_0229_b09.s): out, 32.
- [round6/verified/fixed_0230_b09.s](round6/verified/fixed_0230_b09.s): out, 32.
- [round6/verified/fixed_0231_b09.s](round6/verified/fixed_0231_b09.s): out, 32.
- [round6/verified/fixed_0232_b09.s](round6/verified/fixed_0232_b09.s): out, 32.
- [round6/verified/fixed_0233_b09.s](round6/verified/fixed_0233_b09.s): out, 32.
- [round6/verified/fixed_0234_b09.s](round6/verified/fixed_0234_b09.s): out, 32.
- [round6/verified/fixed_0235_b09.s](round6/verified/fixed_0235_b09.s): out, 32.
- [round6/verified/fixed_0236_b09.s](round6/verified/fixed_0236_b09.s): out, 32.
- [round6/verified/fixed_0237_b09.s](round6/verified/fixed_0237_b09.s): out, 32.
- [round6/verified/fixed_0238_b09.s](round6/verified/fixed_0238_b09.s): out, 32.
- [round6/verified/fixed_0239_b09.s](round6/verified/fixed_0239_b09.s): out, 32.
- [round6/verified/fixed_0240_b09.s](round6/verified/fixed_0240_b09.s): out, 32.
- [round6/verified/fixed_0241_b10.s](round6/verified/fixed_0241_b10.s): out, 32.
- [round6/verified/fixed_0241_b10_mem.s](round6/verified/fixed_0241_b10_mem.s): mem, 42.
- [round6/verified/fixed_0242_b10.s](round6/verified/fixed_0242_b10.s): out, 32.
- [round6/verified/fixed_0243_b10.s](round6/verified/fixed_0243_b10.s): out, 32.
- [round6/verified/fixed_0244_b10.s](round6/verified/fixed_0244_b10.s): out, 32.
- [round6/verified/fixed_0245_b10.s](round6/verified/fixed_0245_b10.s): out, 32.
- [round6/verified/fixed_0246_b10.s](round6/verified/fixed_0246_b10.s): out, 32.
- [round6/verified/fixed_0247_b10.s](round6/verified/fixed_0247_b10.s): out, 32.
- [round6/verified/fixed_0248_b10.s](round6/verified/fixed_0248_b10.s): out, 32.
- [round6/verified/fixed_0249_b10.s](round6/verified/fixed_0249_b10.s): out, 32.
- [round6/verified/fixed_0250_b10.s](round6/verified/fixed_0250_b10.s): out, 32.
- [round6/verified/fixed_0251_b10.s](round6/verified/fixed_0251_b10.s): out, 32.
- [round6/verified/fixed_0252_b10.s](round6/verified/fixed_0252_b10.s): out, 32.
- [round6/verified/fixed_0253_b10.s](round6/verified/fixed_0253_b10.s): out, 32.
- [round6/verified/fixed_0254_b10.s](round6/verified/fixed_0254_b10.s): out, 32.
- [round6/verified/fixed_0255_b10.s](round6/verified/fixed_0255_b10.s): out, 32.
- [round6/verified/fixed_0256_b10.s](round6/verified/fixed_0256_b10.s): out, 32.
- [round6/verified/fixed_0257_b10.s](round6/verified/fixed_0257_b10.s): out, 32.
- [round6/verified/fixed_0258_b10.s](round6/verified/fixed_0258_b10.s): out, 32.
- [round6/verified/fixed_0259_b10.s](round6/verified/fixed_0259_b10.s): out, 32.
- [round6/verified/fixed_0260_b11.s](round6/verified/fixed_0260_b11.s): out, 32.
- [round6/verified/fixed_0260_b11_mem.s](round6/verified/fixed_0260_b11_mem.s): mem, 42.
- [round6/verified/fixed_0261_b11.s](round6/verified/fixed_0261_b11.s): out, 32.
- [round6/verified/fixed_0262_b11.s](round6/verified/fixed_0262_b11.s): out, 32.
- [round6/verified/fixed_0263_b11.s](round6/verified/fixed_0263_b11.s): out, 32.
- [round6/verified/fixed_0264_b11.s](round6/verified/fixed_0264_b11.s): out, 32.
- [round6/verified/fixed_0265_b11.s](round6/verified/fixed_0265_b11.s): out, 32.
- [round6/verified/fixed_0266_b11.s](round6/verified/fixed_0266_b11.s): out, 32.
- [round6/verified/fixed_0267_b11.s](round6/verified/fixed_0267_b11.s): out, 32.
- [round6/verified/fixed_0268_b11.s](round6/verified/fixed_0268_b11.s): out, 32.
- [round6/verified/fixed_0269_b11.s](round6/verified/fixed_0269_b11.s): out, 32.
- [round6/verified/fixed_0270_b11.s](round6/verified/fixed_0270_b11.s): out, 32.
- [round6/verified/fixed_0271_b11.s](round6/verified/fixed_0271_b11.s): out, 32.
- [round6/verified/fixed_0272_b11.s](round6/verified/fixed_0272_b11.s): out, 32.
- [round6/verified/fixed_0273_b11.s](round6/verified/fixed_0273_b11.s): out, 32.
- [round6/verified/fixed_0274_b11.s](round6/verified/fixed_0274_b11.s): out, 32.
- [round6/verified/fixed_0275_b11.s](round6/verified/fixed_0275_b11.s): out, 32.
- [round6/verified/fixed_0276_b11.s](round6/verified/fixed_0276_b11.s): out, 32.
- [round6/verified/fixed_0277_b11.s](round6/verified/fixed_0277_b11.s): out, 32.
- [round6/verified/fixed_0278_b11.s](round6/verified/fixed_0278_b11.s): out, 32.
- [round6/verified/fixed_0279_b11.s](round6/verified/fixed_0279_b11.s): out, 32.
- [round6/verified/fixed_0280_b11.s](round6/verified/fixed_0280_b11.s): out, 32.
- [round6/verified/fixed_0281_b12.s](round6/verified/fixed_0281_b12.s): out, 32.
- [round6/verified/fixed_0281_b12_mem.s](round6/verified/fixed_0281_b12_mem.s): mem, 42.
- [round6/verified/fixed_0282_b12.s](round6/verified/fixed_0282_b12.s): out, 32.
- [round6/verified/fixed_0283_b12.s](round6/verified/fixed_0283_b12.s): out, 32.
- [round6/verified/fixed_0284_b12.s](round6/verified/fixed_0284_b12.s): out, 32.
- [round6/verified/fixed_0285_b12.s](round6/verified/fixed_0285_b12.s): out, 32.
- [round6/verified/fixed_0286_b12.s](round6/verified/fixed_0286_b12.s): out, 32.
- [round6/verified/fixed_0287_b12.s](round6/verified/fixed_0287_b12.s): out, 32.
- [round6/verified/fixed_0288_b12.s](round6/verified/fixed_0288_b12.s): out, 32.
- [round6/verified/fixed_0289_b12.s](round6/verified/fixed_0289_b12.s): out, 32.
- [round6/verified/fixed_0290_b12.s](round6/verified/fixed_0290_b12.s): out, 32.
- [round6/verified/fixed_0291_b12.s](round6/verified/fixed_0291_b12.s): out, 32.
- [round6/verified/fixed_0292_b12.s](round6/verified/fixed_0292_b12.s): out, 32.
- [round6/verified/fixed_0293_b12.s](round6/verified/fixed_0293_b12.s): out, 32.
- [round6/verified/fixed_0294_b12.s](round6/verified/fixed_0294_b12.s): out, 32.
- [round6/verified/fixed_0295_b12.s](round6/verified/fixed_0295_b12.s): out, 32.
- [round6/verified/fixed_0296_b12.s](round6/verified/fixed_0296_b12.s): out, 32.
- [round6/verified/fixed_0297_b12.s](round6/verified/fixed_0297_b12.s): out, 32.
- [round6/verified/fixed_0298_b12.s](round6/verified/fixed_0298_b12.s): out, 32.
- [round6/verified/fixed_0299_b12.s](round6/verified/fixed_0299_b12.s): out, 32.
- [round6/verified/fixed_0300_b12.s](round6/verified/fixed_0300_b12.s): out, 32.
- [round6/verified/fixed_0301_b12.s](round6/verified/fixed_0301_b12.s): out, 32.
- [round6/verified/fixed_0302_b12.s](round6/verified/fixed_0302_b12.s): out, 32.
- [round6/verified/fixed_0303_b12.s](round6/verified/fixed_0303_b12.s): out, 32.
- [round6/verified/fixed_0304_b12.s](round6/verified/fixed_0304_b12.s): out, 32.
- [round6/verified/fixed_0305_b13.s](round6/verified/fixed_0305_b13.s): out, 32.
- [round6/verified/fixed_0305_b13_mem.s](round6/verified/fixed_0305_b13_mem.s): mem, 42.
- [round6/verified/fixed_0306_b13.s](round6/verified/fixed_0306_b13.s): out, 32.
- [round6/verified/fixed_0307_b13.s](round6/verified/fixed_0307_b13.s): out, 32.
- [round6/verified/fixed_0308_b13.s](round6/verified/fixed_0308_b13.s): out, 32.
- [round6/verified/fixed_0309_b13.s](round6/verified/fixed_0309_b13.s): out, 32.
- [round6/verified/fixed_0310_b13.s](round6/verified/fixed_0310_b13.s): out, 32.
- [round6/verified/fixed_0311_b13.s](round6/verified/fixed_0311_b13.s): out, 32.
- [round6/verified/fixed_0312_b13.s](round6/verified/fixed_0312_b13.s): out, 32.
- [round6/verified/fixed_0313_b13.s](round6/verified/fixed_0313_b13.s): out, 32.
- [round6/verified/fixed_0314_b13.s](round6/verified/fixed_0314_b13.s): out, 32.
- [round6/verified/fixed_0315_b13.s](round6/verified/fixed_0315_b13.s): out, 32.
- [round6/verified/fixed_0316_b13.s](round6/verified/fixed_0316_b13.s): out, 32.
- [round6/verified/fixed_0317_b13.s](round6/verified/fixed_0317_b13.s): out, 32.
- [round6/verified/fixed_0318_b13.s](round6/verified/fixed_0318_b13.s): out, 32.
- [round6/verified/fixed_0319_b13.s](round6/verified/fixed_0319_b13.s): out, 32.
- [round6/verified/fixed_0320_b13.s](round6/verified/fixed_0320_b13.s): out, 32.
- [round6/verified/fixed_0321_b13.s](round6/verified/fixed_0321_b13.s): out, 32.
- [round6/verified/fixed_0322_b13.s](round6/verified/fixed_0322_b13.s): out, 32.
- [round6/verified/fixed_0323_b13.s](round6/verified/fixed_0323_b13.s): out, 32.
- [round6/verified/fixed_0324_b13.s](round6/verified/fixed_0324_b13.s): out, 32.
- [round6/verified/fixed_0325_b13.s](round6/verified/fixed_0325_b13.s): out, 32.
- [round6/verified/fixed_0326_b13.s](round6/verified/fixed_0326_b13.s): out, 32.
- [round6/verified/fixed_0327_b13.s](round6/verified/fixed_0327_b13.s): out, 32.
- [round6/verified/fixed_0328_b13.s](round6/verified/fixed_0328_b13.s): out, 32.
- [round6/verified/fixed_0329_b14.s](round6/verified/fixed_0329_b14.s): out, 32.
- [round6/verified/fixed_0329_b14_mem.s](round6/verified/fixed_0329_b14_mem.s): mem, 42.
- [round6/verified/fixed_0330_b14.s](round6/verified/fixed_0330_b14.s): out, 32.
- [round6/verified/fixed_0331_b14.s](round6/verified/fixed_0331_b14.s): out, 32.
- [round6/verified/fixed_0332_b14.s](round6/verified/fixed_0332_b14.s): out, 32.
- [round6/verified/fixed_0333_b14.s](round6/verified/fixed_0333_b14.s): out, 32.
- [round6/verified/fixed_0334_b14.s](round6/verified/fixed_0334_b14.s): out, 32.
- [round6/verified/fixed_0335_b14.s](round6/verified/fixed_0335_b14.s): out, 32.
- [round6/verified/fixed_0336_b14.s](round6/verified/fixed_0336_b14.s): out, 32.
- [round6/verified/fixed_0337_b14.s](round6/verified/fixed_0337_b14.s): out, 32.
- [round6/verified/fixed_0338_b14.s](round6/verified/fixed_0338_b14.s): out, 32.
- [round6/verified/fixed_0339_b14.s](round6/verified/fixed_0339_b14.s): out, 32.
- [round6/verified/fixed_0340_b14.s](round6/verified/fixed_0340_b14.s): out, 32.
- [round6/verified/fixed_0341_b14.s](round6/verified/fixed_0341_b14.s): out, 32.
- [round6/verified/fixed_0342_b14.s](round6/verified/fixed_0342_b14.s): out, 32.
- [round6/verified/fixed_0343_b14.s](round6/verified/fixed_0343_b14.s): out, 32.
- [round6/verified/fixed_0344_b14.s](round6/verified/fixed_0344_b14.s): out, 32.
- [round6/verified/fixed_0345_b14.s](round6/verified/fixed_0345_b14.s): out, 32.
- [round6/verified/fixed_0346_b14.s](round6/verified/fixed_0346_b14.s): out, 32.
- [round6/verified/fixed_0347_b14.s](round6/verified/fixed_0347_b14.s): out, 32.
- [round6/verified/fixed_0348_b14.s](round6/verified/fixed_0348_b14.s): out, 32.
- [round6/verified/fixed_0349_b14.s](round6/verified/fixed_0349_b14.s): out, 32.
- [round6/verified/fixed_0350_b14.s](round6/verified/fixed_0350_b14.s): out, 32.
- [round6/verified/fixed_0351_b14.s](round6/verified/fixed_0351_b14.s): out, 32.
- [round6/verified/fixed_0352_b15.s](round6/verified/fixed_0352_b15.s): out, 32.
- [round6/verified/fixed_0352_b15_mem.s](round6/verified/fixed_0352_b15_mem.s): mem, 42.
- [round6/verified/fixed_0353_b15.s](round6/verified/fixed_0353_b15.s): out, 32.
- [round6/verified/fixed_0354_b15.s](round6/verified/fixed_0354_b15.s): out, 32.
- [round6/verified/fixed_0355_b15.s](round6/verified/fixed_0355_b15.s): out, 32.
- [round6/verified/fixed_0356_b15.s](round6/verified/fixed_0356_b15.s): out, 32.
- [round6/verified/fixed_0357_b15.s](round6/verified/fixed_0357_b15.s): out, 32.
- [round6/verified/fixed_0358_b15.s](round6/verified/fixed_0358_b15.s): out, 32.
- [round6/verified/fixed_0359_b15.s](round6/verified/fixed_0359_b15.s): out, 32.
- [round6/verified/fixed_0360_b15.s](round6/verified/fixed_0360_b15.s): out, 32.
- [round6/verified/fixed_0361_b15.s](round6/verified/fixed_0361_b15.s): out, 32.
- [round6/verified/fixed_0362_b15.s](round6/verified/fixed_0362_b15.s): out, 32.
- [round6/verified/fixed_0363_b15.s](round6/verified/fixed_0363_b15.s): out, 32.
- [round6/verified/fixed_0364_b15.s](round6/verified/fixed_0364_b15.s): out, 32.
- [round6/verified/fixed_0365_b15.s](round6/verified/fixed_0365_b15.s): out, 32.
- [round6/verified/fixed_0366_b15.s](round6/verified/fixed_0366_b15.s): out, 32.
- [round6/verified/fixed_0367_b15.s](round6/verified/fixed_0367_b15.s): out, 32.
- [round6/verified/fixed_0368_b15.s](round6/verified/fixed_0368_b15.s): out, 32.
- [round6/verified/fixed_0369_b15.s](round6/verified/fixed_0369_b15.s): out, 32.
- [round6/verified/fixed_0370_b15.s](round6/verified/fixed_0370_b15.s): out, 32.
- [round6/verified/fixed_0371_b15.s](round6/verified/fixed_0371_b15.s): out, 32.
- [round6/verified/fixed_0372_b15.s](round6/verified/fixed_0372_b15.s): out, 32.
- [round6/verified/fixed_0373_b15.s](round6/verified/fixed_0373_b15.s): out, 32.
- [round6/verified/free_0000_b00.s](round6/verified/free_0000_b00.s): out, 32.
- [round6/verified/free_0000_b00_mem.s](round6/verified/free_0000_b00_mem.s): mem, 42.
- [round6/verified/free_0001_b00.s](round6/verified/free_0001_b00.s): out, 32.
- [round6/verified/free_0002_b00.s](round6/verified/free_0002_b00.s): out, 32.
- [round6/verified/free_0003_b00.s](round6/verified/free_0003_b00.s): out, 32.
- [round6/verified/free_0004_b00.s](round6/verified/free_0004_b00.s): out, 32.
- [round6/verified/free_0005_b00.s](round6/verified/free_0005_b00.s): out, 32.
- [round6/verified/free_0006_b00.s](round6/verified/free_0006_b00.s): out, 32.
- [round6/verified/free_0007_b00.s](round6/verified/free_0007_b00.s): out, 32.
- [round6/verified/free_0008_b00.s](round6/verified/free_0008_b00.s): out, 32.
- [round6/verified/free_0009_b00.s](round6/verified/free_0009_b00.s): out, 32.
- [round6/verified/free_0010_b00.s](round6/verified/free_0010_b00.s): out, 32.
- [round6/verified/free_0011_b00.s](round6/verified/free_0011_b00.s): out, 32.
- [round6/verified/free_0012_b00.s](round6/verified/free_0012_b00.s): out, 32.
- [round6/verified/free_0013_b00.s](round6/verified/free_0013_b00.s): out, 32.
- [round6/verified/free_0014_b00.s](round6/verified/free_0014_b00.s): out, 32.
- [round6/verified/free_0015_b00.s](round6/verified/free_0015_b00.s): out, 32.
- [round6/verified/free_0016_b00.s](round6/verified/free_0016_b00.s): out, 32.
- [round6/verified/free_0017_b00.s](round6/verified/free_0017_b00.s): out, 32.
- [round6/verified/free_0018_b00.s](round6/verified/free_0018_b00.s): out, 32.
- [round6/verified/free_0019_b00.s](round6/verified/free_0019_b00.s): out, 32.
- [round6/verified/free_0020_b01.s](round6/verified/free_0020_b01.s): out, 32.
- [round6/verified/free_0020_b01_mem.s](round6/verified/free_0020_b01_mem.s): mem, 42.
- [round6/verified/free_0021_b01.s](round6/verified/free_0021_b01.s): out, 32.
- [round6/verified/free_0022_b01.s](round6/verified/free_0022_b01.s): out, 32.
- [round6/verified/free_0023_b01.s](round6/verified/free_0023_b01.s): out, 32.
- [round6/verified/free_0024_b01.s](round6/verified/free_0024_b01.s): out, 32.
- [round6/verified/free_0025_b01.s](round6/verified/free_0025_b01.s): out, 32.
- [round6/verified/free_0026_b01.s](round6/verified/free_0026_b01.s): out, 32.
- [round6/verified/free_0027_b01.s](round6/verified/free_0027_b01.s): out, 32.
- [round6/verified/free_0028_b01.s](round6/verified/free_0028_b01.s): out, 32.
- [round6/verified/free_0029_b01.s](round6/verified/free_0029_b01.s): out, 32.
- [round6/verified/free_0030_b01.s](round6/verified/free_0030_b01.s): out, 32.
- [round6/verified/free_0031_b01.s](round6/verified/free_0031_b01.s): out, 32.
- [round6/verified/free_0032_b01.s](round6/verified/free_0032_b01.s): out, 32.
- [round6/verified/free_0033_b01.s](round6/verified/free_0033_b01.s): out, 32.
- [round6/verified/free_0034_b01.s](round6/verified/free_0034_b01.s): out, 32.
- [round6/verified/free_0035_b01.s](round6/verified/free_0035_b01.s): out, 32.
- [round6/verified/free_0036_b01.s](round6/verified/free_0036_b01.s): out, 32.
- [round6/verified/free_0037_b01.s](round6/verified/free_0037_b01.s): out, 32.
- [round6/verified/free_0038_b01.s](round6/verified/free_0038_b01.s): out, 32.
- [round6/verified/free_0039_b01.s](round6/verified/free_0039_b01.s): out, 32.
- [round6/verified/free_0040_b02.s](round6/verified/free_0040_b02.s): out, 32.
- [round6/verified/free_0040_b02_mem.s](round6/verified/free_0040_b02_mem.s): mem, 42.
- [round6/verified/free_0041_b02.s](round6/verified/free_0041_b02.s): out, 32.
- [round6/verified/free_0042_b02.s](round6/verified/free_0042_b02.s): out, 32.
- [round6/verified/free_0043_b02.s](round6/verified/free_0043_b02.s): out, 32.
- [round6/verified/free_0044_b02.s](round6/verified/free_0044_b02.s): out, 32.
- [round6/verified/free_0045_b02.s](round6/verified/free_0045_b02.s): out, 32.
- [round6/verified/free_0046_b02.s](round6/verified/free_0046_b02.s): out, 32.
- [round6/verified/free_0047_b02.s](round6/verified/free_0047_b02.s): out, 32.
- [round6/verified/free_0048_b02.s](round6/verified/free_0048_b02.s): out, 32.
- [round6/verified/free_0049_b02.s](round6/verified/free_0049_b02.s): out, 32.
- [round6/verified/free_0050_b02.s](round6/verified/free_0050_b02.s): out, 32.
- [round6/verified/free_0051_b02.s](round6/verified/free_0051_b02.s): out, 32.
- [round6/verified/free_0052_b02.s](round6/verified/free_0052_b02.s): out, 32.
- [round6/verified/free_0053_b02.s](round6/verified/free_0053_b02.s): out, 32.
- [round6/verified/free_0054_b02.s](round6/verified/free_0054_b02.s): out, 32.
- [round6/verified/free_0055_b02.s](round6/verified/free_0055_b02.s): out, 32.
- [round6/verified/free_0056_b02.s](round6/verified/free_0056_b02.s): out, 32.
- [round6/verified/free_0057_b02.s](round6/verified/free_0057_b02.s): out, 32.
- [round6/verified/free_0058_b02.s](round6/verified/free_0058_b02.s): out, 32.
- [round6/verified/free_0059_b02.s](round6/verified/free_0059_b02.s): out, 32.
- [round6/verified/free_0060_b02.s](round6/verified/free_0060_b02.s): out, 32.
- [round6/verified/free_0061_b02.s](round6/verified/free_0061_b02.s): out, 32.
- [round6/verified/free_0062_b02.s](round6/verified/free_0062_b02.s): out, 32.
- [round6/verified/free_0063_b02.s](round6/verified/free_0063_b02.s): out, 32.
- [round6/verified/free_0064_b02.s](round6/verified/free_0064_b02.s): out, 32.
- [round6/verified/free_0065_b03.s](round6/verified/free_0065_b03.s): out, 32.
- [round6/verified/free_0065_b03_mem.s](round6/verified/free_0065_b03_mem.s): mem, 42.
- [round6/verified/free_0066_b03.s](round6/verified/free_0066_b03.s): out, 32.
- [round6/verified/free_0067_b03.s](round6/verified/free_0067_b03.s): out, 32.
- [round6/verified/free_0068_b03.s](round6/verified/free_0068_b03.s): out, 32.
- [round6/verified/free_0069_b03.s](round6/verified/free_0069_b03.s): out, 32.
- [round6/verified/free_0070_b03.s](round6/verified/free_0070_b03.s): out, 32.
- [round6/verified/free_0071_b03.s](round6/verified/free_0071_b03.s): out, 32.
- [round6/verified/free_0072_b03.s](round6/verified/free_0072_b03.s): out, 32.
- [round6/verified/free_0073_b03.s](round6/verified/free_0073_b03.s): out, 32.
- [round6/verified/free_0074_b03.s](round6/verified/free_0074_b03.s): out, 32.
- [round6/verified/free_0075_b03.s](round6/verified/free_0075_b03.s): out, 32.
- [round6/verified/free_0076_b03.s](round6/verified/free_0076_b03.s): out, 32.
- [round6/verified/free_0077_b03.s](round6/verified/free_0077_b03.s): out, 32.
- [round6/verified/free_0078_b03.s](round6/verified/free_0078_b03.s): out, 32.
- [round6/verified/free_0079_b03.s](round6/verified/free_0079_b03.s): out, 32.
- [round6/verified/free_0080_b03.s](round6/verified/free_0080_b03.s): out, 32.
- [round6/verified/free_0081_b03.s](round6/verified/free_0081_b03.s): out, 32.
- [round6/verified/free_0082_b03.s](round6/verified/free_0082_b03.s): out, 32.
- [round6/verified/free_0083_b03.s](round6/verified/free_0083_b03.s): out, 32.
- [round6/verified/free_0084_b03.s](round6/verified/free_0084_b03.s): out, 32.
- [round6/verified/free_0085_b03.s](round6/verified/free_0085_b03.s): out, 32.
- [round6/verified/free_0086_b03.s](round6/verified/free_0086_b03.s): out, 32.
- [round6/verified/free_0087_b03.s](round6/verified/free_0087_b03.s): out, 32.
- [round6/verified/free_0088_b03.s](round6/verified/free_0088_b03.s): out, 32.
- [round6/verified/free_0089_b03.s](round6/verified/free_0089_b03.s): out, 32.
- [round6/verified/free_0090_b04.s](round6/verified/free_0090_b04.s): out, 32.
- [round6/verified/free_0090_b04_mem.s](round6/verified/free_0090_b04_mem.s): mem, 42.
- [round6/verified/free_0091_b04.s](round6/verified/free_0091_b04.s): out, 32.
- [round6/verified/free_0092_b04.s](round6/verified/free_0092_b04.s): out, 32.
- [round6/verified/free_0093_b04.s](round6/verified/free_0093_b04.s): out, 32.
- [round6/verified/free_0094_b04.s](round6/verified/free_0094_b04.s): out, 32.
- [round6/verified/free_0095_b04.s](round6/verified/free_0095_b04.s): out, 32.
- [round6/verified/free_0096_b04.s](round6/verified/free_0096_b04.s): out, 32.
- [round6/verified/free_0097_b04.s](round6/verified/free_0097_b04.s): out, 32.
- [round6/verified/free_0098_b04.s](round6/verified/free_0098_b04.s): out, 32.
- [round6/verified/free_0099_b04.s](round6/verified/free_0099_b04.s): out, 32.
- [round6/verified/free_0100_b04.s](round6/verified/free_0100_b04.s): out, 32.
- [round6/verified/free_0101_b04.s](round6/verified/free_0101_b04.s): out, 32.
- [round6/verified/free_0102_b04.s](round6/verified/free_0102_b04.s): out, 32.
- [round6/verified/free_0103_b04.s](round6/verified/free_0103_b04.s): out, 32.
- [round6/verified/free_0104_b04.s](round6/verified/free_0104_b04.s): out, 32.
- [round6/verified/free_0105_b04.s](round6/verified/free_0105_b04.s): out, 32.
- [round6/verified/free_0106_b04.s](round6/verified/free_0106_b04.s): out, 32.
- [round6/verified/free_0107_b04.s](round6/verified/free_0107_b04.s): out, 32.
- [round6/verified/free_0108_b04.s](round6/verified/free_0108_b04.s): out, 32.
- [round6/verified/free_0109_b04.s](round6/verified/free_0109_b04.s): out, 32.
- [round6/verified/free_0110_b04.s](round6/verified/free_0110_b04.s): out, 32.
- [round6/verified/free_0111_b04.s](round6/verified/free_0111_b04.s): out, 32.
- [round6/verified/free_0112_b04.s](round6/verified/free_0112_b04.s): out, 32.
- [round6/verified/free_0113_b05.s](round6/verified/free_0113_b05.s): out, 32.
- [round6/verified/free_0113_b05_mem.s](round6/verified/free_0113_b05_mem.s): mem, 42.
- [round6/verified/free_0114_b05.s](round6/verified/free_0114_b05.s): out, 32.
- [round6/verified/free_0115_b05.s](round6/verified/free_0115_b05.s): out, 32.
- [round6/verified/free_0116_b05.s](round6/verified/free_0116_b05.s): out, 32.
- [round6/verified/free_0117_b05.s](round6/verified/free_0117_b05.s): out, 32.
- [round6/verified/free_0118_b05.s](round6/verified/free_0118_b05.s): out, 32.
- [round6/verified/free_0119_b05.s](round6/verified/free_0119_b05.s): out, 32.
- [round6/verified/free_0120_b05.s](round6/verified/free_0120_b05.s): out, 32.
- [round6/verified/free_0121_b05.s](round6/verified/free_0121_b05.s): out, 32.
- [round6/verified/free_0122_b05.s](round6/verified/free_0122_b05.s): out, 32.
- [round6/verified/free_0123_b05.s](round6/verified/free_0123_b05.s): out, 32.
- [round6/verified/free_0124_b05.s](round6/verified/free_0124_b05.s): out, 32.
- [round6/verified/free_0125_b05.s](round6/verified/free_0125_b05.s): out, 32.
- [round6/verified/free_0126_b05.s](round6/verified/free_0126_b05.s): out, 32.
- [round6/verified/free_0127_b05.s](round6/verified/free_0127_b05.s): out, 32.
- [round6/verified/free_0128_b05.s](round6/verified/free_0128_b05.s): out, 32.
- [round6/verified/free_0129_b05.s](round6/verified/free_0129_b05.s): out, 32.
- [round6/verified/free_0130_b05.s](round6/verified/free_0130_b05.s): out, 32.
- [round6/verified/free_0131_b05.s](round6/verified/free_0131_b05.s): out, 32.
- [round6/verified/free_0132_b05.s](round6/verified/free_0132_b05.s): out, 32.
- [round6/verified/free_0133_b05.s](round6/verified/free_0133_b05.s): out, 32.
- [round6/verified/free_0134_b05.s](round6/verified/free_0134_b05.s): out, 32.
- [round6/verified/free_0135_b05.s](round6/verified/free_0135_b05.s): out, 32.
- [round6/verified/free_0136_b06.s](round6/verified/free_0136_b06.s): out, 32.
- [round6/verified/free_0136_b06_mem.s](round6/verified/free_0136_b06_mem.s): mem, 42.
- [round6/verified/free_0137_b06.s](round6/verified/free_0137_b06.s): out, 32.
- [round6/verified/free_0138_b06.s](round6/verified/free_0138_b06.s): out, 32.
- [round6/verified/free_0139_b06.s](round6/verified/free_0139_b06.s): out, 32.
- [round6/verified/free_0140_b06.s](round6/verified/free_0140_b06.s): out, 32.
- [round6/verified/free_0141_b06.s](round6/verified/free_0141_b06.s): out, 32.
- [round6/verified/free_0142_b06.s](round6/verified/free_0142_b06.s): out, 32.
- [round6/verified/free_0143_b06.s](round6/verified/free_0143_b06.s): out, 32.
- [round6/verified/free_0144_b06.s](round6/verified/free_0144_b06.s): out, 32.
- [round6/verified/free_0145_b06.s](round6/verified/free_0145_b06.s): out, 32.
- [round6/verified/free_0146_b06.s](round6/verified/free_0146_b06.s): out, 32.
- [round6/verified/free_0147_b06.s](round6/verified/free_0147_b06.s): out, 32.
- [round6/verified/free_0148_b06.s](round6/verified/free_0148_b06.s): out, 32.
- [round6/verified/free_0149_b06.s](round6/verified/free_0149_b06.s): out, 32.
- [round6/verified/free_0150_b06.s](round6/verified/free_0150_b06.s): out, 32.
- [round6/verified/free_0151_b06.s](round6/verified/free_0151_b06.s): out, 32.
- [round6/verified/free_0152_b06.s](round6/verified/free_0152_b06.s): out, 32.
- [round6/verified/free_0153_b06.s](round6/verified/free_0153_b06.s): out, 32.
- [round6/verified/free_0154_b06.s](round6/verified/free_0154_b06.s): out, 32.
- [round6/verified/free_0155_b06.s](round6/verified/free_0155_b06.s): out, 32.
- [round6/verified/free_0156_b06.s](round6/verified/free_0156_b06.s): out, 32.
- [round6/verified/free_0157_b06.s](round6/verified/free_0157_b06.s): out, 32.
- [round6/verified/free_0158_b06.s](round6/verified/free_0158_b06.s): out, 32.
- [round6/verified/free_0159_b06.s](round6/verified/free_0159_b06.s): out, 32.
- [round6/verified/free_0160_b07.s](round6/verified/free_0160_b07.s): out, 32.
- [round6/verified/free_0160_b07_mem.s](round6/verified/free_0160_b07_mem.s): mem, 42.
- [round6/verified/free_0161_b07.s](round6/verified/free_0161_b07.s): out, 32.
- [round6/verified/free_0162_b07.s](round6/verified/free_0162_b07.s): out, 32.
- [round6/verified/free_0163_b07.s](round6/verified/free_0163_b07.s): out, 32.
- [round6/verified/free_0164_b07.s](round6/verified/free_0164_b07.s): out, 32.
- [round6/verified/free_0165_b07.s](round6/verified/free_0165_b07.s): out, 32.
- [round6/verified/free_0166_b07.s](round6/verified/free_0166_b07.s): out, 32.
- [round6/verified/free_0167_b07.s](round6/verified/free_0167_b07.s): out, 32.
- [round6/verified/free_0168_b07.s](round6/verified/free_0168_b07.s): out, 32.
- [round6/verified/free_0169_b07.s](round6/verified/free_0169_b07.s): out, 32.
- [round6/verified/free_0170_b07.s](round6/verified/free_0170_b07.s): out, 32.
- [round6/verified/free_0171_b07.s](round6/verified/free_0171_b07.s): out, 32.
- [round6/verified/free_0172_b07.s](round6/verified/free_0172_b07.s): out, 32.
- [round6/verified/free_0173_b07.s](round6/verified/free_0173_b07.s): out, 32.
- [round6/verified/free_0174_b07.s](round6/verified/free_0174_b07.s): out, 32.
- [round6/verified/free_0175_b07.s](round6/verified/free_0175_b07.s): out, 32.
- [round6/verified/free_0176_b07.s](round6/verified/free_0176_b07.s): out, 32.
- [round6/verified/free_0177_b07.s](round6/verified/free_0177_b07.s): out, 32.
- [round6/verified/free_0178_b07.s](round6/verified/free_0178_b07.s): out, 32.
- [round6/verified/free_0179_b07.s](round6/verified/free_0179_b07.s): out, 32.
- [round6/verified/free_0180_b07.s](round6/verified/free_0180_b07.s): out, 32.
- [round6/verified/free_0181_b07.s](round6/verified/free_0181_b07.s): out, 32.
- [round6/verified/free_0182_b07.s](round6/verified/free_0182_b07.s): out, 32.
- [round6/verified/free_0183_b07.s](round6/verified/free_0183_b07.s): out, 32.
- [round6/verified/free_0184_b08.s](round6/verified/free_0184_b08.s): out, 32.
- [round6/verified/free_0184_b08_mem.s](round6/verified/free_0184_b08_mem.s): mem, 42.
- [round6/verified/free_0185_b08.s](round6/verified/free_0185_b08.s): out, 32.
- [round6/verified/free_0186_b08.s](round6/verified/free_0186_b08.s): out, 32.
- [round6/verified/free_0187_b08.s](round6/verified/free_0187_b08.s): out, 32.
- [round6/verified/free_0188_b08.s](round6/verified/free_0188_b08.s): out, 32.
- [round6/verified/free_0189_b08.s](round6/verified/free_0189_b08.s): out, 32.
- [round6/verified/free_0190_b08.s](round6/verified/free_0190_b08.s): out, 32.
- [round6/verified/free_0191_b08.s](round6/verified/free_0191_b08.s): out, 32.
- [round6/verified/free_0192_b08.s](round6/verified/free_0192_b08.s): out, 32.
- [round6/verified/free_0193_b08.s](round6/verified/free_0193_b08.s): out, 32.
- [round6/verified/free_0194_b08.s](round6/verified/free_0194_b08.s): out, 32.
- [round6/verified/free_0195_b08.s](round6/verified/free_0195_b08.s): out, 32.
- [round6/verified/free_0196_b08.s](round6/verified/free_0196_b08.s): out, 32.
- [round6/verified/free_0197_b08.s](round6/verified/free_0197_b08.s): out, 32.
- [round6/verified/free_0198_b08.s](round6/verified/free_0198_b08.s): out, 32.
- [round6/verified/free_0199_b08.s](round6/verified/free_0199_b08.s): out, 32.
- [round6/verified/free_0200_b08.s](round6/verified/free_0200_b08.s): out, 32.
- [round6/verified/free_0201_b08.s](round6/verified/free_0201_b08.s): out, 32.
- [round6/verified/free_0202_b08.s](round6/verified/free_0202_b08.s): out, 32.
- [round6/verified/free_0203_b08.s](round6/verified/free_0203_b08.s): out, 32.
- [round6/verified/free_0204_b08.s](round6/verified/free_0204_b08.s): out, 32.
- [round6/verified/free_0205_b09.s](round6/verified/free_0205_b09.s): out, 32.
- [round6/verified/free_0205_b09_mem.s](round6/verified/free_0205_b09_mem.s): mem, 42.
- [round6/verified/free_0206_b09.s](round6/verified/free_0206_b09.s): out, 32.
- [round6/verified/free_0207_b09.s](round6/verified/free_0207_b09.s): out, 32.
- [round6/verified/free_0208_b09.s](round6/verified/free_0208_b09.s): out, 32.
- [round6/verified/free_0209_b09.s](round6/verified/free_0209_b09.s): out, 32.
- [round6/verified/free_0210_b09.s](round6/verified/free_0210_b09.s): out, 32.
- [round6/verified/free_0211_b09.s](round6/verified/free_0211_b09.s): out, 32.
- [round6/verified/free_0212_b09.s](round6/verified/free_0212_b09.s): out, 32.
- [round6/verified/free_0213_b09.s](round6/verified/free_0213_b09.s): out, 32.
- [round6/verified/free_0214_b09.s](round6/verified/free_0214_b09.s): out, 32.
- [round6/verified/free_0215_b09.s](round6/verified/free_0215_b09.s): out, 32.
- [round6/verified/free_0216_b09.s](round6/verified/free_0216_b09.s): out, 32.
- [round6/verified/free_0217_b09.s](round6/verified/free_0217_b09.s): out, 32.
- [round6/verified/free_0218_b09.s](round6/verified/free_0218_b09.s): out, 32.
- [round6/verified/free_0219_b09.s](round6/verified/free_0219_b09.s): out, 32.
- [round6/verified/free_0220_b09.s](round6/verified/free_0220_b09.s): out, 32.
- [round6/verified/free_0221_b09.s](round6/verified/free_0221_b09.s): out, 32.
- [round6/verified/free_0222_b09.s](round6/verified/free_0222_b09.s): out, 32.
- [round6/verified/free_0223_b09.s](round6/verified/free_0223_b09.s): out, 32.
- [round6/verified/free_0224_b09.s](round6/verified/free_0224_b09.s): out, 32.
- [round6/verified/free_0225_b09.s](round6/verified/free_0225_b09.s): out, 32.
- [round6/verified/free_0226_b09.s](round6/verified/free_0226_b09.s): out, 32.
- [round6/verified/free_0227_b09.s](round6/verified/free_0227_b09.s): out, 32.
- [round6/verified/free_0228_b09.s](round6/verified/free_0228_b09.s): out, 32.
- [round6/verified/free_0229_b10.s](round6/verified/free_0229_b10.s): out, 32.
- [round6/verified/free_0229_b10_mem.s](round6/verified/free_0229_b10_mem.s): mem, 42.
- [round6/verified/free_0230_b10.s](round6/verified/free_0230_b10.s): out, 32.
- [round6/verified/free_0231_b10.s](round6/verified/free_0231_b10.s): out, 32.
- [round6/verified/free_0232_b10.s](round6/verified/free_0232_b10.s): out, 32.
- [round6/verified/free_0233_b10.s](round6/verified/free_0233_b10.s): out, 32.
- [round6/verified/free_0234_b10.s](round6/verified/free_0234_b10.s): out, 32.
- [round6/verified/free_0235_b10.s](round6/verified/free_0235_b10.s): out, 32.
- [round6/verified/free_0236_b10.s](round6/verified/free_0236_b10.s): out, 32.
- [round6/verified/free_0237_b10.s](round6/verified/free_0237_b10.s): out, 32.
- [round6/verified/free_0238_b10.s](round6/verified/free_0238_b10.s): out, 32.
- [round6/verified/free_0239_b10.s](round6/verified/free_0239_b10.s): out, 32.
- [round6/verified/free_0240_b10.s](round6/verified/free_0240_b10.s): out, 32.
- [round6/verified/free_0241_b10.s](round6/verified/free_0241_b10.s): out, 32.
- [round6/verified/free_0242_b10.s](round6/verified/free_0242_b10.s): out, 32.
- [round6/verified/free_0243_b10.s](round6/verified/free_0243_b10.s): out, 32.
- [round6/verified/free_0244_b10.s](round6/verified/free_0244_b10.s): out, 32.
- [round6/verified/free_0245_b10.s](round6/verified/free_0245_b10.s): out, 32.
- [round6/verified/free_0246_b10.s](round6/verified/free_0246_b10.s): out, 32.
- [round6/verified/free_0247_b10.s](round6/verified/free_0247_b10.s): out, 32.
- [round6/verified/free_0248_b11.s](round6/verified/free_0248_b11.s): out, 32.
- [round6/verified/free_0248_b11_mem.s](round6/verified/free_0248_b11_mem.s): mem, 42.
- [round6/verified/free_0249_b11.s](round6/verified/free_0249_b11.s): out, 32.
- [round6/verified/free_0250_b11.s](round6/verified/free_0250_b11.s): out, 32.
- [round6/verified/free_0251_b11.s](round6/verified/free_0251_b11.s): out, 32.
- [round6/verified/free_0252_b11.s](round6/verified/free_0252_b11.s): out, 32.
- [round6/verified/free_0253_b11.s](round6/verified/free_0253_b11.s): out, 32.
- [round6/verified/free_0254_b11.s](round6/verified/free_0254_b11.s): out, 32.
- [round6/verified/free_0255_b11.s](round6/verified/free_0255_b11.s): out, 32.
- [round6/verified/free_0256_b11.s](round6/verified/free_0256_b11.s): out, 32.
- [round6/verified/free_0257_b11.s](round6/verified/free_0257_b11.s): out, 32.
- [round6/verified/free_0258_b11.s](round6/verified/free_0258_b11.s): out, 32.
- [round6/verified/free_0259_b11.s](round6/verified/free_0259_b11.s): out, 32.
- [round6/verified/free_0260_b11.s](round6/verified/free_0260_b11.s): out, 32.
- [round6/verified/free_0261_b11.s](round6/verified/free_0261_b11.s): out, 32.
- [round6/verified/free_0262_b11.s](round6/verified/free_0262_b11.s): out, 32.
- [round6/verified/free_0263_b11.s](round6/verified/free_0263_b11.s): out, 32.
- [round6/verified/free_0264_b11.s](round6/verified/free_0264_b11.s): out, 32.
- [round6/verified/free_0265_b11.s](round6/verified/free_0265_b11.s): out, 32.
- [round6/verified/free_0266_b11.s](round6/verified/free_0266_b11.s): out, 32.
- [round6/verified/free_0267_b11.s](round6/verified/free_0267_b11.s): out, 32.
- [round6/verified/free_0268_b11.s](round6/verified/free_0268_b11.s): out, 32.
- [round6/verified/free_0269_b12.s](round6/verified/free_0269_b12.s): out, 32.
- [round6/verified/free_0269_b12_mem.s](round6/verified/free_0269_b12_mem.s): mem, 42.
- [round6/verified/free_0270_b12.s](round6/verified/free_0270_b12.s): out, 32.
- [round6/verified/free_0271_b12.s](round6/verified/free_0271_b12.s): out, 32.
- [round6/verified/free_0272_b12.s](round6/verified/free_0272_b12.s): out, 32.
- [round6/verified/free_0273_b12.s](round6/verified/free_0273_b12.s): out, 32.
- [round6/verified/free_0274_b12.s](round6/verified/free_0274_b12.s): out, 32.
- [round6/verified/free_0275_b12.s](round6/verified/free_0275_b12.s): out, 32.
- [round6/verified/free_0276_b12.s](round6/verified/free_0276_b12.s): out, 32.
- [round6/verified/free_0277_b12.s](round6/verified/free_0277_b12.s): out, 32.
- [round6/verified/free_0278_b12.s](round6/verified/free_0278_b12.s): out, 32.
- [round6/verified/free_0279_b12.s](round6/verified/free_0279_b12.s): out, 32.
- [round6/verified/free_0280_b12.s](round6/verified/free_0280_b12.s): out, 32.
- [round6/verified/free_0281_b12.s](round6/verified/free_0281_b12.s): out, 32.
- [round6/verified/free_0282_b12.s](round6/verified/free_0282_b12.s): out, 32.
- [round6/verified/free_0283_b12.s](round6/verified/free_0283_b12.s): out, 32.
- [round6/verified/free_0284_b12.s](round6/verified/free_0284_b12.s): out, 32.
- [round6/verified/free_0285_b12.s](round6/verified/free_0285_b12.s): out, 32.
- [round6/verified/free_0286_b12.s](round6/verified/free_0286_b12.s): out, 32.
- [round6/verified/free_0287_b12.s](round6/verified/free_0287_b12.s): out, 32.
- [round6/verified/free_0288_b12.s](round6/verified/free_0288_b12.s): out, 32.
- [round6/verified/free_0289_b12.s](round6/verified/free_0289_b12.s): out, 32.
- [round6/verified/free_0290_b13.s](round6/verified/free_0290_b13.s): out, 32.
- [round6/verified/free_0290_b13_mem.s](round6/verified/free_0290_b13_mem.s): mem, 42.
- [round6/verified/free_0291_b13.s](round6/verified/free_0291_b13.s): out, 32.
- [round6/verified/free_0292_b13.s](round6/verified/free_0292_b13.s): out, 32.
- [round6/verified/free_0293_b13.s](round6/verified/free_0293_b13.s): out, 32.
- [round6/verified/free_0294_b13.s](round6/verified/free_0294_b13.s): out, 32.
- [round6/verified/free_0295_b13.s](round6/verified/free_0295_b13.s): out, 32.
- [round6/verified/free_0296_b13.s](round6/verified/free_0296_b13.s): out, 32.
- [round6/verified/free_0297_b13.s](round6/verified/free_0297_b13.s): out, 32.
- [round6/verified/free_0298_b13.s](round6/verified/free_0298_b13.s): out, 32.
- [round6/verified/free_0299_b13.s](round6/verified/free_0299_b13.s): out, 32.
- [round6/verified/free_0300_b13.s](round6/verified/free_0300_b13.s): out, 32.
- [round6/verified/free_0301_b13.s](round6/verified/free_0301_b13.s): out, 32.
- [round6/verified/free_0302_b13.s](round6/verified/free_0302_b13.s): out, 32.
- [round6/verified/free_0303_b13.s](round6/verified/free_0303_b13.s): out, 32.
- [round6/verified/free_0304_b13.s](round6/verified/free_0304_b13.s): out, 32.
- [round6/verified/free_0305_b13.s](round6/verified/free_0305_b13.s): out, 32.
- [round6/verified/free_0306_b13.s](round6/verified/free_0306_b13.s): out, 32.
- [round6/verified/free_0307_b13.s](round6/verified/free_0307_b13.s): out, 32.
- [round6/verified/free_0308_b13.s](round6/verified/free_0308_b13.s): out, 32.
- [round6/verified/free_0309_b13.s](round6/verified/free_0309_b13.s): out, 32.
- [round6/verified/free_0310_b13.s](round6/verified/free_0310_b13.s): out, 32.
- [round6/verified/free_0311_b13.s](round6/verified/free_0311_b13.s): out, 32.
- [round6/verified/free_0312_b13.s](round6/verified/free_0312_b13.s): out, 32.
- [round6/verified/free_0313_b13.s](round6/verified/free_0313_b13.s): out, 32.
- [round6/verified/free_0314_b14.s](round6/verified/free_0314_b14.s): out, 32.
- [round6/verified/free_0314_b14_mem.s](round6/verified/free_0314_b14_mem.s): mem, 42.
- [round6/verified/free_0315_b14.s](round6/verified/free_0315_b14.s): out, 32.
- [round6/verified/free_0316_b14.s](round6/verified/free_0316_b14.s): out, 32.
- [round6/verified/free_0317_b14.s](round6/verified/free_0317_b14.s): out, 32.
- [round6/verified/free_0318_b14.s](round6/verified/free_0318_b14.s): out, 32.
- [round6/verified/free_0319_b14.s](round6/verified/free_0319_b14.s): out, 32.
- [round6/verified/free_0320_b14.s](round6/verified/free_0320_b14.s): out, 32.
- [round6/verified/free_0321_b14.s](round6/verified/free_0321_b14.s): out, 32.
- [round6/verified/free_0322_b14.s](round6/verified/free_0322_b14.s): out, 32.
- [round6/verified/free_0323_b14.s](round6/verified/free_0323_b14.s): out, 32.
- [round6/verified/free_0324_b14.s](round6/verified/free_0324_b14.s): out, 32.
- [round6/verified/free_0325_b14.s](round6/verified/free_0325_b14.s): out, 32.
- [round6/verified/free_0326_b14.s](round6/verified/free_0326_b14.s): out, 32.
- [round6/verified/free_0327_b14.s](round6/verified/free_0327_b14.s): out, 32.
- [round6/verified/free_0328_b14.s](round6/verified/free_0328_b14.s): out, 32.
- [round6/verified/free_0329_b14.s](round6/verified/free_0329_b14.s): out, 32.
- [round6/verified/free_0330_b14.s](round6/verified/free_0330_b14.s): out, 32.
- [round6/verified/free_0331_b14.s](round6/verified/free_0331_b14.s): out, 32.
- [round6/verified/free_0332_b14.s](round6/verified/free_0332_b14.s): out, 32.
- [round6/verified/free_0333_b14.s](round6/verified/free_0333_b14.s): out, 32.
- [round6/verified/free_0334_b14.s](round6/verified/free_0334_b14.s): out, 32.
- [round6/verified/free_0335_b14.s](round6/verified/free_0335_b14.s): out, 32.
- [round6/verified/free_0336_b14.s](round6/verified/free_0336_b14.s): out, 32.
- [round6/verified/free_0337_b15.s](round6/verified/free_0337_b15.s): out, 32.
- [round6/verified/free_0337_b15_mem.s](round6/verified/free_0337_b15_mem.s): mem, 42.
- [round6/verified/free_0338_b15.s](round6/verified/free_0338_b15.s): out, 32.
- [round6/verified/free_0339_b15.s](round6/verified/free_0339_b15.s): out, 32.
- [round6/verified/free_0340_b15.s](round6/verified/free_0340_b15.s): out, 32.
- [round6/verified/free_0341_b15.s](round6/verified/free_0341_b15.s): out, 32.
- [round6/verified/free_0342_b15.s](round6/verified/free_0342_b15.s): out, 32.
- [round6/verified/free_0343_b15.s](round6/verified/free_0343_b15.s): out, 32.
- [round6/verified/free_0344_b15.s](round6/verified/free_0344_b15.s): out, 32.
- [round6/verified/free_0345_b15.s](round6/verified/free_0345_b15.s): out, 32.
- [round6/verified/free_0346_b15.s](round6/verified/free_0346_b15.s): out, 32.
- [round6/verified/free_0347_b15.s](round6/verified/free_0347_b15.s): out, 32.
- [round6/verified/free_0348_b15.s](round6/verified/free_0348_b15.s): out, 32.
- [round6/verified/free_0349_b15.s](round6/verified/free_0349_b15.s): out, 32.
- [round6/verified/free_0350_b15.s](round6/verified/free_0350_b15.s): out, 32.
- [round6/verified/free_0351_b15.s](round6/verified/free_0351_b15.s): out, 32.
- [round6/verified/free_0352_b15.s](round6/verified/free_0352_b15.s): out, 32.
- [round6/verified/free_0353_b15.s](round6/verified/free_0353_b15.s): out, 32.
- [round6/verified/free_0354_b15.s](round6/verified/free_0354_b15.s): out, 32.
- [round6/verified/free_0355_b15.s](round6/verified/free_0355_b15.s): out, 32.


# Round 7: median-preserving SAT rewrites

No core with `k <= 31` was found. Assumptions: **G1-G4, A2, A11**.

The bases are the first strict-PASS k=32 repairs from round 6: 15 w6
representatives and the w9 representative. This round did not repeat the
earlier one-edit or sorting-network searches.

The static dependency analysis found **six bases with one median-only write,
nine with two median-only writes, and one with three median-only writes**.
A median-only write affects output 2 but no other output. None is a comparison.
The three-write case initializes an accumulator and then selects its value
twice using existing flags. Most of the median dependency cone is shared
with other outputs. See [round7/structure.json](round7/structure.json).

Each SAT slot chooses any I1 instruction, any source and destination from
original registers plus two fresh registers, or an omitted instruction.
The median can use any register at any instruction boundary. The other four
outputs retain their base registers and events. All instruction and output
choices are shared across input cases. No intermediate value column is fixed
inside the editable slots.

| Search | Completed UNSAT tests | Unknown tests | CPU seconds |
| --- | ---: | ---: | ---: |
| Median-only positions | 16 | 0 | 1.321 |
| Last six median-cone writes plus median-only writes | 16 | 0 | 106.049 |
| Last eight median-cone writes plus median-only writes | 6 | 10 | 821.987 |
| Median-only writes relocated to any gaps | 16 | 0 | 195.223 |
| Full median cone; all-case encoding attempted; bases 0, 10, 15 | 0 | 3 | 319.840 |

Full-cone bases 0 and 10 reached CPU limits after encoding all 541 cases.
Base 15 stopped with `std::bad_alloc` under the 2,800 MiB address-space limit.
It has no final solver result. All three full-cone tests remain unknown.

For relocation, the search removes all m median-only writes and inserts at
most m-1 new instructions into any gaps in the retained event stream.
It includes two new instructions in the same gap. The hardest case permits
29 fixed core instructions plus two arbitrary new instructions. Its initial
45-second attempt was unknown. The retry completed UNSAT. Thus the relocation
family is exhausted for all 16 bases. This is a finite family result.

The encoder fixes scratch values at 5 and input ranks at 0 through 4.
It fixes initial flags to equality. It allows reads and comparisons of scratch
values. Every strict program must work for this initialization. Therefore
UNSAT excludes a strict program in the stated instruction and register family.
A solver limit is unknown. It is not a negative result. See
[round7/METHODS.md](round7/METHODS.md) for the exact scope.

The independent scalar enumeration matched every zero- and one-instruction
relocation result. It tested **169,056** raw plans across 15 bases.
The separate C++ checker exhausted the two-instruction relocation for base 10:
`RESULT NONE slots=595 raw=140536620 simulations=2814732 case_slots=2875 cpu=3.01695`.
The transition audit checked 108 fixed and 126 editable instruction cases.
These are validation checks, not a formal certificate.

The gap controls restored the original median-only instructions at k=32.
Every control received strict PASS in the register and memory models.
The full strict-PASS ledger is [round7/pass_ledger.json](round7/pass_ledger.json).
Every new PASS file is listed below. These controls do not improve the length.

- [round7/control.s](round7/control.s): `out`, k=32.
- [round7/control_mem.s](round7/control_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b00.s](round7/schedule_control_r2_b00.s): `out`, k=32.
- [round7/schedule_control_r2_b00_mem.s](round7/schedule_control_r2_b00_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b01.s](round7/schedule_control_r2_b01.s): `out`, k=32.
- [round7/schedule_control_r2_b01_mem.s](round7/schedule_control_r2_b01_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b02.s](round7/schedule_control_r2_b02.s): `out`, k=32.
- [round7/schedule_control_r2_b02_mem.s](round7/schedule_control_r2_b02_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b03.s](round7/schedule_control_r2_b03.s): `out`, k=32.
- [round7/schedule_control_r2_b03_mem.s](round7/schedule_control_r2_b03_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b04.s](round7/schedule_control_r2_b04.s): `out`, k=32.
- [round7/schedule_control_r2_b04_mem.s](round7/schedule_control_r2_b04_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b05.s](round7/schedule_control_r2_b05.s): `out`, k=32.
- [round7/schedule_control_r2_b05_mem.s](round7/schedule_control_r2_b05_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b06.s](round7/schedule_control_r2_b06.s): `out`, k=32.
- [round7/schedule_control_r2_b06_mem.s](round7/schedule_control_r2_b06_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b07.s](round7/schedule_control_r2_b07.s): `out`, k=32.
- [round7/schedule_control_r2_b07_mem.s](round7/schedule_control_r2_b07_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b08.s](round7/schedule_control_r2_b08.s): `out`, k=32.
- [round7/schedule_control_r2_b08_mem.s](round7/schedule_control_r2_b08_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b09.s](round7/schedule_control_r2_b09.s): `out`, k=32.
- [round7/schedule_control_r2_b09_mem.s](round7/schedule_control_r2_b09_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b10.s](round7/schedule_control_r2_b10.s): `out`, k=32.
- [round7/schedule_control_r2_b10_mem.s](round7/schedule_control_r2_b10_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b11.s](round7/schedule_control_r2_b11.s): `out`, k=32.
- [round7/schedule_control_r2_b11_mem.s](round7/schedule_control_r2_b11_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b12.s](round7/schedule_control_r2_b12.s): `out`, k=32.
- [round7/schedule_control_r2_b12_mem.s](round7/schedule_control_r2_b12_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b13.s](round7/schedule_control_r2_b13.s): `out`, k=32.
- [round7/schedule_control_r2_b13_mem.s](round7/schedule_control_r2_b13_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b14.s](round7/schedule_control_r2_b14.s): `out`, k=32.
- [round7/schedule_control_r2_b14_mem.s](round7/schedule_control_r2_b14_mem.s): `mem`, length 42.
- [round7/schedule_control_r2_b15.s](round7/schedule_control_r2_b15.s): `out`, k=32.
- [round7/schedule_control_r2_b15_mem.s](round7/schedule_control_r2_b15_mem.s): `mem`, length 42.

All CPU jobs ran sequentially with `nice -n 19` on one CPU.
The address-space limit was 2,800 MiB. The largest recorded search resident
memory was 2,642,996 KiB. The records are in [round7/summary.json](round7/summary.json)
and the `round7/*.resources` files. No job exceeded 3 GB.

The completed negatives preserve the other instructions and output events.
They do not exclude broader rewrites of shared computation. The tested
larger families with solver limits remain unknown. No assumption was
contradicted. No global lower bound or optimality proof is claimed.
The smallest strict-verified core remains k=32.

Reproduction: `nice -n 19 python3 round7/reproduce.py`. This round ran its
commands separately. The full driver was syntax-checked, not rerun as one job.


# Round 8: median and adjacent-output SAT rewrites

No core with `k <= 31` was found. The model assumptions are **G1-G4**.
The local rewrite scope is **A11**. Tests with only two fresh registers also
use **A2**. No result contradicts an assumption.

The bases are the 15 original w6 k=31 near misses and the 16 strict-PASS
k=32 repairs used in round 7. Each base has two tests: outputs (1,2) and
outputs (2,3), with zero-based indices. This gives 62 base/pair tests.
The other three output registers and events stay fixed. Both selected
outputs can use any register at any boundary. The two-output searches do
not fix any intermediate value inside the editable positions.

An exclusive position affects the selected pair and no other output.
For outputs (1,2), the exclusive paths contain five to eight instructions.
Every such path contains one comparison. For outputs (2,3), the paths
contain two to six instructions. Eight of those 31 paths contain a comparison.
See [round8/bases.json](round8/bases.json) for exact positions and input hashes.

Each editable position permits any I1 instruction with freely chosen operands,
or an omitted instruction. A repair must omit at least one instruction.
A near miss can replace all selected instructions at the same k=31 budget.
The tail tests also free the last specified number of writes in the pair
dependency cone. Full-cone probes free all instructions in that cone.

| Run | Tests | UNSAT | Unknown | CPU seconds |
| --- | ---: | ---: | ---: | ---: |
| `cone_batch` | 62 | 0 | 62 | 627.748 |
| `exclusive_batch` | 62 | 52 | 10 | 542.253 |
| `exclusive_retry_batch` | 10 | 2 | 8 | 1160.217 |
| `tail6_batch` | 62 | 24 | 38 | 654.490 |
| `unbounded_batch` | 62 | 41 | 21 | 269.871 |

Combining completed negatives, **54 of 62 exclusive tests are UNSAT**.
The other **8 tests remain unknown** before any symmetry implications.
Only a completed UNSAT test is a negative for its stated finite family.
A CPU limit or process failure is unknown. The complete pair family is not
claimed exhausted while any case remains unknown.

The all-order retries encode all 541 weak orders. Other tests add failed
weak orders after each SAT model. Scratch values start at 5 and initial
flags represent equality. A strict program must work for this initialization.
Thus UNSAT excludes strict correctness within the tested instruction family.
A scalar survivor is only a candidate until the shared strict judge passes it.

The unrestricted-register exclusive tests permit 2m fresh registers for m
editable instructions. Each instruction has two operands. Thus 2m names
cover every new register that can occur in this fixed-position family.
Fresh names follow their order of first occurrence. The independent check
exhausted **6,561 operand traces** for two editable positions. It matched the
naming clauses and verified every renamed representative. This removes A2
for completed negatives in this exclusive family. It does not remove A11.

The exact-template symmetry check found **62 distinct classes**. Input
renaming, scratch renaming, value-order reversal, and global comparison
reversal therefore closed no additional test. This is a completed dead end.

The compact encoder computes the unchanged prefix directly. It shares suffix
transition variables only when complete register values and flags agree.
Each weak order still imposes its own output requirements. See
[round8/METHODS.md](round8/METHODS.md) for the encoding and its limits.

The independent scalar selector audit checked **19,392** decisions.
It checked fixed and pinned instruction paths with both encoders.
Every decision agreed. The controls restore the original k=32 repairs.
All 32 controls received strict PASS in the out model and in the memory
model. Their memory forms have length 42. These are validation results,
not shorter sorters. Exact logs are in [round8/pass_ledger.json](round8/pass_ledger.json).

Every new strict PASS file is listed below.

- [round8/control_00.s](round8/control_00.s): out.
- [round8/control_00_mem.s](round8/control_00_mem.s): mem.
- [round8/control_01.s](round8/control_01.s): out.
- [round8/control_01_mem.s](round8/control_01_mem.s): mem.
- [round8/control_02.s](round8/control_02.s): out.
- [round8/control_02_mem.s](round8/control_02_mem.s): mem.
- [round8/control_03.s](round8/control_03.s): out.
- [round8/control_03_mem.s](round8/control_03_mem.s): mem.
- [round8/control_04.s](round8/control_04.s): out.
- [round8/control_04_mem.s](round8/control_04_mem.s): mem.
- [round8/control_05.s](round8/control_05.s): out.
- [round8/control_05_mem.s](round8/control_05_mem.s): mem.
- [round8/control_06.s](round8/control_06.s): out.
- [round8/control_06_mem.s](round8/control_06_mem.s): mem.
- [round8/control_07.s](round8/control_07.s): out.
- [round8/control_07_mem.s](round8/control_07_mem.s): mem.
- [round8/control_08.s](round8/control_08.s): out.
- [round8/control_08_mem.s](round8/control_08_mem.s): mem.
- [round8/control_09.s](round8/control_09.s): out.
- [round8/control_09_mem.s](round8/control_09_mem.s): mem.
- [round8/control_10.s](round8/control_10.s): out.
- [round8/control_10_mem.s](round8/control_10_mem.s): mem.
- [round8/control_11.s](round8/control_11.s): out.
- [round8/control_11_mem.s](round8/control_11_mem.s): mem.
- [round8/control_12.s](round8/control_12.s): out.
- [round8/control_12_mem.s](round8/control_12_mem.s): mem.
- [round8/control_13.s](round8/control_13.s): out.
- [round8/control_13_mem.s](round8/control_13_mem.s): mem.
- [round8/control_14.s](round8/control_14.s): out.
- [round8/control_14_mem.s](round8/control_14_mem.s): mem.
- [round8/control_15.s](round8/control_15.s): out.
- [round8/control_15_mem.s](round8/control_15_mem.s): mem.
- [round8/control_16.s](round8/control_16.s): out.
- [round8/control_16_mem.s](round8/control_16_mem.s): mem.
- [round8/control_17.s](round8/control_17.s): out.
- [round8/control_17_mem.s](round8/control_17_mem.s): mem.
- [round8/control_18.s](round8/control_18.s): out.
- [round8/control_18_mem.s](round8/control_18_mem.s): mem.
- [round8/control_19.s](round8/control_19.s): out.
- [round8/control_19_mem.s](round8/control_19_mem.s): mem.
- [round8/control_20.s](round8/control_20.s): out.
- [round8/control_20_mem.s](round8/control_20_mem.s): mem.
- [round8/control_21.s](round8/control_21.s): out.
- [round8/control_21_mem.s](round8/control_21_mem.s): mem.
- [round8/control_22.s](round8/control_22.s): out.
- [round8/control_22_mem.s](round8/control_22_mem.s): mem.
- [round8/control_23.s](round8/control_23.s): out.
- [round8/control_23_mem.s](round8/control_23_mem.s): mem.
- [round8/control_24.s](round8/control_24.s): out.
- [round8/control_24_mem.s](round8/control_24_mem.s): mem.
- [round8/control_25.s](round8/control_25.s): out.
- [round8/control_25_mem.s](round8/control_25_mem.s): mem.
- [round8/control_26.s](round8/control_26.s): out.
- [round8/control_26_mem.s](round8/control_26_mem.s): mem.
- [round8/control_27.s](round8/control_27.s): out.
- [round8/control_27_mem.s](round8/control_27_mem.s): mem.
- [round8/control_28.s](round8/control_28.s): out.
- [round8/control_28_mem.s](round8/control_28_mem.s): mem.
- [round8/control_29.s](round8/control_29.s): out.
- [round8/control_29_mem.s](round8/control_29_mem.s): mem.
- [round8/control_30.s](round8/control_30.s): out.
- [round8/control_30_mem.s](round8/control_30_mem.s): mem.
- [round8/control_31.s](round8/control_31.s): out.
- [round8/control_31_mem.s](round8/control_31_mem.s): mem.

All CPU jobs ran one at a time on one CPU with `nice -n 19`.
Each search had a 2,800 MiB address-space limit. The largest recorded
resident memory was **659,544 KiB**.
Commands, coverage, resource files, and source hashes are indexed in
[round8/summary.json](round8/summary.json). All writes stayed in w1.

These finite local results do not exclude arbitrary k=31 programs.
No global lower bound or optimality proof is claimed. The smallest
strict-verified core remains k=32.

Reproduction: `nice -n 19 python3 round8/reproduce.py`.
This round ran the stages separately. The full driver was syntax-checked.
It was not rerun as a single job.


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

<!-- ROUND10_BEGIN -->
# Round 10: three direct partial columns

No sort5 program with `k <= 31` has passed the strict judge in this round.
Assumptions: **G1–G4, A15** and the explicit normal forms below.
No assumption was contradicted. No `ASSUMPTION CHALLENGED` line is warranted.

A partial column is one written register version with at least one entry
that still holds initial scratch data. Every other written version must
be a min/max function. Comparisons read defined values. The new SAT
encoding leaves all 7,579 lattice shapes free. It has no register cap.
It frees comparison operands, comparison outcomes, sources, destinations,
I1 conditions, block sizes, and output snapshots. No network or term pool
is fixed. No instruction precedes the first comparison.

The three worker briefs were read before implementation. This round keeps
undefined entries directly. It does not run w11’s full non-lattice
formulas, w12’s undefined comparisons, or w13’s skeleton routing.
See [round10/SCOPE.md](round10/SCOPE.md) and
[round10/METHODS.md](round10/METHODS.md) for the scope and representation.

The main targets require a direct dependency between partial versions.
The existing no-dependency rewrite and d2 result cover the complementary
class. Seven and eight comparisons were not searched again: the existing
lattice-comparison-operand exclusion already covers them in this class.

| Target | Comparisons | Orders | Solver CPU seconds | Decision |
| --- | ---: | ---: | ---: | --- |
| k31_c9_three_weak | 9 | 541 | 178.711 | UNKNOWN |
| k31_c10_three_strict | 10 | 120 | 118.107 | UNKNOWN |
| k31_c9_strong_topology1 | 9 | 541 | 44.428 | UNKNOWN |
| k31_c9_strong_topology2 | 9 | 541 | 44.636 | UNKNOWN |
| k31_c9_strong_topology3 | 9 | 541 | 44.659 | UNKNOWN |
| k31_c9_strong_topology4 | 9 | 541 | 44.444 | UNKNOWN |
| k31_c9_strong_topology5 | 9 | 541 | 44.702 | UNKNOWN |
| k31_c9_strong_topology6 | 9 | 541 | 44.546 | UNKNOWN |
| k31_c9_strong_topology7 | 9 | 541 | 44.384 | UNKNOWN |
| k31_c11_three_strict | 11 | 120 | 29.590 | UNKNOWN |
| k31_c12_three_strict | 12 | 120 | 29.839 | UNKNOWN |
| k31_c13_three_strict | 13 | 120 | 29.793 | UNKNOWN |
| k31_c14_three_strict | 14 | 120 | 29.823 | UNKNOWN |
| k31_c15_three_strict | 15 | 120 | 29.699 | UNKNOWN |

Target decisions: 0 UNSAT, 0 SAT, 14 UNKNOWN.
The target logs record 1,319,386 solver conflicts in total.
Only a completed UNSAT query is an exhaustive negative for its saved formula.
Each limit remains unknown. The three-partial family is not exhausted.

The stronger queries require every partial column to have both a defined
and an undefined entry and to be read later. Every comparison must control
a conditional move. They also require different complete flag histories
on different strict input orders. The seven topology masks are the
nonempty subsets of edges 0→1, 0→2, and 1→2. They partition the stronger
three-column dependency family; limited masks remain unknown.

Strict-order queries count partial versions on 120 strict orders only.
They can omit a version that is undefined only on ties. They are explicit
subclasses, not a complete replacement for the 541-order query.

The independent transition audit tested **96 instruction streams** and
**1,012 opposite-value probes**. Every scalar value and defined bit agreed.
It includes all four I1 conditions, equality comparisons, unknown sources,
partial copies, and overwrites. This is validation evidence, not a proof.

The negative controls all completed. A separate DRAT checker accepted
every recorded UNSAT certificate. The controls reject a two-partial bound
for a pinned three-partial program. They also exhaust the two-input,
one-comparison, k=5, exactly-three-partial formula. Its count is zero.
A k=6 control in that class passed the strict judge. These small controls
do not establish a sort5 lower bound.

Every new strict PASS file is listed below. Each memory file has length
`k + 2n`. These are controls, not improvements to the sort5 record.

The SAT-model audit checked 38,456 intermediate
values and 14,616 comparison outcomes against
the independent scalar trace of 6 controls. All agreed.

- [round10/check2_three.s](round10/check2_three.s): n=2, k=6, out.
- [round10/check2_three_mem.s](round10/check2_three_mem.s): n=2, k=6, mem.
- [round10/n2_k6_three.s](round10/n2_k6_three.s): n=2, k=6, out.
- [round10/n2_k6_three_mem.s](round10/n2_k6_three_mem.s): n=2, k=6, mem.
- [round10/check5_two.s](round10/check5_two.s): n=5, k=32, out.
- [round10/check5_two_mem.s](round10/check5_two_mem.s): n=5, k=32, mem.
- [round10/check5_three.s](round10/check5_three.s): n=5, k=33, out.
- [round10/check5_three_mem.s](round10/check5_three_mem.s): n=5, k=33, mem.
- [round10/strong_check2.s](round10/strong_check2.s): n=2, k=6, out.
- [round10/strong_check2_mem.s](round10/strong_check2_mem.s): n=2, k=6, mem.
- [round10/strong_check5.s](round10/strong_check5.s): n=5, k=33, out.
- [round10/strong_check5_mem.s](round10/strong_check5_mem.s): n=5, k=33, mem.

The exact PASS outputs and hashes are in
[round10/pass_ledger.json](round10/pass_ledger.json). Formula hashes,
certificate records, commands, source hashes, and coverage are in
[round10/summary.json](round10/summary.json).

Largest recorded resident memory: **837,432 KiB**.
Recorded child CPU use: **928.790 seconds**.
All CPU jobs ran serially at `nice -n 19`. The encoder address-space limit
was 2,400 MiB. All writes stayed in w1.

The smallest strict-verified sort5 core remains k=32. The general A15
statement and global optimality remain open.

Reproduction phases: `nice -n 19 python3 round10/run.py controls`,
`primary`, `strong`, and `sweep`. The transition audit is
`nice -n 19 python3 round10/audit.py`. The report command is
`nice -n 19 python3 round10/report.py`. Use a clean output folder before
rerunning a phase; the journals append records.
<!-- ROUND10_END -->
