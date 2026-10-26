# Checks for d7-structure

No program with k <= 31 was found.

All scripts use local files only. Run them with python3. The NumPy scripts
were run with OPENBLAS_NUM_THREADS=1 and OMP_NUM_THREADS=1, under nice -n 10.
The total computation took less than three minutes on one core.

## Instruction fragments

check.py checks both counterexamples to a general Q >= number-of-full-comparators
bound on all 541 weak orders. Both counterexamples use only lattice values.

With C=min(a,d) and b<=d already available, these three instructions compute
both max(a,b) and min(a,b), with no new copy:

    cmp A,B
    cmovl A,B
    cmovl B,C

With d<=b, two full comparators share one copy:

    mov T,A
    cmp A,B
    cmovl A,B
    cmovl B,T
    cmp T,D
    cmovl T,D
    cmovl D,B

Their outputs are A=max(a,b), B=min(a,b), T=max(a,d), D=min(a,d).
The checks use a=x0, d=x1, b=max(x1,x2).

fragments.py checks the four-gate block and adaptive select described in the
response on all 541 weak orders. Required input terms are assumptions of the
fragments; their production costs are not included in the block costs.

## Restricted circuit search

check.py builds the 23-term pool from ex_gates1.txt. It finds 28 nontrivial
binary min/max rules whose arguments and results belong to that pool.
All alternate decompositions of a pool term are allowed. Its comparison-block
search finds minimum 9 comparisons, even with unlimited term preservation.

copies.py finds that all 18 non-input terms are necessary to produce all five
outputs in that pool. Its relaxed register-use search finds no schedule with
18 new-term gates and at most four copies.

one_extra.py adds each of the 155 different terms min(a,b) or max(a,b) outside
the base pool, where a,b belong to the base pool. Each run permits only that
one extra term. Every run still needs at least 18 gates. No run finds
G=18,Q<=4 or G=19,Q<=3. The copy search ignores comparison constraints,
allows unlimited registers, and records an output as soon as it exists.
Each term is produced at most once. A destructive gate can preserve its
destination's previous value for one copy. This is a relaxation of ordinary
gate scheduling, not a search over arbitrary conditional-value programs.

extra_cmps.py checks all 541 weak orders for gate deciders in each extended
pool. Each run needs at least nine comparison blocks to produce all outputs.
Blocks preserve every available term and close over all legal min/max rules.
Thus the checks exclude 31 for these pools with distinct-term gates and copies.
They do not exclude two new terms, arbitrary conditional values, or other pools.

The scripts also enumerate conditional selects whose results are lattice
terms but are not min/max of their actual two data operands. Those results
are stored in selects.json. They are not included in the restricted circuit
search. Many reconstruct an earlier term from later min/max results.
