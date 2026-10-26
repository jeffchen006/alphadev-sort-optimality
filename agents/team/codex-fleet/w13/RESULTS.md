# w13: comparison structures outside the lattice model

No k <= 31 strict PASS has been found at this checkpoint.

The target is an out-model program with at most 31 counted instructions.
All writes stay in w13. The local CPU update in BRIEF.md assigns one CPU core.
All compute jobs run sequentially at nice level 10.

`src/generate.cpp` generates conditional wire permutations. A step compares two
wire values. On the greater-than outcome, it can permute all five wires.
The other outcome leaves the wires in place. This includes cycles through the
compared values. The generator also supports several special steps in one trace.
Ordinary comparison-and-exchange steps complete each trace.

The generator checks the 120 strict input orders. It retains only traces whose
final wire values have one common permutation, with a non-lattice comparison
operand. This is a source check, not a strict correctness claim. Each skeleton
records the exact comparison operand columns. Input relabeling, global value
reversal, and independent comparison operand reversal remove equivalent records.
The same symmetry section applies to prior records and new records.

The prior index includes w8's saved eight- and nine-comparison skeletons and
control programs, d7's fam32 programs, and the known eight-comparison sources.
The completed indexing counts and search results will be appended below.

`src/dagx.cpp` is a local copy of w8's `dagx_order.cpp`. This version includes
the conservative open-requirement bound. It searches fully defined values with
unbounded register names. Its negative results apply only to the fixed operand
columns on 120 strict orders. It excludes partially initialized scratch values.
A node limit gives an unresolved case, not a negative result.

`closed.txt` will contain SHA-256 hashes of canonical skeletons only after a
completed k=31 routing search. Each supporting record will name the log.
No general lower bound follows from these searches.

## First-pass checkpoint

The first prior index contained 30,506 keys. The completed external index adds
the raw w8 keys, the external paths in w8's lists, and w6's saved out programs.
The full index has 39,143 keys. Its SHA-256 and source counts are in
`logs/prior_full.json`. Five first-pass records match this larger index.
The remaining 6,929 records are new relative to that finite index.

The first generation used one arbitrary conditional wire permutation at
comparison 4 for c=9. It produced 6,912 records. The c=8 generator produced
22 records with the special step at comparison 6. Positions 5 and 7 produced
no completed c=8 source trace. These are results for the stated source grammar.

The first k=31 routing pass tested all 6,934 records at 100,000 nodes per case.
It returned NONE for 3,059 records and LIMIT for 3,875 records. It found no
candidate. These records include the five later prior matches.
One process stopped before completion. The resumed process skipped recorded
cases and completed the same ledger. Counts come from the complete ledger,
not the resumed process's partial summary counters.

The independent Python evaluator checked all 22 c=8 recipes. It matched every
saved operand column, found 120 flag histories per source, and reproduced
the required-column and non-lattice-column counts. Its 44 fixed graph layouts
had k=34 in 22 cases and k=35 in 22 cases. This fixed graph calculation does
not minimize all possible routing for a skeleton.

All 22 k=32 routing searches reached a one-million-node limit. They remain
unresolved. A deeper k=31 search uses ten million nodes per c=8 case.

Verified control files:

- `programs/audit_c8_first_c8_k34.s`
- `programs/audit_c8_first_c8_k34_mem.s`

Exact judge output:

```text
PASS programs/audit_c8_first_c8_k34.s [relaxed+strict] n=5 L=34 R=13 iset=I1 model=out
PASS programs/audit_c8_first_c8_k34_mem.s [relaxed+strict] n=5 L=44 R=18 iset=I1 model=mem
```

The judge logs are `logs/audit_c8_first_c8_k34.judge.log` and
`logs/audit_c8_first_c8_k34_mem.judge.log`.

## Restart continuation: first new batch

The deep c=8 ledger is complete. All 22 searches reached ten million nodes
at k=31. None completed. The ledger is `logs/c8_deep31/results.jsonl`.

`src/resume_wave.py` generated 5,171 additional canonical skeletons. The
exclusion index included all 39,143 prior keys and the first local batch.
The generator tested ten placements and action modes. It retained 241 new
c=8 structures and 4,930 new c=9 structures. Source positions and generation
caps are in the stage records `logs/resume_c*.stage.json`.

The distance is the number of comparison positions with different operand
columns, minimized over input relabeling, value reversal, operand reversal,
and the finite prior index. This is a finite-index measurement. It does not
show that a family is absent from every external search.

The selected batch has all 241 c=8 records and 1,355 c=9 records at distance
at least three. In particular, 118 c=8 records have distance six. Independent
source evaluation matched all comparison columns and flag histories.
`logs/resume_source_audit.json` records this check.

The k=31 routing pass tested these 1,596 records at 100,000 nodes each. It
returned 841 NONE and 755 LIMIT. All NONE records have c=9. All 241 c=8
records remain unresolved. The negative scope is the saved router's fully
defined strict-order representation. `closed.txt` now contains 3,900 unique
closed hashes, with supporting records in `logs/closed.jsonl`.

The first independent SAT target used 24 strict orders. It returned UNKNOWN
at 60 seconds. Its formula and result are `logs/sat_target31.cnf` and
`logs/sat_target31.json`. UNKNOWN does not close a skeleton.

The fixed-program SAT control returned SATISFIABLE and its assignment was
checked against every saved clause. The decoded program passed the strict
judge in both models:

```text
PASS programs/sat_positive34.s [relaxed+strict] n=5 L=34 R=13 iset=I1 model=out
PASS programs/sat_positive34_mem.s [relaxed+strict] n=5 L=44 R=18 iset=I1 model=mem
```

`src/fixed_sat.py` removes redundant comparison evaluation from the SAT
formula. It fixes the exact operand columns and flag outcomes. It leaves
all intermediate full input selections free. It tracks destructive writes,
register lifetimes, and free output snapshots. This version uses strict
comparisons with unequal operands on all encoded orders. The first control
used all 120 strict orders, fixed the known k=34 program, and returned
SATISFIABLE. Every model clause was checked. The decoded programs passed:

```text
PASS programs/fixed_control34.s [relaxed+strict] n=5 L=34 R=13 iset=I1 model=out
PASS programs/fixed_control34_mem.s [relaxed+strict] n=5 L=44 R=18 iset=I1 model=mem
```

The SAT controls validate successful decoding on those inputs. They do not
prove that the encoder covers every possible program. The formulas and
SHA-256 hashes are saved with each result.

## Weak-order source audit and second continuation

`src/audit_weak.py` checks source recipes on all 541 weak input orders.
The first new selected batch had 12 source recipes that failed this check.
All 12 are listed in `logs/resume_weak_audit.json`, with counterexamples.
These failures do not invalidate strict-order skeleton generation or a
negative search on strict orders. They show why a source recipe is not a
verified program. A different route for the same strict skeleton could
still handle ties. Every claimed sorting program still needs strict PASS.

The fixed source-graph copy calculation on the 1,596 selected records gave
best costs k=35 for c=8 and k=36 for c=9. This calculation fixes the source
gate graph; it does not minimize over all graphs for the operand skeleton.
The best programs passed both strict judges:

```text
PASS programs/resume_layout_audit_c8_k35.s [relaxed+strict] n=5 L=35 R=14 iset=I1 model=out
PASS programs/resume_layout_audit_c8_k35_mem.s [relaxed+strict] n=5 L=45 R=19 iset=I1 model=mem
PASS programs/resume_layout_audit_c9_k36.s [relaxed+strict] n=5 L=36 R=14 iset=I1 model=out
PASS programs/resume_layout_audit_c9_k36_mem.s [relaxed+strict] n=5 L=46 R=19 iset=I1 model=mem
```

`src/round3.py` generated 6,233 further canonical structures. It selected
4,574 records: 233 c=8 records and 4,341 c=9 records at distance >=3.
Maximum distance is seven for c=8 and eight for c=9. Of the c=9 records,
399 have distance eight. All saved operand columns and history classes
passed the independent strict source audit. Six selected recipes failed
the separate weak-order source audit. Their counterexamples are in
`logs/round3_weak_audit.json`. The routing ledger is
`logs/round3_31/results.jsonl`; final counts will be added after completion.

The unrestricted full-column SAT query for
`sk/resume_c8_p3_5_6_m2/s000008.txt` used all 120 strict orders and returned
UNKNOWN at 90 seconds. This case has distance six.

The query for `sk/resume_c9_p2_4_6_m1/s000034.txt` returned UNSATISFIABLE
at k=31 after 28.6 seconds. This case has distance **one**, so it serves as
an independent control, not as a distant-case result. The saved formula is
`logs/fixed_far_c9_31.cnf`; the historical file tag does not state its true
distance. A certificate run is queued. Its result will be recorded separately.

`src/fixed_sat_cuts.py` adds implied constraints to the direct SAT model.
A register version cannot equal two different full value columns. A value
column also has an earliest possible comparison block: identical flag
histories must select the same input identity. These constraints do not
fix intermediate columns or restrict the column pool. A full 120-order
fixed-program control is queued before new target queries.

`src/generate_focus.cpp` adds a required-column cap and a recorded random
traversal seed to the source generator. This selects low-column structures
without changing canonicalization. The next batch uses required <=16 for
c=8 and required <=17 for c=9. Generation and routing remain serial.
