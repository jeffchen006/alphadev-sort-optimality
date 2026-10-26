# Round 5: A15 reduction and a new SAT formula

Current C2 review: see `C2_COVERAGE.md`. The existing encoder requires lattice
comparison operands. Its position cases do not cover C2b, which permits original
full non-lattice comparison operands. The review also lists the exact counts,
normal-form arguments, certificate retention requirements, and remaining gaps.

Current ownership: d2-lattice runs both V1 and V2. V1 has 1351 position cases
at c=9..15. V2 has 1929 position cases at c=7..15 and permits full non-lattice
comparison operands. The judge's 09:10 note in `board/team/DIRECTION_A.md`
records both encoders as SOUND. That review does not decide their formulas.
w10 supplies coverage notes and an independent random 10% LRAT proof sample.
The two remaining reduction gaps are stated in `../GAPS.md`.

## Purpose

Search sort5 with k=31 and at most two full non-lattice written values.
Leave all lattice expressions, data instructions, comparison operands,
comparison outcomes, block sizes, and output snapshots free. [A15]

The previous bound-two formulas both reached their 600-second limits.
This round uses a different value representation. It does not repeat those
formulas. Its target has nine comparisons and 22 data instructions.

## Terms

A **written value** is one version of a register after one mov or cmov.
An **exception** is a written value that can be non-lattice. An exception can
also be lattice. Thus an exception count is an upper bound.

A **threshold bit** states whether a value is at least a specified input rank.
A **shape** is a min/max function, represented by a monotone Boolean table.
An input subset is encoded by a five-bit mask.

## Method

The encoder is `src/threshold_sat.py`. The serial runner is
`src/threshold_run.py`. Both remain in this worker folder.

### All lattice shapes

Each written value has a Boolean table on all 32 subsets of the inputs.
The empty-subset entry is false. The full-subset entry is true.
For each subset S and input i outside S, the formula requires

    table[S] implies table[S union {i}].

These are exactly the monotone nonconstant Boolean functions.
They represent all 7,579 min/max shapes on five inputs.
No comparison network or term pool is selected in advance.

For completeness of the representation, a monotone table h gives the lattice
expression

    max over nonempty S with h(S)=true of (min of inputs in S).

At a threshold t, the expression is at least t exactly when h(U_t) is true,
where U_t is the set of input indices whose values are at least t.
Conversely, min and max commute with threshold tests. Each min/max expression
therefore gives such a monotone table. This is a representation argument.
It is not a claim that the search finished.

### Full exceptional values

The formula has two optional exception positions. Their real positions are
strictly increasing. A sentinel position means that the exception is absent.
Each selected position writes one of two separate arrays of threshold bits.
Each array has one row per encoded input order. The bits in a row decrease
with the threshold. Thus they represent one input rank, with no undefined
scratch value. The arrays can represent non-lattice functions.

Unselected written values use their Boolean tables. A selected position can
ignore its table. Comparison operands and output snapshots cannot select an
exception position. The unused table of an exception imposes no restriction
on its actual value.

Data sources and old destinations select either a lattice table or one of the
two exceptional arrays. A counted mov always creates a fresh register name.
A counted cmov overwrites its old destination. The old destination version
cannot be read later, except by an earlier free output snapshot.
These are the same register normal forms as in the previous encoder.
There is no fixed register cap. [A2, A7]

### Comparison and instruction semantics

The comparison operand selectors choose two lattice tables A and B.
For each input order, the formula evaluates these tables on its nested sets
U_t. It sets the less flag exactly when some threshold has B(U_t)=true and
A(U_t)=false. It sets the greater flag by the reverse test.
The equal flag holds exactly when neither strict flag holds.

Each data instruction selects the preceding comparison block. A mov always
takes its source. For a cmov, its direction bit and inclusive bit select the
appropriate comparison outcomes. The result copies every threshold bit of
the selected source or old destination.

The output of rank j must have table entry true exactly when the subset has
at least n-j inputs. This characterizes that order statistic among lattice
values. The output selector can use any historical lattice value.

### Scope and symmetry

The target uses all 120 strict input orders. Positive candidates must pass the
strict reference judge on all 541 weak orders in both models. A SAT result
alone is not a correctness claim.

The first comparison is P0 against P1. Input permutation gives this normal
form when the first useful comparison is between different inputs.
Every comparison uses increasing version indices. Swapping its operands and
reversing the strict condition direction preserves its behavior.
The remaining input names follow their first reference in the fixed selector
stream. There is no fixed order for later comparisons.

No data instruction occurs before the first comparison. Comparisons use only
full lattice values. The search does not cover other comparison counts or
comparisons of initial scratch garbage. It does not settle general A15.

### Position cases

After one 1,200-second target query, the runner divides its formula into

    1 + 22 + choose(22,2) = 254

cases. These cover zero, one, or two selected exception positions.
Every case leaves all lattice tables free. Each case has a five-second
solver limit. Its exact formula is the shared target CNF plus the two unit
clauses saved in the case JSON. A unit clause fixes one position selector.
The new header increases the shared clause count by two. The runner records
the reconstructed formula hash. It removes duplicate temporary CNF files.

The 254 cases exhaust all choices of the two optional positions in this
formula. This does not mean that a limited solver run exhausts its case.
UNSAT gives exhaustive satisfying-program count zero for that case.
UNKNOWN leaves that count unknown. Selected exceptions can actually be
lattice. Thus the same instruction program can occur in several cases.
Counts of programs are not added across these overlapping classes.

### Controls and certificates

The runner checks a known k=32 program with one non-lattice value and a known
pure lattice k=32 program. It rejects the first program when no exception is
permitted. It also synthesizes sort2 at k=4 and rejects sort2 at k=3.
The sort2 queries use all three weak orders.

Every SAT assignment is checked against its saved clauses. Every decoded
sorting candidate is submitted to the reference judge in both models.
Every UNSAT decision gets a separate DRAT certificate check. A limited
certificate check remains incomplete. A solver timeout always means UNKNOWN.

### Follow-up normal forms

After the 254 position cases, `src/threshold_followup.py` checks three more
positive controls with two actual non-lattice written values. They test an
exception as a cmov destination, a cmov source, and a mov source. A negative
control permits only the first of two required exceptional positions.

The follow-up then uses `src/threshold_strong.py`. It adds these normal forms:

1. Each written value is read by a later counted instruction or an output.
2. Each selected exception is actually non-lattice on the 120 strict orders.
3. An absent exception array has the same values as input P0.

For the first rule, remove a data instruction whose result has no later use.
Repeat this removal. If the core is then shorter than 31, insert a chain of
fresh mov copies after a lattice output value is produced. Use the final copy
for that output snapshot. Each added value is read. These moves preserve the
comparison count and do not create a non-lattice value. Thus a solution at
length at most 31 has a representative at length exactly 31 with every data
value read or output. The rule need not preserve fixed exception positions.
It is used only in a new query with all positions free.

For the second rule, suppose an exceptional array has consistent threshold
bits each time the same input subset occurs. Any two nested nonempty proper
subsets occur in one strict input order. The row monotonicity therefore makes
the consistent subset table monotone. Such an array is lattice and can be
untagged. Conversely, a non-lattice array has some subset with both a false
observation and a true observation. The formula requires one such witness
when the exception is present. This requires only two clauses per subset.

An absent array is never read. Its fixed P0 assignment changes no instruction.
These arguments justify the normal forms within the declared formula scope.
The control programs test the implementation; they do not prove the arguments.

The stronger c=9 query has a 600-second limit. Six more queries use c=10 through
c=15, with 60 seconds each. Every query still leaves all lattice shapes and
comparison outcomes free. Their time limits leave UNKNOWN classes open.

To explain the upper comparison-count endpoint, take a shortest program in
the declared full-value class. Each comparison must control a cmov before the
next comparison. Otherwise it can be removed. Thus c is at most the number
of cmovs, which is at most k-c. At k<=31 this gives c<=15. Fresh input copies
before the first useful comparison can move after that comparison. The first
comparison can then use their original input sources. The omitted c<=8 cases
are excluded by the separate existing lattice-comparand result [A12]. This
round does not repeat that result or produce new certificates for it.

## Reduction and limits

The earlier reduction maps at most three partial written values into at most
two full non-lattice written values. It preserves the core length and the
comparison count. It assumes that all originally full values are lattice
and that all comparison operands are full. See `round4full/METHOD.md`.

Under those hypotheses, the new full-value class contains the three-partial
class. There is no converse claim. A strict-correct full non-lattice solution
would still be a main-target solution.

All CPU jobs run serially at nice level 19. Solvers have a 2,400 MiB address
space cap. The runner has a 2,800 MiB cap. No sub-agents run. Files outside this
worker folder are read-only.
