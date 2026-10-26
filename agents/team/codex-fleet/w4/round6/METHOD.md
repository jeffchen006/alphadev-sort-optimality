# Round 6 scope

A value column gives one register value for each of the 541 weak input orders.
A partial column contains an initial scratch value in some orders and an input
value in other orders. This search permits partial columns as move data. It
does not permit a comparison to read an initial scratch value.

The source inventory contains 18 verified c=8, k=32 programs from w6/verified.
The private copies and source hashes are in logs/seeds.json. For each source,
the search records the two value columns before each comparison. These eight
ordered pairs remain fixed. Physical comparison registers remain free.

Each target deletes one non-comparison instruction. The other comparison
positions stay fixed. Every other instruction can be mov, cmovl, cmovle,
cmovg, or cmovge. Every move source and every output snapshot is free.
The first pass keeps physical write destinations. The second pass also frees
write destinations and adds two registers. No min/max term pool applies.
New non-lattice data columns can feed moves and outputs. Comparison operands
must match the source columns. These limits distinguish this search from
w11's two-column enumeration, w12's undefined comparisons, and w13's distant
comparison structures. The three briefs were read before the search started.

The encoder uses a distinct top value for initial scratch data. All input
ranks are below top. A comparison must read its prescribed input rank in each
encoded order. Thus it cannot read top. Conditional moves can copy top and
can replace it in only some orders. If a comparison reads only defined data,
its flags do not depend on scratch values. A top marker then suffices to
track which data still depend on scratch values. Outputs must equal input
ranks, so they cannot contain top. Initial flags are equality. This is a
necessary initial state for strict correctness. Every candidate still needs
the strict judge, which also checks other initial flags.

The search starts with 16 strict orders and case indices 0, 1, and 2.
After a SAT model, a separate scalar evaluator checks comparison columns and
the selected output snapshots on all 541 orders. It adds up to 16 failing
orders. Every model is also saved and submitted to the strict out judge.
A strict rejection can exclude only that instruction core with those output
snapshots. Every successful candidate gets a second strict out check and a
strict mem check after translation.

Kissat solves each accumulated formula. Its SAT assignment must satisfy all
emitted clauses before decoding. An UNSAT result retains its formula and
DRAT certificate. drat-trim checks the certificate. A certificate check limit
is UNSAT_UNCHECKED. A solver or resource limit is UNKNOWN. Neither is counted
as a checked exclusion.

The controller runs serially at nice level 19 on CPU 74. Each child inherits
a 2,800 MiB address-space limit. The solver wrapper stops if its sampled
combined Python/Kissat resident memory exceeds 2,850,000 KiB. No second CPU
job runs at the same time. All writes remain in w4.

Assumptions: [G1,G2,G3,G4,A2,A4,A11]. A2 is the finite register set. A4 is
the fixed comparison-value skeleton. A11 is the deletion-shaped schedule.
The queries test the A15 partial-column gap without assuming lattice data.
An exclusion applies only to its stated shape and register set. It is not
a global lower bound.

The follow-up batch is in `extra/`. It changes the solver strategy for the
unknown free-destination scopes. It numbers scratch registers by first touch.
This removes register-name symmetry. It also maps literal signs to prefer
seed instruction choices. This mapping is reversible and adds no constraints.
The decoded model must satisfy the original clauses before it reaches the
judge. The follow-up starts with the 31 orders that use at most two ranks.
It still checks all 541 orders and adds counterexamples before acceptance.

The follow-up also tries an early-move deletion from each of the 18 seeds.
It removes duplicate free-routing scopes under input permutations, order
reversal, and independent comparison-orientation changes. The retained keys
include comparison positions and the register cap. The duplicate ledger is
`extra/logs/symmetry_duplicates.json`. One additional scope allows 16 total
registers. The register-cap test still has a finite scope [A2].

A final targeted batch is prepared in `partial/`. It applies only to unresolved
free-destination scopes. It requires two conditional-move results that are
scratch-dependent on some initial cases and defined on other initial cases.
It also requires one conditional-move data operand with that mixed property.
These witnesses must occur among the 31 initial binary orders. A completed
UNSAT result for this batch excludes only this additional witness condition.
It does not exclude partial columns visible only on other input orders.
The fixed two-partial-column control tests these extra constraints.
