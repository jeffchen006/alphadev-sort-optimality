# Direct search with three partial columns [A15]

This round searches partial written register versions directly. A partial
version contains an initial scratch value on at least one encoded input order.
Every other written version must be a lattice function. A lattice function
is an expression of the inputs made with min and max.

The search keeps three optional creation positions. Each position has a
defined bit and input-rank threshold bits for each input order. Untagged
versions use arbitrary monotone Boolean tables on all input subsets.
Comparison operands and outputs must be full. The main query requires all
three positions to be active. Later queries can relax that requirement.

Disjoint work allocation, after reading the three briefs:

- w11 searches full non-lattice versions after garbage removal.
- w12 permits comparisons that read garbage.
- w13 generates distant comparison structures and routes those structures.
- w1 retains undefined entries and free lattice shapes. It permits no
  comparison of an undefined entry. It does not enumerate or route w13's
  skeletons, or run w11's full-column formulas.

The representation is new. The earlier w10 direct encoder stores an input
identity for every version on every order. This encoder stores full versions
as shared threshold tables and only the three partial versions per order.
This is not a repeat of w1 rounds 1–9.

One CPU job runs at a time, at nice level 19. Each job has an address-space
limit below 3 GB. All writes stay in w1. A limit means UNKNOWN. Only a
completed solver decision can close its saved finite formula. Only a strict
reference-judge PASS establishes an accepted sorting candidate.
