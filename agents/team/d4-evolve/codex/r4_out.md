No k≤31 sorter found. Best remains **14/541 failures**.

CMP 6 overwrites the saved inner minimum. The exact failure condition is: the outer pair contains the strict extremes **and** `x2 > min(x1,x2,x3)`. [Block-by-block trace](work/r4_trace.md).

Results:

- Scored **113.1 million** targeted variants.
- Found **four additional correct c=8, k=32 programs**. All passed the strict judge.
- Saved **300 near misses**, including 10 new operand-value skeletons at k=31/fail14.
- Checked all 4,576 w6 deletions. Best fails 27 cases under one simple condition.
- SAT returned UNSAT for that fail27 program with ≤4 changes in slots 20–31, eight registers, and free outputs. Independent proof verification did not succeed.

[Programs](work/r4_designs.txt) · [Four new k=32 programs](work/r4_new_correct32.txt) · [w6 failure conditions](work/r4_w6_single_case.tsv) · [Full report and search limits](work/r4_report.md)