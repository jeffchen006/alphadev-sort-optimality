# C2 case coverage and encoder review [A12, A15]

## Purpose

State what the position cases cover. State the gaps before any completeness
claim. This review concerns `src/threshold_sat.py` and its unchanged d2 copy.
The base method is `round5/METHOD.md`. The current task is Direction A.

The current cases do **not** cover every full program with at most two
non-lattice written values. They cover that class only when every comparison
operand is lattice. This restriction is in the encoder, not in the position
split. Direction A names the missing class C2b.

## Terms

A written value is the register version after one mov or cmov. Two writes to
one register create two written values. An exceptional position permits a
non-lattice value. It does not require a non-lattice value. A lattice value is
the value of a min/max expression in the inputs.

The core length k counts mov, cmp, and cmov. The comparison count is c. The
data instruction count is m=k-c. An absent exception has position m.

## Method

### Position coverage

For fixed k=31 and c, select the sorted pair (i,j) from these cases:

1. (m,m): no exceptional position.
2. (i,m), for 0<=i<m: one exceptional position.
3. (i,j), for 0<=i<j<m: two exceptional positions.

The encoder requires one position in each selector. It forbids reversed or
repeated real positions. These cases therefore partition its selector
assignments. Each case adds exactly two positive unit clauses to the base
formula. A unit clause fixes the corresponding selector variable to true.
The cases do not partition the decoded programs. An exceptional value can
be lattice, so a program can occur in several cases.

| c | m=31-c | zero positions | one position | two positions | cases |
|---:|---:|---:|---:|---:|---:|
| 9 | 22 | 1 | 22 | 231 | 254 |
| 10 | 21 | 1 | 21 | 210 | 232 |
| 11 | 20 | 1 | 20 | 190 | 211 |
| 12 | 19 | 1 | 19 | 171 | 191 |
| 13 | 18 | 1 | 18 | 153 | 172 |
| 14 | 17 | 1 | 17 | 136 | 154 |
| 15 | 16 | 1 | 16 | 120 | 137 |
| total | | 7 | 133 | 1211 | 1351 |

Thus c=10..15 adds 1097 cases to the 254 c=9 cases. Every lattice table is
free in each case. No enumeration of preselected lattice expressions is used.

### Length and comparison count

Use a shortest program in the declared full-value class. If a comparison
controls no cmov before the next comparison, remove that comparison. This
does not change any register or output. Each remaining comparison therefore
controls a different cmov. Thus c<=number of cmovs<=k-c. If k<=31, then c<=15.

If k<31, append fresh mov copies of one lattice output value. Save that output
from the last copy. Each move counts one instruction. This gives k=31 without
changing c or increasing the non-lattice count. Consequently, the exact-length
formulas can cover shorter programs after this padding. Fixed exception
positions need not survive padding; the union over all position cases does.

For c<=8, this coverage argument relies on the separate lattice-comparison
operand exclusion [A12]. This document does not supply its certificate. That
result does not apply if a comparison operand is non-lattice.

### Register and instruction normal forms

Give every mov destination a fresh register name. Rename its later reads until
the next write to that register. This preserves every value and does not add
an instruction. Each cmov consumes its old destination version. After that
write, a later counted instruction cannot read the consumed version. Outputs
can use historical versions because a free output snapshot can occur before
the overwrite. These rules do not impose a register limit.

Fix one allowed initial flag state. Strict correctness makes the final outputs
independent of that choice. Before the first comparison, each cmov now has a
constant condition. Replace a taken cmov with mov. Remove an untaken cmov.
Every remaining useful full value in that prefix is an input copy. The first
useful comparison can use the original inputs. Move the copies immediately
after that comparison. No compared value changes. Pad later if necessary.

If the first comparison compares equal input aliases, its outcome is constant.
Remove it and simplify its block. Repeat until the first useful comparison
compares two different inputs. Rename these inputs P0 and P1.

Each later comparison can exchange its operands. Reverse the strict direction
of every cmov in that comparison block. Keep its inclusive bit unchanged. This
allows increasing operand version indices. The remaining input names P2..P4
can follow their first occurrence in the encoder's fixed selector stream.
Operand exchange restores increasing comparison indices after that renaming.
Mov condition bits have no effect and can be fixed. These operations justify
the implemented symmetry rules within the declared class. Judge review of
this argument is still required.

### Threshold representation and clauses

For each written lattice value, the encoder creates a Boolean table on all
32 input subsets. Its endpoints are 0 and 1. Every subset edge requires a
nondecreasing table value. Such a table represents a min/max expression:
take the maximum of the minimum over each nonempty subset with table value 1.
At threshold t, evaluate the table on the indices whose inputs are at least t.
This representation includes every lattice expression.

For each exception, a separate row of four threshold bits represents each
strict input permutation. A row is nonincreasing. Its sum is the selected input
rank from 0 through 4. Thus each exceptional value is full and may be
non-lattice. Its unused monotone table does not constrain its actual value.

For a comparison, A<B holds exactly when one threshold bit of B is 1 and the
corresponding bit of A is 0. The reverse test gives A>B. Equality means neither
test succeeds. The formula implements both implications of these tests.
For each mov or cmov, guarded equalities copy every threshold bit from the
selected source or old destination. The instruction block chooses the last
preceding comparison. Nondecreasing block indices give execution order.

The output at rank j has table value 1 exactly on subsets of size at least
5-j. This is the corresponding order statistic. A correct output is lattice.
It need not be tagged exceptional. Untag any exceptional position that holds
that output column. The output exclusion therefore does not remove a correct
program that uses at most two actual non-lattice values.

The comparison exclusion has a different effect. For every selected exception
position g and every comparison operand selector p for version 5+g, the encoder
adds `not p or not exception[g]`. No satisfying assignment can compare an
actual non-lattice written value. This is the central scope restriction.

## Result and limits

Within the lattice-comparison-operand class, the position union for c=9..15,
together with [A12] for c<=8 and the normal forms above, covers k<=31 with
at most two full non-lattice written values. This is a coverage argument.
It does not report UNSAT for any case. Each case still needs a completed
solver result and a saved, independently checkable certificate.

These gaps remain for the broader Direction A claim:

1. C2b permits original full non-lattice values as comparison operands. The
   current encoder excludes them. That class also needs c=7 and c=8. On strict
   inputs, each fixed comparison history makes each register an input alias.
   A useful comparison has at most two outcomes at that history. The 120
   permutations therefore require at least seven useful comparisons. With
   c=7, the split has 301 cases. With c=8, it has 277 cases. These add 578 cases
   to the 1351 above, but all c=7..15 bases also need the broader semantics.
2. Comparisons that depend on scratch garbage are outside this encoder and
   the existing reduction. C1 owns that class.
3. The earlier q-to-q-1 reduction assumes that every originally full written
   value is lattice. It does not, as stated, cover mixed partial and original
   non-lattice values. It also does not reduce three original full non-lattice
   values with no partial value to the two-exception class. Direction A's
   phrase "at most 3 ... garbage-partial or non-lattice in total" is therefore
   broader than the hypotheses of that reduction. This needs a separate
   argument or an explicit narrower scope.
4. The formula checks 120 strict orders. This is sufficient for a negative
   result about programs correct on all 541 weak orders. It is insufficient
   to accept a positive candidate. Each candidate still needs the strict
   reference judge in both models.
5. A solver limit leaves UNKNOWN. A proof checker limit leaves the certificate
   incomplete. Neither result closes a case. An independent sample check
   supplements the required check of every certificate; it does not replace it.

## Certificate retention

At the first source inspection, d2's `c2/src/run.py` deleted both the LRAT file
and its case CNF after a successful first check. The CNF is reproducible from
the base and two units. The LRAT certificate is not saved in the result JSON.
That deletion prevents the requested later independent check.

Required runner change: retain each accepted LRAT file under `c2/proofs/` and
record its path and hash. Keep the exact formula or its base, units, and hash.
Preserve the checker log. Existing deleted certificates need recovery or a
new run. w10 does not edit d2 files. No long position case is run by w10.

Update during this review: d2 revised its runner. It now retains compressed
LRAT and CNF files by default. Its `--nokeep` option still deletes accepted
files. The independent checker supports the compressed format. Retention of
the certificates from already running processes still needs confirmation.

`src/c2_short.py --sample-d2` selects ceil(N/10) completed, verified d2 UNSAT
results uniformly without replacement. It uses seed 101026 and saves the
population and sample. For each selected case, it copies the saved certificate,
rebuilds the exact CNF, checks both hashes, and runs `bin/lrat-check` independently.
If no completed result exists, the check remains pending. If a proof is absent,
the report says `MISSING_CERTIFICATE`; it does not claim verification.

## Review of d2 V2 during this round

d2 added `c2/src/threshold_cmpx.py` during this review. Its comparison block
replaces the exceptional-operand exclusion with two operand-use bits. The
selected version fixes those bits to its exceptional-position tags. If neither
tag is selected, guarded equalities use the selected lattice table. If a tag
is selected, guarded equalities use that exception's row of threshold bits.
The comparison then uses these actual bits for both strict tests. The timing
and register lifetime clauses remain unchanged.

By clause inspection, this change gives the intended full-value comparison
semantics. Its comparison rows use the same decreasing threshold sequences as
the data operands. Thus the less and greater tests remain exact. This is a
source review, not a completed formula decision or a judge acceptance.

V2 removes the comparison restriction described above. Its position union
must include c=7..15, with 1929 cases. It still requires defined comparison
operands. It still has only two exceptional written positions. It does not
close C1 or the mixed three-column reduction gap. The original short-pass
formulas are V1. Their hashes and decisions must not be attributed to V2.

The d2 cube splitter uses a chain partition. For Boolean variables x0..xT-1,
the cases are `not x0`, `x0 and not x1`, through the first false variable, and
the final case in which all T variables are true. Exactly one case holds for
every assignment. The splitter first applies this partition to block 0. In
each uncapped branch, it applies another complete chain partition to block 1.
Keeping the capped block-0 branch unsplit preserves coverage. Consequently,
the union of these cubes covers its parent position case. Some cubes can be
inconsistent with the base formula; those cubes do not remove coverage.
Every decided cube needs its own saved formula and checked certificate.
Every parent case needs a complete manifest that accounts for all its cubes.

## Reproduction for judge review

For V1, use these existing files under d2's `c2/base/`:

```
base_k31_cC.cnf
base_k31_cC.json
```

Replace C by the comparison count. The JSON records the encoder hashes,
variable count, clause count, and the two `position_choices` vectors. For a
case (i,j), copy the DIMACS body unchanged. Increase its clause count by two.
Append one unit containing `position_choices[0][i]` and one unit containing
`position_choices[1][j]`. Retain the variable count. Hash the whole new file.

V2 uses `base_k31_cC_v2.cnf` and its JSON. Its variable numbers differ from V1.
Never use a V1 selector number or decoder with a V2 assignment.

For a cube case, append both position units and every cube unit. Increase the
base clause count by the total number of appended units. The cube manifest
must identify the variant, comparison count, position pair, and all cube units.
The coverage certificate concerns the disjunction of the listed cubes. The
case certificates concern the base formula together with each cube. Both are
needed to close a split parent case.

After exact reconstruction and hash checks, run:

```
bin/lrat-check formula.cnf proof.lrat
```

The checker must exit with code 0 and print `c VERIFIED`. A compressed file
must first be decompressed. The recorded formula and proof hashes refer to
the uncompressed files. w10 saves its copied artifacts and checker logs in
`c2_short/independent_lrat/`. These paths are within w10's write boundary.

For a positive assignment, check every saved clause, decode with the same
encoder variant, and run the strict reference judge. A formula assignment
alone is insufficient. The required commands for a sort5 candidate are:

```
python3 shared/judge.py candidate.s --strict --model out
python3 shared/judge.py candidate_mem.s --strict --model mem
```

The memory file must implement the register candidate with the counted loads
and stores. Only the judge's PASS output supports a positive sorting claim.

## Current review and support status

The judge's 09:10 note in `board/team/DIRECTION_A.md` records V1 and V2 as
SOUND, with matching rebuilt base hashes and the comparison ranges above.
Earlier statements here that judge review is pending describe the earlier
review stage. Encoder acceptance does not close a position case or either
gap in `../GAPS.md`.

d2-lattice now owns all 1351 V1 cases and all 1929 V2 cases. w10 starts no
long position solver. `src/c2_support_watch.py` tracks both variants and
split parents. A parent closes in its peer count only if its direct result
has a retained, checked UNSAT certificate, or every child has such a result
and the current split has a retained coverage certificate. The peer count
is separate from w10's independent proof checks. Missing artifacts keep
a case open. A SAT result remains pending strict candidate review.

The random sample uses all available verified d2 UNSAT result files, including
cube results and both variants. It samples ceil(N/10) files uniformly without
replacement, with seed 101026. Each sampled case requires exact base, formula,
and proof hashes and an independent `bin/lrat-check` acceptance. The watcher
continues after the first nonempty sample, because later files change the
population. A cached acceptance is reused only if the saved local formula,
proof, checker log, return code, and peer hashes still agree. The sample
remains incomplete when N=0. Split coverage proofs are not counted as
position UNSAT proofs in this sample.

`c2_short/support_status.json` records every root status. It distinguishes
UNKNOWN from absent and incomplete results. An absent result can be an active
job; it does not establish that the job has not started. `RESULTS.md` receives the
decided / remaining / unknown counts at least every two hours while the
watcher runs. The earlier five-second V1 pass remains 1351 UNKNOWN; these
limited results do not transfer to V2 or close a d2 case.
