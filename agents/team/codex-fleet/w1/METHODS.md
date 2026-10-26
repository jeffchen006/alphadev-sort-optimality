# Purpose

Find the minimum number of register copies for all nine-comparator sorting
networks on five inputs. Permit reuse on either output side. Permit any live
register as the destination or source of a conditional move.

# Terms

A **term** is a function of the five input values made with `min` and `max`.
A **channel state** is the unordered set of the five terms on the network wires.
A **comparator sequence** is an ordered list of pairs of channel terms.
A **register state** is a multiset of terms. A multiset records duplicate copies.

The family has nine comparison instructions and eighteen conditional moves.
Each comparator produces its own minimum and maximum before the next comparison.
The search also permits register copies at any point, through the normalization
described below. Each conditional move must produce one comparator output.

# Method

## Enumerate the networks

Represent a term by its values on all 32 binary input vectors. Pack those values
in a 32-bit integer. Min and max then become bitwise AND and OR.

This representation is exact for min/max terms on a totally ordered value set.
To see this, choose any threshold `h`. For any term `t`, the predicate `t >= h`
equals the same AND/OR expression evaluated on the predicates `xi >= h`.
Thus equal binary truth tables give equal values for every numeric input.

Start with the five input terms. At each step, select every unordered pair of
channels. Replace that pair with its min and max. Store channel states as sorted
arrays. Keep every transition, including transitions into an existing state.
State merging therefore retains every comparator order.

If a comparator leaves both terms unchanged, omit it. Such a comparator is
redundant. No generated state is sorted at any depth from zero through eight.
Any sorting network with a redundant comparator would reduce to a shorter
network. Therefore no nine-comparator sorting network is lost by this rule.

Fix the first comparator to the input pair `{x0,x1}`. All ten first input pairs
have equal cost under input renaming. The search performs no other input or
value symmetry reduction. At depth nine, select the channel state containing
all five sorted-output functions. Traverse every path that reaches that state.

The state omits physical wire labels. This covers arbitrary comparator
orientations: each future pair is selected by its current values. Every labeled
wire network maps to a term-pair sequence in this search. Conversely, the
transitions can be assigned to five wires to produce a network. The reported
sequence counts count term-pair sequences, not all equivalent wire drawings.

Every completed sequence has 23 distinct terms: five inputs and eighteen new
comparator outputs. In particular, no earlier term can be produced again by a
later comparator in this family.

## Check conditional reuse

For each sequence, compute the 23 term values on all 541 weak input orders.
A weak input order specifies which inputs are equal and which are smaller.

For comparison operands `A,B`, output term `T`, and each of the four conditions
`l`, `le`, `g`, `ge`, compute two sets:

- Destinations `D` that equal `T` whenever the condition is false.
- Sources `S` that equal `T` whenever the condition is true.

Any live `D,S` from these sets give a legal instruction `cmov D,S` with result
`T`. The comparison flags refer to the original operands even after either
operand register changes. The two output instructions can use different
conditions. Both output orders are searched.

This check permits more choices than the usual conditional swap. Both its
destination and its source may be arbitrary live registers. They need match
the required value only on the respective condition cases.

## Count copies

Start with one copy of each input term. Registers have no fixed output roles.
Represent their values as a multiset. For each legal output instruction, search
both choices below:

1. Overwrite one existing destination copy. This costs zero moves.
2. Copy the destination to a fresh register, then overwrite the fresh copy.
   This costs one move and preserves every old register value.

Fresh registers suffice for unconditional copies. Replacing a write to an old
register with a write to a fresh register preserves the old value at no extra
instruction cost. Unlimited registers are part of the task model.

Copies can also be placed immediately before conditional moves. Consider two
registers that hold the same copied term. Until one of those registers changes,
all reads can use the other register. Delay creation of the second copy until
the first change. If the old source register changes first, exchange the names
of the two equal registers from that point. The write then affects the fresh
copy. A copy with no later change is unnecessary. Apply this process to each
copy. It preserves the instruction count and gives the two choices above.

There is no limit on the multiplicity of a term except the move budget. The
four-bit counters in `reuse.cpp` support every budget used in this run.

Record each sorted output when its term is produced. Its register may change
later. This implements the free `out` instruction. Keep all other old register
values; the search does not discard useful reuse sources.

If the last copy of an already produced term is needed by a future comparison,
reject a write that destroys it. This is necessary because all eighteen
comparator outputs are distinct. A later copy instruction cannot recreate a
term after its last copy has been lost.

Merge equal register multisets at equal comparator boundaries. After each
conditional move, every register again holds a full input or min/max term.
No flag history affects future behavior beyond the fixed comparator sequence.

Run with move budgets four, five and seven. Run the remaining 744 sequences
with budget nine. Combine the minimum counts into `minimum_moves.tsv`.

## Independent checks

`crosscheck.py` separately implements the enumeration with tuples of 32 binary
values. It regenerates exactly the same set of comparator sequences.

Its register search uses sorted tuples of register terms. It checks equality
on condition cases with Python bit sets over all 120 strict input orders.
It does not use the C++ rule tables. A negative result on this subset is
sufficient for the four-move lower bound. This run found no four-move plan and
the same aggregate state count as the C++ search over all 541 weak orders.

`check_witnesses.py` parses and simulates four emitted register programs on all
541 weak orders and three initial comparison states. It also converts the
programs to the memory model. The shared judge then checks all eight files with
`--strict`. The judge supplies the check for all initial scratch values and
all four initial x86 flag states.

# Result and limits

The minimum for this family is five moves. It gives `9 + 18 + 5 = 32` core
instructions and `5 + 32 + 5 = 42` memory instructions.

This is an exhaustive search result with two implementations. It is not a
machine-checked mathematical proof. It excludes a 31-instruction core obtained
by the comparator-block copy-reuse method defined above.

It does not exclude general register programs. In particular, those programs
may use different comparison operands, flag sharing across comparator outputs,
non-min/max intermediate values, or different numbers of conditional moves.
