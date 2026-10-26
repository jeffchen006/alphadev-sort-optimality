# Round 10 scope

Read w5 rounds 1–9 and the w11, w12, and w13 briefs before this run.

This worker reserves c=8 sequences of conditional permutations with at least
two companion-pair swaps. Each special comparison swaps its compared pair
and a second disjoint pair under the same strict-greater condition. The
first comparison is an ordinary compare-exchange of input wires 0 and 1.
All comparisons read values defined by inputs. This differs from w11's
two-column relation and w12's comparisons on unknown scratch values.
The c=9 partner searches of w8 are excluded. The broad c=8/c=9 work of w13
is excluded by using this explicit conditional-permutation subfamily.

Generation uses sets of current permutations to reject prefixes that lack
a completion. A completed eight-step sequence must map all 120 strict input
orders to one fixed wire permutation. That check does not establish strict
correctness. Each generated operand skeleton is canonical under input
renaming, value reversal, and independent comparison-operand reversal.
Limits in generation leave the family open.

The completed extension adds both three-value rotations of the companion
wires. A second extension permits companion permutations without swapping
the two compared wires. The generator skips any step that leaves the set
of reachable wire permutations unchanged. In the pair-swap and rotation
families, such a step acts as the identity on every reachable input. For
the companion-only extension, this rule is an explicit scope restriction.
An independent integer-bitset dynamic program counts the raw sorting
paths under exactly these same action and no-stationary-step rules.

Routing uses the conservative-open-bound DAG router copied from w2/w8.
The original d1 source is retained for comparison. A route fixes comparison
operand columns but can introduce arbitrary defined CMOV columns. The
router has no fixed register count. It tests the 120 strict input orders.
A completed NONE excludes only the fixed skeleton in that representation.
A node, wall, or memory limit is UNKNOWN. Any emitted program must pass
both reference strict judges on all 541 weak orders and scratch states.

The routing batch uses w8's cached router with search-order mode 13. This
changes branch order and caches exact subcomputations. It keeps the
conservative open-requirement bound. The uncached source is also retained.
The first pilot used the uncached router at 2,000,000 nodes. It was limited.
The broad batch allows 3,000,000 nodes and 60 seconds per query.

An independent Python evaluator checked all retained source recipes on
120 strict orders and 541 weak orders. It also reconstructed each operand
column and matched the saved skeleton. These are source checks. A recipe
does not become an upper-bound result until assembly passes the judge.

The known-source index has 370 c=8 source records and 232 canonical classes.
It includes the frozen w6/w5 representatives and 197 round-4 comparison
variants. No generated skeleton matches one of these classes. The saved
w13 c=8 index has 22 classes. None matches this worker's 177 classes.
Canonical SHA-256 hashes use ASCII digits, as w13 does. A pilot comparison
against w13's independent key executable agreed. The runner checks the
current w13 closed hashes before each query.

The distance measure is the minimum number of changed comparison blocks
under input renaming, value reversal, independent operand reversal, and
all known-source choices. The broad batch selects distance at least four.
This gives 138 cases. It is a numerical separation from the indexed c=8
sources, not a statement about all known sorting algorithms.

After the ordinary-first family finished, the first comparison was also
allowed to permute companions. One pair-swap first action and one rotation
first action represent those choices under input renaming. The generator
counts the first action toward the total number of companion operations.
It enumerates totals two through eight. This gives 1,056 additional
canonical classes: 712 from the initial pair swap and 344 from the initial
rotation. All source traces pass the independent 541-order check. No class
matches the known index or the current w13 saved c=8 classes.

The final source union has 1,347 classes. There are 1,269 classes at distance
at least four. Of these, 252 already have completed routing exclusions.
The next batch routes only the 1,017 new far classes. Seventy-eight closer
classes remain outside this routing selection. The original 138-case
count above describes the initial queue, not the final source union.

All compute jobs run sequentially at nice level 19, on CPU 77, with a
2,800 MiB address-space limit. The worker does not change files elsewhere.

Assumption tags: [G1,G2,G3,A4,A6]. Generation is bounded. No general lower
bound follows. The new scope tests value structures outside known families.
