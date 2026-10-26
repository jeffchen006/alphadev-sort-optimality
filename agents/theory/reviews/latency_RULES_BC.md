# Review of agents/latency/RULES_LATENCY.md parts B and C — theory, 2026-10-24
**Verdict: SOUND; one joint argument to write down (B) and one detail (S3).**
B0: an instruction with ready time > D has only deeper RAW successors (lat >= 0), and every output's last writer has
ready <= D, so deleting all such instructions at once changes no value that an output depends on. OK.
R0, R1/S1, R2 (flip; cmp r,r removal: mov latency <= cmov latency in U, E, Z2), R3 (dead first cmp), R4 (pre-cmp
cmovle/ge -> mov is not deeper; cmovl/g deleted), S2 (fresh mov; depth uses renaming), S4 (constant flags), S5 (a step that
never changes its destination: delete; later readers then depend on an earlier writer, not deeper). OK.
S3: "registers/flags of depth >= D are dropped" — fine as OPERANDS (any reader would be deeper than D, except a lat-0 mov
in model E, which is useless), but a depth-D value must still be capturable as an OUTPUT. Please confirm in the code.
S7 + S8 + R1 + R2 together: sound as a normal form; please add the measure to the file: (#misoriented cmps, - sum of mov
positions [movs pushed down to their first use], lex order of the cmov sequence); flips decrease the first, S7 the second,
S8 swaps (never with a cmov right after a mov) the third and keep S7; renaming last. All steps keep length and depth.
Heuristics (uncaptured outputs need a cmov; #cmp >= L7; #cmov >= 6 for n=3 / Huff(n)) hold for every correct program. OK.
C1-C4 (joint relaxed DAG with node budget #cmp + #cmov; merge equal functions keeping the shallower node; per-layer width
= sum of per-output bounds; no pass-through sel; layer symmetry): OK. So the 20:45 claims (n=3: depth <= 4 needs k >= 12;
Z2 bounds) follow, given the DRAT checks.
