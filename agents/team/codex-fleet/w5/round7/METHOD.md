# Round 7 method

This round refines only the 797 unresolved round-6 position pairs. It does not repeat completed pair exclusions. The queue contains 364 near9 pairs followed by 433 near14 pairs. All pairs share the same failing-order count within a seed. The secondary order is distance from the previously selected pair [13,20].

The unchanged round-6 repair encoder defines the query. Exactly two positions are free to choose any legal instruction. It can change all four CMOV predicates at every other CMOV position. Other operands and MOV/CMP opcodes remain fixed. Two free positions can also retain their old instructions. All seed registers and one extra register are available: R=8 for near9 and R=9 for near14. A common output selector chooses one snapshot for each output across all encoded cases.

The first formula has every actual failing weak order and twelve strict orders sampled with seed 62026. This gives 20 distinct cases for near9 and 24 for near14. A relaxed SAT proposal is evaluated on all 541 weak orders. If an output has no exact snapshot, counterexamples extend the formula. Kissat restarts on the complete extended formula. All calls for one pair share a 1,200-second wall limit, including formula construction and validation. No solver result relies on preferred phases.

The SAT model fixes initial scratch values to rank 7 and initial flags to equal. This is a necessary condition for strict correctness. A formula UNSAT excludes the stated relaxed query, and hence excludes a strict solution in that query. A relaxed SAT proposal must pass both strict judges. A timeout is UNKNOWN. No claim covers other register limits or more free instruction positions.

All query jobs use nice level 19 and CPU 76. The batch runs one query at a time. Each query has a 2,800 MiB address-space limit. The runner also checks the combined resident memory of the Python encoder and Kissat. Every emitted SAT model is checked against all clauses before decoding. Solver exit code 20 and the UNSAT status line are required for an UNSAT record. Log and formula hashes support the final file audit. They are not proof certificates.

Assumption tags: G1, G2, G3, A2, A11 from board/ASSUMPTIONS_42.md. These results test local repair with a finite register alphabet. They do not establish global optimality.
