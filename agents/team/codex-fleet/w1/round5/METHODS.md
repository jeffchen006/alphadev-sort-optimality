# Purpose

Search new rank and merge designs. Do not use a 32-instruction sort5 program
as an input. All new CPU jobs use one CPU, `nice -n 19`, and one process at a
time. SAT search jobs have a 2,800 MiB address-space limit. A search limit means
unknown. Only a completed finite search can give a negative result.

# Terms

A **case** is one weak input order. A weak input order can contain ties.
A **value column** gives one value for every case. A **selection gate** selects
one of two earlier values under one comparison condition. A selection gate
can represent a conditional move. It does not include its register-copy cost.

The sorted pair is `a <= b`. The sorted triple is `c <= d <= e`.
There are 10 strict interleavings and 76 weak orders for these two lists.
If the two single inputs are unordered, there are 20 strict interleavings and
132 weak orders with the triple sorted.

# Independent raw-source chains

`rank_chains.py` checks an idealized accumulator for each output. Each
accumulator starts at any original list entry for free. Each conditional move
can read any original list entry. Original entries remain available for free.
The accumulators do not share intermediate results.

The sorted-pair search uses each of the six raw cross comparisons once. It
checks all 720 orders. The unordered-pair search also compares its two single
inputs. It checks all 5,040 orders of the seven comparisons. Each flag block
can contain any number of conditional moves. The search permits all four I1
conditions. It does not impose a limit on conditional-move cost.

The search works backward from the required output values. A demand mask
records the cases that still need the correct accumulator value. A conditional
move can remove its selected cases only if its raw source is correct on all
those cases. The search checks the full closure of each flag block. It can stop
when one free initial entry is correct on every remaining case. Demands only
decrease. A repeated demand with a larger cost cannot improve the result.

A later unconditional move makes every earlier write to that accumulator
unused. Its source can instead be the free initial entry. Thus omitting later
unconditional moves does not increase the minimum for this family.

`forward_chains.cpp` is an independent forward implementation. It checks all
720 orders on the 10 strict interleavings. It retains full accumulator values
and costs up to four. On distinct inputs, a raw comparison has two complementary
conditions. If a block writes both regions, the earlier accumulator value is
unused. The same two raw entries can be selected with one move from a different
free initial entry. Thus one conditional move per flag block is sufficient for
this forward check. Its complete cost table is compared with the Python table.

The Python scalar audit replays every finite output-chain witness on all 76
weak orders. These checks support the implementations. They are not a formal
certificate.

# Shared selection values

`rank_dag.py` permits selections to share earlier results. Its six comparison
blocks can occur in any order. A gate can use any original entry or earlier
gate. Gates occur in nondecreasing block order. The sources stay available for
free. The output can be any original entry or gate. Register copies have zero
cost in this relaxation.

The ten-gate search asks whether six comparisons plus at most ten conditional
value creations can suffice. Identity gates permit padding. The encoding
orders the two data-source indices. Swapping the sources and complementing the
condition preserves a gate. I1 contains each complement: l/ge and le/g.

The initial SAT formula uses all 10 strict interleavings. A satisfying plan is
checked on all 76 weak orders. Failed cases are added. A satisfying abstract
plan is not an executable sort5 program. It still needs register allocation
and the shared strict judge.

`rank_batch.py` queries all 720 comparison orders with one incremental solver.
It gives each order a conflict budget. It revisits unresolved orders with a
larger budget. A completed UNSAT query can be blocked from later queries. The
batch can reuse the earlier completed fixed-order result. It does not infer
untested results from value reversal. The JSON ledger records every query.

`rank_units.py` uses a separate formula for each order. The order choices are
permanent unit clauses. This permits simplification before the solver starts.
It first checks the 120 orders with the best independent-chain cost. Each order
has a CPU limit. A separate total CPU limit applies. The ledger distinguishes
completed negatives, abstract positive plans, and unknown orders. It includes
the earlier completed fixed-order result once.

The raw-pair indices in the ledgers are:

| Index | Comparison |
| --- | --- |
| 0 | a, c |
| 1 | a, d |
| 2 | a, e |
| 3 | b, c |
| 4 | b, d |
| 5 | b, e |

The batch uses only the ten strict interleavings. Every fixed raw cross
comparison then has unequal operands. Thus l/le coincide and g/ge coincide
on every encoded case. The batch keeps l and g. This is a projection of I1
onto these cases. It is not an assumption about comparisons of arbitrary
copied values. An I1 plan can replace le by l and ge by g without changing
its behavior on these cases. A negative for this projection therefore also
excludes an I1 plan correct on all weak orders. If a strict plan is found,
the script changes g to ge and checks its value behavior on all 76 weak orders.
The fixed raw orientation then gives triple entries priority at cross-list
ties. A failed weak-order check remains an abstract strict-only result.

# Register and flag schedules

`merge_sat.py` constructs a fresh prefix from a sort3 and a sort2. The prefix
has 15 instructions. It leaves eight defined registers. The remaining merge
budget is 16 instructions. The alternate prefix uses only the 11-instruction
sort3. It leaves seven defined registers and a 20-instruction budget for the
two single inputs. That search also permits one fresh register.

The suffix encoding selects every opcode, source register, destination
register, output time, and output register. Its operations are mov, cmp,
cmovl, cmovle, cmovg, and cmovge. Each case has its own register values and
flags. Every instruction choice is shared across cases. The encoding includes
the exact state produced by the prefix. It permits every interleaving of
copies, conditional moves, and the specified number of comparisons. It does
not prescribe intermediate value columns.

The unrestricted merge search uses four comparisons. The fixed-predicate
searches can require the first two predicates to compare the list extremes or
the triple middle. They still permit either comparison orientation.

The binary merge design uses these four semantic comparisons:

```
compare a, d
compare b, d
compare a, (c if a < d else e)
compare b, (c if b < d else e)
```

The comparisons against d select the operands for the insertion comparisons. If both
pair entries are below d, the last comparisons insert c into the pair. If the
pair straddles d, the last comparisons place a against c and b against e. If
both pair entries are above d, they insert e into the pair.

The predicate-order argument can interleave the insertion comparisons. Order
`0,2,1,3` completes the search for a before it starts the search for b. Order
`0,1,2,3` compares both entries with d first. Each result JSON records its
order. If an older result has no order key, its order is `0,1,2,3`.

The alternate triple-only prefix first compares its two unordered inputs. The
four binary merge predicates then use their minimum and maximum. The encoding
does not require a physical sorted pair at that point. It can use the first
flag to retain partial values instead. This permits shared flag work across
pair sorting and merging.

The fixed predicates constrain comparison outcomes on each case. They do not
fix comparison operands or the writes that create them. A global orientation
choice for each comparison permits the reversed predicate. Comparison positions
remain variable. The creation-output option records a correct column when it
first appears. Any column first appears initially or in the destination of a
write. This option preserves the free-output model.

The search starts with all strict interleavings whose source triple is already
ordered. The pair-plus-triple prefix also starts with an ordered source pair.
A candidate is checked on all 541 weak orders through the complete prefix and
suffix. Failed cases are added to the SAT formula. A final candidate must pass
the shared strict judge.

The fresh register starts with an undefined-value symbol. A conditional copy
can leave that symbol on cases where the condition is false. A comparison
cannot read the symbol. A write cannot select it as its source. An output
cannot contain it. The symbol is not used as a sentinel in any comparison.
An unconditional move can initialize a fresh destination. These constraints
permit partial conditional copies whose later uses select only defined cases.

The register encoding orders comparison-register indices. If a comparison is
reversed, exchanging l/g and le/ge in its flag block preserves its effect.
Self comparisons remain permitted. Self moves permit instruction padding.

`merge_shapes.py` fixes the first comparison at instruction zero. It queries
all 455 placements of the remaining three comparisons. Every write operation
and register operand remains free. It revisits unresolved placements with
larger conflict budgets. A completed negative applies only to the recorded
comparison placement. If any placement remains unresolved, the whole
455-placement family remains unknown.

# Verification and limits

`check_encoding.py` checks the register encoding against a constructed correct
merge. It also checks wrong outputs, random concrete transitions, the shared
selection encoding, and the four binary comparison predicates. The full
constructed control is checked by the shared strict judge in out and memory
models. It is a control, not an improvement.

The chain search excludes shared intermediate values. The shared selection
search omits register-copy costs. The register search uses the stated fixed
prefix and eight registers. It does not cover further fresh registers,
every prefix, every comparison count, or every semantic comparison order.
The binary design fixes four or five predicates. A negative for that design
does not exclude other merge designs. A CPU limit does not establish a negative
result. Solver judgments and finite search results are not called proofs here.
