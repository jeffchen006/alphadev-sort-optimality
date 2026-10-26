# Purpose

Search M_out(5,I1) at k=31 with three written register versions that have
undefined entries. Every other written version is a min/max function of the
inputs. Comparisons read defined values. This tests the partial-column gap
in A15. It does not fix a comparison network, value pool, or register count.

# Terms

A version is one register value after a data instruction. A data instruction
is mov or cmov. A column gives that version's value for each encoded input
order. An entry is undefined when it is an initial scratch value. This is
not a fixed numeric value. A partial column has at least one undefined entry;
it can be undefined on every encoded order.

A shape is a monotone Boolean table on the 32 input subsets. Its empty-set
entry is false and its full-set entry is true. At threshold t, evaluate the
table on the set of input indices whose values are at least t. These tables
represent every nonconstant min/max function. For a monotone table h, use
the max of the terms min(x_i : i in S) over nonempty S with h(S)=true.
This representation includes all 7,579 lattice shapes. The formula does not
enumerate a network term pool.

# Method

`partial_shapes.py` is the encoder. It copies basic CNF and program-decoding
helpers into the local file `base_sat.py`. The instruction and value encoding
is new. `audit.py` has a separate parser, scalar simulator, and lattice test.
`run.py` runs each CPU job in sequence at nice level 19.

The formula has c comparisons and m=k-c data instructions. Each data instruction
selects its preceding comparison. These block indices cannot decrease. No
instruction precedes the first comparison. All data opcodes, sources, old
destinations, comparison operands, conditions, block sizes, and output versions
are free, unless a control explicitly pins them.

Each mov allocates a fresh register name. Each cmov selects an older version
or a fresh undefined destination. It consumes its selected older destination:
later data reads and later comparisons cannot read that consumed version.
Historical output snapshots remain available. This gives an unbounded-register
encoding. The decoder emits each output at its selected version's creation.
A fresh undefined source is also available at each data instruction.
Fresh sources need no shared garbage identity because comparisons never read
undefined entries and outputs are defined.

Three ordered position selectors identify the partial versions. A sentinel
position makes a selector absent. Each active partial version must be
undefined on at least one encoded order. Its per-order entries have a defined
bit and threshold bits. The threshold bits decrease with increasing rank.
They therefore represent an input rank wherever the entry is defined.
Every unselected version uses one full lattice shape.

The destination and source selectors each choose a lattice table, a partial
array, or an undefined fresh register. A mov always selects its source.
A cmov selects its source or old destination using its comparison flags.
The result's defined bit equals the selected operand's defined bit. When the
result is defined, its threshold bits equal the selected operand's bits.
An unselected result must be defined on every order and agree with its shared
lattice table. A selected result agrees with its partial array.

Every comparison selector excludes the partial positions. Its two operands
are lattice tables. The less flag is true exactly when some threshold bit is
zero on the left and one on the right. The greater flag uses the reverse test.
The equal flag holds when neither strict flag holds. All four I1 conditions
remain distinct, including equality of intermediate copies on strict inputs.

Every output selector excludes the partial positions. For output rank j,
its shape is true on subset S exactly when |S| >= n-j. This is the j-th
order statistic. Outputs are free snapshots, as required by the out model.

For free searches, the first comparison is P0 against P1. Comparison operands
use increasing version indices. Reversing a comparison and its conditions
justifies this orientation. The remaining input names follow first reference
in one fixed selector stream. These input and comparison symmetries preserve
the partial count. Controls can disable them.

# Partial dependencies

The main targets require at least one direct read from a partial version into
a later partial version. A source counts as a read for mov and cmov. An old
destination counts only for cmov. The earlier w10 no-dependency rewrite reduces
the complementary class to pure lattice at the same length. d2 has already
excluded k<=31 in that class. This necessary condition relies on that rewrite
and the d2 result. It is not a new exhaustive search of the pure-lattice class.

For three partial versions, the possible directed edges are 0->1, 0->2,
and 1->2. The encoder can fix any of the eight exact edge masks. Mask zero
is omitted from the target batch for the reason above. Masks 1 through 7
partition the remaining syntactic dependency graphs in this formula.

# Verification

Every SAT assignment is checked against every saved CNF clause before decoding.
The independent simulator checks decoded outputs on all weak orders and
classifies the partial and full columns. Each decoded sorting program is
submitted to the shared strict judge in the out model and its memory form.
Only PASS counts as an accepted program. Each UNSAT query records a DRAT
certificate and runs the separate `bin/drat-trim` checker. A limited checker
is incomplete; a limited solver is UNKNOWN.

The transition audit pins 96 two-input instruction streams. It varies all
four conditions, reads of undefined sources, copies between partial versions,
overwrites, and equality comparisons. It asks the SAT solver for the opposite
of each scalar value or defined bit. All 1,012 opposite-value probes are
UNSAT. This is finite validation evidence, not a proof of the encoder.

## Additional explicit subfamilies

`strong_shapes.py` imports the unchanged direct encoder and adds four rules.
Each active partial column must contain a defined entry as well as an undefined
entry. Each partial column must have a later data read. Every comparison block
must contain a cmov. These three rules define a smaller search family. They
exclude dead partial versions and completely undefined written versions.

The fourth rule separates complete flag histories on the 120 distinct input
orders. This rule is redundant for a correct program in the stated model.
Given the same complete flag history, each fixed instruction stream selects
the same input identities for its outputs. Different strict input orders have
different sorted input-identity sequences. Thus they cannot share a complete
flag history. The rule permits equality outcomes from comparisons of copies.
It does not replace I1 conditions with strict conditions.

For a shortest program, a comparison with no later cmov in its block can be
removed. It has no observable effect. Therefore a shortest program has at most
as many comparisons as data instructions. At k<=31 this gives c<=15. A shorter
program can be padded to k=31 by an identity-copy chain before an output. This
argument motivates stopping the comparison-count sweep at 15. It does not
remove the separate mixed-entry and live-partial restrictions from the stronger
queries, nor the prefix restriction from either encoder.

# Limits

The main all-weak-order query counts exactly three partial versions on all
541 weak orders. A strict-order query counts exactly three partial versions
on its 120 orders. A partial version that is undefined only on tied inputs
can become full in the latter relaxation. If that completion is non-lattice,
it can be outside the strict-order query. These strict-order queries are
explicit subclasses, not a complete relaxation of every all-weak-order
three-partial program. The all-weak-order query has no such counting gap.

Full non-lattice written versions are excluded. Comparisons of undefined
values are excluded. Instructions before the first comparison are excluded.
Only the stated comparison counts are queried. No register cap is imposed.
The general A15 statement and global optimality remain open when any target
query is unknown. Seven and eight comparisons are skipped: the existing
lattice-comparison-operand exclusion already covers this class.

All writes stay in w1. The encoder has a 2,400 MiB address-space limit.
The runner has a 2,600 MiB limit. One CPU job runs at a time at nice level 19.
